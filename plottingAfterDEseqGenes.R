
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

resIHWOrdered[mitoGenes,]
mitoRes<-resIHWOrdered[mitoGenes,]
write.table(mitoRes,sep="\t",file="mitoRes.txt")
