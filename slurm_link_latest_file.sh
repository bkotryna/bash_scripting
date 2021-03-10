entry=$(ls slurm-*.out | sort -r | head -1)
namea=$(echo $entry | awk -Fslurm '{print $2}' | awk -F. '{print $1}');
nameb=$(awk '/--o/ {print $0; exit;}' $entry | awk -F--o '{print $2}' | awk -F/ '{print $2}');
namec="-slurm"	
namejoin=$nameb$namec$namea;	
ln -s $entry $namejoin.txt