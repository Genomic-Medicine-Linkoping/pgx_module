## NOTE: setting '.libPaths('/lib/rlib')' specific to singularity used

rule GetClinicalGuidelines:
    """ Given detected variants, get possible Haplotype combinations """
    input:
        found_variants  = "results/Report/detected_variants/{sample}_{seqID}.csv",
    output:
        csv = "results/Report/detected_variants/possible_diploids/{sample}_{seqID}.csv"
    params:
        haplotype_definitions = load_local(config["table_data"]["haplotype_definitions"]),
        clinical_guidelines   = load_local(config["clinical_data"]["clinical_guidelines"]),
        haplotype_activity    = load_local(config["clinical_data"]["haplotype_activity"]),
        hidden_haplotypes     = load_local(config["table_data"]["hidden_haplotypes"]),
        script_location       = config["run_location"]
    log:
        "results/logs/{sample}_{seqID}_getClinicalGuidelines.log"
    singularity:
        config["singularities"]["get_target"]
    shell:
        """
        python3 {params.script_location}/src/Summary/get_possible_diplotypes.py \
            --variant_csv {input.found_variants} \
            --haplotype_definitions {params.haplotype_definitions} \
            --clinical_guidelines {params.clinical_guidelines} \
            --haplotype_activity {params.haplotype_activity} \
            --output {output.csv} \
            --hidden_haplotypes {params.hidden_haplotypes} &> {log}
        """

rule Get_interaction_guidelines:
    """ Given Haplotype Combinations, get possible interactions between these """
    input:
        diploids = "results/Report/detected_variants/possible_diploids/{sample}_{seqID}.csv"
    output:
        csv = "results/Report/detected_variants/possible_interactions/{sample}_{seqID}.csv"
    params:
        script_location = config["run_location"],
        interacting_targets = load_local(config["clinical_data"]["interacting_guidelines"])
    singularity:
        config["singularities"]["get_target"]
    log:
        "results/logs/{sample}_{seqID}_interaction_guidelines.log"
    shell:
        """
        python3 {params.script_location}/src/Summary/get_interaction_guidelines.py \
            --diploids {input.diploids} \
            --interaction_guidelines {params.interacting_targets} \
            --output {output.csv} &> {log}
        """

rule GeneratePGXReport:
    """ Generates markdown report per sample """
    input:
        found_variants  = "results/Report/detected_variants/{sample}_{seqID}.csv",
        missed_variants = "results/Report/coverage/{sample}_{seqID}_depth_at_missing_annotated.gdf",
        diploids        = "results/Report/detected_variants/possible_diploids/{sample}_{seqID}.csv",
        depth_at_baits  = "results/gdf/{sample}_{seqID}.gdf",
        interactions    = "results/Report/detected_variants/possible_interactions/{sample}_{seqID}.csv",
        report_template = "src/Report/generate_sample_report.Rmd"
    output:
        html = "/home/lauri/Desktop/pgx_module/results/Report/{sample}_{seqID}_pgx.html"
    params:
        haplotype_definitions = config["table_data"]["haplotype_definitions"],
        dbsnp = config["dbsnp"],
        ref = config["reference_fasta"],
        name = config["name"],
        adress = config["adress"],
        mail = config["mail"],
        phone = config["phone"],
    singularity:
        config["singularities"]["rmarkdown"]
    log:
        "logs/{sample}_{seqID}_GeneratePGXReport.log"
    shell:
        """
        WKDIR=$(pwd)  # Needed since Rscript will set wd to location of file not session
        INTDIR=$(echo {output.html} | head -c -6)
        DBSNP=$(basename {params.dbsnp})

        Rscript -e "\
        library(rmdformats); \
        rmarkdown::render(\
        input = '{input.report_template}', \
        params = \
        list(\
        title  = 'Farmakogenomisk analys av {wildcards.sample}_{wildcards.seqID}', \
        author = 'ljm', \
        found_variants = '$WKDIR/{input.found_variants}', \
        missed_variants = '$WKDIR/{input.missed_variants}', \
        haplotype_definitions = '$WKDIR/{params.haplotype_definitions}', \
        clinical_guidelines = '$WKDIR/{input.diploids}', \
        interaction_guidelines = '$WKDIR/{input.interactions}', \
        data_location = '$WKDIR/data', \
        depth_file = '$WKDIR/{input.depth_at_baits}', \
        sample = '{wildcards.sample}', \
        seqid = '{wildcards.seqID}', \
        dbsnp = '$DBSNP', \
        ref = '{params.ref}', \
        name = '{params.name}', \
        adress = '{params.adress}', \
        mail = '{params.mail}', \
        phone = '{params.phone}'\
        ), \
        output_file = '{output.html}', \
        intermediates_dir = '$WKDIR/$INTDIR', \
        output_format = c('readthedown'))" &> {log}
        """
