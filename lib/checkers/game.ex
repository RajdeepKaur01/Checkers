defmodule Checkers.Game do
  def new do
    %{
      tiles: fill(),
      kings: List.duplicate(nil,64),
    }
  end

  def fillTiles(tiles,x,last,start,val) do
    if(x<=last) do
      if(rem(x,8) == 0) do
        # IO.inspect(x)
        if(start == 0) do
          start=1
        else start=0
      end
    end
    if(start+ rem(x,2) == 1) do
      tiles= List.replace_at(tiles,x,val)
      # IO.inspect(tiles)
    end
    tiles=  fillTiles(tiles,x+1,last,start,val)
  end
  tiles
end


def fill do
  tiles= List.duplicate(nil,64)
  start=1

  tiles = fillTiles(tiles,0,23,1,1)
  start=0
  tiles = fillTiles(tiles,40,63,0,-1)
  tiles
end



def client_view(game) do

  %{
    tiles: game.tiles,
    kings: game.kings,
  }
end
end
