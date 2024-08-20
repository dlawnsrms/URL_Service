#!/bin/bash 
javac LoadTest.java 
echo $SECONDS 
java LoadTest 127.0.0.1 4001 11 PUT 1000 & 
java LoadTest 127.0.0.1 4001 12 PUT 1000 & 
java LoadTest 127.0.0.1 4001 13 PUT 1000 & 
java LoadTest 127.0.0.1 4001 14 PUT 1000 & 
wait $(jobs -p) 
echo $SECONDS
