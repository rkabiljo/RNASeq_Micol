gene_cts <- read.table("merged_cellular.txt",row.names=1,header=T)
dim(gene_cts)
#[1] 63246    11
phe <- read.table("pheno.txt",row.names=1,header=T)
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
#check if there are surrogate variables to use as a covariate
library("sva")
dat  <- counts(dds_genes, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ sex + RIN  + status, colData(dds_genes))
mod0 <- model.matrix(~   1, colData(dds_genes))
nsv <- num.sv(dat,mod)
nsv
#there were 0, do nothing
dds_genes <- DESeq(dds_genes)
library(IHW)
resIHW <- results(dds_genes, filterFun=ihw)
resIHWOrdered <- resIHW[order(resIHW$pvalue),]
sum(resIHW$padj < 0.05, na.rm=TRUE)
write.table(resIHWOrdered,"fixedSex_res_cases_controls.txt",sep="\t")



