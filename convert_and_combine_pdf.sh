#! bin/bash

# for file in *.txt
# do
#     sed -e ':a' -e 'N' -e '$!ba' -e 's/-\n/ /g' $file > ${file%.*}p2.txt
#     rm $file
# done
# takes out dashes for line/word break

# pdfarray=()
# for pdf in *.pdf
# do
#     pdfarray+=($pdf)
# done
# echo "${pdfarray[@]}"
# cpdf -merge ${pdfarray[@]} -o combined.pdf
# populating pdfs in an array and combining all the pdfs in the array into one pdf file

for file in *.txt
do
    cat $file >> all.txt
    echo '\newpage' >> all.txt
done
# combining all the txt files to one file and adding a page break command to 

pandoc --pdf-engine=xelatex -V geometry=margin=2cm -V mainfont="DejaVu Serif" -o all.pdf all.txt