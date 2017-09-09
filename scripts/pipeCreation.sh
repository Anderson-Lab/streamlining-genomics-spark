#!/bin/sh

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
