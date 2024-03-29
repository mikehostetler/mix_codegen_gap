<% preload = for {key, _, _, _} <- schema.assocs, do: key %>
defmodule <%= inspect schema.module %>.GenGap do
  @doc false
  defmacro __using__(_opts) do
    quote do
      import Ecto.Query, warn: false
      alias <%= inspect schema.repo %>
      alias <%= inspect schema.module %>

      alias Forage

      @doc """
      Returns the list of <%= schema.plural %>.

      ## Examples

          iex> list_<%= schema.plural %>()
          [%<%= inspect schema.alias %>{}, ...]

      """
      # def list_<%= schema.plural %> do
      #   Repo.all(<%= inspect schema.alias %>)
      # end
      def list_<%= schema.plural %>(params) do<% [{default_sort_field, _type} | _attrs] = schema.attrs %>
        Forage.paginate(params, <%= inspect schema.alias %>, Repo, sort: [:<%= default_sort_field %>, :id], preload: <%= inspect(preload) %>)
      end
      defoverridable(list_<%= schema.plural %>: 1)

      @doc """
      Gets a single <%= schema.singular %>.

      Raises `Ecto.NoResultsError` if the <%= schema.human_singular %> does not exist.

      ## Examples

          iex> get_<%= schema.singular %>!(123)
          %<%= inspect schema.alias %>{}

          iex> get_<%= schema.singular %>!(456)
          ** (Ecto.NoResultsError)

      """
      def get_<%= schema.singular %>!(id), do: Repo.get!(<%= inspect schema.alias %>, id)
      defoverridable(get_<%= schema.singular %>!: 1)

      @doc """
      Creates a <%= schema.singular %>.

      ## Examples

          iex> create_<%= schema.singular %>(%{field: value})
          {:ok, %<%= inspect schema.alias %>{}}

          iex> create_<%= schema.singular %>(%{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def create_<%= schema.singular %>(attrs \\ %{}) do
        %<%= inspect schema.alias %>{}
        |> <%= inspect schema.alias %>.changeset(attrs)
        |> Repo.insert()
      end
      defoverridable(create_<%= schema.singular %>: 1)

      @doc """
      Updates a <%= schema.singular %>.

      ## Examples

          iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: new_value})
          {:ok, %<%= inspect schema.alias %>{}}

          iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def update_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>, attrs) do
        <%= schema.singular %>
        |> <%= inspect schema.alias %>.changeset(attrs)
        |> Repo.update()
      end
      defoverridable(update_<%= schema.singular %>: 2)

      @doc """
      Deletes a <%= inspect schema.alias %>.

      ## Examples

          iex> delete_<%= schema.singular %>(<%= schema.singular %>)
          {:ok, %<%= inspect schema.alias %>{}}

          iex> delete_<%= schema.singular %>(<%= schema.singular %>)
          {:error, %Ecto.Changeset{}}

      """
      def delete_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>) do
        Repo.delete(<%= schema.singular %>)
      end
      defoverridable(delete_<%= schema.singular %>: 1)

      @doc """
      Returns an `%Ecto.Changeset{}` for tracking <%= schema.singular %> changes.

      ## Examples

          iex> change_<%= schema.singular %>(<%= schema.singular %>)
          %Ecto.Changeset{data: %<%= inspect schema.alias %>{}}

      """
      def change_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>) do
        <%= inspect schema.alias %>.changeset(<%= schema.singular %>, %{})
      end
      defoverridable(change_<%= schema.singular %>: 1)
    end
  end
end
