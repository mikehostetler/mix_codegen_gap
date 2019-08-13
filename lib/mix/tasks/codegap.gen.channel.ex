defmodule Mix.Tasks.Codegap.Gen.Channel do
  @shortdoc "Generates a MixCodegenGap channel"

  @moduledoc """
  Generates a MixCodegenGap channel.

      mix codegap.gen.channel Room

  Accepts the module name for the channel

  The generated files will contain:

  For a regular application:

    * a channel in `lib/my_app_web/channels`
    * a channel test in `test/my_app_web/channels`

  For an umbrella application:

    * a channel in `apps/my_app_web/lib/app_name_web/channels`
    * a channel test in `apps/my_app_web/test/my_app_web/channels`

  """
  use Mix.Task

  @doc false
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise "mix codegap.gen.channel can only be run inside an application directory"
    end
    [channel_name] = validate_args!(args)
    context_app = Mix.MixCodegenGap.context_app()
    web_prefix = Mix.MixCodegenGap.web_path(context_app)
    test_prefix = Mix.MixCodegenGap.web_test_path(context_app)
    binding = Mix.MixCodegenGap.inflect(channel_name)
    binding = Keyword.put(binding, :module, "#{binding[:web_module]}.#{binding[:scoped]}")

    Mix.MixCodegenGap.check_module_name_availability!(binding[:module] <> "Channel")

    Mix.MixCodegenGap.copy_from paths(), "priv/templates/codegap.gen.channel", binding, [
      {:eex, "channel.ex",       Path.join(web_prefix, "channels/#{binding[:path]}_channel.ex")},
      {:eex, "channel_test.exs", Path.join(test_prefix, "channels/#{binding[:path]}_channel_test.exs")},
    ]

    Mix.shell.info """

    Add the channel to your `#{Mix.MixCodegenGap.web_path(context_app, "channels/user_socket.ex")}` handler, for example:

        channel "#{binding[:singular]}:lobby", #{binding[:module]}Channel
    """
  end

  @spec raise_with_help() :: no_return()
  defp raise_with_help do
    Mix.raise """
    mix codegap.gen.channel expects just the module name:

        mix codegap.gen.channel Room

    """
  end

  defp validate_args!(args) do
    unless length(args) == 1 do
      raise_with_help()
    end
    args
  end

  defp paths do
    [".", :mix_codegen_gap]
  end
end
