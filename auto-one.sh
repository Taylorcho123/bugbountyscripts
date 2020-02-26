#!/bin/bash

if [ "$1" == "" ];
then
        echo "Domain not found. script exited."
        exit 0
fi

echo "~~~~" $1 "~~~~"
mkdir $1_results;
cd $1_results;
../amass/amass enum -norecursive -noalts -d $1 > 1_$1.txt;
../subfinder/subfinder -d $1 -o 2_$1.txt;
assetfinder --subs-only $1 | tee -a 3_$1.txt;
../findomain/findomain -t $1 -o;
mv $1.txt 4_$1.txt;
cat *_$1.txt | sort | uniq > target1_$1.txt;
cat target1_$1.txt | dnsgen - > 5_o_$1.txt;
goaltdns -l target1_$1.txt -w ~/go/src/github.com/subfinder/goaltdns/words.txt -o 6_o_$1.txt;
python ../massdns/scripts/subbrute.py ../subdomains.txt $1 > 7_o_$1.txt;
cat *_o_* | sort | uniq > target2_$1.txt;
cat target2_$1.txt | massdns -r ../resolvers.txt -t A -o S -w 8_$1.txt;
sed 's/A.*//' 8_$1.txt | sed 's/CN.*//' | sed 's/\..$//' > target3_$1.txt;
cat target3_$1.txt | httprobe -c 40 -t 3000 -p http:8443 -p https:8443 -p http:8080 -p https:8 080 -p http:8008 -p https:8008 -p http:591 -p https:591 -p http:593 -p https:593 -p http:981 -p https:981 -p http:2480 -p https:2480 -p http:4567 -p https:4567 -p http:5000 -p https:5000 -p http:5800 -p https:5800 -p http:7001 -p https:7001 -p http:7002 -p https:7002 -p http:9080 -p https:9080 -p http:9090 -p https:9090 -p https:9443 -p https:18091 -p https:18092 | tee final_$1.txt;
wc -l final_$1.txt;

