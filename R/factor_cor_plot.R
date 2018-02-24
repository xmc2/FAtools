#' @title Effective Factor Correlation Plot
#'
#' @description Plots inter-factor correlations from a psych object
#'
#' @param psych_object object resulting from psych::fa()
#' @param colors The number of colors to be utilized
#' @param type argument passed to corrplot
#' @param cl.lim Vector range of corrleations to be plotted. Use c(0,1)
#' @param tl.srt Tilt of upper labels
#' @param names alternative factor names (vector)
#'
#' @return A graphic of correlations
#'
#' @importFrom corrplot corrplot
#' @importFrom RColorBrewer brewer.pal
#' @importFrom magrittr "%>%"
#' @importFrom grDevices colorRampPalette
#'
#' @examples
#' library(datasets)
#' corr.matrix <- cor(mtcars)
#' results <- psych::fa(corr.matrix, 5, rotate = "varimax")
#' factor_cor_plot(results, colors = 10)
#'
#' @export

factor_cor_plot <- function(psych_object,
                colors = 5,
                names = NA,
                cl.lim = c(-1,1),
                tl.srt = 45,
                type = "lower"){

        interfactor_corr <- psych_object$r.scores

        if (!is.na(names)){
                rownames(interfactor_corr) <- names
                colnames(interfactor_corr) <- names
        }

        interfactor_corr %>%
                corrplot::corrplot(method = "color",
                 type   = type,
                 diag   = F,
                 col    = colorRampPalette(c("black", "white", "steelblue"))(colors),
                 cl.lim = cl.lim,
                 tl.srt = tl.srt)
}

