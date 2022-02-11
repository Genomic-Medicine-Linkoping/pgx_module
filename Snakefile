
configfile: "config.yaml"

wildcard_constraints:
    sample = "VAL",
    seqID = "[0-9]+"


include:    "src/Variantcalling/HaplotypeCaller.smk"
include:    "src/Annotation/VariantAnnotator.smk"
include:    "src/Summary/DetectedVariants.smk"
include:    "src/Summary/DepthAtTargets.smk"
include:    "src/Summary/AppendIDtoGDF.smk"
include:    "src/Report/GeneratePGXReport.smk"
include:    "src/Filtering/VariantFiltration.smk"
include:    "src/Filtering/SubsetReadsTarget.smk"


rule All:
    input:
        expand("/home/lauri/Desktop/pgx_module/results/Report/{sample}_{seqID}_pgx.html",sample=["VAL"],seqID=["01","02","09","17"])
