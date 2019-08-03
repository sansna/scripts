filelocation=$(realpath $0 | rev | cut -d/ -f 2- | rev)
# or can be like this
filelocation=$(realpath $0 | sed -ne 's/^\(.*\)\/[^/]*$/\1/p')
