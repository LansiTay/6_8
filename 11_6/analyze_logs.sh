#!/bin/bash

awk '
BEGIN { 
    countA = 0; 
    countU = 0; 
    countG = 0; 
    countP = 0; 
    delete ips;    
    delete urls;
}
{
    countA++;
    
    if (!ips[$1]++) {
        countU++;
    }
    
    if ($6 ~ /GET/) countG++;
    if ($6 ~ /POST/) countP++;
    
    split($7, url_arr, "?");
    current_url = url_arr[1];
    urls[current_url]++;
}	
END {
    max_count = 0;
    popular_url = "";
    for (url in urls) {
        if (urls[url] > max_count) {
            max_count = urls[url];
            popular_url = url;
        }
    }
    print "Отчет о логе веб-сервера" > "report.txt";
    print "=======================" >> "report.txt";
    print "Общее количество запросов:", countA >> "report.txt";
    print "Количество уникальных IP-адресов:", countU >> "report.txt";
    print countG, "GET" >> "report.txt";
    print countP, "POST" >> "report.txt";
    print "Самый популярный URL:", max_count, popular_url >> "report.txt"
}' access.log


echo "Отчет сохранен в файл report.txt"
