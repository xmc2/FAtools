#' @title Factor loadings table from psych object
#'
#' @description Creates a factor loading table
#'
#' @param psych_object The Factor analysis psych object
#' @param cutoff loadings whose absolute value are less than this are excluded
#' @param roundto rounding to how many digits
#' @param trim Removes the first n characters of the Description column when rendering the table.
#' @param Name variable name (to be included as a column in data_dic)
#' @param Description variable description (to be included as a column in data_dic)
#'
#' @return A table with rounded factor loadings, ommiting weak loadings with variable information on the side.
#'
#'
#' @importFrom magrittr "%>%"
#' @importFrom dplyr select full_join as_data_frame mutate everything
#'
#' @examples
#' library(datasets)
#' corr.matrix <- cor(mtcars)
#' results <- psych::fa(corr.matrix, 2, rotate = "varimax")
#' loadings_table_psych(results, 2, cutoff = 0.3, roundto = 2)
#'
#' @export
#'
loadings_table_psych <- function(
        psych_object,
        cutoff = 0.2,
        roundto = 3,
        trim = 0,
        Description = NA){

        # checking to ensure we are working with a psych object

        if (sum(class(psych_object) != c("psych", "fa")) == 2){
                warning("Not psych object")
        }

        # isolating the factor loading frame

        factors  <- ncol(psych_object$loadings)
        vars     <- nrow(psych_object$loadings)
        loadings <- psych_object$loadings[1:vars, 1:factors]
        labels   <- rownames(loadings)


        # lets round all loadings to roundto parameter
        loadings <- loadings %>%
                as.data.frame() %>%
                sapply(function(x) round(as.numeric(x), roundto)) %>%
                as.data.frame()

        # lets remove small loading values (small -> lower than cutoff)
        for (j in 1:ncol(loadings)){
                for (i in 1:nrow(loadings)){
                        if (abs(as.numeric(loadings[i,j])) < cutoff){
                                loadings[i,j] = ""
                        }
                }
        }

        # Assign the rownames as var names

        loadings <- loadings %>%
                mutate(labels = labels) %>%
                dplyr::select(labels, everything())

        if (!is.na(Description)){
                loadings$labels = loadings$Description
        }

        return(loadings)
}
