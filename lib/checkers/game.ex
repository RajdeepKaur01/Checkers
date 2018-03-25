defmodule Checkers.Game do
  def new do
    %{
      tiles: fill(),
      kings: List.duplicate(nil,88),
      turn: true,
      winner: nil,
      prev: nil,
      players: %{player1: nil, player2: nil,},
      spectators: MapSet.new,
      moves: 0,
      nextTurn: 0,
    }
  end

  def restart(game) do
    Map.merge(game,%{tiles: fill(),kings: List.duplicate(nil,80),turn: true,winner: nil,
    prev: nil, players: game.players, spectators: game.spectators,moves: 0,})
  end

  def fillTiles(tiles,x,last,start,val) do
    if(x<=last) do
      if(rem(x,8) == 0) do
        if(start == 0) do
          start=1
        else start=0
      end
    end
    if(start+ rem(x,2) == 1) do
      tiles= List.replace_at(tiles,x,val)
    end
    tiles=  fillTiles(tiles,x+1,last,start,val)
  end
  tiles
end


def fill do
  tiles= List.duplicate(nil,88)
  start=1

  tiles = fillTiles(tiles,0,23,1,1)
  start=0
  tiles = fillTiles(tiles,40,63,0,-1)
  tiles
end

def addUser(game, user) do
  players= game.players
  spectators= game.spectators
  cond do
    players.player1 == nil ->  players= Map.merge(players, %{player1: user})
    Map.merge(game, %{players: players})
    players.player2 == nil and players.player1 != user -> players= Map.merge(players, %{player2: user})
    Map.merge(game, %{players: players})
    players.player1 != user and players.player2 != user -> Map.merge(game,%{spectators: MapSet.put(spectators,user)})
    true -> game
  end
end

def deleteUser(game, user) do
  spectators= game.spectators
  spectators= MapSet.delete(spectators,user)
  Map.merge(game,%{spectators: spectators})
end

def handleClick(game,i) do
  tiles=game.tiles
  kings=game.kings
  turn= game.turn
  winner= game.winner
  prev= game.prev
  moves= game.moves
  # IO.inspect(prev)
  if(prev == nil) do
    if(Enum.at(tiles,i) == nil) do game else
      if((turn and Enum.at(tiles,i) == 1) or (!turn and Enum.at(tiles,i) == -1)) do
        prev = i
      end
      winner = findWinner(tiles,moves)
      IO.inspect(prev)
      Map.merge(game, %{prev: prev, moves: moves+1, winner: winner, nextTurn: 0}) end
    else helper(game,i)
  end
end

def normalJump(game,i,pos) do
  tiles=game.tiles
  kings=game.kings
  turn= game.turn
  winner= game.winner
  prev= game.prev
  moves= game.moves
  nextMove= false
  nextTurn= game.nextTurn

  val = Enum.at(tiles,i)
  prev_val = Enum.at(tiles,prev)
  king = Enum.at(kings,i)

  tiles = List.replace_at(tiles,prev,nil)
  tiles = List.replace_at(tiles,prev+pos,nil)
  tiles = List.replace_at(tiles,i,prev_val)
  if(Enum.at(kings,prev+pos) == 1) do kings= List.replace_at(kings,prev+pos,nil) end
  if(king == nil and (i < 8 or i > 55)) do kings = List.replace_at(kings,i,1)
  nextMove = nextMoveForKing(tiles,i)
  else nextMove= nextMoveForNormal(tiles,i) end
  winner = findWinner(tiles,moves)
  IO.inspect(nextMove)
  if(winner == nil and nextMove == true) do prev= i
  nextTurn = 1
  turn = !turn
  else prev = nil
  nextTurn = 0 end
  Map.merge(game, %{tiles: tiles, turn: !turn, prev: prev, kings: kings, winner: winner, moves: 0,nextTurn: nextTurn})
end

def normalMove(game,i) do
  tiles=game.tiles
  kings=game.kings
  turn= game.turn
  winner= game.winner
  prev= game.prev
  moves= game.moves
  nextMove= false
  nextTurn= game.nextTurn

  val = Enum.at(tiles,i)
  prev_val = Enum.at(tiles,prev)
  king = Enum.at(kings,i)

  tiles = List.replace_at(tiles,prev,nil)
  tiles = List.replace_at(tiles,i,prev_val)
  if(king == nil and (i < 8 or i > 55)) do kings = List.replace_at(kings,i,1)
  moves = 0
  else moves = moves + 1 end
  winner = findWinner(tiles,moves)
  Map.merge(game, %{tiles: tiles, turn: !turn, prev: nil, kings: kings, winner: winner, moves: moves, nextTurn: 0})
