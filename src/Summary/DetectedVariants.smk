
rule DetectedVariants:
    """ Get variants with target rsIDs """
    input:
        vcf = "results/Haplotypecaller/filtered/annotated/{sample}_{seqID}.vcf"
    output:
        csv = "results/Report/detected_variants/{sample}_{seqID}.csv"
    params:
        target_bed        = config["table_data"]["target_rsid"],
        hidden_haplotypes = config["table_data"]["hidden_haplotypes"]
    log:
        "logs/{sample}_{seqID}_detectedVariants.log"
    singularity:
        config["singularities"]["get_target"]
    shell:
        """
        python3 src/Summary/get_target_variants.py \
            --target_bed {params.target_bed} \
            --vcf {input.vcf} \
            --output {output.csv} &> {log}
        """