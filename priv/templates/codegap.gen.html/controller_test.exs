defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase

  alias <%= inspect context.module %>

  @create_attrs <%= inspect schema.params.create %>
  @update_attrs <%= inspect schema.params.update %>
  @invalid_attrs <%= inspect for {key, _} <- schema.params.create, into: %{}, do: {key, nil} %>

  def fixture(:<%= schema.singular %>) do
    {:ok, <%= schema.singular %>} = <%= inspect context.alias %>.create_<%= schema.singular %>(@create_attrs)
    <%= schema.singular %>
  end

  describe "index" do
    test "lists all <%= schema.plural %>", %{conn: conn} do
      conn = get(conn, Routes.<%= schema.route_helper %>_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing <%= schema.human_plural %>"
    end
  end

  describe "new <%= schema.singular %>" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.<%= schema.route_helper %>_path(conn, :new))
      assert html_response(conn, 200) =~ "New <%= schema.human_singular %>"
    end
  end

  describe "create <%= schema.singular %>" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.<%= schema.route_helper %>_path(conn, :create), <%= schema.singular %>: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.<%= schema.route_helper %>_path(conn, :show, id)

      conn = get(conn, Routes.<%= schema.route_helper %>_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show <%= schema.human_singular %>"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.<%= schema.route_helper %>_path(conn, :create), <%= schema.singular %>: @invalid_attrs)
      assert html_response(conn, 200) =~ "New <%= schema.human_singular %>"
    end
  end

  describe "edit <%= schema.singular %>" do
    setup [:create_<%= schema.singular %>]

    test "renders form for editing chosen <%= schema.singular %>", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      conn = get(conn, Routes.<%= schema.route_helper %>_path(conn, :edit, <%= schema.singular %>))
      assert html_response(conn, 200) =~ "Edit <%= schema.human_singular %>"
    end
  end

  describe "update <%= schema.singular %>" do
    setup [:create_<%= schema.singular %>]

    test "redirects when data is valid", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      conn = put(conn, Routes.<%= schema.route_helper %>_path(conn, :update, <%= schema.singular %>), <%= schema.singular %>: @update_attrs)
      assert redirected_to(conn) == Routes.<%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>)

      conn = get(conn, Routes.<%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>))<%= if schema.string_attr do %>
      assert html_response(conn, 200) =~ <%= inspect Mix.MixCodegenGap.Schema.default_param(schema, :update) %><% else %>
      assert html_response(conn, 200)<% end %>
    end

    test "renders errors when data is invalid", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      conn = put(conn, Routes.<%= schema.route_helper %>_path(conn, :update, <%= schema.singular %>), <%= schema.singular %>: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit <%= schema.human_singular %>"
    end
  end

  describe "delete <%= schema.singular %>" do
    setup [:create_<%= schema.singular %>]

    test "deletes chosen <%= schema.singular %>", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      conn = delete(conn, Routes.<%= schema.route_helper %>_path(conn, :delete, <%= schema.singular %>))
      assert redirected_to(conn) == Routes.<%= schema.route_helper %>_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.<%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>))
      end
    end
  end

  defp create_<%= schema.singular %>(_) do
    <%= schema.singular %> = fixture(:<%= schema.singular %>)
    {:ok, <%= schema.singular %>: <%= schema.singular %>}
  end
end
