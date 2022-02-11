
rule VariantFiltration:
    input:
        vcf = "results/Haplotypecaller/{sample}_{seqID}.vcf"
    output:
        filtered_vcf = "results/Haplotypecaller/filtered/{sample}_{seqID}.vcf"
    params:
        DP = 100,
        read_ratio = 0.2
    log:
        "logs/{sample}_{seqID}_variantFiltration.log"
    singularity:
        config["singularities"]["get_target"]
    shell:
        """
        python3 {params.script_location}/src/Filtering/variant_filtration.py \
            --input_vcf={input.vcf} \
            --read_ratio={params.read_ratio} \
            --depth={params.DP} \
            --output_file={output.filtered_vcf} &> {log}
        """
