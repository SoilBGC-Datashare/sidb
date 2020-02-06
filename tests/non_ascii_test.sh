#if LC_ALL=C grep -r '[![:cntrl:][:print:]]' ../data/; then
#  echo "Contain Non-ASCII"
#fi 

FILES="ls -d ../data/*/"

for f in eval $FILES 
do
 file -I $f/*
done
