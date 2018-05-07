functor
import
   GUI
   Input
   PlayerManager
   Browser
   OS
   System
   Application
   %import de test
define
   WindowPort
   PacmansPort
   GhostPort
   PlayerPort
  %variables de spawn d'entitees
  MakePacman
  MakeGhost
  PacmanListPort
  PacmanSpawn
  GhostSpawn
  PosListPacman
  InitPacmanList
  InitGhostList
  SpawnBonus
  SpawnPoints
  %variables de generation des cases map
  CreaSpawnBonus
  CreaSpawnGhost
  CreaSpawnPacman
  CreaPoint
  GetPosListPacmanSpawn
  GetPosListGhostSpawn
  GetPosListBonusSpawn
  GetPosListPoints
  GetRemainingPoints
  GetWallPosition
  %variables d'initialisation de partie
  RandomTri
  BuildRandomList
  ControlPos
  RandomPosP
  RandomPosG
  GameSetUp
  GenerateBonus
  GeneratePoints
  RandomPlayer
  InitCell
  %variables turnbyturn
  PacmanTurn
  GhostTurn
  %variables de partie
  EndGame
  FindWinnerID
  FindIdByPosition
  FindPortByID
  PacmanIsKillRandom
  PacmanIsKillGhostLoop
  PacmanKillGhostRandom
  PacmanKillGhostPacmanLoop
  MoveCell
  MovePacmanById
  MoveGhostById
  DeleteCell
  GameStartTurn
  IsDead
  UpdateDead
  GetBonus
  UpdatePoint
  GetPoint
  ScanPositionGhost
  ScanPosition
  PacmanIsKill
  PacmanIsDead
  PacmanKillGhost
  UpdateScore
  UpdateLife
  PacmanLive
  GhostLive
  PacmanRespawn
  GhostRespawn
  PointIsIn
  AddToRespawn
  RemoveFromDeath
  SetMode
  PacmanGotBonus
  RespawnTimeBonus
  RespawnBonus
  RespawnPoint
  UpdateBonusTime
  UpdatePointsTime
  UpdateHuntMode
  InformGhostThanPacmanDead
  InformGhostThanPacmanMove
  InformPacmanThanBonusHide
  InformPacmanThanBonusSpawn
  InformPacmanThanPointHide
  InformPacmanThanPointSpawn
  InformPacmanThanGhostDead
  InformPacmanThanGhostMove
  GameManager
  %variables de test
  BrowseList
  BrowsePortId
  BrowseItemByID
  %variables d'environnement
  BonusList
  DeadPlayer
  SpawnPacmanList
  SpawnGhostList
  SpawnPacmanPositions
  SpawnGhostPositions
  SpawnBonusPositions
  NumberOfDeath
  RemainingPoints
  PacmanPositions
  GhostsPositions
  PointsRespawn
  BonusRespawn
  WallPosition
  HuntMode
  PacmanPortPositions
  GhostPortPositions
  %variables utilitaires
  Split
  Append
  Remove
  Length
  GetWithPosition
  Purge
  IsIn
in
%%%%%%%%%%%%%%%%%%%%%%%% fonctions de testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %procedure de testing

  proc {BrowseList L}
    case L of nil then skip
    []H|T then
    thread {Browser.browse H} end
    {BrowseList T}
    end
  end

  %procedure de testing
  %prend une liste de ports en entree et browse leur id

  proc {BrowsePortId P}
    case P of nil then skip
    [] H|T then X in
    {Send H getId(X)}
    {Browser.browse X}
    {BrowsePortId T}
    end
  end

  proc {BrowseItemByID L ID}
    case L of nil then {Browser.browse 'notfound'}
    [] H|T then if H.id == ID.id then {Browser.browse H}
                else {BrowseItemByID T ID}
                end
    end
  end

%%%%%%%%%%%%%%%%%%%% fonctions utilitaires %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun {Append L1 L2}
  case L1 of nil then L2
  []H|T then {Append T H|L2}
  end
end

fun{Split L N}
  case L of nil then nil
  []H|T then
          if N == 0 then H
          else {Split T N-1}
          end
  end
end

fun{Remove L Cut}
  case L of nil then nil
  [] H|T then if H == Cut then T
              else H|{Remove T Cut}
              end
  end
end

fun {Purge L}
  case L of nil then nil
  [] H|T then if H == nil then {Purge T}
              else H|{Purge T}
              end
  end
end
%Acc est initialise a 0
fun {Length L Acc}
  case L of nil then Acc
  [] H|T then {Length T Acc+1}
  end
end

fun {GetWithPosition L This}
  case L of nil then nil
  [] H|T then if H.pt.x == This.x andthen H.pt.y == This.y then H
              else {Get T This}
              end
  end
