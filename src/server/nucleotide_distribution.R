library(hash)

counting_routine <- function(l, window, letter, ngs_read_count) {
  count_indices <- unlist(gregexpr(letter, window))
  if (count_indices[1] != -1){
    for (i in count_indices) {
      l[[i]] <- l[[i]] + ngs_read_count
    }
  }
  return (l)
}

count_nuc_dist <- function(seq, positions, ngs_read_counts) {
  A <- integer(10)
  C <- integer(10)
  G <- integer(10)
  U <- integer(10)
  for (i in 1:length(positions)) {
    p <- positions[[i]]
    ngs_read_count <- ngs_read_counts[[i]]
    window <- subseq(seq, start=p-4, end=p+5)
    A <- counting_routine(A, window, "A", ngs_read_count)
    C <- counting_routine(C, window, "C", ngs_read_count)
    G <- counting_routine(G, window, "G", ngs_read_count)
    U <- counting_routine(U, window, "U", ngs_read_count)
  }
  rel_occurrence <- c(A, C, G, U) / sum(ngs_read_counts)
  position <- c(rep(seq(1, 10), 4))
  nucleotide <- c(rep("A", 10), rep("C", 10), rep("G", 10), rep("U", 10))
  return(data.frame(rel_occurrence, position, nucleotide))
}

create_sampling_data <- function(pos, n_samples, sequence) {
  start <- floor(quantile(pos, probs=seq(0, 1, 1/10))[[2]])
  end <- floor(quantile(pos, probs=seq(0, 1, 1/10))[[10]])
  random_positions <- floor(runif(n_samples, min=start, max=end+1))
  random_counts <- rep(1, n_samples)
  count_nuc_dist(sequence, random_positions, random_counts)
}

create_nuc_dist_data <- function(df, strain, segment, flattened) {
  # load observed data
  df <- df[df$Segment == segment,]
  positions <- df[, "Start"]
  ngs_read_counts <- df[, "NGS_read_count"]
  if (flattened == "flattened") {
    ngs_read_counts[ngs_read_counts != 1] <- 1
  }
 
  # load sequence
  sequence <- get_seq(strain, segment)

  # count nuc dist around deletion site
  start_df <- count_nuc_dist(sequence, df[, "Start"], ngs_read_counts)
  start_df["location"] <- rep("Start", nrow(start_df))
  end_df <- count_nuc_dist(sequence, df[, "End"], ngs_read_counts)
  end_df["location"] <- rep("End", nrow(end_df))

  count_df <- rbind(start_df, end_df)
  count_df["group"] <- rep("observed", nrow(count_df))
 
  # create sampling data
  n_samples <- nrow(df) * 5
  sampling_start_df <- create_sampling_data(df[, "Start"], n_samples, sequence)
  sampling_end_df <- create_sampling_data(df[, "End"], n_samples, sequence)
  sampling_start_df["location"] <- rep("Start", nrow(sampling_start_df))
  sampling_end_df["location"] <- rep("End", nrow(sampling_end_df))
  sampling_df <- rbind(sampling_start_df, sampling_end_df)
  sampling_df["group"] <- rep("expected", nrow(sampling_df))
 
  final_df <- rbind(count_df, sampling_df)
  # save as .csv file
  path <- file.path(TEMPPATH, "temp.csv")
  write.csv(final_df, path)
}

create_nuc_dist_plot <- function(pos, nuc) {
  # load df from .csv file
  path <- file.path(TEMPPATH, "temp.csv")
  df <- read.csv(path)

  df <- df[df$location == pos,]
  df <- df[df$nucleotide == nuc,]

  color <- hash()
  color[["A"]] <- "blue"
  color[["C"]] <- "green"
  color[["G"]] <- "yellow"
  color[["U"]] <- "red"

  # create a barplot
  ggplot(data=df, aes(x=position, y=rel_occurrence, fill=nucleotide, alpha=group)) +
    geom_bar(stat="identity", fill=color[[nuc]], color="black", position=position_dodge()) +
    ylim(0, 0.8) +
    scale_x_continuous(
      breaks=c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
      labels=c("5", "4", "3", "2", "1", "-1", "-2", "-3", "-4", "-5")
    )

}
