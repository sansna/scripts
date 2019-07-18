today=$(date +"%s" -d "-"$1" days"|awk '{print int($1/(3600*24))*3600*24-8*3600}')
yesterday=$(($today-3600*24))
todaydate=$(date -d @$today +"%Y/%m/%d")
yesterdaydate=$(date -d @$yesterday +"%Y/%m/%d")
echo $todaydate $yesterdaydate
