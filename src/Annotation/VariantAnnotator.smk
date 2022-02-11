
rule VariantAnnotator:
    input:
        vcf = "results/Haplotypecaller/filtered/{sample}_{seqID}.vcf",
        bam = "results/bam/{sample}_{seqID}-dedup.filtered.bam"
    output:
        vcf = "results/Haplotypecaller/filtered/annotated/{sample}_{seqID}.vcf",
    params:
        dbsnp = config["dbsnp"],
        ref   = config["reference_fasta"]
    log:
        "logs/{sample}_{seqID}_variantAnnotator.log"
    singularity:
        config["singularities"]["gatk4"]
    shell:
        """
        (gatk VariantAnnotator \
            -R {params.ref} \
            -V {input.vcf} \
            -I {input.bam} \
            -O {output.vcf} \
            --dbsnp {params.dbsnp}) &> {log}
        """