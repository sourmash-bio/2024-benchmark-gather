#! /bin/bash -login
#SBATCH -A ctbrowngrp
#SBATCH -p bmm                # partition, or queue, to assign to
#SBATCH -J gather-bench            # name for job
#SBATCH -N 1                   # one "node", or computer
#SBATCH -n 1                   # one task for this node
#SBATCH -c 64                  # cores per task
#SBATCH -t 1-0                 # ask for 1 days
#SBATCH --mem=40000             # memory (30,000 mb = 30gb)
#SBATCH --mail-type=ALL
#SBATCH --mail-user=titus@idyll.org

[[ -z "$1" ]] && { echo "remember to specify conda environment" ; exit 1; }
target=${2:-small}

# initialize conda
module load conda

# activate your desired conda environment
conda activate $1

# fail on weird errors
set -o nounset
set -o errexit
set -x

# go to the directory you ran 'sbatch' in, OR just hardcode it...
#cd $SLURM_SUBMIT_DIR

# run workflow
echo snakemake -c 64 $target

# print out various information about the job
env | grep SLURM            # Print out values of the current jobs SLURM environment variables

scontrol show job ${SLURM_JOB_ID}     # Print out final statistics about resource uses before job exits

sstat --format 'JobID,MaxRSS,AveCPU' -P ${SLURM_JOB_ID}.batch
