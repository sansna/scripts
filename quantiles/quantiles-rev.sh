echo "TYPE\tCOUNT\t95%\t90%\t80%"
sort -k2,2 -rsn|sort -k1,1 -ns | gawk -vFS=' ' -vRS='\n' 'BEGIN{delete kv;h=0;i=0;delete kvlen;}{if (h!=$1){kvlen[h]=i;h=$1;i=0;}else{i+=1;};kv[$1,i]=$2}END{kvlen[h]=i;for (i in kvlen){print i"\t"kvlen[i]"\t"kv[i,int(kvlen[i]*0.05)]"\t"kv[i,int(kvlen[i]*0.1)]"\t"kv[i,int(kvlen[i]*0.2)]"\t"};}'
