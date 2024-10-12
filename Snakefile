SAMPLES, = glob_wildcards("{sample}.trim.sig.zip")
print(f"found {len(SAMPLES)}")

DB="/group/ctbrowngrp/sourmash-db/gtdb-rs214/gtdb-rs214-k31.zip"

rule all:
    input:
        expand("{sample}.pygather.csv", sample=SAMPLES),
        expand("{sample}.fastgather.csv", sample=SAMPLES),
        expand("{sample}.fastmultigather_rocksdb.csv", sample=SAMPLES),
        expand("{sample}.fastmultigather.csv", sample=SAMPLES),

rule pygather:
    input:
        sig = "{sample}.trim.sig.zip",
        db=DB,
    output:
        "{sample}.pygather.csv"
    threads: 128
    benchmark: "benchmarks/pygather.{sample}.txt"
    shell: """
        sourmash gather -k 31 --scaled 1000 {input.sig} {input.db} \
           -o {output}
    """

rule fastgather:
    input:
        sig = "{sample}.trim.sig.zip",
        db=DB,
    output:
        "{sample}.fastgather.csv"
    threads: 128
    benchmark: "benchmarks/fastgather.{sample}.txt"
    shell: """
        sourmash scripts fastgather -k 31 -s 1000 {input.sig} {input.db} \
           -c {threads} -o {output}
    """

rule make_rocksdb:
    input:
        db=DB,
    output:
        directory("gtdb-rs214-k31.rocksdb"),
    threads: 128
    benchmark:
        "benchmarks/index.rocksdb.txt",
    shell: """
        sourmash scripts index -c {threads} -k 31 -s 1000 {input} -o {output}
    """

rule fastmultigather_rocksdb:
    input:
        sig="{sample}.trim.sig.zip",
        db="gtdb-rs214-k31.rocksdb",
    output:
        "{sample}.fastmultigather_rocksdb.csv",
    threads: 128
    benchmark: "benchmarks/fastmultigather_rocksdb.{sample}.txt"
    shell: """
        sourmash scripts fastmultigather -k 31 -s 1000 {input.sig} {input.db} \
            -o {output} -c {threads}
    """

rule fastmultigather:
    input:
        sig="{sample}.trim.sig.zip",
        db=DB,
    output:
        actual="{sample}.gather.csv",
        prefetch="{sample}.prefetch.csv",
        rename="{sample}.fastmultigather.csv",
    threads: 128
    benchmark:
        "benchmarks/fastmultigather.{sample}.txt",
    shell: """
        sourmash scripts fastmultigather {input.sig} {input.db} -k 31 -s 1000 \
           -c {threads}
        cp {output.actual} {output.rename}
    """