end

fun {IsIn L Elem}
  case L of nil then false
  []H|T then if H.x == Elem.x andthen H.y == Elem.y then true
              else {IsIn T Elem}
              end
  end
end

proc {PacmanIsKillGhostLoop List GhostPort}
  case List of nil then skip
  [] H|T then {PacmanIsKill {FindPortByID PacmansPort H} GhostPort}
              {PacmanIsKillGhostLoop T GhostPort}
  end
end

%Number est toujours plus petit ou = a List.length
%Number doit etre choisi aleatoirement
proc {PacmanKillGhostRandom List GhostID GhostPort Number}
  if Number == 1 then {PacmanKillGhost {FindPortByID PacmansPort List.1} GhostID GhostPort}
  else {PacmanKillGhostRandom List.2 GhostID GhostPort Number-1}
  end
end

%Number est toujours plus petit ou = a List.length
%Number doit etre choisi aleatoirement
proc {PacmanIsKillRandom PacmanPort List Number}
  if Number == 1 then  {PacmanIsKill PacmanPort {FindPortByID GhostPort List.1}}
  else {PacmanIsKillRandom PacmanPort List.2 Number-1}
  end
end

proc {PacmanKillGhostPacmanLoop PacmanPort List}
  case List of nil then skip
  [] H|T then {PacmanKillGhost PacmanPort H {FindPortByID GhostPort H}}
              {PacmanKillGhostPacmanLoop PacmanPort T}
  end
end
%%%%%%%%% fonctions d'initialisation des parametres du jeu %%%%%%%%%%

%les 4 fonctions suivantes permettent de generer le template des 4 tuples de
%positions
fun{CreaSpawnPacman Row Column}
  pt(x:Column y:Row)
end

fun {CreaSpawnGhost Row Column}
  pt(x:Column y:Row)
end

fun {CreaSpawnBonus Row Column}
  bonus(x:Column y:Row bool:true)
end

fun {CreaPoint Row Column}
  point(x:Column y:Row time:Input.respawnTimePoint)
end

%Cette fonction renvoie une liste de tuples pt() contenant les positions des
%differents Pacmans sur la map
fun {GetPosListPacmanSpawn L Row Acc}
  local
    fun {Loop L Row Column Acc}
      case L of nil then Acc
      [] H|T then if H == 2 then {Loop T Row Column+1 {CreaSpawnPacman Row Column}|Acc}
                  else {Loop T Row Column+1 Acc}
                  end
      end
    end
  in
    case L of nil then Acc
    [] H|T then {GetPosListPacmanSpawn T Row+1 {Append {Loop H Row 1 nil} Acc}}
    end
  end
end

%Cette fonction renvoie une liste de tuples pt() contenant les positions des
%differents ghosts sur la map
fun {GetPosListGhostSpawn L Row Acc}
  local
    fun {Loop L Row Column Acc}
      case L of nil then Acc
      [] H|T then if H == 3 then {Loop T Row Column+1 {CreaSpawnGhost Row Column}|Acc}
                  else {Loop T Row Column+1 Acc}
                  end
      end
    end
  in
    case L of nil then Acc
    [] H|T then {GetPosListGhostSpawn T Row+1 {Append {Loop H Row 1 nil} Acc}}
    end
  end
end

%Cette fonction renvoie une liste de tuples pt() contenant les positions des
%differents bonus sur la map
fun {GetPosListBonusSpawn L Row Acc}
  local
    fun {Loop L Row Column Acc}
      case L of nil then Acc
      [] H|T then if H == 4 then {Loop T Row Column+1 {CreaSpawnBonus Row Column}|Acc}
                  else {Loop T Row Column+1 Acc}
                  end
      end
    end
  in
    case L of nil then Acc
    [] H|T then {GetPosListBonusSpawn T Row+1 {Append {Loop H Row 1 nil} Acc}}
    end
  end
end

%Cette fonction renvoie une liste de tuples pt() contenant les positions des
%differents points "walkabled" sur la map
fun {GetPosListPoints L Row Acc}
  local
    fun {Loop L Row Column Acc}
      case L of nil then Acc
      [] H|T then if H == 0 then {Loop T Row Column+1 {CreaPoint Row Column}|Acc}
                  else {Loop T Row Column+1 Acc}
                  end
      end
    end
  in
    case L of nil then Acc
    [] H|T then {GetPosListPoints T Row+1 {Append {Loop H Row 1 nil} Acc}}
    end
  end
end


