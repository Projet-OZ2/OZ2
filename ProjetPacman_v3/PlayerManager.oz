functor
import
   Pacman000random
   Pacman001rene
   Pacman037Hungry
   Pacman037Randy
   Pacman094basic
   Pacman103fred
   Ghost000random
   Ghost037Angry
   Ghost037Randy
   Ghost094basic
   Ghost103vincent
export
   playerGenerator:PlayerGenerator
define
   PlayerGenerator
in
   % Kind is one valid name to describe the wanted player, ID is either the <pacman> ID, either the <ghost> ID corresponding to the player
   fun{PlayerGenerator Kind ID}
      case Kind
      of pacman000random then {Pacman000random.portPlayer ID}
      [] pacman001rene then {Pacman001rene.portPlayer ID}
      [] pacman037Hungry then {Pacman037Hungry.portPlayer ID}
      []pacman037Randy then {Pacman037Randy.portPlayer ID}
      []pacman094basic then {Pacman094basic.portPlayer ID}
      [] pacman103fred then {Pacman103fred.portPlayer ID}
      [] ghost000random then {Ghost000random.portPlayer ID}
      [] ghost037Angry then {Ghost037Angry.portPlayer ID}
      [] ghost037Randy then {Ghost037Randy.portPlayer ID}
      [] ghost094basic then {Ghost094basic.portPlayer ID}
      [] ghost103vincent then {Ghost103vincent.portPlayer ID}
      end
   end
end
