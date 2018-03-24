defmodule CheckersWeb.PageController do
  use CheckersWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def index1(conn, _params) do
    render conn, "index1.html"
  end

  def game(conn, params) do
    
    render conn, "game.html", game: params["game"]
  end
end