fun {GetRemainingPoints L Row Acc}
  local
  fun {Loop L Row Column Acc}
      case L of nil then Acc
      [] H|T then if H == 0 then {Loop T Row Column+1 Acc+1}
                  else {Loop T Row Column+1 Acc}
                  end
      end
    end
  in
    case L of nil then Acc
    [] H|T then {GetRemainingPoints T Row+1 {Loop H Row 1 0}+Acc}
    end
  end
end

fun {GetWallPosition L Row Acc}
  local
    fun {Loop L Row Column Acc}
      case L of nil then Acc
      [] H|T then if H == 1 then {Loop T Row Column+1 {CreaPoint Row Column}|Acc}
                  else {Loop T Row Column+1 Acc}
                  end
      end
    end
  in
    case L of nil then Acc
    [] H|T then {GetWallPosition T Row+1 {Append {Loop H Row 1 nil} Acc}}
    end
  end
end
%%%%%%%%%%%% fonctions d'initialisation pacmans et fantomes %%%%%%%%%%%%%%%%%%%
%cette fonction renvoie une liste de tuples Pacman()
fun {MakePacman PacmanNumber ColorList NameList Acc}
    if PacmanNumber == 0 then nil
    else case ColorList of nil then nil%cette fonction renvoie une liste de tuples ghost()
         [] (H|T) then
           case NameList
           of nil then nil
           [] A|B then
           pacman(id:Acc color:H name:A)|{MakePacman PacmanNumber-1 T B Acc+1}
           end
        end
    end
 end

 %cette fonction renvoie une liste de tuples ghost()
 fun {MakeGhost GhostNumber ColorList NameList Acc}
    if {Length ColorList 0} > {Length NameList 0} then
      if GhostNumber == 0 then nil
      else case ColorList of nil then nil
           [] (H|T) then X in
            X = [103 104 111 115 116 Acc+48-Input.nbPacman]
             ghost(id:Acc color:H name:{String.toAtom X})|{MakeGhost GhostNumber-1 T nil Acc+1}
          end
      end
    else
      if GhostNumber == 0 then nil
      else case ColorList of nil then nil
           [] (H|T) then
             case NameList
             of nil then nil
             [] A|B then
             ghost(id:Acc color:H name:{String.toAtom A})|{MakeGhost GhostNumber-1 T B Acc+1}
             end
          end
      end
    end
  end

 %cette fonction renvoie une liste contenant les ports des differents pacmans
 fun {InitPacmanList IDList Kind}
  case IDList of nil then nil
  [] H|T then {PlayerManager.playerGenerator Kind.1 H}|{InitPacmanList T Kind.2}
  end
 end

 %cette fonction renvoie une liste contenant les ports des differents fantomes
 fun {InitGhostList IDList Kind}
  case IDList of nil then nil
  [] H|T then {PlayerManager.playerGenerator Kind.1 H}|{InitGhostList T Kind.2}
  end
 end

 %Procedure contenant les commandes pour que la fenetre initialise et spawn
 %un Pacman et de setup la position de depart du Pacman
 proc {PacmanSpawn Pacman Position}
    local X Y in
      {Send Pacman assignSpawn(Position)}
      thread {Send Pacman spawn(X Y)} end
      thread {Send WindowPort initPacman(X)} end
      thread {Send WindowPort spawnPacman(X Y)} end
    end
 end

 %Procedure contenant les commandes pour que la fenetre initialise et spawn
 %un ghost et de setup la position de depart du ghost
 proc {GhostSpawn Ghost Position}
  local X Y in
      {Send Ghost assignSpawn(Position)}
      thread {Send Ghost spawn(X Y)} end
      thread {Send WindowPort initGhost(X)} end
      thread {Send WindowPort spawnGhost(X Y)} end
    end
 end

 %Procedure contenant les commandes pour que la fenetre initialise et spawn
 %un bonus
 proc {SpawnBonus Bonus}
   if Bonus.bool == false then skip
   else
      thread {Send WindowPort initBonus(pt(x:Bonus.x y:Bonus.y))} end
      thread {Send WindowPort spawnBonus(pt(x:Bonus.x y:Bonus.y))} end
   end
 end

 %Procedure contenant les commandes pour que la fenetre initialise et spawn
 %un point
 proc {SpawnPoints Point}
      thread {Send WindowPort initPoint(pt(x:Point.x y:Point.y))} end
      thread {Send WindowPort spawnPoint(pt(x:Point.x y:Point.y))} end
 end
%%%%%%%%%%%%%%%%%%%%%%%% procedure de spawn aleatoire %%%%%%%%%%%%%%%%%%%%%%%%%

%Procedure renvoyant une liste pseudo-aleatoire
fun {BuildRandomList L Save Max}
  if Max == 0 then nil
  else
    case L of nil then {BuildRandomList Save nil Max}
    []H|T then H|{BuildRandomList T H|Save Max-1}
    end
  end