end

def helper(game,i) do
  tiles=game.tiles
  kings=game.kings
  turn= game.turn
  winner= game.winner
  prev= game.prev
  moves= game.moves
  nextMove= false
  nextTurn= game.nextTurn

  val = Enum.at(tiles,i)
  prev_val = Enum.at(tiles,prev)
  king = Enum.at(kings,i)

  cond do
    nextTurn == 0 and turn and val == 1 ->  IO.inspect(prev)
    Map.merge(game, %{prev: i, nextTurn: 0})
    nextTurn == 0 and !turn and val== -1 -> IO.inspect(prev)
    Map.merge(game, %{prev: i, nextTurn: 0})
    val == 1 or val == -1 -> game
    Enum.at(kings,prev) == 1 -> solveKings(game,i)
    # IO.inspect(i)

    prev_val == 1 and ((i == prev + 7 && rem(prev,8) != 0) or (i== prev + 9 && rem(prev,8) != 7)) -> normalMove(game,i)
    prev_val == -1 and ((i == prev-7 && rem(prev,8) != 7) or (i == prev - 9 && rem(prev,8) != 0)) -> normalMove(game,i)
    prev_val == 1 and ( i == prev + 14 && rem(prev,8) != 0 and rem(prev,8) != 1 and Enum.at(tiles,prev+7) == -1 ) -> normalJump(game,i,7)
    prev_val == 1 and  (i == prev + 18 && rem(prev,8) != 7 and rem(prev,8) != 6 and Enum.at(tiles,prev+9) == -1  ) -> normalJump(game,i,9)
    prev_val == -1 and (i == prev-14 && rem(prev,8) != 7 && rem(prev,8) != 6 and Enum.at(tiles,prev-7) == 1)  -> normalJump(game,i,-7)
    prev_val == -1 and  (i == prev - 18 && rem(prev,8) != 0 and rem(prev,8) != 1 and Enum.at(tiles,prev-9) == 1) -> normalJump(game,i,-9)
    true -> game
end
end

def kingJump(game,i,pos) do
  tiles = game.tiles
  kings = game.kings
  turn = game.turn
  winner = game.winner
  prev = game.prev
  val = Enum.at(tiles,i)
  prev_val = Enum.at(tiles,prev)
  moves = game.moves
  nextTurn = game.nextTurn

  tiles = List.replace_at(tiles,prev,nil)
  tiles = List.replace_at(tiles,prev+pos,nil)
  if(Enum.at(kings,prev+pos) == 1) do kings= List.replace_at(kings,prev+pos,nil) end
  tiles = List.replace_at(tiles,i,prev_val)
  kings = List.replace_at(kings,prev,nil)
  kings = List.replace_at(kings,i,1)
  winner = findWinner(tiles,moves)
  nextMove= nextMoveForKing(tiles,i)
  if(winner == nil and nextMove == true) do prev= i
  nextTurn= 1
  turn = !turn
  else prev = nil
  nextTurn = 0 end
  Map.merge(game, %{tiles: tiles, turn: !turn, prev: prev, kings: kings, winner: winner, moves: 0,nextTurn: nextTurn})


end

