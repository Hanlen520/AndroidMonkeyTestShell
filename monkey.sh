#!/bin/bash 

#————————————————
# author：gholl    
#
# blog.gholl.com  
#————————————————

log="./log"
mkdir $log
c_log=${log}"/$2_`date +%Y-%m-%d_%H_%m`"
mkdir $c_log
normal=${c_log}"/normal.txt"
error=${c_log}"/error.txt"
adb shell settings put global policy_control immersive.full=*
for((i=1;i<=$1;i++));  
do   
#echo $i;
printf "[%d/%d]" "$i" "$1"
printf "\n"
x=`expr $i % 20`
if [ $x == 0 ]; then
echo "Restart App $i"
adb shell am start -n com.pandarow.chinese/.view.page.splash.SplashActivity
fi
adb shell monkey -p com.pandarow.chinese -s 500 --ignore-crashes --ignore-timeouts --monitor-native-crashes -v -v 10000 1>>$normal 2>>$error
echo "\n\n\n\n--------------------$i-----------------\n\n\n " >> $normal
done  

echo "Monkey Test END"
echo "---------------------ANR-------------------"
grep -rin "ANR" $normal
echo "---------------------OOM-------------------"
grep -rin "OOM" $normal
echo "-------------------Exception---------------" 
grep -rin "Exception" $normal
adb shell settings put global policy_control null
