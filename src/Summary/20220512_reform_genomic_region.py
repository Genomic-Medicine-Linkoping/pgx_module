# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from pathlib import Path
import argparse
import pandas as pd

def reform(target_bed: Path, output_f: Path, detected_variants: Path,
           padding: int, file_format: str) -> None:
    """
    Perform padding of bed file

    Parameters
    ----------
    target_bed : Path
        Path to bed file to be padded.
    output_f : Path
        Name of the padded output bed file.
    detected_variants : Path
        Path to a tsv file with detected variants. The table should have an ID
        column.
    padding : int
        The amount of padding for the defined regions in the bed file.
    file_format : str
        The file format to use in the output file. Alternatives are: bed format
        or 'chr{chrom}:{start}-{end}' list.
    Returns
    -------
    None
        DESCRIPTION.

    """
    targets : pd.DataFrame = pd.read_csv(target_bed,
                                         sep="\t",
                                         names=["CHROM", "START", "END", "ID", "GENE"],
                                         dtype={"START": int, "END": int})

    if detected_variants.is_file():
        detected_rsid = pd.read_csv(detected_variants, sep="\t").ID
        targets = targets[~targets.ID.isin(detected_rsid)]

    with open(output_f, "w+", encoding="utf-8") as f:
        for i, row in targets.iterrows():
            chrom, start, end, id = row[0:4]
            if start > end:
                end, start = start, end
            start -= padding
            end += padding
            if file_format == "bed":
                f.write(f"chr{chrom}\t{start}\t{end}\t{id}\n")
            else:
                f.write(f"chr{chrom}:{start}-{end}\n")

def get_args() -> argparse.Namespace:
    """
    Get parsed commandline arguments

    Returns
    -------
    Namespace object parsed from CLI arguments

    """
    parser = argparse.ArgumentParser(
        description="Rewrite bed to chr:start-end list. Removing wt targets or adding padding"
    )
    parser.add_argument("--target_bed", type=Path)
    parser.add_argument("--output_file", type=Path)
    parser.add_argument("--detected_variants", type=Path)
    parser.add_argument("--padding", type=int, default=0)
    parser.add_argument("--format", type=str, default="list")

    return parser.parse_args()


def main():
    """
    Run the main program

    Returns
    -------
    None.

    """
    args = get_args()
    target_bed = args.target_bed
    output_file = args.output_file
    detected_variants = args.detected_variants
    padding = args.padding
    file_format = args.format

    reform(target_bed, output_file, detected_variants, padding, file_format)


if __name__ == '__main__':
    main()
