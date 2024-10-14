# Install required packages if not already installed
if (!requireNamespace("git2r", quietly = TRUE)) {
  install.packages("git2r")
}
if (!requireNamespace("XML", quietly = TRUE)) {
  install.packages("XML")
}
if (!requireNamespace("reutils", quietly = TRUE)) {
  install.packages("reutils")
}

# Load necessary libraries
library(git2r)
library(XML)
library(reutils)

# Define the repository URL and your desired local path
repo_url <- "https://github.com/christopherBelter/pubmedXML.git"
local_path <- "/cloud/home/r1816512/cervical-cancer-multiomics-study/pubmedXML"

# Clone the repository
clone(repo_url, local_path)

# Create a symbolic link for pubmedXML.R
system("ln -s /cloud/home/r1816512/cervical-cancer-multiomics-study/pubmedXML/pubmedXML.R /cloud/home/r1816512/cervical-cancer-multiomics-study/scripts/pubmedXML.R")

# Set the working directory to your project directory
setwd("/cloud/home/r1816512/cervical-cancer-multiomics-study")

# Source the pubmedXML.R script
source("scripts/pubmedXML.R")

# Define your specific PubMed query string
myQuery <- '("cervical cancer"[Title/Abstract] OR "cervical carcinoma"[Title/Abstract] OR "cervical squamous cell carcinoma"[Title/Abstract] OR "CESC"[Title/Abstract] OR "cervical adenocarcinoma"[Title/Abstract]) AND ("genomic"[Title/Abstract] OR "genomics"[Title/Abstract] OR "transcriptomic"[Title/Abstract] OR "transcriptomics"[Title/Abstract] OR "RNA-Seq"[Title/Abstract] OR "gene expression"[Title/Abstract]) AND ("TCGA"[Title/Abstract] OR "TCGA-CESC"[Title/Abstract] OR "GTEx"[Title/Abstract] OR "GEO"[Title/Abstract]) AND ("bioinformatic"[Title/Abstract] OR "bioinformatics"[Title/Abstract]) AND (2012:2024[pdat])'

# Run the PubMed search using the query string
pmids <- esearch(myQuery, db = "pubmed", usehistory = TRUE)

# Fetch the full records in XML format
rawXML <- efetch(pmids, retmode = "xml", outfile = "raw_results.xml")
class(rawXML) 

# Extract values from the raw XML file into a data frame using the extract_xml function
theData <- extract_xml("raw_results.xml")
str(theData)

# Save the extracted data for further analysis or review
write.csv(theData, "results/pubmed_search_results.csv", row.names = FALSE)

# Display the extracted data
str(theData)
