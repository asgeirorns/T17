#Tournament Scheduling 
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
set Groups{g in GroupsNames} within Teams;

#Set of all available Fields
set Fields;

#Number of all available days for the group stage
param n:= 3;

#Set of all available Slots on each field

set Slot := 1..(11*n);

param SplitBetweenDays {s in Slot} := if (s in {1,12,23}) then 1 else 0;


#set of days available in order of the first slot of the day
set Days :=1..(1*n) by 1;


#A Binary variable that assigns a team to a slot and a field
var x{Teams, Teams, Slot} binary;

#-----------------------------------------------#



#Each game is only assigned one time
subject to OnlyOnce{g in GroupsNames, t1 in Groups[g], t2 in Groups[g]:t1<t2}: sum{s in Slot} (x[t1,t2,s]+x[t2,t1,s])=1;


#Maximum number of games per slot - due to limitation in number of fields
subject to MaxNumberOfGamesPerSlot{s in Slot, g in GroupsNames}: sum{t1 in Groups[g], t2 in Groups[g]} x[t1,t2,s]<=7;




#This part will split the solution to two binary values w and ww in order to take CourseClashVariable
#of each individual team to rest as much as possible between games
var w{Teams, Slot}, binary;
subject to ASplit{g in GroupsNames, t1 in Groups[g], s in Slot}: sum{ t2 in Groups[g]:t1<t2} x[t1,t2,s] = w[t1,s];

#Second Part
var ww{Teams, Slot}, binary;
subject to BSplit{g in GroupsNames,t2 in Groups[g], s in Slot}: sum{ t1 in Groups[g]:t1<t2}x[t1,t2,s] = ww[t2,s];



#Each team should not be assigned at the same time to a different venue - why is the slack variable needed?? Is the other not solvable?
var Slack{Teams}, >=0;
subject to NoClash{t1 in Teams, s in Slot: TeamConjoined[t1,t2]}: (w[t1,s]+ww[t1,s]) <=1;

#----rett hingad til----#

#Each team should not have two consecutive games in a Row unless required
#var Slack2{Teams}, >=0;
#subject to OneGameBreak{t1 in Teams, s in Slot: s>1}: w[t1,s-1]+ww[t1,s-1]+w[t1,s]+ww[t1,s]<=1;





#cd Projects/Tournament\ Scheduling/Scripts



#Objective - maximize games within groups
#maximize Objective:
#  sum{g in GroupsNames, t1 in Groups[g], t2 in Groups[g]:t1<t2}match[t1,t2]
  #100*sum{g in GroupsNames, t1 in Groups[g], t2 in Groups[g], s in Slot:t1<t2}x[t1,t2,s]
  #+0.001*z
  #*sum{t1 in Teams, t2 in Teams: t1<t2}MatchSeq[t1,t2]
  #-10000*sum{t1 in Teams, t2 in Teams: t1 < t2} Assigned[t1,t2]
#  ;





solve;
