workdir=$(pwd)
scr=$workdir/geneIDs_scripts

## Assessemnt of gene ID ambiguity 
mkdir -p $workdir/hgnc && cd $workdir/hgnc
bash $scr/hgnc.createGeneLists.sh > HGNC.geneLists_report.txt
bash $scr/hgnc.assessAmbiguity.sh > HGNC.VennDiagram_report.txt

mkdir -p $workdir/ncbi && cd $workdir/ncbi
bash $scr/ncbi.createGeneLists.sh > NCBI.geneLists_report.txt
bash $scr/ncbi.assessAmbiguity.sh > NCBI.VennDiagram_report.txt

mkdir -p $workdir/ens && cd $workdir/ens
bash $scr/ens.createGeneLists.sh > Gencode.geneLists_report.txt
bash $scr/ens.assessAmbiguity.sh > Gencode.VennDiagram_report.txt

## Assessment of gene ID cross referencing
hgnc_master=$workdir/hgnc/hgnc_complete_set.txt
ncbi_master=$workdir/ncbi/Homo_sapiens.gene_info.wPrev
gencode_master=$workdir/ens/ens_current_aggSyn_aggPrev_genAnn_dbXrefs.txt
hgnc_his=$workdir/hgnc/withdrawn.txt
ncbi_his=$workdir/ncbi/human_gene_history_track
gencode_his=$workdir/ens/gencode.gene.discontinued
mkdir -p $workdir/crossRef && cd $workdir/crossRef
bash $scr/exploreMasterFiles.sh "$hgnc_master" "$ncbi_master" "$gencode_master" > catalog_explore.txt
bash $scr/crossRef.sh "$hgnc_master" "$ncbi_master" "$gencode_master" "$hgnc_his" "$ncbi_his" "$gencode_his" > crossRef_stats.txt


###################
## pool the output files
mkdir -p $workdir/results/{geneLists_reports,venDiagram_reports,ambiguous_freq,Gene_ambiguity,crossRef_many,crossRef_inconsistent,crossRef_pairwise,crossRef_discontinued}
mkdir -p $workdir/results/DB_issues/{HGNC,GENCODE}
mkdir -p $workdir/results/master_files/{NCBI,GENCODE}

mv $workdir/*/{HGNC,NCBI,Gencode}.geneLists_report.txt $workdir/results/geneLists_reports/.
mv $workdir/*/{HGNC,NCBI,Gencode}.VennDiagram_report.txt $workdir/results/venDiagram_reports/.
mv $workdir/*/{HGNC,NCBI,Gencode}.ambiguous_freq.txt $workdir/results/ambiguous_freq/.
mv $workdir/*/{HGNC,NCBI,Gencode}.ambiguous.tab $workdir/results/Gene_ambiguity/.

mv $workdir/hgnc/PrevSymbols.missing_From_Current $workdir/results/DB_issues/HGNC/.
mv $workdir/ens/ens_current_aggSyn_aggPrev_genAnn_NotinGencode.txt $workdir/results/DB_issues/GENCODE/.
mv $workdir/ens/ens_current_aggSyn_aggPrev_genAnn_unmatchedSym.txt $workdir/results/DB_issues/GENCODE/.
mv $workdir/ens/missing.ids $workdir/results/DB_issues/GENCODE/.

mv $workdir/ncbi/Homo_sapiens.gene_info.wPrev $workdir/results/master_files/NCBI/.
mv $workdir/ncbi/human_gene_history_track $workdir/results/master_files/NCBI/.
mv $workdir/ens/ens_current_aggSyn_aggPrev_genAnn_dbXrefs.txt $workdir/results/master_files/GENCODE/.
mv $workdir/ens/gencode.gene.discontinued $workdir/results/master_files/GENCODE/.

#mv $workdir/crossRef/catalog_explore.txt $workdir/results/.
mv $workdir/crossRef/crossRef_stats.txt $workdir/results/.
mv $workdir/crossRef/*.many_{hgnc,ncbi,genc} $workdir/results/crossRef_many/.
mv $workdir/crossRef/*.dup_{hgnc,ncbi,genc}.table $workdir/results/crossRef_inconsistent/.
mv $workdir/crossRef/*.{difIDs,difSym} $workdir/results/crossRef_pairwise/.
mv $workdir/crossRef/*.discont_{hgnc,ncbi,genc} $workdir/results/crossRef_discontinued/.
