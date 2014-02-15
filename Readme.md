##Kicker Kata

A simple kata with the goal to calculate game and player statistics for a [foosball](http://en.wikipedia.org/wiki/Table_football) table. 

###Setup 

Given a foosball table (in German "Kicker") which is connected to the internet. It features two goal sensors, one for each team. Players can publish their team (*black* or *white*) and position (*offense* or *defense*) via a mobile phone app. 

Your job is to implement a real-time statistics calculator with the following features:

- Counts the score of the active game.
- Ranking list of individual players ordered by their number of wins.
- Ranking list of teams ordered by their number of wins.

###Rules

- The first team scoring **six** goals wins.
- A team has two players: one at the *offense* and one at the *defense* position (optional: teams can also consist of a single player). 
- After one team has won, a new game starts automatically.
- When a new player registers during an active game, the current game is reset and a new game is started. (optional)
- A player can only register for a single position. Any previous position will be deleted. (optional)

###Events

The following **input events** are defined: 

- `goal:black`- the black team scores a goal.
- `goal:white`- the white team scores a goal.
- `register:white:offense:A`- a new player named `A` registers for the `white` team at the `offense` position.
- `register:white:defense:B`- a new player named `B` registers for the `white` team at the `defense` position.
- `register:black:offense:C`- a new player named `C` registers for the `black` team at the `offense` position.
- `register:black:defense:D`- a new player named `D` registers for the `black` team at the `defense` position.

The statistics module should send the following **output events**: 

- `score:{"black": 3, "white": 4}`- the score of the active game. Send after each goal and when a new player registers.
- `player-ranking:{"Tom": 5, "Bugs Bunny": 3}`- the current player ranking. Send after each finished game. The ranking is listed in descending order by the number of won games. Send after each completed game.
- `team-ranking:{["Tom", "Jerry"]: 5, ["Bugs Bunny", "Tweetie"]: 3}`- the current team ranking. Send after each finished game. The ranking is listed in descending order by the number of won games. Send after each completed game.
