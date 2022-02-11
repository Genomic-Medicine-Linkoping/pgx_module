
rule Haplotypecaller:
    input:
        bam = "results/bam/{sample}_{seqID}-dedup.filtered.bam",
        bai = "results/bam/{sample}_{seqID}-dedup.filtered.bam.bai"
    output:
        vcf = "results/Haplotypecaller/{sample}_{seqID}.vcf"
    params:
        ref   = config["reference_fasta"],
        dbsnp = config["dbsnp"]
    log:
        "logs/{sample}_{seqID}_haplotypecaller.log",
    singularity:
        config["singularities"]["gatk4"]
    threads:
        16
    shell:
         """
        (gatk HaplotypeCaller \
            -R {params.ref} \
            -I {input.bam} \
            --dbsnp {params.dbsnp} \
            -O {output.vcf}) &> {log}
         """