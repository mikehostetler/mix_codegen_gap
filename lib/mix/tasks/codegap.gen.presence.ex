defmodule Mix.Tasks.Codegap.Gen.Presence do
  @shortdoc "Generates a Presence tracker"

  @moduledoc """
  Generates a Presence tracker for your application.

      mix codegap.gen.presence

      mix codegap.gen.presence MyPresence

  The only argument is the module name of the Presence tracker,
  which defaults to Presence.

  A new file will be generated in `lib/my_app_web/channels/presence.ex`,
  where `my_app_web` is the snake cased version of the module name provided.
  """
  use Mix.Task

  @doc false
  def run([]) do
    run(["Presence"])
  end
  def run([alias_name]) do
    if Mix.Project.umbrella?() do
      Mix.raise "mix codegap.gen.presence can only be run inside an application directory"
    end
    context_app = Mix.MixCodegenGap.context_app()
    otp_app = Mix.MixCodegenGap.otp_app()
    web_prefix = Mix.MixCodegenGap.web_path(context_app)
    inflections = Mix.MixCodegenGap.inflect(alias_name)
    inflections = Keyword.put(inflections, :module, "#{inflections[:web_module]}.#{inflections[:scoped]}")

    binding = inflections ++ [
      otp_app: otp_app,
      pubsub_server: Module.concat(inflections[:base], "PubSub")
    ]

    files = [
      {:eex, "presence.ex", Path.join(web_prefix, "channels/#{binding[:path]}.ex")},
    ]

    Mix.MixCodegenGap.copy_from paths(), "priv/templates/codegap.gen.presence", binding, files

    Mix.shell.info """

    Add your new module to your supervision tree,
    in lib/#{otp_app}/application.ex:

        children = [
          ...
          #{binding[:module]}
        ]

    You're all set! See the MixCodegenGap.Presence docs for more details:
    http://hexdocs.pm/mix_codegen_gap/MixCodegenGap.Presence.html
    """
  end

  defp paths do
    [".", :mix_codegen_gap]
  end
end
