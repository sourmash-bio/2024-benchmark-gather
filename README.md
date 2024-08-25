# benchmarks for sourmash-bio/sourmash gather implementations

See: https://github.com/sourmash-bio/sourmash/issues/3232

Allocate node:
```
srun -p bmh --time=48:00:00 --nodes=1 --cpus-per-task=64 --mem=40GB --pty /bin/bash
```
