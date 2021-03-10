for entry in slurm-*.out; do
	namea=$(echo $entry | awk -Fslurm '{print $2}' | awk -F. '{print $1}');
	nameb=$(awk '/--o/ {print $0; exit;}' $entry | awk -F--o '{print $2}' | awk -F/ '{print $2}');
	namejoin=$nameb"-slurm"$namea;	
	ln -s $entry $namejoin.txt;
done