end

%Procedure permettant de faire spawn une liste de Pacmans
proc {RandomPosP Pacmans Position}
  case Pacmans of nil then skip
  []H|T then  X Y in {PacmanSpawn H Position.1}
              thread {Send H getId(Y)} end
              X = {Cell.access PacmanPositions}
              {Cell.assign PacmanPortPositions pacpos(id:Y x:Position.1.x y:Position.1.y)|{Cell.access PacmanPortPositions}}
              {Cell.assign PacmanPositions pacpos(id:Y.id x:Position.1.x y:Position.1.y)|X}
              {RandomPosP T Position.2}
  end
end

%Procedure permettant de faire spawn une liste de ghost
proc {RandomPosG Ghosts Position}
  case Ghosts of nil then skip
  []H|T then X Y in
            {GhostSpawn H Position.1}
            thread {Send H getId(Y)} end
            X = {Cell.access GhostsPositions}
            {Cell.assign GhostPortPositions gopos(id:Y x:Position.1.x y:Position.1.y)|{Cell.access GhostPortPositions}}
            {Cell.assign GhostsPositions gopos(id:Y.id x:Position.1.x y:Position.1.y)|X}
            {RandomPosG T Position.2}
  end
end

%Procedure permettant de faire spawn une liste de bonus
proc {GenerateBonus Bonus}
  case Bonus  of nil then skip
  [] H|T then {SpawnBonus H} {GenerateBonus T}
  end
end

%Procedure permettant de faire spawn une liste de points
proc {GeneratePoints Points}
  case Points of nil then skip
  [] H|T then {SpawnPoints H} {GeneratePoints T}
  end
end

%Renvoie une liste de ports trier de maniere desordonnee
fun {RandomPlayer L Max}
    if Max == 1 then L
    else case L of nil then nil
      [] H|T then X Y in
        %TODO
        X = ({OS.rand} mod Max)+1
        Y = {Split L X}
        Y|{RandomPlayer {Remove L Y} Max-1}
      end
    end
end

fun {InitCell Max Min}
  if Max == Min then nil
  else position(id:Max x:'null' y:'null')|{InitCell Max-1 Min}
  end
end

%%%%%%%%%%%%%%%% procedures generales du jeu %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun {MovePacmanById List ID Position}
if ID == null then List
else if Position == null then List
    else
      case List of nil then nil
      [] H|T then if H.id.id == ID.id then pacpos(id:ID x:Position.x y:Position.y)|T
                  else H|{MovePacmanById T ID Position}
                  end
      end
    end
end
end

fun {MoveGhostById List ID Position}
  case List of nil then nil
  [] H|T then if H.id.id == ID.id then gopos(id:ID x:Position.x y:Position.y)|T
              else H|{MoveGhostById T ID Position}
              end
  end
end

fun{FindWinnerID L ID ScoreMax}
  case L  of nil then ID
  [] H|T then X Y in
  thread {Send H addPoint(0 X Y)} end
    if Y == ScoreMax then A in
      A = {OS.rand} mod 2
      if A == 1 then {FindWinnerID T ID ScoreMax}
      else {FindWinnerID T X Y}
      end
    else
        if Y < ScoreMax then {FindWinnerID T ID ScoreMax}
        else {FindWinnerID T X Y}
        end
    end
  end
end

fun{EndGame DeadPlayer RemainingPoints}
  if DeadPlayer == Input.nbPacman then true
  else
    if RemainingPoints == 0 then true
    else false
    end
  end
end

fun {MoveCell ID X Y List}
  case List of nil then nil
  [] H|T then if H.id == ID then position(id:ID x:X y:Y)|T
    else H|{MoveCell ID X Y T}
    end
  end
end

fun {DeleteCell ID List}
  case List of nil then nil
  [] H|T then if H.id == ID then T
    else H|{DeleteCell ID T}
    end
  end
end

fun {IsDead ID List}
  case List of nil then nil
  [] H|T then if H.id.id == ID then H
              else {IsDead ID T}
              end
  end
end

fun {UpdateDead Cellcontent ID}
  case Cellcontent of nil then nil
  [] H|T then if H.id.id == ID.id then deadstate(id:H.id time:H.time-1)|T
            else H|{UpdateDead T ID}
            end
  end
end

proc{GetBonus PacmanPort Position List ?Bound}
  skip
end

fun {UpdatePoint Cellcontent Position}
  if Position == null then Cellcontent
  else
  {CreaPoint Position.y Position.x}|Cellcontent
  end
end

