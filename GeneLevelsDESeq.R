gene_cts <- read.table("merged_cellular.txt",row.names=1,header=T)
dim(gene_cts)
#[1] 63246    11
phe <- read.table("pheno.txt",row.names=1,header=T)
phe
phe<-phe[colnames(gene_cts),]
phe
phe$status<-as.factor(phe$status)
phe$sex<-as.factor(phe$sex)
library("magrittr")
phe$status %<>% relevel("0")
dds_genes <- DESeqDataSetFromMatrix(countData = gene_cts, colData = phe, design = ~  sex + RIN  + status)
dds_genes
dds_genes <- estimateSizeFactors(dds_genes)
dds_genes_backup<-dds_genes
idx <- rowSums( counts(dds_genes, normalized=T) >= 50 ) >= 5
dds_genes <- dds_genes[idx,]
dds_genes
counts(dds_genes)['ENSG00000189043',]
counts(dds_genes,normalized=TRUE)['ENSG00000189043',]
library("sva")
dat  <- counts(dds_genes, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ sex + RIN  + status, colData(dds_genes))
mod0 <- model.matrix(~   1, colData(dds_genes))
nsv <- num.sv(dat,mod)
nsv
dds_genes <- DESeq(dds_genes)
library(IHW)
resIHW <- results(dds_genes, filterFun=ihw)
resIHWOrdered <- resIHW[order(resIHW$pvalue),]
sum(resIHW$padj < 0.05, na.rm=TRUE)
library(ggplot2)
rld <- rlog(dds_genes, blind = TRUE)
#colour by status
pcaData <- plotPCA(rld, intgroup = "status", returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
ggplot(pcaData, aes(PC1, PC2, color = status)) +
geom_point(size = 3) +
xlab(paste0("PC1: ", percentVar[1], "% variance")) +
ylab(paste0("PC2: ", percentVar[2], "% variance")) +
coord_fixed() +
theme_minimal()
#colour by sex
pcaData <- plotPCA(rld, intgroup = "sex", returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
ggplot(pcaData, aes(PC1, PC2, color = sex)) +
geom_point(size = 3) +
xlab(paste0("PC1: ", percentVar[1], "% variance")) +
ylab(paste0("PC2: ", percentVar[2], "% variance")) +
coord_fixed() +
theme_minimal()
#collour by variant
pcaData <- plotPCA(rld, intgroup = "variant", returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
ggplot(pcaData, aes(PC1, PC2, color = variant)) +
geom_point(size = 3) +
xlab(paste0("PC1: ", percentVar[1], "% variance")) +
ylab(paste0("PC2: ", percentVar[2], "% variance")) +
coord_fixed() +
theme_minimal()
gene_of_interest <- "ENSG00000189043"
# Extract normalized counts
normalized_counts <- counts(dds_genes, normalized = TRUE)
gene_counts <- normalized_counts[gene_of_interest, ]
# Convert to a data frame for ggplot
df <- as.data.frame(colData(dds_genes))
df$counts <- gene_counts
# Plot expression levels
ggplot(df, aes(x = status, y = counts)) +
geom_boxplot() +
geom_jitter(width = 0.2, aes(color = status)) +
xlab("Status") +
ylab("Normalized counts") +
ggtitle(paste("Expression of", gene_of_interest)) +
theme_minimal()
gene_of_interest <- "ENSG00000185633"
# Extract normalized counts
normalized_counts <- counts(dds_genes, normalized = TRUE)
gene_counts <- normalized_counts[gene_of_interest, ]
# Convert to a data frame for ggplot
df <- as.data.frame(colData(dds_genes))
df$counts <- gene_counts
# Plot expression levels
ggplot(df, aes(x = status, y = counts)) +
geom_boxplot() +
geom_jitter(width = 0.2, aes(color = status)) +
xlab("Status") +
ylab("Normalized counts") +
ggtitle(paste("Expression of", gene_of_interest)) +
theme_minimal()
normalized_counts <- counts(dds, normalized = TRUE)
# plot with sample names
normalized_counts <- counts(dds_genes, normalized = TRUE)
gene_counts <- normalized_counts[gene_of_interest, ]
# Convert to a data frame for ggplot
df <- as.data.frame(colData(dds_genes))
df$sample <- rownames(colData(dds_genes))
df$counts <- gene_counts
ggplot(df, aes(x = condition, y = counts)) +
geom_boxplot() +
geom_jitter(width = 0.2, aes(color = condition)) +
geom_text(aes(label = sample), vjust = -0.5, hjust = 0.5, size = 3) +  # Add sample names
xlab("Condition") +
ylab("Normalized counts") +
ggtitle(paste("Expression of transcript", gene_of_interest)) +
theme_minimal()
ggplot(df, aes(x = condition, y = counts)) +
geom_boxplot() +
geom_jitter(width = 0.2, aes(color = status)) +
geom_text(aes(label = sample), vjust = -0.5, hjust = 0.5, size = 3) +  # Add sample names
xlab("Condition") +
ylab("Normalized counts") +
ggtitle(paste("Expression of transcript", gene_of_interest)) +
theme_minimal()
ggplot(df, aes(x = status, y = counts)) +
geom_boxplot() +
geom_jitter(width = 0.2, aes(color = status)) +
geom_text(aes(label = sample), vjust = -0.5, hjust = 0.5, size = 3) +  # Add sample names
xlab("Condition") +
ylab("Normalized counts") +
ggtitle(paste("Expression of transcript", gene_of_interest)) +
theme_minimal()
#check for one gene
resIHWOrdered["ENSG00000189043",]
#check for one gene
resIHWOrdered["ENSG00000185633",]
de_genes <- rownames(resIHW)[which(resIHW$padj < 0.05)]  # Assuming you're using adjusted p-values for cutoff
dds_de_genes <- dds_genes[de_genes,]
# Transform the counts
rld_de_genes <- rlog(dds_de_genes, blind = TRUE)
# PCA plot using only DEGs
pcaData_de_genes <- plotPCA(rld_de_genes, intgroup = "status", returnData = TRUE)
percentVar_de_genes <- round(100 * attr(pcaData_de_genes, "percentVar"))
ggplot(pcaData_de_genes, aes(PC1, PC2, color = status)) +
geom_point(size = 3) +
xlab(paste0("PC1: ", percentVar_de_genes[1], "% variance")) +
ylab(paste0("PC2: ", percentVar_de_genes[2], "% variance")) +
coord_fixed() +
theme_minimal()
write.table(resIHWOrdered,"fixedSex_res_cases_controls.txt",sep="\t")
resIHWOrdered[mitoGenes,]
mitoRes<-resIHWOrdered[mitoGenes,]
write.table(mitoRes,sep="\t",file="mitoRes.txt")
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

