
rule VariantAnnotator:
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