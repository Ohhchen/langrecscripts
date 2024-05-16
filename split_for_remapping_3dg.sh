#! bin/bash

# for file in *.txt
# do
#     sed -e ':a' -e 'N' -e '$!ba' -e 's/Digitized by\n/ /g' $file > 0${file}
# done
# takes out "Digitized by" from the file and renames the file to 0$file

# for file in *.txt
# do
#     filename=${file%.*}
#     if [[ ${filename:0:1} = 0 ]]; then
#         sed -e ':a' -e 'N' -e '$!ba' -e 's/Google\n/ /g' $file > ${filename:1:5}.txt
#         rm $file
#     fi
# done
# takes out "Google" from the file and renames the file back to original name

for file in *.txt
do
    filename=${file%.*}
    if [[ ${filename:0:1} != 0 ]]; then
        mv $file 0${file}
        echo ${filename:0:1}
    fi
done
# rename all original files to have leading 0's

for file in *.txt
do
    gcsplit $file -f "${file%.*}" -b'%d.txt' '/---------------/' '{*}'
done
# split the original txt files into 3 chunks

for file in *.txt
do
    filename=${file%.*}
    if [[ ${filename:4} -eq 2 ]]; then
        rm $file
    fi
    echo ${#filename}
done
# loop through the directory to find any filenames ending in 2 and delete them

for file in *.txt
do
    boasfile=${file%.*}
    if ([ ${#boasfile} -eq 5 ] && [ ${boasfile:4} -eq 1 ]); then
        g2p convert $file kwk-boas kwk-umista > ${file%.*}'umista'.${file##*.}
    fi
done
# running mapping conversion on the files ending with 1 

filestocat=()
for file in *.txt
do
    filename=${file%.*}
    if [[ ${#filename} -gt 4 ]]; then
        filestocat+=($file)
        echo "${filestocat[@]}"
    fi
done
# saving all the new files into an array to loop through for later

for file in "${filestocat[@]}"
do
    filename=${file%.*}
    if [[ ${filename:5:1} == "u" ]]; then
        mv $file ${filename:0:4}2.${file##*.}
        filestocat+=(${filename:0:4}2.${file##*.})
    fi
done
#renaming umista files to end with 2

for file in "${filestocat[@]}"
do
    filename=${file%.*}
    # echo "${filestocat[@]}"
    # echo ${#filename}
    # echo ${filename:4:1}
    if ([ ${#filename} -gt 4 ] && [ ${filename:4:1} == 0 ]) || ([ ${#filename} -gt 4 ] && [ ${filename:4:1} == 1 ]) || ([ ${#filename} -gt 4 ] && [ ${filename:4:1} == 2 ]); then
        touch ${filename:0:4}processed.${file##*.}
        cat $file >> ${filename:0:4}processed.${file##*.}
    fi
done
# combine all the 5 digit files together

mkdir processedfiles
for file in *.txt
do
    filename=${file%.*}
    mv ${filename:0:4}processed.${file##*.} processedfiles/
done
# move all processed files into new directory called processed files(final output)
