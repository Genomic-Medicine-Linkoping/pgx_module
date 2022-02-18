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

SAMPLES_DIR = VAL_01-40
CPUS = 90

# Singularity bind directories
RESOURCES = /data/ref/
INPUT = /data/TNscope/TNscope_data_extraction/deduped
DATA =  /home/lauri/Desktop/pgx_module
REF = /data/Twist_DNA/hg19


.PHONY: \
start \
report \
results_to_temp \
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

## results_to_temp: Move all results to temp directory for temporary archiving
results_to_temp:
	mkdir -p temp/$(SAMPLES_DIR)
	mv results logs temp/$(SAMPLES_DIR)
	cp Snakefile config.yaml temp/$(SAMPLES_DIR)

## clean: Remove output files
clean:
	rm -rf \
	results \
	logs

## help: Show this message
help:
	@grep '^##' ./Makefile
