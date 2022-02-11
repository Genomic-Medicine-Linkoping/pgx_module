
rule Haplotypecaller:
    params:
        ref   = config["reference_fasta"],
        dbsnp = config["dbsnp"]
    log:
        "logs/{sample}_{seqID}_haplotypecaller.log",
    singularity:
        config["singularities"]["gatk4"]
    shell:
         """
        (gatk HaplotypeCaller \
            -R {params.ref} \
            -I {input.bam} \
            --dbsnp {params.dbsnp} \
            -O {output.vcf}) &> {log}
         """