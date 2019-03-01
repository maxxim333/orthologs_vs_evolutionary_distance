from Bio import Phylo
tree = Phylo.read('/home/mvaskin/Desktop/maks/12feb/full_species_unique.nwk', 'newick')
#print tree

list_of_species = open("/home/mvaskin/Desktop/maks/12feb/full_species_unique.txt").read().splitlines()
print list_of_species
list_of_species_pro= ("acanthochromis_polyacanthus", "ailuropoda_melanoleuca")
my_dict = {}
for specie in list_of_species:
	try:
		capitalized=specie.capitalize()
		clean_string = capitalized.replace(" ", "_")
		print clean_string
	
		tree.ladderize()   # Flip branches so deeper clades are displayed at top
		Phylo.draw(tree)
		value=tree.distance("Homo_sapiens",str(clean_string))
		print "The distance between Homo_sapiens and " + str(clean_string) + " is " + str(value)
		my_dict.update({clean_string : value})
		print array_raw_values
	except:
		pass
print my_dict
#print "Equivalent String : %s" % str (my_dict)

distances = open("distances.txt", "w")
distances.write(str(my_dict))
distances.close()
