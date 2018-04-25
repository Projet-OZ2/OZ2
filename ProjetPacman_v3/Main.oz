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
  %variables de partie
  EndGame
  FindWinnerID
  MoveCell
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
  UpdateScore
  UpdateLife
  PacmanLive
  PacmanRespawn
  PointIsIn
  AddToRespawn
  RemoveFromDeath
  SetMode
  PacmanGotBonus
  RespawnTimeBonus
  RespawnBonus
  UpdateBonusTime
  UpdateHuntMode
  InformGhostThanPacmanDead
  InformGhostThanPacmanMove
  InformPacmanThanBonusHide
  InformPacmanThanBonusSpawn
  GameManager
  %variables de test
  BrowseList
  BrowsePortId
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
  point(x:Column y:Row bool:true)
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
   if Point.bool == false then skip
   else
      thread {Send WindowPort initPoint(pt(x:Point.x y:Point.y))} end
      thread {Send WindowPort spawnPoint(pt(x:Point.x y:Point.y))} end
   end
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
  {Browser.browse List}
  {Browser.browse ID}
  {Delay 1000}
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
  {CreaPoint Position.y Position.x}|Cellcontent
end

fun {PointIsIn L Position}
  case L of nil then false
  [] H|T then if H.x == Position.x andthen H.y == Position.y then true
              else
                {PointIsIn T Position}
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
  [] H|T then if H.x == Position.x andthen H.y == Position.y then true
              else {ScanPosition T Position}
              end
  end
end

fun{PacmanIsDead PlayersList PacmanPort}
  case PlayersList of nil then nil
  [] H|T then if H == PacmanPort then
                {Browser.browse 'Pacman is dead and remove to the game'}
                T
              else H|{PacmanIsDead T PacmanPort}
              end
  end
end

proc {AddToRespawn ID RespawnTime}
  local X in
    X = {Cell.access DeadPlayer}
    {Cell.assign DeadPlayer deadstate(id:ID time:RespawnTime)|X}
    {Browser.browse 'Pacman est en attente de respawn'}
  end
end

proc {PacmanIsKill PacmanPort}
  local X Y Z in
    thread {Send PacmanPort gotKilled(X Y Z)} end
    thread {Send WindowPort lifeUpdate(X Y)} end
    thread {Send WindowPort scoreUpdate(X Z)} end
    thread {Send WindowPort hidePacman(X)} end
    thread {InformGhostThanPacmanDead GhostPort X} end
    if Y > 0 then
      {AddToRespawn X Input.respawnTimePacman}
    else local S in
      S = {Cell.access PlayerPort}
      {Cell.assign PlayerPort {PacmanIsDead S PacmanPort}}
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
  [] H|T then {Browser.browse 'case PacmanPort'} thread {Send H bonusSpawn(Position)} end
                     {InformPacmanThanBonusSpawn T Position}
  end
end

proc {PacmanGotBonus Position}
  if {IsIn {Cell.access BonusRespawn} Position} then
    skip
  else
    local X in
      {Browser.browse 'in pacmanGotBonus'}
      {SetMode {Cell.access PlayerPort} 'hunt'}
      thread {Send WindowPort setMode('hunt')} end
      thread {Send WindowPort hideBonus(Position)} end
      %{InformPacmanThanBonusHide PacmansPort Position}
      {Cell.assign HuntMode hunt(bool:true time:Input.huntTime)}
      {Browser.browse 'HuntMode activated'}
      X = {Cell.access BonusRespawn}
      {Browser.browse 'BonusRespawn assign'}
      thread {Cell.assign BonusRespawn bonus(x:Position.x y:Position.y time:Input.respawnTimeBonus)|X} end
      {Browser.browse 'PacmanGotBonusEnd'}
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

