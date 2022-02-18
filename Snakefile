
configfile: "config.yaml"

## NOTE: Adjust wildcards depending on the sample name
wildcard_constraints:
    sample = "LI-VAL",
    seqID = "[0-9]+"


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
        sample=["LI-VAL"],
        seqID=["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40"])
