cd ../data/
names=(*)
for file in ${names[*]}; do
#  wc $file/metadata.yaml
# ln -s  $file/metadata.yaml ../docs/_database/$file.yaml
 cp  $file/metadata.yaml ../docs/_data/entries/$file.yaml
done

#rm template*
