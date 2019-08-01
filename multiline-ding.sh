info=$(echo -e "\""$*"\""|sed 's/,/\\n/g')
curl 'https://oapi.dingtalk.com/robot/send?access_token=' -H 'Content-Type: application/json' -d '{"msgtype": "text","text": {"content": '${info}'}}'
