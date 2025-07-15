
> colnames(txiTranscripts$counts)
 [1] "BRISTOL_S3" "C1_S7"      "C2_S8"      "C5_S9"      "EVELINA_S6" "FRANCE_S5"  "LB_S10"    
 [8] "ROB1_S1"    "ROB2_S2"    "SIA7_S11"   "TURKEY_S4" 
> rownames(samps)
 [1] "BRISTOL" "C1"      "C2"      "C5"      "EVELINA" "FRANCE"  "LB"      "ROB1"    "ROB2"   
[10] "SIA7"    "TURKEY" 
 sampleTable<-data.frame(
 row.names=colnames(txiTranscripts$counts),
 condition=samps$condition
 )
 dds<-DESeqDataSetFromTximport(txiTranscripts,colData = sampleTable,design = ~condition)
using just counts from tximport
 dds
class: DESeqDataSet 
dim: 252048 11 
metadata(1): version
assays(1): counts
rownames(252048): ENST00000456328.2 ENST00000450305.2 ... ENST00000387460.2
 dds<-estimateSizeFactors(dds)
> idx <- rowSums( counts(dds, normalized=T) >= 10 ) >= 5
> dds <- dds[idx,]
> dds
class: DESeqDataSet 
dim: 79333 11 
dds<-DESeq(dds)
resIHW <- results(dds, filterFun=ihw)
> 
> resIHWOrdered <- resIHW[order(resIHW$pvalue),]
> sum(resIHW$padj < 0.05, na.rm=TRUE)
[1] 280
 NDUFA4transcripts<-tx2gene[tx2gene$GENEID=="ENSG00000189043.10",]
> resIHWOrdered[NDUFA4transcripts$TXNAME,]

to plot each transcript level
> NDUFA4transcripts$TXNAME
[1] "ENST00000339600.6" "ENST00000482299.1" "ENST00000470761.5" "ENST00000486007.1"
[5] "ENST00000463308.1" "ENST00000492822.1"
> gene_of_interest<-NDUFA4transcripts$TXNAME[2]
> normalized_counts <- counts(dds, normalized = TRUE)
> gene_counts <- normalized_counts[gene_of_interest, ]
> # Convert to a data frame for ggplot
> df <- as.data.frame(colData(dds))
> df$counts <- gene_counts
> # Plot expression levels
> ggplot(df, aes(x = condition, y = counts)) +
+   geom_boxplot() +
+   geom_jitter(width = 0.2, aes(color = condition)) +
+   xlab("Condition") +
+   ylab("Normalized counts") +
+   ggtitle(paste("Expression of transcript", gene_of_interest)) +
+   theme_minimal()

savehistory("~/RNASeq/quant/drim_seq.Rhistory")
