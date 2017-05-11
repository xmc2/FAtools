#' @title Simple correlation plot with sensable defaults
#'
#' @description creates a simple correlation plot
#'     Essentially a heatmap built on top of gplot::heatmap.2. UNDER HEAVY DEVELOPMENT.
#'
#' @param corr correlation matrix
#' @param colorbreaks cutpoints of the discontinuous factor loading colors
#' @param colors a prespecified vector of colors corresponding to colorbreaks.
#' @param columnlabels x-axis labels (typically more discriptive variable/factor names)
#' @param labRow Names of variables / factors
#' @param xlab x-axis label
#'
#' @return A graphic of correlations
#'
#' @importFrom gplots heatmap.2
#' @importFrom RColorBrewer brewer.pal
#'
#' @examples
#' library(datasets)
#' library(dplyr)
#' data(mtcars)
#' cor(mtcars[1:4,1:4]) %>%
#' cor() %>%
#' corr_plot(columnlabels = 1:4)
#'
#' @export

corr_plot <- function(corr,
                      colorbreaks = c(-0.2,0,0.2,0.4,0.6,0.8,1),
                      colors = NA,
                      columnlabels = NA,
                      labRow = NA,
                      xlab = NA){
        # assigning colors
        if((is.na(colors)) | (length(colors) != length(colorbreaks) - 1)){
                colors = brewer.pal(length(colorbreaks)-1,"Greens")
        }
        colors = c("salmon1",brewer.pal(length(colorbreaks) - 2, "Blues"))
        corr %>%
                as.matrix() %>%
                gplots::heatmap.2(Rowv = F, Colv = F, dendrogram = "none",
                                  scale = "none", breaks = colorbreaks, col = colors,
                                  sepwidth = c(0,0), trace = "none", density.info = "none",
                                  labRow = labRow, xlab = xlab, labCol = columnlabels,
                                  key = TRUE,
                                  key.title = "Correlation", key.xlab = "Correlation",
                                  symkey = FALSE, keysize = 1, lmat = rbind(c(2, 4), c(3, 1)),
                                  lwid = c(0.5, 1.5), lhei = c(1,2.5),
                                  key.par = list(mgp = c(1, 0.5, 0), mar = c(2.5, 0, 2.5, 7)), margins = c(7, 6),
                                  offsetCol = 0, adjCol = c(1, 1), srtCol = 45)
}
