# Load necessary libraries
library(Gviz)
library(biomaRt)
library(GenomicRanges)

# Define the chromosome and regions of interest
#reza and bristol
chromosome <- "chr7"
start_region <- 8792148
end_region <- 16683217

#rob2 and evelina
start_region <-9124433
end_region <- 13615442     

# Define the regions for S1 and S2
#reza and bristol
s1_start <- 8632603
s1_end <- 16683217
s2_start <- 8792148
s2_end <- 17736574

#rob2 and evelina
s1_start <- 9124433
s1_end <- 13615442
s2_start <- 10129376
s2_end <- 11619685

# Create the Ideogram track
ideoTrack <- IdeogramTrack(genome = "hg19", chromosome = chromosome)

# Create the Genome Axis track
gtrack <- GenomeAxisTrack()

# Create the Annotation tracks for S1 and S2 with correct label sizes
s1Track <- AnnotationTrack(start = s1_start, end = s1_end, chromosome = chromosome, id = "S1", name = "S1", col = "black", fill = "grey", fontsize = 14, cex.title = 0.5)
s2Track <- AnnotationTrack(start = s2_start, end = s2_end, chromosome = chromosome, id = "S2", name = "S2", col = "black", fill = "grey", fontsize = 14, cex.title = 0.5)

# Use biomaRt to fetch gene information
mart <- useMart("ENSEMBL_MART_ENSEMBL", dataset = "hsapiens_gene_ensembl", host = "grch37.ensembl.org")

# Fetch gene information with a focus on different name attributes
genes <- getBM(attributes = c("ensembl_gene_id", "external_gene_name", "hgnc_symbol", "gene_biotype", "chromosome_name", "start_position", "end_position", "strand"),
               filters = c("chromosome_name", "start", "end"),
               values = list(chromosome = gsub("chr", "", chromosome), start = start_region, end = end_region),
               mart = mart)

# Ensure gene symbols are not empty by checking multiple attributes
genes$gene_name <- ifelse(genes$hgnc_symbol != "", genes$hgnc_symbol, 
                          ifelse(genes$external_gene_name != "", genes$external_gene_name,
                                 genes$ensembl_gene_id))

# Ensure the gene data is properly formatted for GeneRegionTrack
granges <- GRanges(seqnames = Rle(paste0("chr", genes$chromosome_name)),
                   ranges = IRanges(start = genes$start_position, end = genes$end_position),
                   strand = Rle(ifelse(genes$strand == 1, "+", "-")),
                   gene = genes$gene_name)

# Check the GRanges object
print(granges)

# Create the Gene Region track with gene names as symbols
geneTrack <- GeneRegionTrack(granges, genome = "hg19", chromosome = chromosome, name = "Genes", 
                             symbol = granges$gene, showId = TRUE, transcriptAnnotation = "symbol", 
                             stacking = "full", col = "black", fill = "orange", fontcolor.exon = "black")

# Plotting the tracks
plotTracks(list(ideoTrack, gtrack, s1Track, s2Track, geneTrack), from = start_region, to = end_region, 
           transcriptAnnotation = "symbol", stacking = "full", geneSymbols = TRUE, showId = TRUE)
