defmodule CheckersWeb.PageController do
  use CheckersWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def index1(conn, _params) do
    render conn, "index1.html"
  end

  def game(conn, params) do
      # user = Checkers.Accounts.get_user_by_email(email)
      IO.inspect(conn)
      players= Checkers.Players.get_players_by_game(params["game"])
      person=%{game: params["game"], user_id: conn.assigns.current_user.id}
      if(Checkers.Players.get_player_by_user(conn.assigns.current_user.id) || Checkers.Audiences.get_audience_by_user(conn.assigns.current_user.id )) do
      else
      if(length(players) < 2) do
        Checkers.Players.create_player(person)
      else
        Checkers.Audiences.create_audience(person)
      end
    end
    render conn, "game.html", game: params["game"]
  end
end
