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

## Summarize results to Markdown

```
./summarize-benchmark-to-md.py  benchmarks
```
will produce:

| prefix                  |      s |   max_rss |
|:------------------------|-------:|----------:|
| fastmultigather_rocksdb |  120.5 |       0.5 |
| fastgather              |  146.7 |      13.1 |
| fastmultigather         |  476.4 |      12.9 |
| pygather                | 2783.4 |      13.8 |

Cost of RocksDB indexing: 4:46:17 / 17177s / 14.3 GB
