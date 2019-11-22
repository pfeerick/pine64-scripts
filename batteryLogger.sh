#!/bin/bash

UPDATE_INTERVAL=60

function timer()
{
        local  stime=$1
        etime=$(date '+%s')

        if [[ -z "$stime" ]]; then stime=$etime; fi

        dt=$((etime - stime))
        ds=$((dt % 60))
        dm=$(((dt / 60) % 60))
        dh=$((dt / 3600))
        ELAPSED_TIME=$(printf '%d:%02d:%02d' $dh $dm $ds)
}


if [[ -e ~/batteryHistory.log || -e ~/battlog.csv ]]
then
while true; do
   read -p "Do you wish to delete previous battery logs? " yn

   case $yn in
      [Yy]* ) rm ~/batteryHistory.log ~/battlog.csv; echo "date,time,voltage,current (ma),soc (%),elapsed time (seconds)" > ~/battlog.csv; break;;
      [Nn]* ) echo "Keeping existing logs"; break;;
   esac
done
#   exit 1
fi

START_TIME=$(date +%s)
echo "-------------------------------------------------------------" | tee -a ~/batteryHistory.log
echo "|    date    |   time   | Voltage | Current | SoC | Elapsed |" | tee -a ~/batteryHistory.log
echo "|            |          |         | (mA)    | (%) | Time    |" | tee -a ~/batteryHistory.log
echo "--------------------------------------------------|----------" | tee -a ~/batteryHistory.log
#     2017-03-28 | 10-03-09 | 4.19     | 1       | 100^C

#echo "date/time   voltage   current(mA)  SoC (%)"

while [ 1 ]
do
   DATE=$(date +%Y-%m-%d)
   TIME=$(date +%H:%M:%S)
   BATT_VOLTAGE=$(awk '{printf ("%0.2f",$1/1000000); }' </sys/class/power_supply/battery/voltage_now)
   BATT_CURRENT=$(awk '{printf ("%0i",$1/1000); }' </sys/class/power_supply/battery/current_now )
   BATT_SOC=$(</sys/class/power_supply/battery/capacity)

   timer $START_TIME

   printf "| %-10s | %-8s | %-7s | %-7s | %-3s | %-6s |\n" "$DATE" "$TIME" "$BATT_VOLTAGE" "$BATT_CURRENT" "$BATT_SOC" "$ELAPSED_TIME" | tee -a ~/batteryHistory.log
   echo "$DATE,$TIME,$BATT_VOLTAGE,$BATT_CURRENT,$BATT_SOC,$dt" >> ~/battlog.csv
   sync
   sleep $UPDATE_INTERVAL
done
