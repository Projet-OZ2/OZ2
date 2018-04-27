functor
import
   Pacman000random
   Pacman001rene
   Pacman103fred
   Ghost000random
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
      [] pacman103fred then {Pacman103fred.portPlayer ID}
      [] ghost000random then {Ghost000random.portPlayer ID}
      [] ghost103vincent then {Ghost103vincent.portPlayer ID}
      end
   end
end
