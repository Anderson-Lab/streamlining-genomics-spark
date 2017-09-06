#!/bin/sh

# RDD to Trimmomatic and then Bowtie and then back

BT2_HOME="$1"

#STARTTIME=$(date -u)

# Updated script still pipes one read at a time for IgniteRDD, but it doesn't seem to hang or interrupt like before
# Still need to get IgniteRDD into one pipe!

rm $PWD"/Pipes/rdd_in.pipe"
rm $PWD"/Pipes/app1_out.pipe"
rm $PWD"/Pipes/rdd_out.pipe"

mkfifo $PWD"/Pipes/rdd_in.pipe"
mkfifo $PWD"/Pipes/app1_out.pipe"
mkfifo $PWD"/Pipes/rdd_out.pipe"


cat <&0 > $PWD"/Pipes/rdd_in.pipe" | \
java -jar $PWD"/jars/app1.jar" $PWD"/Pipes/rdd_in.pipe" $PWD"/Pipes/app1_out.pipe" | \

java -jar $PWD"/jars/app2.jar" $PWD"/Pipes/app1_out.pipe" $PWD"/Pipes/rdd_out.pipe" | \

cat < $PWD"/Pipes/rdd_out.pipe"

ENDTIME=$(date -u)
#echo "Start time: "$STARTTIME
#echo "End time: "$ENDTIME
