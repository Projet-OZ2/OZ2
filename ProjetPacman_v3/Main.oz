functor
import
   GUI
   Input
   PlayerManager
   Browser
define
   WindowPort
   PacmanPort
  MakePacman
  PacmanListPort
  PacmanSpawn
  PosListPacman
  InitPacmanList

in

  WindowPort = {GUI.buildWindow}
  %doit etre automatise
  PosListPacman = [pt(x:5 y:6) pt(x:9 y:6)]

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
             endpacman(id: Acc color:H name:A)|{MakePacman PacmanNumber-1 T B Acc+1}
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

   proc {PacmanSpawn PortList PostList}
      case PortList of nil then skip
      [] H|T then X in
      {Send H getId(X)}
      {Send WindowPort initPacman(X)}
      {Send WindowPort spawnPacman(X PostList.1)}
      {PacmanSpawn T PostList.2}
      end
   end

   PacmanListPort = {InitPacmanList {MakePacman Input.nbPacman Input.colorPacman Input.namePacman 1} Input.pacman}

   % Open window
   {Send WindowPort buildWindow}


   % TODO complete


end
