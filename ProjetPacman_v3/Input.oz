functor
export
   isTurnByTurn:IsTurnByTurn
   nRow:NRow
   nColumn:NColumn
   map:Map
   respawnTimePoint:RespawnTimePoint
   respawnTimeBonus:RespawnTimeBonus
   respawnTimePacman:RespawnTimePacman
   respawnTimeGhost:RespawnTimeGhost
   rewardPoint:RewardPoint
   rewardKill:RewardKill
   penalityKill:PenalityKill
   nbLives:NbLives
   huntTime:HuntTime
   nbPacman:NbPacman
   pacman:Pacman
   colorPacman:ColorPacman
   namePacman:NamePacman
   nameGhost:NameGhost
   nbGhost:NbGhost
   ghost:Ghost
   colorGhost:ColorGhost
   thinkMin:ThinkMin
   thinkMax:ThinkMax
define
   IsTurnByTurn
   NRow
   NColumn
   Map
   RespawnTimePoint
   RespawnTimeBonus
   RespawnTimePacman
   RespawnTimeGhost
   RewardPoint
   RewardKill
   PenalityKill
   NbLives
   HuntTime
   NbPacman
   Pacman
   ColorPacman
   NamePacman
   NbGhost
   Ghost
   ColorGhost
   ThinkMin
   ThinkMax
   NameGhost
in

%%%% Style of game %%%%

   IsTurnByTurn = true

%%%% Description of the map %%%%

   NRow = 11
   NColumn = 11
   Map = [[1 1 1 1 1 1 1 1 1 1 1]
	        [1 2 0 0 0 4 0 0 0 2 1]
	        [1 0 1 0 1 0 1 0 1 0 1]
	        [1 0 0 0 0 0 0 0 0 0 1]
	        [1 0 1 0 1 0 1 0 1 0 1]
	        [1 4 0 0 0 3 0 0 0 4 1]
	        [1 0 1 0 1 0 1 0 1 0 1]
          [1 0 0 0 0 0 0 0 0 0 1]
          [1 0 1 0 1 0 1 0 1 0 1]
          [1 2 0 0 0 4 0 0 0 2 1]
          [1 1 1 1 1 1 1 1 1 1 1]]

%%%% Respawn times %%%%

   RespawnTimePoint = 10
   RespawnTimeBonus = 15
   RespawnTimePacman = 5
   RespawnTimeGhost = 5

%%%% Rewards and penalities %%%%

   RewardPoint = 1
   RewardKill = 5
   PenalityKill = 5

%%%%

   NbLives = 2
   HuntTime = 5000

%%%% Players description %%%%

   NbPacman = 4
   Pacman = [pacman037Hungry pacman037Randy pacman094basic pacman103fred]
   ColorPacman = [yellow red yellow red]
   NamePacman = ['louis' 'matthieu' 'jeanmich' 'jerome']
   NbGhost = 4
   Ghost = [ghost037Angry ghost037Randy ghost094basic ghost103vincent]
   ColorGhost = [green red black white]% black red white]
   NameGhost = ["bisounours" "bisoutwo" "bisouthree" "bisoufour"]

%%%% Thinking parameters (only in simultaneous) %%%%

   ThinkMin = 500
   ThinkMax = 3000

end
