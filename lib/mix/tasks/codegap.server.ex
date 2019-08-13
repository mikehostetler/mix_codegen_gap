defmodule Mix.Tasks.Codegap.Server do
  use Mix.Task

  @shortdoc "Starts applications and their servers"

  @moduledoc """
  Starts the application by configuring all endpoints servers to run.

  Note: to start the endpoint without using this mix task you must set
  `server: true` in your `MixCodegenGap.Endpoint` configuration.

  ## Command line options

  This task accepts the same command-line arguments as `run`.
  For additional information, refer to the documentation for
  `Mix.Tasks.Run`.

  For example, to run `codegap.server` without recompiling:

      mix codegap.server --no-compile

  The `--no-halt` flag is automatically added.

  Note that the `--no-deps-check` flag cannot be used this way,
  because Mix needs to check dependencies to find `codegap.server`.

  To run `codegap.server` without checking dependencies, you can run:

      mix do deps.loadpaths --no-deps-check, codegap.server
  """

  @doc false
  def run(args) do
    Application.put_env(:mix_codegen_gap, :serve_endpoints, true, persistent: true)
    Mix.Tasks.Run.run run_args() ++ args
  end

  defp run_args do
    if iex_running?(), do: [], else: ["--no-halt"]
  end

  defp iex_running? do
    Code.ensure_loaded?(IEx) and IEx.started?
  end
end
