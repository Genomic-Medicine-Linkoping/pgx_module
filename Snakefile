
configfile: "config.yaml"

## NOTE: Adjust the base name for all samples
# sample_pattern = "LI-VAL"
sample_pattern = "HD832"

## NOTE: Adjust wildcards depending on the sample name
wildcard_constraints:
    sample = sample_pattern,
    seqID = "T"


include:    "src/Variantcalling/HaplotypeCaller.smk"
include:    "src/Annotation/VariantAnnotator.smk"
include:    "src/Summary/DetectedVariants.smk"
include:    "src/Summary/DepthAtTargets.smk"
include:    "src/Summary/AppendIDtoGDF.smk"
include:    "src/Report/GeneratePGXReport.smk"
include:    "src/Filtering/VariantFiltration.smk"
include:    "src/Filtering/SubsetReadsTarget.smk"

## NOTE: Adjust seqIDs according to the file names
rule All:
    input:
        expand("/home/lauri/Desktop/pgx_module/results/Report/{sample}_{seqID}_pgx.html",
        sample=[sample_pattern],
        seqID=["T"])
        # expand("/home/lauri/Desktop/pgx_module/results/Report/{sample}_{seqID}_pgx.html",
