#! /usr/bin/env python
import sys
import pandas as pd
import argparse

pd.options.display.precision = 1

def main():
    p = argparse.ArgumentParser()
    p.add_argument('bench_dir')
    args = p.parse_args()

    samples = ['SRR12324253', 'SRR1976948', 'SRR5650070', 'SRR606249']
    prefixes = [ 'fastmultigather', 'fastmultigather_rocksdb', 'fastgather', 'pygather']
    df_list = []

    # load all the CSV files
    for s in samples:
        for p in prefixes:
            df = pd.read_csv(f'{args.bench_dir}/{p}.{s}.txt', sep='\t')
            df.insert(0, "prefix", [p], True)
            df.insert(1, "sample", [s], True)
            df_list.append(df)

    df = pd.concat(df_list)

    df_by_second = df[df["sample"] == 'SRR1976948'][["prefix", "s", "max_rss"]].sort_values(by="s")
    
    df_by_second.set_index("prefix", inplace=True)
    df_by_second["max_rss"] /= 1000

    print(df_by_second.to_markdown(floatfmt=".1f"))

    rocksdb_df = pd.read_csv(f'{args.bench_dir}/index.rocksdb.txt', sep='\t')
    rocksdb_df = rocksdb_df[["h:m:s", "s", "max_rss"]]

    hms = list(rocksdb_df["h:m:s"])[0]
    sec = list(rocksdb_df["s"])[0]
    rss = list(rocksdb_df["max_rss"] / 1000)[0]

    print('')
    print(f"Cost of RocksDB indexing: {hms} / {int(sec)}s / {rss:.1f} GB")


if __name__ == '__main__':
    main()
