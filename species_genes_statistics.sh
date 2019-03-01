#!/bin/bash 
#This script takes as input 2 files: one is "all_orthologues_ensembl" which contains all the othologs of a subset of about 6000 clincally relevant genes and the other (file_for_concatenation2) contains all the evolutionary distances (from a phylogenetic tree) between humans and a subset of species.

#Then, it calls the R program and makes a plot of evolutionary distance VS number of orthologs and fits a regression line.

#The file "file_for_concatenation2" was obtained from a script newickread.py that inputs, reads and extracts information from a newick file also provided

#"all_orthologues_ensembl" files are not provided as they are too large, therefore all the comands involving them are commented out and instead the processed "species_list_one2one.txt" file is provided

# The file all_orthologues_ensembl contains all the orthology rleations between humans and other specie. there are different type of #orthology relationship. I am only interested in 1-to-1 relationship. So I need to retreive only one2one orthoogies
#grep "one2one" all_orthologues_ensembl > all_one2one_orthologies_ensembl.txt

#Now I have to make sure each gene appears exactly once (it is a requirement for 1-to-1 orthologies)
#cat all_one2one_orthologies_ensembl.txt | egrep -o "homologies id=\"[a-zA-Z0-9]+\"" > all_one2one_ids_ensembl.txt 

#sort all_one2one_ids_ensembl.txt | uniq -c #we see that all of them are repeated only once!

#Now I count the species. No one shoul surpass 6000 (the innitial dataset of human genes was around 6000)
#cat all_one2one_orthologies_ensembl.txt | egrep -o "species=\"[a-zA-Z0-9]+\_[a-zA-Z0-9]+\"" > species_list_one2one.txt

egrep -o "\"[a-zA-Z0-9]+\_[a-zA-Z0-9]+\"" species_list_one2one.txt | sed 's/"//' |  sed 's/"//' | sed 's/_/ /
' > species_list_counter.txt

sort species_list_counter.txt | uniq -c | sort > species_list_counter_sorted.txt
sort species_list_counter.txt | uniq -c | sort -n #pan paniscus is the one appearing the most: in 4310 genes. It makes sense as it is a primate and we would expect the primates to have the most orthologs with humans. Additionally, no specie has more than 6000 orthologs

#Now I want to join the species/counter file with file containing species/phylogenetic distance values. But for that I need to preprocess them a bit

#From the first file: pick only numeric values and store them apart. Same for the characters ans substitute spaces by _
cat species_list_counter_sorted.txt | grep -Eo [0-9]+ > species_list_counter_numbers.txt
cat species_list_counter_sorted.txt | grep -Eo "[A-Za-z]+ [A-Za-z]+" | sed s'/ /_/' > species_list_counter_species.txt

#Join them
paste species_list_counter_numbers.txt	species_list_counter_species.txt > file_to_join1.txt

#Second file (the one containing phylogenetic distances values)
#cat file_for_concatenation2 | sed s'/ //' | sed s'/ //' > file_for_concatenation2_processed.txt

cat file_for_concatenation2 | grep -Eo "[A-Za-z]+_[A-Za-z]+"  > file_for_concatenation2_part1_pre.txt

#delete homosapiens (as the distance will be 0)
sed '/homo/d' file_for_concatenation2_part1_pre.txt >  file_for_concatenation2_part1.txt
cat file_for_concatenation2 | egrep -Eo "[0-9]+\.?[0-9]+" > file_for_concatenation2_part2.txt

paste file_for_concatenation2_part1.txt file_for_concatenation2_part2.txt > file_to_join2.txt

#Sort
sort file_to_join2.txt > sorted_tojoin2.txt
sort -k2 file_to_join1.txt >sorted_tojoin1.txt

#Finally join them (I sorted them beforehand just in case)
join -a1 -a2  -1 2 -2 1  -e "NULL" sorted_tojoin1.txt sorted_tojoin2.txt | awk ' { t = $2;$2 = $3; $3 = t; print; } '> species_distance_ortho121.txt

#Rename file
mv species_distance_ortho121.txt species_distances_occurrence.txt

#Launch R script
Rscript plot_number_orthologs_vs_occurrences.R
