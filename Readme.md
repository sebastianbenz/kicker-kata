#Kicker Kata

A simple kata with the goal to calculate game and player statistics for a [foosball](http://en.wikipedia.org/wiki/Table_football) table. 

##Setup 

We have a foosball table (in German "Kicker") which is connected to the internet. It features two goal sensors, one for each team. Players can publish their team (black or white) and position (offense or defense) via a mobile phone app. 

Your job is to implement a real-time statistics calculator with the following features:

- Ranking list of teams ordered by their number of wins
- Ranking list of individual players ordered by their number of wins

##Rules

- The first team scoring **six** goals wins.
- A team has two players one at the offense and one at the defense position (advanved: teams can also consist of a single player). 
- After one team has won, a new game starts automatically.
- When a new player registers during an active game, the current game is reset and a new game is started. (optional)
- A player can only register for a single position. Any previous position will be deleted. (optional)

##Events

The following input events are defined: 

- `goal:black`- the black team scores a goal.
- `goal:white`- the white team scores a goal.
- `register:white:offense:A`- a new player named `A` registers for the `white` team at the `offense` position.
- `register:white:defense:B`- a new player named `B` registers for the `white` team at the `defense` position.
- `register:black:offense:C`- a new player named `C` registers for the `black` team at the `offense` position.
- `register:black:defense:D`- a new player named `D` registers for the `black` team at the `defense` position.