fun {PointIsIn L Position}
if Position == null then
  false
else
    case L of nil then false
    [] H|T then if H.x == Position.x andthen H.y == Position.y then true
              else
                {PointIsIn T Position}
              end
    end
end
end

proc {GetPoint PacmanPort Position}
  local X Y Z in
    Z = {Cell.access PointsRespawn}
    if {PointIsIn Z Position} then
      skip
    else if {PointIsIn SpawnPacmanPositions Position} then
            skip
         else if {PointIsIn SpawnGhostPositions Position} then
                skip
              else
                {Cell.assign PointsRespawn {UpdatePoint Z Position}}
                thread {Send PacmanPort addPoint(Input.rewardPoint X Y)} end
                thread {Send WindowPort scoreUpdate(X Y)} end
                thread {Send WindowPort hidePoint(Position)} end
                {InformPacmanThanPointHide PacmansPort Position}
              end
         end
    end
  end
end

proc {InformGhostThanPacmanDead GhostsPort ID}
  case GhostsPort of nil then skip
  [] H|T then thread {Send H deathPacman(ID)} end
              {InformGhostThanPacmanDead T ID}
  end
end

proc {InformGhostThanPacmanMove GhostsPort ID Position}
  case GhostsPort of nil then skip
  [] H|T then thread {Send H pacmanPos(ID Position)} end
              {InformGhostThanPacmanMove T ID Position}
  end
end


%%%%%%%%%%%%%%%%% procedures de gestion du tour par tour %%%%%%%%%%%%%%%%%%%%

fun {ScanPosition List Position}
  case List of nil then false
  [] H|T then if Position == null then false
              else
                if H.x == Position.x andthen H.y == Position.y then true
                          else {ScanPosition T Position}
                          end
              end
  end
end

fun{PacmanIsDead PlayersList PacmanPort}
  case PlayersList of nil then nil
  [] H|T then if H == PacmanPort then
                T
              else H|{PacmanIsDead T PacmanPort}
              end
  end
end

proc {AddToRespawn ID RespawnTime}
  local X in
    X = {Cell.access DeadPlayer}
    {Cell.assign DeadPlayer deadstate(id:ID time:RespawnTime)|X}
  end
end

proc {PacmanIsKill PacmanPort GhostsPort}
  local X Y Z in
    thread {Send PacmanPort gotKilled(X Y Z)} end
    thread {Send WindowPort lifeUpdate(X Y)} end
    thread {Send WindowPort scoreUpdate(X Z)} end
    thread {Send WindowPort hidePacman(X)} end
    thread {Send GhostsPort killPacman(X)} end
    thread {InformGhostThanPacmanDead GhostPort X} end
    if Y > 0 then
      {AddToRespawn X Input.respawnTimePacman}
    else local S in
      S = {Cell.access PlayerPort}
      {Cell.assign PlayerPort {PacmanIsDead S PacmanPort}}
      {Cell.assign NumberOfDeath {Cell.access NumberOfDeath}+1}
        end
    end
  end
end

proc {SetMode L Mode}
  case L of nil then skip
  []H|T then thread {Send H setMode(Mode)} end
                    {SetMode T Mode}
  end
end

proc {InformPacmanThanBonusHide PacmanList Position}
  case PacmanList of nil then skip
  [] H|T then thread {Send H bonusRemoved(Position)} end
              {InformPacmanThanBonusHide T Position}
  end
end

proc {InformPacmanThanBonusSpawn PacmanList Position}
  case PacmanList of nil then skip
  [] H|T then thread {Send H bonusSpawn(Position)} end
              {InformPacmanThanBonusSpawn T Position}
  end
end

proc {InformPacmanThanPointHide PacmanList Position}
  case PacmanList of nil then skip
  [] H|T then thread {Send H pointRemoved(Position)} end
              {InformPacmanThanPointHide T Position}
  end
end

proc {InformPacmanThanPointSpawn PacmanList Position}
  case PacmanList of nil then skip
  [] H|T then thread {Send H pointSpawn(Position)} end
              {InformPacmanThanPointSpawn T Position}
  end
end

proc {InformPacmanThanGhostDead PacmanList GhostID}
  case PacmanList of nil then skip
  [] H|T then thread {Send H deathGhost(GhostID)} end
              {InformPacmanThanGhostDead T GhostID}
  end
end

proc {InformPacmanThanGhostMove PacmanList GhostID Position}
  case PacmanList of nil then skip
  [] H|T then thread {Send H ghostPos(GhostID Position)} end
              {InformPacmanThanGhostMove T GhostID Position}
  end
end