def solveKings(game,i) do
  tiles = game.tiles
  kings = game.kings
  turn = game.turn
  winner = game.winner
  prev = game.prev
  val = Enum.at(tiles,i)
  prev_val = Enum.at(tiles,prev)
  moves = game.moves
  nextTurn = game.nextTurn
  cond do

    (i == prev+7 && rem(prev,8) != 0) or (i == prev + 9 && rem(prev,8) != 7) or (i == prev-7 && rem(prev,8) != 7) or (i== prev - 9 && rem(prev,8) != 0) ->
      tiles = List.replace_at(tiles,prev,nil)
      tiles = List.replace_at(tiles,i,prev_val)
      kings = List.replace_at(kings,prev,nil)
      kings = List.replace_at(kings,i,1)
      winner = findWinner(tiles,moves)
      Map.merge(game, %{tiles: tiles, turn: !turn, prev: nil, kings: kings, winner: winner, moves: moves+1, nextTurn: 0})

      i == prev+14 && rem(prev,8) != 0 and rem(prev,8) !=1 and Enum.at(tiles,prev + 7) == (-1 * prev_val)  -> kingJump(game,i,7)
      i == prev + 18 && rem(prev,8) != 7 and rem(prev,8) != 6 and Enum.at(tiles,prev + 9) == (-1 * prev_val)   -> kingJump(game,i,9)
      i == prev-14 && rem(prev,8) != 7 && rem(prev,8) != 6 and Enum.at(tiles,prev - 7) == (-1 * prev_val) -> kingJump(game,i,-7)
      i== prev - 18 && rem(prev,8) != 0 and rem(prev,8) != 1 and Enum.at(tiles,prev - 9) == (-1 * prev_val) -> kingJump(game,i,-9)

true -> game

end
end

def client_view(game) do
  IO.inspect("inside Client")
  %{
    tiles: game.tiles,
    kings: game.kings,
    turn: game.turn,
    winner: game.winner,
    prev: game.prev,
    players: game.players,
    spectators: game.spectators,
    moves: game.moves,
    nextTurn: game.nextTurn,
  }
end

def nextMoveForNormal(tiles,i) do
  IO.inspect("inside nextMove")
  prev = i
  prev_val = Enum.at(tiles,i)
  cond do
    prev + 14 < 64 and prev + 7 < 64 and prev_val == 1 and rem(prev,8) != 0 and rem(prev,8) !=1 and Enum.at(tiles,prev+7) == -1 and Enum.at(tiles,prev + 14) == nil -> true
    prev + 18 < 64 and prev + 9 < 64 and prev_val == 1 and  rem(prev,8) != 7 and rem(prev,8) != 6 and Enum.at(tiles,prev+9) == -1 and Enum.at(tiles,prev + 18) == nil  -> true
    prev - 14 >= 0 and prev - 7 >= 0 and prev_val == -1 and rem(prev,8) != 7 && rem(prev,8) != 6 and Enum.at(tiles,prev-7) == 1 and Enum.at(tiles,prev - 14) == nil   -> true
    prev - 18 >= 0 and prev - 9 >= 0 and prev_val == -1 and  rem(prev,8) != 0 and rem(prev,8) != 1 and Enum.at(tiles,prev-9) == 1 and Enum.at(tiles,prev - 18) == nil   -> true
    true -> false

  end
end

def nextMoveForKing(tiles,i) do
  prev = i
  IO.inspect("inside King nextMove")
  IO.inspect(i)
  prev_val = Enum.at(tiles,i)
  cond do
    prev + 14 < 64 and prev + 7 < 64  and rem(prev,8) != 0 and rem(prev,8) !=1 and Enum.at(tiles,prev+7) == (-1 * prev_val) and Enum.at(tiles,prev + 14) == nil -> IO.inspect("pass")
    true
    prev + 18 < 64 and prev + 9 < 64  and rem(prev,8) != 7 and rem(prev,8) != 6 and Enum.at(tiles,prev+9) == (-1 * prev_val) and Enum.at(tiles,prev + 18) == nil -> IO.inspect("pass")
    true
    prev - 14 >= 0 and prev - 7 >= 0 and rem(prev,8) != 7 && rem(prev,8) != 6 and Enum.at(tiles,prev-7) == (-1 * prev_val) and Enum.at(tiles,prev - 14) == nil  -> IO.inspect("pass")
    true
    prev - 18 >= 0 and prev - 9 >= 0 and rem(prev,8) != 0 and rem(prev,8) != 1 and Enum.at(tiles,prev-9) == (-1 * prev_val) and Enum.at(tiles,prev - 18) == nil  -> IO.inspect("pass")
    true
    true -> false
  end

end

def findWinner(tiles,moves) do
  first= Enum.count(tiles, fn(x) -> x == 1 end)
  second= Enum.count(tiles, fn(x) -> x == -1 end)

  cond do
    first ==0 -> -1
    second ==0 -> 1
    moves >= 50 -> 0
    true -> nil
  end
end
end
