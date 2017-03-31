#' @title Factor loadings plot
#'
#' @description Creates a factor loading plot.
#'     Essentially a heatmap built on top of gplot::heatmap.2. UNDER HEAVY DEVELOPMENT.
#'
#' @param loadings factor loadings
#' @param colorbreaks cutpoints of the discontinuous factor loading colors
#' @param colors a prespecified vector of colors corresponding to colorbreaks.
#' @param columnlabels x-axis labels (typically more discriptive variable names)
#' @param labRow Names of factors (defaults to factor 1, factor 2, etc.)
#' @param xlab x-axis label
#'
#' @return A graphic of factor loadings.
#'
#'
#' @importFrom gplots heatmap.2
#' @importFrom RColorBrewer brewer.pal
#'
#' @examples
#' library(datasets)
#' corr.matrix <- cor(mtcars)
#' results <- psych::fa(corr.matrix, 5, rotate = "varimax")
#' loadings_plot(loadings = results$loadings,
#'               colorbreaks = c(0, 0.2, 0.4, 0.6, 0.8,1),
#'               colors = NA,
#'               columnlabels = colnames(mtcars),
#'               labRow = NA,
#'               xlab = "Variables")
#'
#' @export

loadings_plot <- function(loadings,
                          colorbreaks = c(0, 0.2, 0.4, 0.6, 0.8, 1),
                          colors = NA,
                          columnlabels = NA,
                          labRow = NA,
                          xlab = NA){

        # Assessing labrow

        if(is.na(labRow) == T){
                labRow = vector()
                for (i in 1:ncol(loadings)){
                        labRow[i] <- paste("Factor",i,sep = " ")
                }
        }

        # assigning colors
        if((is.na(colors)) | (length(colors) != length(colorbreaks) - 1)){
                colors = brewer.pal(length(colorbreaks)-1,"Greens")
        }

        # Calling the heatmap.2 function
        gplots::heatmap.2(x = t(loadings),

          # making the rows not reorder
          Rowv = F,
          Colv = F,
          dendrogram = "none",
          scale = "none",

          # controling colors
          breaks = colorbreaks,
          col = colors,
          sepwidth = c(0,0),

          # Removing default extras
          trace = "none", # this is the key for removing all that trash
          density.info="none",

          # labeling
          labRow = labRow,
          # main = main,
          xlab = xlab,

          # we want the color key
          key = TRUE,
          key.title = "Loading Values",
          key.xlab = "Loading Values", # the thing that actually gets plotted.
          symkey = FALSE,
          keysize = 1,
          lmat = rbind(c(2,4),c(3,1)),
          lwid = c(0.5,1.5),
          lhei = c(1,2.5),
          # adjusting color key margins
          key.par=list(mgp=c(1, 0.5, 0),
                       mar=c(2.5, 0, 2.5, 7)),

          # Row/Column Labeling
          margins = c(7, 6),
          labCol = columnlabels,
          offsetCol = 0,
          adjCol = c(1,1),
          # Making the x axis angled.
          srtCol=45
          )
}