proc {PacmanGotBonus Position}
  if {IsIn {Cell.access BonusRespawn} Position} then
    skip
  else
    local X in
      {SetMode {Cell.access PlayerPort} 'hunt'}
      thread {Send WindowPort setMode('hunt')} end
      thread {Send WindowPort hideBonus(Position)} end
      %{InformPacmanThanBonusHide PacmansPort Position}
      {Cell.assign HuntMode hunt(bool:true time:Input.huntTime)}
      X = {Cell.access BonusRespawn}
      thread {Cell.assign BonusRespawn bonus(x:Position.x y:Position.y time:Input.respawnTimeBonus)|X} end
    end
  end
end

proc {RespawnBonus B}
  thread {Send WindowPort spawnBonus(pt(x:B.x y:B.y))} end
  thread {InformPacmanThanBonusSpawn PacmansPort pt(x:B.x y:B.y)} end
end

fun {UpdateBonusTime BonusList}
  case BonusList of nil then nil
  [] H|T then if H.time > 0 then bonus(x:H.x y:H.y time:H.time-1)|{UpdateBonusTime T}
              else thread {RespawnBonus H} end
                          {UpdateBonusTime T}
              end
  end
end

fun {UpdateHuntMode HuntMode}
  case HuntMode of nil then nil
  [] hunt(bool:X time:Y) then if Y > 0 then hunt(bool:true time:Y-1000)
              else {SetMode {Cell.access PlayerPort} 'classic'}
                thread {Send WindowPort setMode('classic')} end
                    hunt(bool:false time:0)
              end
  end
end

fun {FindIdByPosition List Position}
  case List of nil then nil
  [] H|T then if H.x == Position.x andthen H.y == Position.y then
                  H.id|{FindIdByPosition T Position}
              else {FindIdByPosition T Position}
              end
  end
end

fun {FindPortByID Ports ID}
  local X in
    case Ports of nil then nil
    [] H|T then thread {Send H getId(X)} end
                if X.id == ID.id then H
                else {FindPortByID T ID}
                end
    end
  end
end

proc {PacmanKillGhost PacmanPort GhostID GhostPort}
  local X Y in
  thread {Send PacmanPort killGhost(GhostID X Y)} end
  thread {Send WindowPort hideGhost(GhostID)} end
  thread {Send WindowPort scoreUpdate(X Y)} end
  thread {Send GhostPort gotKilled()} end
  thread {InformPacmanThanGhostDead PacmansPort GhostID} end
  {Cell.assign GhostPortPositions {MoveGhostById {Cell.access GhostPortPositions} GhostID pt(x:0 y:0)}}
  {AddToRespawn GhostID Input.respawnTimeGhost}
  end
end

fun{RemoveFromDeath CellContent ID}
if ID == null then CellContent
else
  case CellContent of nil then nil
  [] H|T then if H.id.id == ID.id then T
              else H|{RemoveFromDeath T ID}
              end
  end
end
end

proc {PacmanRespawn PacmanPort DeadRemove}
  local X Y Z in
  thread {Send PacmanPort spawn(X Y)} end
  thread {Send WindowPort spawnPacman(X Y)} end
  thread {InformGhostThanPacmanMove GhostPort X Y} end
  Z = {Cell.access DeadPlayer}
  {Cell.assign DeadPlayer {RemoveFromDeath Z X}}
  {Cell.assign PacmanPortPositions {MovePacmanById {Cell.access PacmanPortPositions} X Y}}
  end
end

proc {GhostRespawn GhostPort DeadRemove}
  local X Y Z in
  thread {Send GhostPort spawn(X Y)} end
  thread {Send WindowPort spawnGhost(X Y)} end
  thread {InformPacmanThanGhostMove PacmansPort X Y} end
  Z = {Cell.access DeadPlayer}
  {Cell.assign DeadPlayer {RemoveFromDeath Z X}}
  {Cell.assign GhostPortPositions {MoveGhostById {Cell.access GhostPortPositions} X Y}}
  end
end

