ml openbabel

for i in base*; 
do 
	cd $i; 
	cp ../receptor.pdb .; 
	for j in rank1 rank2 rank3;
	do
		obabel ${j}_* -O ${j}.pdb -h;
		grep "UNL" ${j}.pdb > ${j}_mod.pdb
	done

	cd ..; 
done
