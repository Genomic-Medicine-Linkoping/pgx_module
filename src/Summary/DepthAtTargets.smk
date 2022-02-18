
rule SampleTargetList:
    input:
        detected_variants = "results/Report/detected_variants/{sample}_{seqID}.csv",
    output:
        interval = "results/Report/coverage/{sample}_{seqID}_target_interval.list"
    params:
        target_bed = config["table_data"]["target_rsid"]
    log:
        "logs/{sample}_{seqID}_sampleTargetList.log"
    singularity:
        config["singularities"]["get_target"]
    shell:
        """
        python3 src/Summary/reform_genomic_region.py \
            --target_bed={params.target_bed} \
            --output_file={output.interval} \
            --detected_variants={input.detected_variants} &> {log}
        """


rule DepthOfTargets:
    """ Get read depth of variant locations at wildtrype-called positions """
    input:
        bam      = "results/bam/{sample}_{seqID}-dedup.filtered.bam",
        interval = "results/Report/coverage/{sample}_{seqID}_target_interval.list"
    output:
        gdf      = "results/Report/coverage/{sample}_{seqID}_depth_at_missing.gdf",
    params:
        ref        = config["reference_fasta"],
        target_bed = config["table_data"]["target_rsid"]
    log:
        "logs/{sample}_{seqID}_depthOfTargets.log"
    singularity:
        config["singularities"]["gatk3"]
    shell:
        """
        (java -jar /usr/GenomeAnalysisTK.jar \
        -T DepthOfCoverage \
        -R {params.ref} \
        -I {input.bam} \
        -o {output.gdf} \
        -L {input.interval}) &> {log}
        """


rule GetPaddedBaits:
    output:
        interval = "results/gdf/padded_bait_interval.list"
    params:
        padding = 100,
        target_bed = config["table_data"]["target_regions"]
    log:
        "logs/getPaddedBaits.log"
    singularity:
        config["singularities"]["get_target"]
    shell:
        """
        python3 src/Summary/reform_genomic_region.py \
            --target_bed={params.target_bed} \
            --output_file={output.interval} \
            --padding={params.padding} &> {log}
        """


rule DepthOfBaits:
    """ Get read depth of baits """
    input:
        bam = "results/bam/{sample}_{seqID}-dedup.filtered.bam",
        interval = "results/gdf/padded_bait_interval.list"
    output:
        gdf = "results/gdf/{sample}_{seqID}.gdf",
    params:
        ref = config["reference_fasta"],
        target_bed = config["table_data"]["target_regions"],
        padding = 100
    log:
        "logs/{sample}_{seqID}_depthOfBaits.log"
    singularity:
        config["singularities"]["gatk3"]
    shell:
        """
        # NOTE: does not work with openjdk-11, openjdk-8 works
        (java -jar /usr/GenomeAnalysisTK.jar \
        -T DepthOfCoverage \
        -R {params.ref} \
        -I {input.bam} \
        -o {output.gdf} \
        -L {input.interval}) &> {log}
        """