%TODO
proc {PacmanLive PacmanPort}
  local X Y in
    {Send PacmanPort move(X Y)}
    {Browser.browse 'scanghost'}
    if {ScanPosition {Cell.access GhostPortPositions} Y} == true then Z in
      Z = {FindIdByPosition {Cell.access GhostPortPositions} Y}
      thread {Send WindowPort movePacman(X Y)} end
      thread {InformGhostThanPacmanMove GhostPort X Y} end
      if {Length Z 0} > 1 then
        if {Cell.access HuntMode}.bool == true then
                                                    {Cell.assign PacmanPortPositions {MovePacmanById {Cell.access PacmanPortPositions} X Y}}
                                                    {PacmanKillGhostPacmanLoop PacmanPort Z}
                                                    {GetPoint PacmanPort Y}
        else
             {PacmanIsKillRandom PacmanPort Z ({OS.rand} mod {Length Z 0})+1}
             {Cell.assign PacmanPortPositions {MovePacmanById {Cell.access PacmanPortPositions} X pt(x:0 y:0)}}
        end
      else
        if {Cell.access HuntMode}.bool == true then
                                                    {Cell.assign PacmanPortPositions {MovePacmanById {Cell.access PacmanPortPositions} X Y}}
                                                    {PacmanKillGhost PacmanPort Z.1 {FindPortByID GhostPort Z.1}}
                                                    {GetPoint PacmanPort Y}
        else
             {PacmanIsKill PacmanPort {FindPortByID GhostPort Z.1}}
             {Cell.assign PacmanPortPositions {MovePacmanById {Cell.access PacmanPortPositions} X pt(x:0 y:0)}}
        end
      end
    else {Browser.browse 'scanbonus'} if {ScanPosition {Cell.access BonusList} Y} == true then
          thread {InformGhostThanPacmanMove GhostPort X Y} end
          thread {Send WindowPort movePacman(X Y)} end
          {PacmanGotBonus Y}
          {Cell.assign PacmanPortPositions {MovePacmanById {Cell.access PacmanPortPositions} X Y}}
         else {Browser.browse 'scanwall'} if {ScanPosition WallPosition Y} == true then
               {Browser.browse Y}
               {Browser.browse 'Its a wall'}
              else
                thread {Send WindowPort movePacman(X Y)} end
                thread {InformGhostThanPacmanMove GhostPort X Y} end
                {GetPoint PacmanPort Y}
                {Cell.assign PacmanPortPositions {MovePacmanById {Cell.access PacmanPortPositions} X Y}}
              end
         end
    end
  end
end

proc {GhostLive GhostPort}
  local X Y in
    thread {Send GhostPort move(X Y)} end
    if {ScanPosition {Cell.access PacmanPortPositions} Y} == true then Z in
      Z = {FindIdByPosition {Cell.access PacmanPortPositions} Y}
      thread {Send WindowPort moveGhost(X Y)} end
      thread {InformPacmanThanGhostMove PacmansPort X Y} end
      if {Length Z 0} > 1 then
        if {Cell.access HuntMode}.bool == true then
                                                {PacmanKillGhostRandom Z X GhostPort ({OS.rand} mod {Length Z 0})+1}
        else
             {Cell.assign GhostPortPositions {MoveGhostById {Cell.access GhostPortPositions} X Y}}
             {PacmanIsKillGhostLoop Z GhostPort}
        end
      else
        if {Cell.access HuntMode}.bool == true then {PacmanKillGhost {FindPortByID PacmansPort Z.1} X GhostPort}
        else {Cell.assign GhostPortPositions {MoveGhostById {Cell.access GhostPortPositions} X Y}}
              {PacmanIsKill {FindPortByID PacmansPort Z.1} GhostPort}
        end
      end
    else if {ScanPosition WallPosition Y} == true then
           {Browser.browse Y}
           {Browser.browse 'Its a wall'}
         else
            thread {Send WindowPort moveGhost(X Y)} end
            thread {InformPacmanThanGhostMove PacmansPort X Y} end
            {Cell.assign GhostPortPositions {MoveGhostById {Cell.access GhostPortPositions} X Y}}
        end
    end
  end
end

proc {PacmanTurn PacmanPort}
  local X Dead in
    thread {Send PacmanPort getId(X)} end
    thread Dead = {IsDead X.id {Cell.access DeadPlayer}} end
    if Dead == nil then
      {PacmanLive PacmanPort}
    else
      if Dead.time > 0 then S in
        S = {UpdateDead {Cell.access DeadPlayer} Dead.id}
        {Cell.assign DeadPlayer S}
      else {PacmanRespawn PacmanPort Dead}
      end
    end
  end
end

proc {GhostTurn GhostPort}
  local X Dead in
    thread {Send GhostPort getId(X)} end
    thread Dead = {IsDead X.id {Cell.access DeadPlayer}}end
    if Dead == nil then
      {GhostLive GhostPort}
    else
        if Dead.time > 0 then S in
          S = {UpdateDead {Cell.access DeadPlayer} Dead.id}
          {Cell.assign DeadPlayer S}
        else {GhostRespawn GhostPort Dead}
        end
    end
  end
end

proc {RespawnPoint Point}
  thread {Send WindowPort spawnPoint(pt(x:Point.x y:Point.y))} end
  thread {InformPacmanThanPointSpawn PacmansPort pt(x:Point.x y:Point.y)} end
end

