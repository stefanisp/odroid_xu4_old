#!/bin/bash


sudo ./CPU_governor_performance.sh


#CPU_LIST=("0-3,4-7" "0-3,4-7" "0-1,4-5" "0-1,4-5" "4-7" "4-7" "0-3" "0-3")
CPU_LIST=("0-3,4-7")
#NUM_THREADS=("8" "16" "4" "8" "4" "8" "4" "8")
NUM_THREADS=("8")
#ITERACOES="1 2 3 4 5"
ITERACOES="1"

#rm *.log *.txt


for ((j = 0; j < ${#CPU_LIST[@]}; j++));
do
  if [ -d ${CPU_LIST[$j]} ];then           
      cd ${CPU_LIST[$j]}
      for it in `echo $ITERACOES`
      do
        cd $it
        files=$(ls 2> /dev/null | wc -l)
        if [ "$files" != "0" ]; then
             rm *.*              
        fi
        cd ..
      done
      cd ..
  else
      mkdir ${CPU_LIST[$j]}
      echo "Criando o Folder "${CPU_LIST[$j]}
      cd ${CPU_LIST[$j]}
      for it in `echo $ITERACOES`
      do
        mkdir $it
      done
      cd ..
  fi
done



for it in `echo $ITERACOES`
do
    echo "Iteracao "$it
    for ((i = 0; i < ${#CPU_LIST[@]}; i++));
    do
        
     echo "Executing Config "${CPU_LIST[$i]}
     #sudo taskset -a -c ${CPU_LIST[$i]} /home/odroid/meabo/./meabo.armv7 -C ${NUM_THREADS[$i]} -r 8192 -c 8192 -s 524288 -l 1048576 -p 524288 -R 1048576 &
     #sudo taskset -a -c ${CPU_LIST[$i]} /home/odroid/meabo/./meabo.armv7 -C ${NUM_THREADS[$i]} -r 4096 -c 4096 -s 262144 -l 4194304 -p 262144 -R 524288 &
     sudo taskset -a -c ${CPU_LIST[$i]} /home/odroid/meabo/./meabo.armv7 -C ${NUM_THREADS[$i]} -r 4096 -c 4096 -s 262144 -l 4194304 -p 262144 -R 524288
     PID_MEABO=$!
     echo "MEABO="$PID_MEABO

#     sleep 1
#     PidMeabo1=`pgrep meabo`
#     PidMeabo2=`pgrep -f meabo`
#     PidMeabo3=`pgrep -n meabo`
#     echo "PidMeabo="$PidMeabo3
#     echo "pidapp="$pid_app
     sudo ./Status.sh $pid_app &	
     PID_STATUS=$!
     echo "STATUS="$PID_STATUS


     grabserial -T -d /dev/ttyUSB0  >> Power2.log & 
     PID_GRABSERIAL=$!
     echo "GRANSERIAL="$PID_GRABSERIAL

#     PidPower1=`pgrep grabserial`
#     PidPower2=`pgrep -f grabserial`
#     PidPower3=`pgrep -n grabserial`
#     echo "Power Power1="$PidPower1" Pid Power2="$PidPower2" Pid Power 3="$PidPower3

#     echo "Esperando o fim do meabo"
     wait $PID_MEABO
     echo "Terminou PidMeabo!!"

#     echo "Killing Power"
     #sudo kill -9 $PidPower3
     sudo pkill grabserial
     echo "Killing Status"
     sudo pkill Status

     sleep 3

     mv *.log time.txt ${CPU_LIST[$i]}
     cd ${CPU_LIST[$i]}
     mv *.* $it
     cd ..        
     echo "FIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIM"
   done
done


#tar -cf MeaboPERFORMANCE.tar 0-1,4-5/ 0-3/ 0-3,4-7/ 4-7/
#cp MeaboPERFORMANCE.tar git/
#cd git && git add MeaboPERFORMANCE.tar && git commit -m "add" && git push origin master
