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
   PacmanPort
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
  %varibales turnbyturn
  PacmanTurn
  %variables de partie
  EndGame
  FindWinnerID
  GameStartTurn
  %variables de test
  BrowseList
  BrowsePortId
  %variables d'environnement
  SpawnPacmanList
  SpawnGhostList
  SpawnPacmanPositions
  SpawnGhostPositions
  SpawnBonusPositions
  PointsPosition
  NumberOfDeath
  RemainingPoints
  %variables utilitaires
  Split
  Append
  Remove
  Length
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

%Acc est initialise a 0
fun {Length L Acc}
  case L of nil then Acc
  [] H|T then {Length T Acc+1}
  end
end
%%%%%%%%% fonctions d'initialisation des parametres du jeu %%%%%%%%%%

%les 4 fonctions suivantes permettent de generer le template des 4 tuples de
%positions
fun{CreaSpawnPacman Row Column}
  spawnP(x:Column y:Row)
end

fun {CreaSpawnGhost Row Column}
  spawnG(x:Column y:Row)
end

fun {CreaSpawnBonus Row Column}
  spawnB(x:Column y:Row bool:true)
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

  local
  fun {GetRemainingPoints L Row Acc}
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
    []H|T then  {PacmanSpawn H Position.1} {RandomPosP T Position.2}
    end
  end

  %Procedure permettant de faire spawn une liste de ghost
  proc {RandomPosG Ghosts Position}
    case Ghosts of nil then skip
    []H|T then {GhostSpawn H Position.1} {RandomPosG T Position.2}
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
%%%%%%%%%%%%%%%%% procedures de gestion du tour par tour %%%%%%%%%%%%%%%%%%%%

proc {PacmanTurn PacmanPort}
  local X Y in
  thread {Send PacmanPort move(X Y)} end
  thread {Send WindowPort movePacman(X Y)} end
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
proc {GameStartTurn PlayersList Save}
  if {EndGame NumberOfDeath RemainingPoints} == true then {Send WindowPort displayWinner({FindWinnerID PacmanPort pacman(id:~1 color:'red' name:'null') ~1})}
    else case PlayersList of nil then {GameStartTurn Save nil}
    [] H|T then X in
      {Send H getId(X)}
      if X == pacman(id:X.id color:X.color name:X.name) then {PacmanTurn H}%procedure Pacman
      else {Browser.browse 'ghost'}%procedure ghost
      end
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%% corps du programme %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %initialisaion des variables globales
  WindowPort = {GUI.portWindow}
  {Send WindowPort buildWindow}

  PacmanPort = {InitPacmanList {MakePacman Input.nbPacman Input.colorPacman Input.namePacman 1} Input.pacman}
  GhostPort = {InitGhostList {MakeGhost Input.nbGhost Input.colorGhost Input.nameGhost Input.nbPacman+1} Input.ghost}

  SpawnPacmanPositions = {GetPosListPacmanSpawn Input.map 1 nil}
  SpawnGhostPositions = {GetPosListGhostSpawn Input.map 1 nil}
  SpawnBonusPositions = {GetPosListBonusSpawn Input.map 1 nil}
  PointsPosition = {GetPosListPoints Input.map 1 nil}


  {GameSetUp PacmanPort GhostPort {BuildRandomList SpawnPacmanPositions nil
    {Length SpawnPacmanPositions 0}} {BuildRandomList SpawnGhostPositions nil
      {Length SpawnGhostPositions 0}} SpawnBonusPositions PointsPosition}

  %Initialisation de l'ordre des Pacmans/Ghosts pour le tour par tour.
  local X in
  X = {Append PacmanPort GhostPort}
  PlayerPort = {RandomPlayer X {Length X 0}}
  end

  NumberOfDeath = {Cell.new 0}
  RemainingPoints = {Cell.new {GetRemainingPoints Input.map 1 0}}

  %%%%%%%%%%% le jeu est pret a demarrer %%%%%%%%%%%%%%%%%%%%

  if Input.isTurnByTurn == true then
    {GameStartTurn PacmanPort nil}
  else
  {Browser.browse 'noTurnperTurn'}
  end


   % Open GameWindow




   % TODO complete


end
