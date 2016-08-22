INSTRUCTIONS TO RUN THE CODE:
We have a single vhd file which is the source code, and this is the project top code. 
This is in essence a single file code, so the test bench can directly be added to the project and simulated.
Once you start the simulation, keep running the simulation until SAT gets assigned with something, by using the command $run <time> continously until SAT gets assigned. (Set <time> to may be 1ms)


FORMAT OF THE TEST BENCH TO BE USED: 
The test bench format is as follows, 
load should be put to 1, and clause is to be set to the required clause value in the format as specified in the problem specification, and wait for one clock cycle.
And keep doing this until your inputs are done to be given. 
For example,
		load<='1';
		clause<="1111111111000000000000000000000000000000000000000000000000000000";
		wait for clock_period;
		load<='1';
		clause<="0000000001000000000000000000000000000000000000000000000000000000";
		wait for clock_period;
The above set of 6 lines denotes one single clause. 


ASSUMPTIONS TAKEN:
We are having the following assumptions, (some of these are the assumptions mentioned in the problem statement)
Input should not have empty clause.
Once load turns high from low we are assuming that it stays high for atleast two or more even cycles and after that if it becomes zero then it should not be immediately followed by a 1. 
We also assume the load to be zero untill the circuit completes the calculations.
We assume that none of the input variables can not have 1 and 1.
The circuit is assumed to have 65 outputs.
And set load to 0 once you are finished with giving inputs. 


DESCRIPTION OF THE OUTPUTS AND HOW TO FIND THE DESIRED OUTPUTS:
The output signal named SAT denotes whether the given problem instance is satisfiable or not, i.e SAT = 1 means it is satisfiable, and unsatisfiable otherwise.
The output signal named output denotes the actual assignment which satisfies the given problem instance in case SAT is 1, and it does not signify anything in case SAT is 0.   