# Minimal theme
minimal_theme <- function() {
  font <- "Open Sans"

  ggplot2::theme(

  plot.margin=unit(c(.5,.8,0,.8),"cm"),
  plot.background = ggplot2::element_rect( fill = "#fefefe", colour = NA ),
  plot.title = ggplot2::element_text(family=font, size=18, lineheight=1.2, face="bold", color="#222222", margin=ggplot2::margin(0,0,5,0)),
  plot.subtitle = ggplot2::element_text(family=font, size=14, lineheight=1, color="#222222", margin=ggplot2::margin(5,0,30,0)),
  plot.caption = ggplot2::element_text(family=font, size=10, color="#222222", hjust = 0, margin=ggplot2::margin(20,0,0,0)),

  axis.title = ggplot2::element_text(family=font, face="bold", size=10, color="#222222"),
  axis.text = ggplot2::element_text(family=font, size=10, color="#222222"),
  # axis.line = ggplot2::element_blank(),
  # # axis.line.x = ggplot2::element_line(color="#777777"),
  # axis.line.y = ggplot2::element_blank(),
  axis.ticks = ggplot2::element_line(color="#777777"),
  # axis.ticks.x = ggplot2::element_line(color="#777777"),
  # axis.ticks.y = ggplot2::element_blank(),

  legend.position = "top",
  legend.text.align = 0,
  legend.background = ggplot2::element_blank(),
  legend.text = ggplot2::element_text(family=font, size=12, color="#222222"),
  legend.key.width = unit(3, "mm"),
  legend.key.height = unit(3, "mm"),

  panel.grid.major.y = ggplot2::element_line(color="#ebebeb"),
  panel.grid.major.x = ggplot2::element_blank(),
  panel.grid.minor = ggplot2::element_blank(),
  panel.background = ggplot2::element_blank(),
  panel.spacing = unit(2, "lines"),

  strip.background = ggplot2::element_rect(fill="white"),
  strip.text = ggplot2::element_text(size  = 12, hjust = 0)
  )
}


minimal_theme_map <- function() {

  font <- "Open Sans"

  ggplot2::theme(

  plot.margin=unit(c(.25,.25,.25,.25),"cm"),
  plot.background = ggplot2::element_rect( fill = "#fefefe", colour = NA ),
  # plot.background = element_blank(),
  plot.title = ggplot2::element_text(family=font, size=18, lineheight=1.2, face="bold", color="#222222", margin=ggplot2::margin(0,0,5,0)),
  plot.subtitle = ggplot2::element_text(family=font, size=14, lineheight=1, color="#222222", margin=ggplot2::margin(5,0,30,0)),
  plot.caption = ggplot2::element_text(family=font, size=10, color="#222222", hjust = 0, margin=ggplot2::margin(20,0,0,0)),

  # axis.title = ggplot2::element_text(family=font, face="bold", size=10, color="#222222"),
  # axis.text = ggplot2::element_text(family=font, size=10, color="#222222"),
  # axis.line = ggplot2::element_blank(),
  # # axis.line.x = ggplot2::element_line(color="#777777"),
  # axis.line.y = ggplot2::element_blank(),
  # axis.ticks = ggplot2::element_line(color="#777777"),
  # axis.ticks.x = ggplot2::element_line(color="#777777"),
  # axis.ticks.y = ggplot2::element_blank(),

  axis.line = element_blank(),
  axis.text = element_blank(),
  axis.ticks = element_blank(),
  axis.title = element_blank(),

  legend.justification = c(0, 0),
  legend.position = c(0, 0),
  legend.text.align = 0,
  legend.background = ggplot2::element_blank(),
  legend.text = ggplot2::element_text(family=font, size=12, color="#222222"),
  legend.key.width = unit(3, "mm"),
  legend.key.height = unit(3, "mm"),

  panel.grid = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = ggplot2::element_blank(),
  panel.background = ggplot2::element_blank(),
  panel.border = element_blank(),
  panel.spacing = unit(0, "lines"),

  strip.background = ggplot2::element_rect(fill="white"),
  strip.text = ggplot2::element_text(size  = 12, hjust = 0)
  )
}

#Left align text
left_align <- function(plot_name, pieces){
  grob <- ggplot2::ggplotGrob(plot_name)
  n <- length(pieces)
  grob$layout$l[grob$layout$name %in% pieces] <- 2
  return(grob)
}

prepare_plot <- function(plot_name,
                          source_name,
                          save_filepath=file.path(Sys.getenv("TMPDIR"), "tmp-nc.png"),
                          width_pixels=640,
                          height_pixels=450,
                          logo_image_path = file.path(system.file("data", package = 'bbplot'),"placeholder.png")) {

  #Draw your left-aligned grid
  plot_left_aligned <- left_align(plot_name, c("subtitle", "title", "caption"))
  plot_grid <- ggpubr::ggarrange(plot_left_aligned,
                                 # footer,
                                 ncol = 1, nrow = 2,
                                 heights = c(1, 0.045/(height_pixels/450))
                                 )

  ## print(paste("Saving to", save_filepath))
  # save_plot(plot_grid, width_pixels, height_pixels, save_filepath)

  ## Return (invisibly) a copy of the graph. Can be assigned to a
  ## variable or silently ignored.
  invisible(plot_grid)
}


align_plot_elements <- function(ggplot, title = 2, subtitle = 2, caption = 2) {
  # grab the saved ggplot2 object
  g <- ggplotGrob(ggplot)

  # find the object which provides the plot information for the title, subtitle, and caption
  g$layout[which(g$layout$name == "title"),]$l <- title
  g$layout[which(g$layout$name == "subtitle"),]$l <- subtitle
  g$layout[which(g$layout$name == "caption"),]$l <- caption
  g
}

#' Wrap text with newline.
#'
#' @param x character vector.
#' @param width number of spaces before wrapping.
#' @return character vector with individual elements wrapped.
#'
#' @details Return atomic vector if input is atomic. Else return list.
wrap_text <- function(x, width = 19){
  if (is.factor(x))
    stop(paste("You haven't implementend this functionality yet.",
               "MAYBE YOU SHOULD DO THAT NOW."))
  wrapped <- lapply(x, function(char) strwrap(char, width))
  wrapped <- lapply(wrapped, paste, collapse = '\n')
  if (is.atomic(x))
    wrapped <- unlist(wrapped)
  return(wrapped)
}

############################################################
