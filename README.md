[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.12157628.svg)](https://doi.org/10.5281/zenodo.12157628)

# Defective Interfering Particle Deletion Site Analyzer (DIP-DSA)

This application allows the user to investigate datasets that include Defective
Interfering Particles. It provides different analyses about the DelVGs of these
particles. It includes the analyses made in our [manuscript](https://doi.org/10.1093/nargab/lqaf031).

## How to set up

As a first step the right R version (3.6.3) and some additional packages need
to be installed. These additional libraries are listed here:

- DT 0.33
- ggplot2 3.5.0
- hash 2.2.6.3
- jsonlite 1.8.8
- plotly 4.10.4
- plyr 1.8.9
- shiny 1.8.1.1
- shinydashboard 0.7.2
- shinyvalidate 0.1.3
- stringr 1.5.1
- dplyr 1.1.4
- Biostrings 2.62.0
- ComplexHeatmap 2.10.0

The libraries can be installed by running the following command from the root
folder:

```
sudo bash setup_script.sh
```

For further support on the installation of specific libraries please use the
original documentation of the corresponding library.

### Running the app

To run the application locally type the following command into the commandline.

```
bash run_DIP-DSA_local.sh
```

It will automatically open the application on http://localhost:8161.

#### Building a docker container

Alternatively a docker container can be built to deploy the application.
The commands for this are given in docker_commands.sh. It builds the container
and runs it locally.

```
bash docker_commands.sh
```

It will automatically open the application on http://localhost:8161.

### Example dataset

When uploading a custom data set the user has to provide the data in a specific
format. It is a csv file with four columns. Correct ordering of the
columns is crucial! For more information about the content see the following
table:

|                 | Column1 | Column2  | Column3 | Column4      |
|-----------------|---------|----------|---------|--------------|
| header names    | Segment                                              | Start                               |End                                | NGS_read_count                                                 |
| column data type| character                                            | integer                             | integer                           | integer                                                        |
| description     | Name of the segment that the DI RNA is comming from  | Start position of the deletion site | End position of the deletion site | Number of counts in the NGS data of the specific DI RNA sample |

