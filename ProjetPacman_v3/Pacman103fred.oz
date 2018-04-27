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
  GoFar
  RemoveGhostPosition
  UpdateGhostPositionList
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

  fun{GoFar PositionToAvoid PossibleMoves BestMove}
    case PossibleMoves
    of nil then BestMove
    [] H|T then
      if BestMove == nil then {GoFar PositionToAvoid T H}
      else
        if {Dist H PositionToAvoid} > {Dist BestMove PositionToAvoid}  then
          {GoFar PositionToAvoid T H}
        else
          {GoFar PositionToAvoid T BestMove}
        end
      end
    end
  end

  fun{Move Position GhostPositionList BonusPosition Mode}
    X = Position.x
    Y = Position.y
    AllDirections
  in
    AllDirections = pt(x:(X mod Input.nColumn)+1 y:Y)|pt(x:(X mod Input.nColumn)-1 y:Y)|pt(x:X y:(Y mod Input.nRow)+1)|pt(x:X y:(Y mod Input.nRow)-1)|nil
    local PossibleMoves in
      PossibleMoves = {CanGo AllDirections nil}
      case Mode of classic then
        case GhostPositionList
        of nil then PossibleMoves.1
        [] ID#P|T then {GoFar P PossibleMoves nil}
        end
      [] hunt then
        case GhostPositionList
        of nil then PossibleMoves.1
        [] ID#P|T then {Follow P PossibleMoves nil}
        end
      else
        PossibleMoves.1
      end
    end
  end

  fun{RemoveGhostPosition GhostID GhostPositionList NewList}
    case GhostPositionList
    of nil then nil
    [] ID#P|T then
      if ID == GhostID then
        {RemoveGhostPosition GhostID T NewList}
      else
        {RemoveGhostPosition GhostID T ID#P|NewList}
      end
    end
  end

  fun{UpdateGhostPositionList GhostID GhostNewPosition GhostPositionList}
    NewList
  in
    GhostID#GhostNewPosition|{RemoveGhostPosition GhostID GhostPositionList NewList}
  end

  %cree le port
  fun{CreatePort ID}
    Stream
    Port
    PacmanID
    SpawnPoint
    Position
    IsAlive = false
    BonusPosition = nil
    GhostPositionList = nil
    PointPositionList = nil
    Score = 0
    NumberOfLifes = Input.nbLives
    Mode = classic
  in
    PacmanID = ID
    {NewPort Stream Port}
    thread
      {TreatStream Stream PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
    end
    Port
  end

  %traite le Stream
  proc{TreatStream Stream PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
    case Stream of nil then skip
    [] getId(ID)|T then
      ID = PacmanID
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
    [] assignSpawn(P)|T then
      SpawnPoint = P
      Position = P
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
    [] spawn(ID P)|T then
      ID = PacmanID
      P = SpawnPoint
      {TreatStream T PacmanID SpawnPoint Position true BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
    [] move(ID P)|T then
      if IsAlive then
        ID = PacmanID
        P = {Move Position GhostPositionList BonusPosition Mode}
        {TreatStream T PacmanID SpawnPoint P IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
      else
        ID = null
        P= null
        {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
      end
    [] bonusSpawn(P)|T then
      {TreatStream T PacmanID SpawnPoint Position IsAlive P GhostPositionList PointPositionList Score NumberOfLifes Mode}
    [] pointSpawn(P)|T then %
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
    [] bonusRemoved(P)|T then
      {TreatStream T PacmanID SpawnPoint Position IsAlive nil GhostPositionList PointPositionList Score NumberOfLifes Mode}
    [] pointRemoved(P)|T then %
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
    [] addPoint(Add ID NewScore)|T then
      ID = PacmanID
      NewScore = Score + Add
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList NewScore NumberOfLifes Mode}
    [] gotKilled(ID NewLife NewScore)|T then
      ID = PacmanID
      NewLife = NumberOfLifes-1
      NewScore = Score-Input.penalityKill
      {TreatStream T PacmanID SpawnPoint Position false BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
    [] ghostPos(ID P)|T then
      local NewGhostPositionList in
        NewGhostPositionList = {UpdateGhostPositionList ID P GhostPositionList}
        {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition NewGhostPositionList PointPositionList Score NumberOfLifes Mode}
      end
    [] killGhost(IDg IDp NewScore)|T then
      IDp = PacmanID
      NewScore = Score+Input.rewardKill
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes Mode}
    [] deathGhost(ID)|T then
      local NewGhostPositionList NewList in
        NewGhostPositionList = {RemoveGhostPosition ID GhostPositionList NewList}
        {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition NewGhostPositionList PointPositionList Score NumberOfLifes Mode}
      end
    [] setMode(M)|T then %
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes hunt}
    else
      {Browser.browse '---Pacman didn\'t recognise this message---'}
    end
  end



end
