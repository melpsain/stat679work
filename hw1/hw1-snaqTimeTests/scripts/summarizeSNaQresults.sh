# shell script to start a summary of the results from all snaq analyses.
# The script produces a table in csv format, with 1 row per analysis and 3
#columns titled Analysis, hmax, and CPUtime

echo Analysis,hmax,CPUtime > snaqSummary.csv
for filename in log/*.log
do
  echo this is filename: $filename
  analysis=$(find $filename | grep -E -o "[^log/.log]+")
  # the line above produces only the rootname of the file
  echo this is analysis: $analysis
  hmax=$(grep "hmax" $filename | head -n 1 | grep -P -o "\d")
  # the line above produces only the hmax value for each file in .log
  echo this is hmax: $hmax
  CPUtime=$(grep -P "Elapsed time. \d+\.\d" -o out/$analysis.out  | grep -P -o "\d+\.\d")
  # the above line produces the time taken to run each analysis
  echo this is CPUtime: $CPUtime
  echo "$analysis,$hmax,$CPUtime" >> snaqSummary.csv
done
