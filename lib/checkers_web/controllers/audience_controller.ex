defmodule CheckersWeb.AudienceController do
  use CheckersWeb, :controller

  alias Checkers.Audiences
  alias Checkers.Audiences.Audience

  def index(conn, _params) do
    audiences = Audiences.list_audiences()
    render(conn, "index.html", audiences: audiences)
  end

  def new(conn, _params) do
    changeset = Audiences.change_audience(%Audience{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"audience" => audience_params}) do
    case Audiences.create_audience(audience_params) do
      {:ok, audience} ->
        conn
        |> put_flash(:info, "Audience created successfully.")
        |> redirect(to: audience_path(conn, :show, audience))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    audience = Audiences.get_audience!(id)
    render(conn, "show.html", audience: audience)
  end

  def edit(conn, %{"id" => id}) do
    audience = Audiences.get_audience!(id)
    changeset = Audiences.change_audience(audience)
    render(conn, "edit.html", audience: audience, changeset: changeset)
  end

  def update(conn, %{"id" => id, "audience" => audience_params}) do
    audience = Audiences.get_audience!(id)

    case Audiences.update_audience(audience, audience_params) do
      {:ok, audience} ->
        conn
        |> put_flash(:info, "Audience updated successfully.")
        |> redirect(to: audience_path(conn, :show, audience))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", audience: audience, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    audience = Audiences.get_audience!(id)
    {:ok, _audience} = Audiences.delete_audience(audience)

    conn
    |> put_flash(:info, "Audience deleted successfully.")
    |> redirect(to: audience_path(conn, :index))
  end
end
