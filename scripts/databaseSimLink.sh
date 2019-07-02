cd ../data/
names=(*)
cd ../docs/_data/entries/
for file in ${names[*]}; do
#  wc $file/metadata.yaml
 ln -s ../../../data/$file/metadata.yaml $file.yaml
# cp  $file/metadata.yaml ../docs/_data/entries/$file.yaml
done

#rm template*
