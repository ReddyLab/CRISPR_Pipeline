
process mappingHashing {
   
    cache 'lenient'
    debug true

    input:
    each batch_fastq
    path hashing_index
    path t2g_hashing
    path parsed_seqSpec_file
    path barcode_file

    output:
    path "*_ks_hashing_out", emit: ks_hashing_out_dir
    path "*_ks_hashing_out/counts_unfiltered/adata.h5ad", emit: ks_hashing_out_adata

    script:
        batch = batch_fastq[0]
        fastq_files = batch_fastq[1]
        """
        echo "Processing $batch with $fastq_files"

        k_bin=\$(type -p kallisto)
        bustools_bin=\$(type -p bustools)
        chemistry=\$(extract_parsed_seqspec.py --file ${parsed_seqSpec_file})

        kb count -i ${hashing_index} -g ${t2g_hashing} --verbose -w ${barcode_file} \\
                --h5ad --kallisto \$k_bin  --bustools \$bustools_bin -x \$chemistry -o ${batch}_ks_hashing_out -t ${task.cpus} \\
                ${fastq_files} --overwrite 

        echo "Hash KB mapping Complete"
        """
}
