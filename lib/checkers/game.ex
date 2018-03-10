defmodule Checkers.Game do
  def new do
    %{
      tiles: List.duplicate(nil,16),
      found: List.duplicate(0,16),
      prev_value: -1,
      count: 0,
      click: 0,
    }
  end
  def client_view(game) do

    %{
      tiles: game.tiles,
      tiles1: game.tiles1,
      found: game.found,
      prev_value: game.prev_value,
      count: game.count,
      click: game.click,
    }
  end
end
