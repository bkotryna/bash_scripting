Want: a bash script to make a soft link to slurm-324348723854.out with a name relion_job_alias.out (or at least relion_job_ID.out)


Strategy:
identify newest slurm file (highest number in the file name / last in alphabetic ranking, Ig)
look inside the file, find "--o" text
follow until the first "job" text
take text until the first "/" sign
make a soft link to the newest slurm file: location is the same, name is the extracted text



# example line from the .out file
mpirun -N 3 -n 3 /usr/local/Cluster-Apps/relion-gpu/2.1/bin/relion_refine_mpi --o Refine3D/job121/run --auto_refine --split_random_halves --i ./Polish/job120/shiny.star --ref ./Import/job104/run_class001_330.mrc --ini_high 60 --dont_combine_weights_via_disc --pool 3 --ctf --ctf_corrected_ref --particle_diameter 180 --flatten_solvent --zero_mask --solvent_mask ./Import/job105/mask330.mrc --solvent_correct_fsc  --oversampling 1 --healpix_order 2 --auto_local_healpix_order 4 --offset_range 5 --offset_step 2 --sym C1 --low_resol_join_halves 40 --norm --scale  --j 4 --gpu  

# make soft link
ln -s file1 link1

# example for renaming files based on text found in them
https://unix.stackexchange.com/questions/330990/one-liner-command-to-rename-a-file-using-the-output-of-another-command
#!/bin/bash 
old_file_name=$1  # take an argument for the file you want to muck with
new_file_name=$(grep -e "some words" -e "other words" "${old_file_name}" | awk '{print $1}' | head -n 1).txt 
mv "$old_file_name" "$new_file_name"

awk '/(some|other) words/ {print $1}' filename.txt | xargs -I{} mv filename.txt {}.txt



#!/bin/bash 
old_file_name=$1  # take an argument for the file you want to muck with
new_file_name=$(grep -e "--o" "${old_file_name}" | awk '/-oo/ {print $2}' | awk '{}' | head -n 1).txt 
mv "$old_file_name" "$new_file_name"


awk '/--o/ {print $2}' filename.txt | awk '{/job/ print $1}' | awk -F/ '{print $1}' | xargs -I{} mv filename.txt job{}.txt
awk '/--o/ {print $2}' filename.txt | awk '{/job/ print $1}' | awk -F/ '{print $1}' | xargs -I{} ln -s filename.txt job{}.txt

# listing & sorting files
ls -1 | sort
# sort in reverse alphabetical order, then take the top file (ie lowest in alhabet)
ls -1 | sort -r | head -1

ls slurm*.out | sort -r | head -1

# intermediate achievement
myfile=$(ls test*.txt | sort -r | head -1)
awk '/--o/ {print $0}' myfile | awk -F--o '{print $2}' | awk -F/ '{print $2}' | xargs -I{} ln -s awk_output.txt {}.txt


# Jamie's renaming
for entry in *.mrc; do
mv $entry ${entry//.mrc/.mrcs};
done
for entry in *.mrcs; do
mv $entry ${entry:41};
done

# my tinkering
for entry in slurm-*.out; do awk '/--o/ {print $0}' entry | awk -F--o '{print $2}' | awk -F/ '{print $2}' | xargs -I{} ln -s entry {}.txt; done

# Current best work:
# takes file test1.txt and creates a soft link with relion job ID to a file named awk_output.txt
awk '/--o/ {print $0}' test1.txt | awk -F--o '{print $2}' | awk -F/ '{print $2}' | xargs -I{} ln -s awk_output.txt {}.txt

awk '/--o/ {print $0}' test1.txt | awk -F--o '{print $2}' | awk -F/ '{print $2}' | xargs -I{} ln -s test1.txt {}.txt

# select latest slurm.out file
ls slurm*.out | sort -r | head -1


# try to write a shell script
ls slurm*.out | sort -r | head -1
awk '/--o/ {print $0}' myfile | awk -F--o '{print $2}' | awk -F/ '{print $2}' | xargs -I{} ln -s awk_output.txt {}.txt

# how about we try this..
for entry in slurm-*.out; do
awk '/--o/ {print $0}' entry | awk -F--o '{print $2}' | awk -F/ '{print $2}' | xargs -I{} ln -s entry {}.txt;
done

for entry in slurm-*.out; do awk '/--o/ {print $0; exit;}' $entry | awk -F--o '{print $2}' | awk -F/ '{print $2}' | xargs -I{} ln -s $entry {}.txt; done

for entry in te*.txt; do awk '/--o/ {print $0; exit;}' $entry | awk -F--o '{print $2}' | awk -F/ '{print $2}' | xargs -I{} ln -s $entry {}.txt; done


for entry in slurm-*.out; do
	name1=echo $entry | awk -Fslurm '{print $2}' | awk -F. '{print $1}'
	name2=awk '/--o/ {print $0; exit;}' $entry | awk -F--o '{print $2}' | awk -F/ '{print $2}'
	ln -s $entry $name1_$name2.txt
done


for entry in slurm-*.out; do
	name1=$(echo $entry | awk -Fslurm '{print $2}' | awk -F. '{print $1}')
	name2=$(awk '/--o/ {print $0; exit;}' $entry | awk -F--o '{print $2}' | awk -F/ '{print $2}')
	ln -s $entry $name1$name2.txt
done



for entry in slurm-*.out; do
	namea=$(echo $entry | awk -Fslurm '{print $2}' | awk -F. '{print $1}');
	nameb=$(awk '/--o/ {print $0; exit;}' $entry | awk -F--o '{print $2}' | awk -F/ '{print $2}');
	ln -s $entry $namea$nameb.txt;
done

###############################################################
###############################################################

# Good ones

# rename all
for entry in slurm-*.out; do
	namea=$(echo $entry | awk -Fslurm '{print $2}' | awk -F. '{print $1}');
	nameb=$(awk '/--o/ {print $0; exit;}' $entry | awk -F--o '{print $2}' | awk -F/ '{print $2}');
	namec="-slurm"	
	namejoin=$nameb$namec$namea;	
	ln -s $entry $namejoin.txt;
done

# rename latest
entry=$(ls slurm-*.out | sort -r | head -1)
namea=$(echo $entry | awk -Fslurm '{print $2}' | awk -F. '{print $1}');
nameb=$(awk '/--o/ {print $0; exit;}' $entry | awk -F--o '{print $2}' | awk -F/ '{print $2}');
namec="-slurm"	
namejoin=$nameb$namec$namea;	
ln -s $entry $namejoin.txt


