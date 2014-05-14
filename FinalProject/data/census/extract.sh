for file in  *.zip
do
  unzip -d "${file%.zip}" $file
done
