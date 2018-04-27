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
  RemovePositionBonus
  %%
  AllWalkable
  Abs
  GoTo
  GoFar
  DistanceRms
in

fun{Move ActualPosition}
  X = ActualPosition.x
  Y = ActualPosition.y
in
  pt(x:(X mod Input.nColumn)+1 y:Y)
end

  /* fun{Move Position}
    X = Position.x
    Y = Position.y
  in
    pt(x:X+2 y:Y)
  end */

  % si on upgrade à checker tous les bonus dispo
  /* fun{RemoveBonusPosition P PositionBonusList NewPositionBonusList}
    case PositionBonusList
    of nil then NewPositionBonusList
    [] H|T then
      if H == P then
        {RemoveBonusPosition P T NewPositionBonusList}
      else
        {RemoveBonusPosition P T H|NewPositionBonusList}
      end
  end */

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
  in
    PacmanID = ID
    {NewPort Stream Port}
    thread
      {TreatStream Stream PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    end
    Port
  end

  %traite le Stream
  proc{TreatStream Stream PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    case Stream of nil then skip
    [] getId(ID)|T then
      ID = PacmanID
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    [] assignSpawn(P)|T then
      SpawnPoint = P
      Position = P
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    [] spawn(ID P)|T then
      ID = PacmanID
      P = SpawnPoint
      {TreatStream T PacmanID SpawnPoint Position true BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    [] move(ID P)|T then
      if IsAlive then
        ID = PacmanID
        P = {Move Position}
        {TreatStream T PacmanID SpawnPoint P IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
      else
        ID = null
        P= null
        {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
      end
    [] bonusSpawn(P)|T then
      {TreatStream T PacmanID SpawnPoint Position IsAlive P GhostPositionList PointPositionList Score NumberOfLifes}
    [] pointSpawn(P)|T then
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList P|PointPositionList Score NumberOfLifes}
    [] bonusRemoved(P)|T then
      {TreatStream T PacmanID SpawnPoint Position IsAlive nil GhostPositionList PointPositionList Score NumberOfLifes}
    [] pointRemoved(P)|T then
      %%%%%complete
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    [] addPoint(Add ID NewScore)|T then
      %%%%%complete
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    [] gotKilled(ID NewLife NewScore)|T then
      ID = PacmanID
      NewLife = NumberOfLifes-1
      NewScore = Score-Input.penalityKill
      {TreatStream T PacmanID SpawnPoint Position false BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    [] ghostPos(ID P)|T then
      %%%%%complete
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    [] killGhost(IDg IDp NewScore)|T then
      IDp = PacmanID
      NewScore = Score+Input.rewardKill
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    [] deathGhost(ID)|T then
      %%%%%complete
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    [] setMode(M)|T then
      %%%%%complete
      {TreatStream T PacmanID SpawnPoint Position IsAlive BonusPosition GhostPositionList PointPositionList Score NumberOfLifes}
    else
      {Browser.browse '---Pacman didn\'t recognise this message---'}
    end
  end



end
