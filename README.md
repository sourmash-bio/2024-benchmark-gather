# benchmarks for sourmash-bio/sourmash gather implementations

See: https://github.com/sourmash-bio/sourmash/issues/3232

Use `environment.yml` to create the basic conda environment, and then
customize from there.

## Make targets

`make check` -- run `snakemake -n` to see what will be done

`make clean` -- remove CSV files (but not rocksdb index)

`make clean-all` -- remove CSV files and RocksDB => rerun from scratch

## Run interactively

Allocate node:
```!
srun -p bmh --time=48:00:00 --nodes=1 --cpus-per-task=64 --mem=40GB --pty /bin/bash

snakemake -c 64
```

## Run in batch mode

```
sbatch run-sbatch.slurm <conda-env>
```