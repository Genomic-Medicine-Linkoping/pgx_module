
rule AppendIDtoGDF:
    """ Add variant id to appropriate location in gdf """
    input:
        gdf = "results/Report/coverage/{sample}_{seqID}_depth_at_missing.gdf"
    output:
        gdf = "results/Report/coverage/{sample}_{seqID}_depth_at_missing_annotated.gdf"
    params:
        target_bed = config["table_data"]["target_rsid"]
    log:
        "logs/{sample}_{seqID}_appendIDtoGDF.log"
    singularity:
        config["singularities"]["get_target"]
    shell:
         """
         python3 {params.script_location}/src/Summary/append_rsid_to_gdf.py \
            --input_gdf={input.gdf} \
            --target_bed={params.target_bed} \
            --output_file={output.gdf} &> {log}
         """