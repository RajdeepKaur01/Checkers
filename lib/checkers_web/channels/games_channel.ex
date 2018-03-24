defmodule CheckersWeb.GamesChannel do
  use CheckersWeb, :channel
  alias Checkers.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Checkers.GameBackup.load(name) || Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      |> assign(:user, payload)
      Checkers.GameBackup.save(socket.assigns[:name], game)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  def handle_in("addUser", %{"username" => user, "gamename" => name}, socket) do
    game = Checkers.GameBackup.load(name)
    game = Game.addUser(game, user)
    Checkers.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    push socket , "user_update", Game.client_view(game)
    broadcast socket, "user_update", Game.client_view(game)
    {:noreply, socket}
  end


  def handle_in("handleClick", %{"num" => i, "name" => name}, socket) do

    game = Checkers.GameBackup.load(name)
    game = Game.handleClick(game, i)
    Checkers.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    push socket , "game_update", Game.client_view(game)
    broadcast socket, "game_update", Game.client_view(game)
    {:noreply, socket}
  end

  def handle_in("restart", %{}, socket) do
    game = Checkers.GameBackup.load(socket.assigns[:name])
    game = Game.restart(game)
    Checkers.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    push socket , "restart", Game.client_view(game)
    broadcast socket, "restart", Game.client_view(game)
    {:noreply, socket}
  end

  defp authorized?(_payload) do
    true
  end

  def terminate(_msg, socket) do
    game = Checkers.GameBackup.load(socket.assigns[:name])
    game = Game.deleteUser(game, socket.assigns[:user])
    Checkers.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    push socket , "user_gone", Game.client_view(game)
    broadcast socket, "user_gone", Game.client_view(game)
    socket

  end
end
