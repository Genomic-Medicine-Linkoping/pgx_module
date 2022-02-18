.ONESHELL:
SHELL = /bin/bash
.SHELLFLAGS := -e -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# The conda env definition file "requirements.yml" is located in the project's root directory
CURRENT_CONDA_ENV_NAME = pgx_module
CONDA_ACTIVATE = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate $(CURRENT_CONDA_ENV_NAME)

# ARGS = --forceall
ARGS = --rerun-incomplete 
# ARGS = --dry-run
# ARGS = --forceall --rerun-incomplete

CONFIG = /data/pgx_module/results/LI_VAL_1-2-9-17/config.yaml
OUT_DIR = /data/pgx_module/results
SEQ_ID = LI_VAL_1-2-9-17
CPUS = 90

# Singularity bind directories
RESOURCES = /data/ref/
INPUT = /data/TNscope/TNscope_data_extraction/deduped
DATA =  /home/lauri/Desktop/pgx_module
REF = /data/Twist_DNA/hg19


.PHONY: \
start \
report \
clean \
help \
test


## start: Run the pipeline
start:
	$(CONDA_ACTIVATE)
	snakemake \
	--printshellcmds \
    --reason \
	--configfile config.yaml \
	--use-singularity \
	--singularity-args "--bind ${RESOURCES} --bind ${INPUT} --bind ${DATA} --bind ${REF}" \
	--cores $(CPUS) \
	$(ARGS)

## report: Make snakemake report
report:
	$(CONDA_ACTIVATE)
	snakemake -j 1 --report $(REPORT) -s Snakefile

## clean: Remove output files
clean:
	rm -rf \
	results \
	logs

## help: Show this message
help:
	@grep '^##' ./Makefile
