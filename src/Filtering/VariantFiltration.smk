
rule VariantFiltration:
    params:
        DP = 100,
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
