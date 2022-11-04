
# The to_tsv.py script was created as part of University of Hull's 2nd year Genetic Analysis Module (500697)
# This script is employed to analyse a small test dataset during the module's Bioinformatics Practical
# A practical designed specifically to familiarise students with the Unix command line and data analysis of ONT MinION Flongle data

# Author: Dr Graham S Sellers
# For use in Python 3.7+

# A simple python script to produce a more human-readable .tsv output file from a Kraken 2 report file
# It has limited functionality when used outside the context of the practical

import argparse

parser = argparse.ArgumentParser(description = 'Simplified taxonomy assignment output from Kraken 2 report files')
parser.add_argument('-i', '--input_file', type = str, dest = 'input', help = 'input Kraken 2 report file', required = True)
parser.add_argument('-o', '--output_file', type = str, dest = 'output', help = 'output file name', required = True)
args = parser.parse_args()

rank_reads = {'S': [], 'G': [], 'F': [], 'O': []}
ranks = {'S': 'species', 'G': 'genus', 'F': 'family', 'O': 'order'}
assigned_reads = []
total_reads = []

sample = args.input
# sample = 'data/barcode01.txt'
samplie_id = sample.split('/')[-1].split('.')[0]

with open(sample, 'r') as infile:
    for line in infile:
        tax = line.split('\t')
        otu = tax[5].strip().replace(' ', '_')
        reads = int(tax[2].strip())
        total_reads.append(reads)
        rank = tax[3].strip()
        if rank in ranks.keys() and reads > 0:
            assigned_reads.append(reads)
            rank_reads[rank].append('%s\t%s\t%s' %(otu, reads, ranks[rank]))

unassigned_reads = sum(total_reads) - sum(assigned_reads)

otus = ['OTU\t%s\ttaxonomic_rank' % samplie_id]
for i in rank_reads.keys():
    for x in rank_reads[i]:
        otus.append(x)

otus.append('unassigned\t%s\tunassigned' % unassigned_reads)

with open(args.output, 'w') as outfile:
    outfile.write('\n'.join(otus))


