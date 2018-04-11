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
  MakePacman
  PacmanListPort
  PacmanSpawn
  PosListPacman
  InitPacmanList
  %variables de test
  BrowseList
  BrowsePortId
in

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
             pacman(id: Acc color:H name:A)|{MakePacman PacmanNumber-1 T B Acc+1}
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

   proc {PacmanSpawn PortList PostList Acc}
      case PortList of nil then skip
      [] H|T then X in
      {Browser.browse 'boucle'}
      thread {Send H getId(X)} end
      thread {Send WindowPort initPacman(X)} end
      thread {Send WindowPort spawnPacman(X PostList.1)} end
      {PacmanSpawn T PostList.2 Acc+1}
      end
   end

  WindowPort = {GUI.portWindow}
  %doit etre automatise
  PosListPacman = [pt(x:5 y:6) pt(x:9 y:6)]
  PacmanListPort = {InitPacmanList {MakePacman Input.nbPacman Input.colorPacman Input.namePacman 1} Input.pacman}
  {PacmanSpawn PacmanListPort PosListPacman 1}

  {Send WindowPort buildWindow}

   % Open window



   % TODO complete


end
