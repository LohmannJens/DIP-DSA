load_dataset_tab <- tabItem(tabName="load_dataset",
  h1("Select an existing dataset or load a custom one"),
  fluidRow(
    box(
      width=12,
      title="Select existing data set",
      "More info about the predefined datasets can be found in the",
      actionLink("link_to_about_tab", "About"),
      "tab.",
      selectInput(
        inputId="strain",
        label="Select a strain:",
        choices=gsub(
          "_",
          "/",
          list.dirs(DATASETSPATH, full.names=FALSE, recursive=FALSE)
        )
      ),
      selectInput(
        inputId="dataset",
        label="Select an existing dataset:",
        choices="Alnaji2019"
      )
    ),
    box(
      width=12,
      title="Select second dataset",
      "Here a second dataset can be chosen to compare them to each other.",
      radioButtons(
        inputId="two_datasets",
        label="Use second dataset:",
        choices=c("No", "Yes"),
        inline=TRUE
      ),
      selectInput(
        inputId="strain2",
        label="Select a strain:",
        choices=gsub(
          "_",
          "/",
          list.dirs(DATASETSPATH, full.names=FALSE, recursive=FALSE)
        )
      ),
      selectInput(
        inputId="dataset2",
        label="Select an existing dataset:",
        choices="Alnaji2019",
      )
    ),
    box(
      width=12,
      title="Upload new dataset",
      selectizeInput(
        inputId="upload_strain",
        label="Select a strain or write a new one:",
        choices=gsub(
          "_",
          "/",
          list.dirs(DATASETSPATH, full.names=FALSE, recursive=FALSE)
        ),
        options=list(create=TRUE)
      ),
      textInput(
        inputId="upload_dataset",
        label="Give the dataset a unique name:"
      ),
      fileInput(
        inputId="upload_dataset_file",
        label="Upload custom dataset here (*.csv):",
        accept=c(".csv")
      ),
      div(style="display:inline-block",
        fileInput(
          inputId="upload_PB2_file",
          label="Upload PB2 sequence as FASTA:"
        )
      ),
      div(style="display:inline-block",
        fileInput(
          inputId="upload_PB1_file",
          label="Upload PB1 sequence as FASTA:"
        )
      ),
      div(style="display:inline-block",
        fileInput(
          inputId="upload_PA_file",
          label="Upload PA sequence as FASTA:"
        )
      ),
      div(style="display:inline-block",
        fileInput(
          inputId="upload_HA_file",
          label="Upload HA sequence as FASTA:"
        )
      ),
      div(style="display:inline-block",
        fileInput(
          inputId="upload_NP_file",
          label="Upload NP sequence as FASTA:"
        )
      ),
      div(style="display:inline-block",
        fileInput(
          inputId="upload_NA_file",
          label="Upload NA sequence as FASTA:"
        )
      ),
      div(style="display:inline-block",
        fileInput(
          inputId="upload_M_file",
          label="Upload M sequence as FASTA:"
        )
      ),
      div(style="display:inline-block",
        fileInput(
          inputId="upload_NS_file",
          label="Upload NS sequence as FASTA:"
        )
      ),
      br(),
      actionButton(
        inputId="dataset_submit",
        label="Upload data"
      )
    )
  )
)
