defmodule CheckersWeb.AudienceControllerTest do
  use CheckersWeb.ConnCase

  alias Checkers.Audiences

  @create_attrs %{game: "some game"}
  @update_attrs %{game: "some updated game"}
  @invalid_attrs %{game: nil}

  def fixture(:audience) do
    {:ok, audience} = Audiences.create_audience(@create_attrs)
    audience
  end

  describe "index" do
    test "lists all audiences", %{conn: conn} do
      conn = get conn, audience_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Audiences"
    end
  end

  describe "new audience" do
    test "renders form", %{conn: conn} do
      conn = get conn, audience_path(conn, :new)
      assert html_response(conn, 200) =~ "New Audience"
    end
  end

  describe "create audience" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, audience_path(conn, :create), audience: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == audience_path(conn, :show, id)

      conn = get conn, audience_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Audience"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, audience_path(conn, :create), audience: @invalid_attrs
      assert html_response(conn, 200) =~ "New Audience"
    end
  end

  describe "edit audience" do
    setup [:create_audience]

    test "renders form for editing chosen audience", %{conn: conn, audience: audience} do
      conn = get conn, audience_path(conn, :edit, audience)
      assert html_response(conn, 200) =~ "Edit Audience"
    end
  end

  describe "update audience" do
    setup [:create_audience]

    test "redirects when data is valid", %{conn: conn, audience: audience} do
      conn = put conn, audience_path(conn, :update, audience), audience: @update_attrs
      assert redirected_to(conn) == audience_path(conn, :show, audience)

      conn = get conn, audience_path(conn, :show, audience)
      assert html_response(conn, 200) =~ "some updated game"
    end

    test "renders errors when data is invalid", %{conn: conn, audience: audience} do
      conn = put conn, audience_path(conn, :update, audience), audience: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Audience"
    end
  end

  describe "delete audience" do
    setup [:create_audience]

    test "deletes chosen audience", %{conn: conn, audience: audience} do
      conn = delete conn, audience_path(conn, :delete, audience)
      assert redirected_to(conn) == audience_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, audience_path(conn, :show, audience)
      end
    end
  end

  defp create_audience(_) do
    audience = fixture(:audience)
    {:ok, audience: audience}
  end
end
