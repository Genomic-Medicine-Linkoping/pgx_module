
rule GetPaddedBed:
    output:
        interval = "results/bam/padded_bait_interval.bed"
    params:
        padding= 100,
        target_bed = config["table_data"]["target_regions"]
    log:
        "logs/getPaddedBed.log"
    singularity:
        config["singularities"]["get_target"]
    shell:
        """
        python3 {params.script_location}/src/Summary/reform_genomic_region.py \
            --target_bed={params.target_bed} \
            --output_file={output.interval} \
            --padding={params.padding} \
            --format='bed' &> {log}
        """


rule Subset_pharmacogenomic_reads:
    """ Subset analysis ready bam to only regions relevant"""
    input:
        bam   = config["bam_location"],
        index = f'{config["bam_location"]}.bai',
        region_list = "results/bam/padded_bait_interval.bed"
    output:
        bam = "results/bam/{sample}_{seqID}-dedup.filtered.bam",
        bai = "results/bam/{sample}_{seqID}-dedup.filtered.bam.bai"
    log:
        "logs/{sample}_{seqID}_subset_pharmacogenomic_reads.log"
    singularity:
        config["singularities"]["samtools"]
    shell:
        """
        (samtools view -b {input.bam} -L {input.region_list} > {output.bam}) &> {log}
        samtools index {output.bam} &>> {log}
        """
