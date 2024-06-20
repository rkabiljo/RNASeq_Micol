# Load necessary libraries
library(data.table)
library(Gviz)

# Read the filtered ROH data
roh_data <- fread("ROH.txt")

# Name the columns appropriately
colnames(roh_data) <- c("FID", "IID", "PHE", "CHR", "SNP1", "SNP2", "POS1", "POS2", "KB", "NSNP", "DENSITY", "PHOM", "PHET")

# Filter data for chromosome 7
roh_chr7 <- roh_data[roh_data$CHR == 7,]

# Split the data for the two individuals
subject1_data <- roh_chr7[roh_chr7$IID == "208250180153_R04C01",]
subject2_data <- roh_chr7[roh_chr7$IID == "208250180153_R05C01",]

# Create an empty data.table to store overlapping regions
overlapping_regions <- data.table()

# Function to check for overlapping regions
check_overlap <- function(pos1_start, pos1_end, pos2_start, pos2_end) {
  return(pos1_start <= pos2_end & pos2_start <= pos1_end)
}

# Loop through each pair of segments and check for overlap
for (i in 1:nrow(subject1_data)) {
  for (j in 1:nrow(subject2_data)) {
    if (check_overlap(subject1_data$POS1[i], subject1_data$POS2[i], subject2_data$POS1[j], subject2_data$POS2[j])) {
      overlapping_regions <- rbind(overlapping_regions, data.table(
        FID1 = subject1_data$FID[i],
        IID1 = subject1_data$IID[i],
        POS1_start = subject1_data$POS1[i],
        POS1_end = subject1_data$POS2[i],
        FID2 = subject2_data$FID[j],
        IID2 = subject2_data$IID[j],
        POS2_start = subject2_data$POS1[j],
        POS2_end = subject2_data$POS2[j]
      ))
    }
  }
}

print(overlapping_regions)
