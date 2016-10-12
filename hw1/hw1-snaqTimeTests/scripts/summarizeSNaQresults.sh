#!/bin/bash
#This script was created by Melody Sain on 11-Oct-2016
# This script assumes GNU grep

set -e # script terminates if any command exits with non-zero status
set -u # terminates if any variable is unset
set -o pipefail # terminates if command within a pipes exits unsuccessfully

# This shell script is used to summarize some of the results from all snaq analyses.
# The script produces a table in .csv format, with 1 row per analysis and 13
#columns titled Analysis, hmax, CPUtime, Nruns, Nfail, fabs, frel, xabs, xrel,
# Seed, under3460, under3450, and under3440.

# The script should be ran while in the directory that contains your SNaq .log and .out files


echo Analysis,hmax,CPUtime,Nruns,Nfail,fabs,frel,xabs,xrel,Seed,under3460,under3450,under3440 > snaqSummary.csv
#above command creates the column headers in the .csv file.
for filename in log/*.log
do
  echo this is filename: $filename
  #analysis=$(find $filename | grep -E -o "[^log/.log]+")
  analysis=$(basename -s ".log" $filename)
  # the line above produces only the rootname of the file
  echo this is analysis: $analysis
  hmax=$(grep "hmax" $filename | head -n 1 | grep -P -o "\d")
  # the line above produces only the hmax value for each file in .log
  echo this is hmax: $hmax
  CPUtime=$(grep -P "Elapsed time. \d+\.\d+" -o out/$analysis.out  | grep -P -o "\d+\.\d+")
  # the above line produces the time taken to run each analysis
  echo this is CPUtime: $CPUtime
  Nruns=$(sed -n '7p' $filename | cut -f2 -d " ")
  #the above line produces the number of runs per analysis
  echo this is Nruns: $Nruns
  Nfail=$(sed -n "5p" $filename | grep -o -P "proposals\s=\s\d+" | grep -o -P "\d+") #sed command as used here finds the 5th line in the file
  # the above line produces the tuning parameter, "max number of failed proposals"
  echo this is Nfail: $Nfail
  Seed=$(grep "main seed" $filename  | grep -P -o "\d+")
  # the above line produces the  main seed, i.e. seed for the first runs
  echo this is Seed: $Seed
  frel=$(sed -n '3p' $filename | cut -f4 -d" " | grep -P -o "\d+.+\d+") #sed command as used here finds the 3rd line in the file
  # the above line prints "ftolRel" for each analysis
  echo this is frel: $frel
  fabs=$(sed -n '3p' $filename | cut -f5 -d" " | grep -P -o "\d+.+\d+") #sed command as used here find the 3rd line in the file
  #the above line prints the tuning parameter called "ftolAbs" in the log file
  #(tolerated difference in the absolute value of the score functioin, to stop 4
  #the search)
  echo this is fabs: $fabs
  xabs=$(sed -n '4p' $filename | cut -f1 -d "," | grep -P -o "\d+.+\d+") #sed command as used here finds the 4th line in the file
  # the line above prints "xtolABS" for each analysis
  echo this is xabs: $xabs
  xrel=$(sed -n '4p' $filename | cut -f2 -d "," | grep -P -o "\d+.+\d+") #sed command as used here finds the 4th line in the file
  #the line above prints "xtolRel" for each analysis
  echo this is xrel: $xrel
  loglik=$(sed -E -n 's/.*-loglik ([0-9]+).*/\1/p' out/$analysis.out) #sed command as used here finds the line with the -loglik valuse and extracts only the -loglik value (network score)
  # the line above only prints the digits before the . for -loglik
  under3460=0 # this variable is for the number of runs that returned a network with a score (-loglik value) better than (below) 3460
  under3450=0 #this variable is for the number of runs with a network score under 3450
  under3440=0 #this variable is for the number of runs with a network score under 3440
  for lik in $loglik
  do
    if [ $lik -lt 3460 ]
    then
    under3460=$((under3460+1))
  fi
  # the above loop finds the number of runs with a network score under 3460 and saves it to the variable under3460.
  done
    for lik in $loglik
    do
      if [ $lik -lt 3450 ]
      then
      under3450=$((under3450+1))
    fi
    # the above loop finds the number of runs with a network score under 3450 and saves it to the variable under3450.
    done
      for lik in $loglik
      do
        if [ $lik -lt 3440 ]
        then
        under3440=$((under3440+1))
      fi
      # the above loop finds the number of runs with a network score under 3440 and saves it to the variable under3440.
      done
  echo "$analysis,$hmax,$CPUtime,$Nruns,$Nfail,$fabs,$frel,$xabs,$xrel,$Seed,$under3460,$under3450,$under3440" >> snaqSummary.csv
done
