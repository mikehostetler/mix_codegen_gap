defmodule Mix.Tasks.Codegap do
  use Mix.Task

  @shortdoc "Prints MixCodegenGap help information"

  @moduledoc """
  Prints MixCodegenGap tasks and their information.

      mix codegap

  """

  @doc false
  def run(args) do
    case args do
      [] -> general()
      _ -> Mix.raise "Invalid arguments, expected: mix codegap"
    end
  end

  defp general() do
    Application.ensure_all_started(:mix_codegen_gap)
    Mix.shell.info "MixCodegenGap v#{Application.spec(:mix_codegen_gap, :vsn)}"
    Mix.shell.info "Productive. Reliable. Fast."
    Mix.shell.info "A productive web framework that does not compromise speed or maintainability."
    Mix.shell.info "\nAvailable tasks:\n"
    Mix.Tasks.Help.run(["--search", "codegap."])
  end
end
