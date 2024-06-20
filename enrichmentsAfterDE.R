dbs
sig <- convert_ensembl_to_entrez(rownames(resIHW[resIHW$padj < 0.05,]))
dim(sig)
enrichment_result <- enrichr(sig$external_gene_name, dbs)
plotEnrich(enrichment_result[[1]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[2]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[3]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[4]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[5]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
printEnrich(
enrichment_result,
prefix = "enrichrR_0_05_bothDirections",
showTerms = NULL,
columns = c(1:9),
write2file = TRUE,
outFile = c("txt", "excel")
)
sig <- convert_ensembl_to_entrez(rownames(resIHW[resIHW$padj < 0.05 & resIHW$log2FoldChange < 0,]))
dim(sig)
enrichment_result <- enrichr(sig$external_gene_name, dbs)
plotEnrich(enrichment_result[[1]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[2]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[3]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[4]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[5]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
printEnrich(
enrichment_result,
prefix = "enrichrR_0_05_Downregulated",
showTerms = NULL,
columns = c(1:9),
write2file = TRUE,
outFile = c("txt", "excel")
)
sig <- convert_ensembl_to_entrez(rownames(resIHW[resIHW$padj < 0.05 & resIHW$log2FoldChange > 0,]))
dim(sig)
plotEnrich(enrichment_result[[1]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[2]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[3]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[4]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[5]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
enrichment_result <- enrichr(sig$external_gene_name, dbs)
plotEnrich(enrichment_result[[1]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[2]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[3]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[4]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
plotEnrich(enrichment_result[[5]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
printEnrich(
enrichment_result,
prefix = "enrichrR_0_05_Upregulated",
showTerms = NULL,
columns = c(1:9),
write2file = TRUE,
outFile = c("txt", "excel")
)
savehistory("~/RNASeq/DEGenesWithMicol.Rhistory")
