#Tournament Scheduling for ReyCup
#Author:Asgeir Orn Sigurpalsson
#Version: Beta 0.0.1
#Keyrsla: /Users/asgeirornsigurpalsson/Desktop/untitled\ folder\ 2/Keyrsla/glpk-4.60/examples/glpsol --check --math Tournament.mod  -d teams.dat -d groups.dat -d fields.dat  --wlp Tourin.lp
#Gurobi: gurobi_cl Threads=8 TimeLimit=300 ResultFile=Tourin.sol Tourin.lp

#---------------------------------------#

#A set of all Teams registered to the tournament
set Teams;
#A set of all names of groups in the tournament
set GroupsNames;
#A set of teams in each group by name
set Groups{g in GroupsNames} within Teams default {};

#Set of all available Fields
set Fields;

#Number of all available days for the group stage
param n:= 3;

#Set of all available Slots on each field
set Slots = 1..(11*n)

#set of days available in order of the first slot of the day
set Days :=1..(11*n)-1 by 2;

var Assign{Teams, Slots} binary;

#-----------------------------------------------#





solve;
