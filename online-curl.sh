payload=$1
url=$2
[ "x$url" == "x" ]\
    && url=$payload\
    && payload=""

comma=","
[ "x$payload" != "x" ]\
    && payload="${comma}${payload}"
echo "payload: "$payload
echo "url: "$url
curl -d '{"h_did":"","token":"","h_m":11'${payload}'}' api.iupvideo.net/${url}?sign=
