# Outpacing the Lanes: Toronto's Bike Share Ridership Surges Ahead of Infrastructure Growth

## Overview of Paper
This paper explores the relationship between Toronto’s rapidly growing Bike Share ridership and the city's development of cycling infrastructure from 2017 to 2023. Using open data from Toronto’s Bike Share program and the Cycling Network Plan, the analysis highlights the significant growth in ridership, outpacing the expansion of bikeways. The paper argues for the need to accelerate the city’s cycling infrastructure development to keep up with the increasing demand and ensure safe and efficient cycling options for residents.

## File Structure
The repository is structured as follows:
- `data/raw_data`: Due to the raw Bake Share Ridership being too large to upload, follow the "Reproducing Graphs and Tables" instruction below
- `data/analysis_data`: Contains the cleaned and processed dataset that forms the basis of the analysis.
- `paper`: Contains the Quarto document, references, and the final PDF of the paper.
- `scripts`: Contains R scripts used for data downloading, cleaning, simulating, and testing

## Reproducing Graphs and Tables
To reproduce the graphs and tables from the paper, follow these steps:
1. Clone the repository to your local machine.
2. Go to `scripts/` and run `01-download_data.R`.
  - Note: The November 2022 Bike Share Ridership data is not automatically downloaded by the script due to a file format limitation. Follow these steps manually after running the script:
    1. Go to Bike Share Toronto Ridership Data in Open Data Toronto Portal [Link](https://open.toronto.ca/dataset/bike-share-toronto-ridership-data/)
    2. Download the bikeshare-ridership-2022.zip file.
    3. Unzip the file and then unzip Bike share ridership 2022-11.zip.
    4. Import the file Bike share ridership 2022-11.csv into the raw_data/raw_bikeshare_data/ folder.
4. Go to `scripts/` and run `01-data_cleaning.R`: Cleans and standardizes the raw Bike Share ridership and Bikeway data
7. Open the Quarto document in `paper/paper.qmd` and render the PDF file.

## Statement on LLM usage
Large Language Models such as GPT-4o were used to assist in parts of the data analysis and writing process. The chat logs are saved in the inputs/llms folder for full transparency.
