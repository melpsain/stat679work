#HMWK 1 Trial

for y in {1..9}
do
  echo $y
  mv log/timetest${y}_snaq.log log/timetest0${y}_snaq.log
  mv out/timetest${y}_snaq.out out/timetest0${y}_snaq.out
done
#prints filenames timetest 1 - 9
#use  variables and loop in bash script and execute