%TODO
proc {PacmanLive PacmanPort}
  local X Y in
    {Send PacmanPort move(X Y)}
    if {ScanPosition {Cell.access GhostsPositions} Y} == true then
      {Browser.browse 'I percut ghost'}
      thread {Send WindowPort movePacman(X Y)} end
      thread {InformGhostThanPacmanMove GhostPort X Y} end
      if {Cell.access HuntMode}.bool == true then {Browser.browse 'Pacman kill the ghost'}
      {Delay 2000}
      else {Browser.browse 'Ghost kill Pacman'} {PacmanIsKill PacmanPort}
      end
    else if {ScanPosition {Cell.access BonusList} Y} == true then
          {Browser.browse 'I found bonus'}
          thread {InformGhostThanPacmanMove GhostPort X Y} end
          thread {Send WindowPort movePacman(X Y)} end
          {Delay 1000}
          {PacmanGotBonus Y}
         else if {ScanPosition WallPosition Y} == true then
               {Browser.browse Y}
               {Browser.browse 'Its a wall'}
              else
                {Browser.browse 'I found point'}
                thread {Send WindowPort movePacman(X Y)} end
                thread {InformGhostThanPacmanMove GhostPort X Y} end
                {Browser.browse 'get Point'}
                {Delay 1000}
                {GetPoint PacmanPort Y}
              end
         end
    end
  end
end

fun{RemoveFromDeath CellContent ID}
  case CellContent of nil then nil
  [] H|T then if H.id.id == ID.id then T
              else H|{RemoveFromDeath T ID}
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
  end
end

proc {PacmanTurn PacmanPort}
  local X Dead in
    thread {Send PacmanPort getId(X)} end
    thread Dead = {IsDead X.id {Cell.access DeadPlayer}} end
    if Dead == nil then
      {Browser.browse 'is live'}
      {Delay 500}
      {PacmanLive PacmanPort}
    else
      if Dead.time > 0 then S in
        {Browser.browse 'is dead ++++'}
        S = {UpdateDead {Cell.access DeadPlayer} Dead.id}
        {Cell.assign DeadPlayer S}
      else {PacmanRespawn PacmanPort Dead}
      end
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
  if {EndGame {Cell.access NumberOfDeath} RemainingPoints} == true then {Send WindowPort displayWinner({FindWinnerID PacmansPort pacman(id:~1 color:'red' name:'null') ~1})}
    else case PlayersList of nil then skip
    [] H|T then X in
      thread {Send H getId(X)} end
      case X of pacman(id:X color:Y name:Z) then {Browser.browse 'pacman'}{Delay 500}
        {PacmanTurn H} {GameStartTurn T}
      []ghost(id:X color:Y name:Z) then {Browser.browse 'ghost'} {GameStartTurn T}%procedure ghost
      []nil then {Browser.browse 'error'}
      end
    end
  end
end

proc {GameManager PlayersList}
  {Browser.browse 'turnStart'}
  local X Y in
    X = {Cell.access BonusRespawn}
    {Cell.assign BonusRespawn {UpdateBonusTime X}}
    {Browser.browse 'update des bonus'}
    {Browser.browse {Cell.access BonusRespawn}}
    {Delay 3000}
    Y = {Cell.access HuntMode}
    {Cell.assign HuntMode {UpdateHuntMode Y}}
    {Browser.browse 'update du huntMode'}
    {Browser.browse {Cell.access HuntMode}}
    {Delay 3000}
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

  SpawnPacmanPositions = {GetPosListPacmanSpawn Input.map 1 nil}
  {Browser.browse SpawnPacmanPositions}
  SpawnGhostPositions = {GetPosListGhostSpawn Input.map 1 nil}
  {Browser.browse SpawnGhostPositions}
  SpawnBonusPositions = {GetPosListBonusSpawn Input.map 1 nil}
  {Browser.browse SpawnBonusPositions}
  BonusList = {Cell.new SpawnBonusPositions}
  WallPosition = {GetWallPosition Input.map 1 nil}

  {Browser.browse {BuildRandomList SpawnPacmanPositions nil
    {Length SpawnPacmanPositions 0}}}
  {Browser.browse {Length SpawnPacmanPositions 0}}
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
  {Delay 5000}

  {GameManager {Cell.access PlayerPort}}

  %%%%%%%%%%% le jeu est pret a demarrer %%%%%%%%%%%%%%%%%%%%


  %if Input.isTurnByTurn == true then
  %  {GameStartTurn PacmanPort nil}
  %else
  %{Browser.browse 'noTurnperTurn'}
  %end


   % Open GameWindow




   % TODO complete


end
