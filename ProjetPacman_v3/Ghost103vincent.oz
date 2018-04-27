functor
import
  Input
  Browser
export
  portPlayer:CreatePort
define
  CreatePort
  TreatStream
  Move
  CanGo
  Abs
  Dist
  Follow
  RemovePacmanPosition
  UpdatePacmanPositionList
in
  fun{CanGo PositionList NewPositionList}
    fun{CountRow XList Position Row}
      case XList of H|T then
        if Position.x == Row then
          if H \= 1 then
            true
          else
            false
          end
        else
          {CountRow T Position Row+1}
        end
      else
        false
      end
    end

    fun{CountColumn YList Position Column}
      case YList of H|T then
        if Column == Position.y then
          {CountRow H Position 1}
        else
          {CountColumn T Position Column+1}
        end
      else
        false
      end
    end
  in
    case PositionList
    of nil then NewPositionList
    [] H|T then
      if {CountColumn Input.map H 1} then
        {CanGo T H|NewPositionList}
      else
        {CanGo T NewPositionList}
      end
    end
  end

  fun{Abs X Y}
    if X > Y then
      X-Y
    elseif X == Y then
	    0
    else
	    Y-X
    end
  end

  fun{Dist P1 P2}
    {Abs P1.x P2.x} + {Abs P1.y P2.y}
  end

  fun{Follow PositionToFollow PossibleMoves BestMove}
    case PossibleMoves
    of nil then BestMove
    [] H|T then
      if BestMove == nil then {Follow PositionToFollow T H}
      else
        if {Dist H PositionToFollow} < {Dist BestMove PositionToFollow}  then
          {Follow PositionToFollow T H}
        else
          {Follow PositionToFollow T BestMove}
        end
      end
    end
  end

  fun{Move Position PacmanPositionList}
    X = Position.x
    Y = Position.y
    AllDirections
  in
    AllDirections = pt(x:(X mod Input.nColumn)+1 y:Y)|pt(x:(X mod Input.nColumn)-1 y:Y)|pt(x:X y:(Y mod Input.nRow)+1)|pt(x:X y:(Y mod Input.nRow)-1)|nil
    local PossibleMoves in
      PossibleMoves = {CanGo AllDirections nil}
      case PacmanPositionList
      of nil then PossibleMoves.1
      [] ID#P|T then {Follow P PossibleMoves nil}
      end
    end
  end

  fun{RemovePacmanPosition PacmanID PacmanPositionList NewList}
    case PacmanPositionList
    of nil then nil
    [] ID#P|T then
      if ID == PacmanID then
        {RemovePacmanPosition PacmanID T NewList}
      else
        {RemovePacmanPosition PacmanID T ID#P|NewList}
      end
    end
  end

  fun{UpdatePacmanPositionList PacmanID PacmanNewPosition PacmanPositionList}
    NewList
  in
    PacmanID#PacmanNewPosition|{RemovePacmanPosition PacmanID PacmanPositionList NewList}
  end

  %cree le port
  fun{CreatePort ID}
    Stream
    Port
    GhostID
    SpawnPoint
    Position
    IsAlive = false
    PacmanPositionList = nil
  in
    GhostID = ID
    {NewPort Stream Port}
    thread
      {TreatStream Stream GhostID SpawnPoint Position IsAlive PacmanPositionList}
    end
    Port
  end

  %traite le Stream
  proc{TreatStream Stream GhostID SpawnPoint Position IsAlive PacmanPositionList}
    case Stream of nil then skip
    [] getId(ID)|T then
      ID = GhostID
      {TreatStream T GhostID SpawnPoint Position IsAlive PacmanPositionList}
    [] assignSpawn(P)|T then
      SpawnPoint = P
      Position = P
      {TreatStream T GhostID SpawnPoint Position IsAlive PacmanPositionList}
    [] spawn(ID P)|T then
      ID = GhostID
      P = SpawnPoint
      {TreatStream T GhostID SpawnPoint Position true PacmanPositionList}
    [] move(ID P)|T then
      if IsAlive then
        ID = GhostID
        P = {Move Position PacmanPositionList}
        {TreatStream T GhostID SpawnPoint P IsAlive PacmanPositionList}
      else
        ID = null
        P= null
        {TreatStream T GhostID SpawnPoint Position IsAlive PacmanPositionList}
      end
    [] gotKilled()|T then
      {TreatStream T GhostID SpawnPoint Position false PacmanPositionList}
    [] pacmanPos(ID P)|T then
    %%
      local NewPacmanPositionList in
        NewPacmanPositionList = {UpdatePacmanPositionList ID P PacmanPositionList}
        {TreatStream T GhostID SpawnPoint Position IsAlive NewPacmanPositionList}
      end
    [] killPacman(ID)|T then
    %%
      local NewPacmanPositionList NewList in
        NewPacmanPositionList = {RemovePacmanPosition ID PacmanPositionList NewList}
        {TreatStream T GhostID SpawnPoint Position IsAlive NewPacmanPositionList}
      end
    [] deathPacman(ID)|T then
    %%
      local NewPacmanPositionList NewList in
        NewPacmanPositionList = {RemovePacmanPosition ID PacmanPositionList NewList}
        {TreatStream T GhostID SpawnPoint Position IsAlive NewPacmanPositionList}
      end
    [] setMode(M)|T then %
      {TreatStream T GhostID SpawnPoint Position IsAlive PacmanPositionList}
    else
      {Browser.browse '---Pacman didn\'t recognise this message---'}
    end
  end



end
