#!/bin/bash

# Run me in envs folder to get needed singularity containers
# Please adjust paths of simg location in the appropriate config_file


sudo singularity build target_variants_python.simg recipes/get_target_variants
sudo singularity build rmarkdown.simg recipes/Rmarkdown.def
sudo singularity build samtools.simg recipes/samtools
sudo singularity build gatk3.simg docker://broadinstitute/gatk3:3.8-1
sudo singularity build gatk4.simg docker://broadinstitute/gatk:4.2.5.0
