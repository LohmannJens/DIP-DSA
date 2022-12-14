motif_search_tab <- tabItem(tabName="motif_search",
  h1("Motif search"),
  fluidRow(
    box(
      title="Input motif",
      width=12,
      textInput(
        inputId="motif",
        label="Type a motif to search for:"
      ),
    ),
    box(
      title="Motif matches on sequence",
      width=12,
      "Showing the matches to the motif on the full length sequence. The",
      "matches are only shown if there are less than 100. Otherwise the",
      "rendering of the plot takes too long and is too crowded.",
      plotlyOutput("motif_on_sequence")
    ),
    box(
      title="Details of all matches",
      width=12,
      "Listing all matches of the motif on the sequence as a table",
      dataTableOutput("motif_table")
    ),
  )
)
