-----------------------------------------------------------------

ELTE University has new freshmen which need to get residence permit for the time of their studies.

So, they must visit local immigration offices for getting one.

Note:

- All important activities should be printed by a protected monitor,

- Random generators must be protected

- each minute on text is 0.1 seconds in programming

-----------------------------------------------------------------

# For mark 2:

Create the freshman and the immigration task.

An immigration takes random float time to open (from 0 to 10 minutes), after that it allows freshman

to get their residence (can be accepted ... or terminate).

The freshman calls the immigration waiting max. 5 minutes for the call to be taken.

Print all events. Results:

Freshman: did not get residence

or

Immigration: freshman gets his residence

Freshman: got his residence

-----------------------------------------------------------------

# For mark 3:

Convert freshman task into task type. Add its ID as a discriminant (a pointer to String which contains his starting number as a string – the for loop I parameter’s image, later denoted as ID). Create an array of 21 dynamic freshmen, each after 5 minutes internal.

To each freshman a random priority value from 0 to 2. Priority be represented by the user created Priority type, Ada.Numerics.Discrete_Random generic should be for getting the random priority (Hint: extend with Priority type). Freshman’s priority will determine if it gets the residence permit or not or will have another chance getting it.

If it has priority 2 or 1, he will try to get residence
If he could get residence, he writes "ID, got residence permit" after that goes home.
If he could not get the residence and he has priority 2, write: " ID will try again later" (after every trial priority decreases by 1 and he can try again after 7 minutes).
If he could not get the residence and has the priority 1, write: “ID couldn't get the residence” and he is not trying anymore.
If he has priority 0, then he is not trying, "ID couldn't get the residence" should be printed and the freshman goes home as well.
Each time the freshman tries to access the immigration output his priority as following “ID, has priority PRIORITY”. Every time the student tries to get residence, he waits float random time between 0.0 and 1.0 for getting accepted.

 

Immigration office opens after a float random time (between 0.0 and 1.0).  Immigration works 24/7 and closes only when there is no more freshman arriving to it.  It accepts students one each time, after which it waits for 10 minutes for the new freshman to come.

 

EXAMPLE OUTPUT:

1 has priority 1

1, got residence permit

2 has priority 2

2 will try again later

2 has priority 1

2 will try again later

2 couldn't get the residence

3 has priority 2

3 will try again later

4 could not get residence permit

3 has priority 1

3, got residence permit

5 could not get residence permit

6 has priority 1

6 will try again later

6 couldn't get the residence

7 could not get residence permit

8 has priority 2

8, got residence permit

9 has priority 1

9 will try again later

9 couldn't get the residence

10 has priority 2

10 will try again later

11 could not get residence permit

10 has priority 1

10, got residence permit

12 has priority 1

12 will try again later

12 couldn't get the residence

14 has priority 1

14, got residence permit

13 has priority 1

13 will try again later

13 couldn't get the residence

15 has priority 1

15 will try again later

15 couldn't get the residence

16 could not get residence permit

17 has priority 1

17, got residence permit

18 could not get residence permit

19 has priority 2

19 will try again later

19 has priority 1

19, got residence permit

21 could not get residence permit

20 has priority 2

20, got residence permit

-----------------------------------------------------------------

# For mark 4:

The government, after analysing research results from task 3, decides to open new immigration offices.

Convert the immigration task into a task type, create an array of 3 dynamic immigration offices.

They should start before freshmen start with the same delay (5 minutes).

Choose randomly from these three offices ( Ada.Numerics.Discrete_Random generic should be used again)  before freshman starts to try to get residence. If he fails, chooses randomly again using same functionality and print: “ID will try again later in office OFFICE”

Increase the number of freshmen twice.

EXAMPLE OUTPUT:

30, got residence permit from office 3

32 could not get residence permit

31 has priority 1

31 will try again later in office 1

31 couldn't get the residence from office 1 going home.

33 could not get residence permit

-----------------------------------------------------------------

# For mark 5:

A special committee will keep monitoring the statistics from the getting residence process.

Create a protected committee object, that calculates the number of freshmen who got residence,

and print it at the end of the process (use committee functionality to get the result).

 

EXAMPLE OUTPUT:

Number of accepted freshmen is 16

Good luck!
