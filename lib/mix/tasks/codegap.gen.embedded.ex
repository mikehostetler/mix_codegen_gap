defmodule Mix.Tasks.Codegap.Gen.Embedded do
  @shortdoc "Generates an embedded Ecto schema file"

  @moduledoc """
  Generates an embedded Ecto schema for casting/validating data outside the DB.

      mix codegap.gen.embedded Blog.Post title:string views:integer

  The first argument is the schema module followed by the schema attributes.

  The generated schema above will contain:

    * an embedded schema file in `lib/my_app/blog/post.ex`

  ## Attributes

  The resource fields are given using `name:type` syntax
  where type are the types supported by Ecto. Omitting
  the type makes it default to `:string`:

      mix codegap.gen.embedded Blog.Post title views:integer

  The following types are supported:

  #{for attr <- Mix.MixCodegenGap.Schema.valid_types(), do: "  * `#{inspect attr}`\n"}
    * `:datetime` - An alias for `:naive_datetime`
  """
  use Mix.Task

  alias Mix.MixCodegenGap.Schema

  @switches [binary_id: :boolean, web: :string]

  @doc false
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise "mix codegap.gen.embedded can only be run inside an application directory"
    end

    schema = build(args)

    paths = Mix.MixCodegenGap.generator_paths()

    prompt_for_conflicts(schema)

    copy_new_files(schema, paths, schema: schema)
  end

  @doc false
  def build(args) do
    {schema_opts, parsed, _} = OptionParser.parse(args, switches: @switches)
    [schema_name | attrs] = validate_args!(parsed)
    opts =
      schema_opts
      |> Keyword.put(:embedded, true)
      |> Keyword.put(:migration, false)

    schema = Schema.new(schema_name, nil, attrs, opts)

    schema
  end

  @doc false
  def validate_args!([schema | _] = args) do
    cond do
      not Schema.valid?(schema) ->
        raise_with_help "Expected the schema argument, #{inspect schema}, to be a valid module name"
      true ->
        args
    end
  end
  def validate_args!(_) do
    raise_with_help "Invalid arguments"
  end

  @doc false
  @spec raise_with_help(String.t) :: no_return()
  def raise_with_help(msg) do
    Mix.raise """
    #{msg}

    mix codegap.gen.embedded expects a module name followed by
    any number of attributes:

        mix codegap.gen.embedded Blog.Post title:string
    """
  end


  defp prompt_for_conflicts(schema) do
    schema
    |> files_to_be_generated()
    |> Mix.MixCodegenGap.prompt_for_conflicts()
  end

  @doc false
  def files_to_be_generated(%Schema{} = schema) do
    [{:eex, "embedded_schema.ex", schema.file}]
  end

  @doc false
  def copy_new_files(%Schema{} = schema, paths, binding) do
    files = files_to_be_generated(schema)
    Mix.MixCodegenGap.copy_from(paths, "priv/templates/codegap.gen.embedded", binding, files)

    schema
  end
end
