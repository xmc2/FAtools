#' @title Factor loadings plot
#'
#' @description Creates a factor loading plot.
#'     Essentially a heatmap built on top of gplot::heatmap.2. UNDER HEAVY DEVELOPMENT.
#'
#' @param loadings factor loadings
#' @param colorbreaks cutpoints of the discontinuous factor loading colors
#' @param columnlabels x-axis labels (typically more discriptive variable names)
#' @param colors colors pertaining to the 'colorbreaks' argument
#'
#' @return A graphic of factor loadings.
#'
#'
#' @importFrom gplots heatmap.2
#' @importFrom RColorBrewer brewer.pal
#'
#' @examples
#' library(datasets)
#' library(RColorBrewer)
#' corr.matrix <- cor(mtcars)
#' results <- psych::fa(corr.matrix, 5, rotate = "varimax")
#' FAtools::loadings_plot(results$loadings,
#' columnlabels = colnames(mtcars), colorbreaks = c(0, 0.2, 0.4, 0.6, 0.8,1),
#' colors = brewer.pal(length(colorbreaks), "Greens"))
#'
#' @export

loadings_plot <- function(loadings,
                          columnlabels,
                          breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1),
                          colors = NA
                          ){
        # warning message
        warning("This function is under heavy deleopment")

        # auto selecting colors
        if(length(breaks) != length(colors) - 1){
                colors = brewer.pal(length(colorbreaks)-1,"Greens")
        }

        # calling heatmap2
        heatmap.2(x = t(loadings),

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
                          labRow = c("Factor 1", "Factor 2", "Factor 3", "Factor 4", "Factor 5"),
                          #main = "Factor loadings",
                          xlab = "Symptom",

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
