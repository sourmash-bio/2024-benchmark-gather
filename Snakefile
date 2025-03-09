SAMPLES, = glob_wildcards("{sample}.trim.sig.zip")
print(f"found {len(SAMPLES)}")

SMALL=['SRR1976948']

DB="/group/ctbrowngrp/sourmash-db/gtdb-rs214/gtdb-rs214-k31.zip"

rule small:
    input:
        expand("output/{sample}.pygather.csv", sample=SMALL),
        expand("output/{sample}.pygather_rocksdb.csv", sample=SMALL),
        expand("output/{sample}.fastgather.csv", sample=SMALL),
        expand("output/{sample}.fastmultigather_rocksdb.csv", sample=SMALL),
        expand("output/{sample}.fastmultigather.csv", sample=SMALL),

rule all:
    input:
        expand("output/{sample}.pygather.csv", sample=SAMPLES),
        expand("output/{sample}.pygather_rocksdb.csv", sample=SAMPLES),
        expand("output/{sample}.fastgather.csv", sample=SAMPLES),
        expand("output/{sample}.fastmultigather_rocksdb.csv", sample=SAMPLES),
        expand("output/{sample}.fastmultigather.csv", sample=SAMPLES),

rule pygather:
    input:
        sig = "{sample}.trim.sig.zip",
        db=DB,
    output:
        "output/{sample}.pygather.csv"
    threads: 64
    benchmark: "benchmarks/pygather.{sample}.txt"
    shell: """
        sourmash gather -k 31 --scaled 1000 {input.sig} {input.db} \
           -o {output}
    """

rule pygather_rocksdb:
    input:
        sig = "{sample}.trim.sig.zip",
        db="output/gtdb-rs214-k31.rocksdb",
    output:
        "output/{sample}.pygather_rocksdb.csv"
    threads: 64
    benchmark: "benchmarks/pygather_rocksdb.{sample}.txt"
    shell: """
        sourmash gather -k 31 --scaled 1000 {input.sig} {input.db} \
           -o {output} --no-prefetch
    """

rule fastgather:
    input:
        sig = "{sample}.trim.sig.zip",
        db=DB,
    output:
        "output/{sample}.fastgather.csv"
    threads: 64
    benchmark: "benchmarks/fastgather.{sample}.txt"
    shell: """
        sourmash scripts fastgather -k 31 -s 1000 {input.sig} {input.db} \
           -c {threads} -o {output}
    """

rule make_rocksdb:
    input:
        db=DB,
    output:
        directory("output/gtdb-rs214-k31.rocksdb"),
    threads: 64
    benchmark:
        "benchmarks/index.rocksdb.txt",
    shell: """
        sourmash scripts index -c {threads} -k 31 -s 1000 {input} -o {output}
    """

rule fastmultigather_rocksdb:
    input:
        sig="{sample}.trim.sig.zip",
        db="output/gtdb-rs214-k31.rocksdb",
    output:
        "output/{sample}.fastmultigather_rocksdb.csv",
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
        prefetch="{sample}.prefetch.csv",
        csv="output/{sample}.fastmultigather.csv",
    threads: 64
    benchmark:
        "benchmarks/fastmultigather.{sample}.txt",
    shell: """
        sourmash scripts fastmultigather {input.sig} {input.db} -k 31 -s 1000 \
           -c {threads} -o {output.csv}
    """
