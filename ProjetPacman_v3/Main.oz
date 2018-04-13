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
  %variables de generation des cases map
  CreaSpawnBonus
  CreaSpawnGhost
  CreaSpawnPacman
  GetPosListPacmanSpawn
  GetPosListGhostSpawn
  GetPosListBonusSpawn
  %variables d'initialisation de partie
  RandomTri
  BuildPos
  ControlPos
  RandomPosP
  RandomPosG
  GameSetUp

  %variables de test
  BrowseList
  BrowsePortId
  %variables d'environnement
  SpawnPacmanList
  SpawnGhostList
  SpawnPacmanPositions
  SpawnGhostPositions
  SpawnBonusPositions
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

fun{CreaSpawnPacman Row Column}
  spawnP(x:Column y:Row)
end

fun {CreaSpawnGhost Row Column}
  spawnG(x:Column y:Row)
end

fun {CreaSpawnBonus Row Column}
  spawnB(x:Column y:Row bool:true)
end

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

%%%%%%%%%%%% fonctions d'initialisation pacmans et fantomes %%%%%%%%%%%%%%%%%%%

  %return a list of pacmanID
  %ColorList.size == NameList.size
  %Acc == 1 at the start

  fun {MakePacman PacmanNumber ColorList NameList Acc}
      if PacmanNumber == 0 then nil
      else case ColorList of nil then nil
           [] (H|T) then
             case NameList
             of nil then nil
             [] A|B then
             pacman(id:Acc color:H name:A)|{MakePacman PacmanNumber-1 T B Acc+1}
             end
          end
      end
   end

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

   proc {PacmanSpawn Pacman Position}
      local X in
        thread {Send Pacman getId(X)} end
        thread {Send WindowPort initPacman(X)} end
        thread {Send WindowPort spawnPacman(X Position)} end
        thread {Send Pacman assignSpawn(Position)} end
      end
   end

   proc {GhostSpawn Ghost Position}
    local X in
        thread {Send Ghost getId(X)} end
        thread {Send WindowPort initGhost(X)} end
        thread {Send WindowPort spawnGhost(X Position)} end
        thread {Send Ghost assignSpawn(Position)} end
      end
   end
%%%%%%%%%%%%%%%%%%%%%%%% procedure de spawn aleatoire %%%%%%%%%%%%%%%%%%%%%%%%%

  %prend en entree une liste de ports et de position
  fun {BuildPos PosList NumMax}
    case PosList of nil then nil
    [] H|T then possetup(position: H count: NumMax)|{BuildPos T NumMax}
    end
  end

  fun {ControlPos L N}
    case L of nil then nil
    [] H|T then
      if N == 0 then X in
        if H.count == 1 then T
        else X = possetup(position: H.position count: H.count-1)
              X|T
        end
      else {ControlPos T N-1}
      end
    end
  end

  %procedure permettant de choisir la position d'un pacman au hasard
  proc {RandomPosP Pacmans Possetup}
    case Pacmans of nil then skip
    [] H|T then X in
      X = ({OS.rand} mod {Length Possetup 0}-1)+1
      {PacmanSpawn H {Split Possetup X}.position}
      {RandomPosP T {ControlPos Possetup X}}
    end
  end

  %procedure permettant de choisir la position d'un fantome au hasard
  proc {RandomPosG Ghosts Possetup}
    case Ghosts of nil then skip
    [] H|T then X in
      X = ({OS.rand} mod {Length Possetup 0}-1)+1
      {GhostSpawn H {Split Possetup X}.position}
      {RandomPosG T {ControlPos Possetup X}}
    end
  end

  %permet de trier la liste des joueurs pour le tour par tour

  fun {RandomTri L NumMax}
    case L of H|nil then L
    [] H|T then X in
    X = {Split L ({OS.rand} mod NumMax-1)+1}
    X|{RandomTri {Remove L X} NumMax-1}
    end
  end
%%%%%%%%%%%%%%%%%% procedure de clarification du code %%%%%%%%%%%%%%%%%%%%%%

%clarifie le code d'initialisation des inits de listes.
proc {GameSetUp PacmanList GhostList PosPacman PosGhost}
  thread {RandomPosP PacmanList PosPacman}end
  thread {RandomPosG GhostList PosGhost}end
end

%%%%%%%%%%%%%%%%%%%%%%%% corps du programme %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %initialisaion des variables globales
  WindowPort = {GUI.portWindow}

  PacmanPort = {InitPacmanList {MakePacman Input.nbPacman Input.colorPacman Input.namePacman 1} Input.pacman}

  GhostPort = {InitGhostList {MakeGhost Input.nbGhost Input.colorGhost Input.nameGhost Input.nbPacman+1} Input.ghost}
  SpawnPacmanPositions = {GetPosListPacmanSpawn Input.map 1 nil}
  SpawnGhostPositions = {GetPosListGhostSpawn Input.map 1 nil}
  SpawnBonusPositions = {GetPosListBonusSpawn Input.map 1 nil}

  {GameSetUp PacmanPort GhostPort {BuildPos SpawnPacmanPositions {Float.toInt {Int.toFloat Input.nbPacman}/{Int.toFloat {Length SpawnPacmanPositions 0}}}} {BuildPos SpawnGhostPositions {Float.toInt {Int.toFloat Input.nbGhost}/{Int.toFloat {Length SpawnGhostPositions 0}}}}}

   % Open GameWindow
  {Send WindowPort buildWindow}


  %tu peux enlever cette partie ; elle sert a tester le spawn des pacmans/ghost
  %fais gaffe le jeu mets une demi seconde pour etre operationnel
  local X Y
  in
  {Delay 2000}
  thread {Send PacmanPort.1 spawn(X Y)} end
  {Browser.browse X}
  {Browser.browse Y}
  end




   % TODO complete


end
