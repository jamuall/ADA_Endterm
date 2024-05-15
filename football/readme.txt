# Ada 2. programming exam - tasks

For each mark you have to solve different tasks; therefore, place the solution for each mark in different directory.

For mark 2 in /2 directory, for mark 3 in directory /3, for mark 4 in directory /4, for 5 in directory /5.
At the end the zip of must be uploaded, containing only the sources. If has different structure, then mark is failed.
The problem to be solved is a football match. 

## For mark 2 (place it in /2 directory)

In the firts part only penalties have to be simulated, for which the followings are needed:

* Protected for writing on the screen (`Printer`);
* The gate task (`Gate`);
* The goalkeeper task (`Goalkeeper`);
* The player task (`Player`).

The `Printer` protected should print all messages on screen using the (`Print`) procedure. Use this at the printing of each event.

The `Gate` has two entry points, and should receive calls continuously, if no more calls then it should terminate
(with `or terminate` branch).

* `Shoot`: it will be called by the player as attempt to score a goal. It can not be called if the goalkeeper is not read.
* `Keeper (Ready)`: the goalkeeper will call it, giving in its parameter that he is ready to get the balls.

The `Goalkeeper` is ready for balls from the beginning, and signals this to the gate by calling the corresponding entry point.
After 5 seconds, his attention is wandering and calls the gate with false parameter and terminates.

The `Player` starts after 1 second waiting, if can not score a goal tries again after 1 second by calling the 
`Shoot` entrypoint of the gate. If he can not call, then it should wait 1 second, and try again after.
If he scores a goal, then happily terminates.

## For mark 3 (place it in /3 directory)

The goalkeeper now got new fitness form, instead of 5s now he can be active for 10s, but he is still not at 100%.
He needs energy as there is a second player as well.

New elements:

* Random number generator protected.

* Modification of the goalkeeper.

* The `Player` is a task type, a player is created dynamically. 

To generate random values, create a `Safe_Random` protected with a procedure (`Generate`) generating a `Float` value between `0.0` and `1.0`.

The goalkeeper at every 1.5s generates a random value using the protected. If the value is smaller then 0.7, then he is ready for ball receiving, otherwise he is not.

The player should be a task type, create one dynamically at the beginning of the game, and a second one after 1s.

The players terminate after 10s of game.

## For mark 4 (place it in /4 directory)

The commentators had problems with anyonymous players, identify now the players by name and count their goals.

New elements:

* The player should be a task type with discriminant, its parameter a pointer to String. At printing write the name of the players as well.

* Create a `Scoreboard` protected.

* A player terminates differently.

The `Scoreboard` protected has a counter, increased by the `Score` procedure when a goal is scored.
The `Get_Score` function can read it. A player should terminate if  `Get_Score` < 4.

## For mark 5 (place it in /5 directory)

Create balls. Next to the score now record on the scoreboard also the player who scored it.

New elements:

* Create `Ball` task type, its discriminant is the name and id of the player. At each ball usage write the name of the player too.

* The counter's operations waits now also the id of the player calling them. 

* The player has new discriminant, its id.

The players are not calling directly the gate, they are calling via the ball.
The `Ball` is task type, which are dynamically created by players.

The counter is not a variable, but an array counting the goals scored by a player. 
Change the operations accordingly. A player should terminate if at least 4 goals were scored by him.

Have fun with programming!