fun {UpdatePointsTime PointsList}
  case PointsList of nil then nil
  [] H|T then if H.time > 0 then bonus(x:H.x y:H.y time:H.time-1)|{UpdatePointsTime T}
              else thread {RespawnPoint H} end
                          {UpdatePointsTime T}
              end
  end
end

%%%%%%%%%%%%%%%%%% procedure de clarification du code %%%%%%%%%%%%%%%%%%%%%%
%clarifie le code d'initialisation des inits de listes.
proc {GameSetUp PacmanList GhostList PosPacman PosGhost Bonus Points}
  {GeneratePoints Points}
  {RandomPosP PacmanList PosPacman}
  {RandomPosG GhostList PosGhost}
  {GenerateBonus Bonus}
end

%TODO verif
proc {GameStartTurn PlayersList}
  {Delay 100}
  if {EndGame {Cell.access NumberOfDeath} RemainingPoints} == true then {Send WindowPort displayWinner({FindWinnerID PacmansPort pacman(id:~1 color:'red' name:'null') ~100000000})}
    else case PlayersList of nil then skip
    [] H|T then X in
      thread {Send H getId(X)} end
      case X of pacman(id:X color:Y name:Z) then {PacmanTurn H} {GameStartTurn T}
      []ghost(id:X color:Y name:Z) then {GhostTurn H} {GameStartTurn T}%procedure ghost
      []nil then {Browser.browse 'error'}
      end
    end
  end
end

proc {GameManager PlayersList}
  local X Y Z in
    X = {Cell.access BonusRespawn}
    {Cell.assign BonusRespawn {UpdateBonusTime X}}
    Y = {Cell.access HuntMode}
    {Cell.assign HuntMode {UpdateHuntMode Y}}
    Z = {Cell.access PointsRespawn}
    {Cell.assign PointsRespawn {UpdatePointsTime Z}}
  end
  {GameStartTurn PlayersList}
  {GameManager PlayersList} %a changer en playerPort
end

%%%%%%%%%%%%%%%%%%%%%%%% corps du programme %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %initialisaion des variables globales
  WindowPort = {GUI.portWindow}
  {Send WindowPort buildWindow}

  PacmansPort = {InitPacmanList {MakePacman Input.nbPacman Input.colorPacman Input.namePacman 1} Input.pacman}
  GhostPort = {InitGhostList {MakeGhost Input.nbGhost Input.colorGhost Input.nameGhost Input.nbPacman+1} Input.ghost}

  PacmanPositions = {Cell.new {InitCell Input.nbPacman 0}}
  GhostsPositions = {Cell.new {InitCell Input.nbPacman+Input.nbGhost Input.nbPacman}}

  BonusRespawn = {Cell.new nil}
  PointsRespawn = {Cell.new nil}
  PacmanPortPositions = {Cell.new nil}
  GhostPortPositions = {Cell.new nil}

  SpawnPacmanPositions = {GetPosListPacmanSpawn Input.map 1 nil}
  SpawnGhostPositions = {GetPosListGhostSpawn Input.map 1 nil}
  SpawnBonusPositions = {GetPosListBonusSpawn Input.map 1 nil}
  BonusList = {Cell.new SpawnBonusPositions}
  WallPosition = {GetWallPosition Input.map 1 nil}

  local StartPosP StartPosG in
    StartPosG = {BuildRandomList SpawnGhostPositions nil Input.nbGhost}
    StartPosP = {BuildRandomList SpawnPacmanPositions nil Input.nbPacman}
    {GameSetUp PacmansPort GhostPort StartPosP StartPosG SpawnBonusPositions {GetPosListPoints Input.map 1 nil}}

    %Initialisation de l'ordre des Pacmans/Ghosts pour le tour par tour.
    local X in
      X = {Append PacmansPort GhostPort}
      PlayerPort = {Cell.new {Purge {RandomPlayer X {Length X 0}}}}
    end

    NumberOfDeath = {Cell.new 0}
    DeadPlayer = {Cell.new nil}
    RemainingPoints = {Cell.new {GetRemainingPoints Input.map 1 0}}
    HuntMode = {Cell.new hunt(bool:false time:0)}
  end

  {Delay 15000}
  {Browser.browse {Cell.access PlayerPort}}
  {Delay 10000}

  {GameManager {Cell.access PlayerPort}}

  %%%%%%%%%%% le jeu est pret a demarrer %%%%%%%%%%%%%%%%%%%%


  %if Input.isTurnByTurn == true then
  %  {GameStartTurn PacmanPort nil}
  %else
  %{Browser.browse 'noTurnperTurn'}
  %end


   % Open GameWindow




   % TODO complet


end
