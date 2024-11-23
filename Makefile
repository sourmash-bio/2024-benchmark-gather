.PHONY: clean clean-all

check:
	snakemake -n

clean:
	rm -fr output/*.csv

clean-all:
	rm -fr output/
