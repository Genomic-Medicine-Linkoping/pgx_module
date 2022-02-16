
configfile: "config.yaml"

## NOTE: Adjust wildcards depending on the sample name
wildcard_constraints:
    sample = "BC",
    seqID = "[0-9]+_T"


include:    "src/Variantcalling/HaplotypeCaller.smk"
include:    "src/Annotation/VariantAnnotator.smk"
include:    "src/Summary/DetectedVariants.smk"
include:    "src/Summary/DepthAtTargets.smk"
include:    "src/Summary/AppendIDtoGDF.smk"
include:    "src/Report/GeneratePGXReport.smk"
include:    "src/Filtering/VariantFiltration.smk"
include:    "src/Filtering/SubsetReadsTarget.smk"

## NOTE: Adjust sample and seqID according to the file names
rule All:
    input:
        expand("/home/lauri/Desktop/pgx_module/results/Report/{sample}_{seqID}_pgx.html",
        sample=["BC"],
        seqID=["1_T","2_T","3_T","4_T","5_T","6_T","7_T","8_T"])
