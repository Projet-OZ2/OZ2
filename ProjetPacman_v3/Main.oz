functor
import
   GUI
   Input
   PlayerManager
   Browser
   %import de test
define
   WindowPort
   PacmanPort
   GhostPort
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
  Append
  CreaSpawnBonus
  CreaSpawnGhost
  CreaSpawnPacman
  GetPosListPacmanSpawn
  GetPosListGhostSpawn
  GetPosListBonusSpawn
  %variables de test
  BrowseList
  BrowsePortId
  %variables d'environnement
  SpawnPacmanList
  SpawnGhostList
  SpawnBonusList
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
%%%%%%%%%%%%%%%%%%%%%%%% fonctions d'initialisation des parametres du jeu %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun {Append L1 L2}
  case L1 of nil then L2
  []H|T then {Append T H|L2}
  end
end

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

%%%%%%%%%%%%%%%%%%%%%%%% fonctions d'initialisation pacmans et fantomes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
       if GhostNumber == 0 then nil
       else case ColorList of nil then nil
            [] (H|T) then
              case NameList
              of nil then nil
              [] A|B then
              ghost(id:Acc color:H name:A)|{MakeGhost GhostNumber-1 T B Acc+1}
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

   proc {PacmanSpawn PortList PostList Acc}
      case PortList of nil then skip
      [] H|T then X in
      thread {Send H getId(X)} end
      thread {Send WindowPort initPacman(X)} end
      thread {Send WindowPort spawnPacman(X PostList.1)} end
      {PacmanSpawn T PostList.2 Acc+1}
      end
   end

   proc {GhostSpawn PortList PostList Acc}
      case PortList of nil then skip
      [] H|T then X in
      thread {Send H getId(X)} end
      thread {Send WindowPort initGhost(X)} end
      thread {Send WindowPort spawnGhost(X PostList.1)} end
      {GhostSpawn T PostList.2 Acc+1}
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%% corps du programme %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  WindowPort = {GUI.portWindow}

  %doit etre automatise
  %PosListPacman = [pt(x:5 y:6) pt(x:9 y:6)]
  %PacmanListPort = {InitPacmanList {MakePacman Input.nbPacman Input.colorPacman Input.namePacman 1} Input.pacman}
  %{PacmanSpawn PacmanListPort PosListPacman 1}
  %{Send WindowPort buildWindow}

   % Open window



   % TODO complete


end
