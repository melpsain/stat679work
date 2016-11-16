#!/usr/bin/env python
#before running from command line run chmod +x hw2function2.py
#This python script combines the solar energy captured to the water temperature.
#The script should be within the folder with the temperature and energy data files to run.

# As of right now the script is not complete but almost there.

import os, sys, re

import argparse #turns this module into a shell command
# use an Argument Parser object to handle script arguments
parser = argparse.ArgumentParser()
parser.add_argument("-t", help="water temperature file")
parser.add_argument("-e", help="solar energy file")
args = parser.parse_args()

#test if there is a problem with the arguments:
if not (args.t and args.e):
    raise Exception("needs two files for temp -t and energy -e")

#temp = open(args.t, 'r') # creates file handle
#energy = open(args.e, 'r') # creates file handle

OutFilename = "solarEnergyTempLog.csv"
OutFile = open(OutFilename, 'w')
#temp = sys.argv[1:]
#energy = sys.argv[2:]
#temp = numpy.loadtxt(fname="waterTemperature.csv", delimite=',')
#energy = numpy.loadtxt(fname="energy.csv", delimiter=',')

def solarenergy_temp(t, e):
    """ the function requires two files (temp and energy)
    where temp = waterTemperature.csv  and energy = energy.csv"""

    with open(t) as t:
        temperature = [line.rstrip('\n').split(",") for line in t if line.rstrip('\n') != '']

    with open(e) as e:
        energy = [line.rstrip('\n').split(",") for line in e if line.rstrip('\n') != '']


    for i in energy:
        if (energy.index(i) == 0) or (energy.index(i) == len(energy) - 1):
            pass
        else:
            i[0] = re.sub(r'([0-9]{2})([0-9]{2})-([0-9]{2})-([0-9]{2})', r'\3/\4/\2', i[0])

    #clean temperature file del(temperature[0:2])
    tempData = temperature[2:]
    tempDate = [i[1].split(" ")[0] for i in tempData] #keeps these in time order
    tempDate


    #for loop below matches dates in energy and temperature files and appends together
    for i in energy:
        if (energy.index(i) == 0) or (energy.index(i) == len(energy) - 1):
            pass
        else:
            if energy.index(i) == 1:
                tempData[0].append(str(float(i[1])/1000) + " warning: this energy value was recorded after this time")
            else:
                energyDate = i[0].split()[0] #splits the date from the time only giving the date
                index = tempDate.index(energyDate)
                tempData[index-1].append(float(i[1])/1000)
                #print(tempData)



            OutFile.write(tempData+'\n')

#temp.close()
#energy.close()
OutFile.close()
