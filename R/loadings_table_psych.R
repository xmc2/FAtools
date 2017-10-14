#' @title Factor loadings table from psych object
#'
#' @description Creates a factor loading table
#'
#' @param psych_object The Factor analysis psych object
#' @param cutoff loadings whose absolute value are less than this are excluded
#' @param roundto rounding to how many digits
#' @param trim Removes the first n characters of the Description column when rendering the table.
#' @param fac.lab Alternative factor labels
#' @param var.lab Alternative variable labels
#' @param communalities include communalities?
#'
#' @return A table with rounded factor loadings, ommiting weak loadings with variable information on the side.
#'
#'
#' @importFrom dplyr select full_join as_data_frame mutate everything "%>%"
#'
#' @examples
#' library(datasets)
#' corr.matrix <- cor(mtcars)
#' results <- psych::fa(corr.matrix, 3, rotate = "varimax")
#' FAtools::loadings_table_psych(results, cutoff = 0.3, roundto = 2)
#'
#' @export
#'
loadings_table_psych <- function(
        psych_object,
        cutoff = 0.2,
        roundto = 3,
        trim = 0,
        fac.lab = NULL,
        var.lab = NULL,
        communalities = T){

        # checking to ensure we are working with a psych object
        # if not, we will print a warning

        if (sum(class(psych_object) != c("psych", "fa")) == 2){
                warning("Not psych object")
        }

        # isolating the factor loading frame

        factors  <- ncol(psych_object$loadings)
        vars     <- nrow(psych_object$loadings)
        loadings <- psych_object$loadings[1:vars, 1:factors]

        # Checking: did we provide factor labels?
        # if so, lets use them as col names, else defaults

        if (!is.null(fac.lab)){
                colnames(loadings) = fac.lab
        } else {
                colnames(loadings) <- rep("F", ncol(loadings))
                for (i in 1:ncol(loadings)){
                        colnames(loadings)[i] = paste(colnames(loadings)[i], i, sep = "")
                }
        }

        # Checking: did we provide variable labels?
        # if so, lets use them, else we will use current variable names
        if (!is.null(var.lab)){
                var_labels   <- var.lab
        } else {
                var_labels   <- rownames(loadings)
        }

        # extracting communalities

        communal <- psych_object$communalities


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

        # loadings <- loadings %>%
        #         dplyr::select(labels, everything())
        #

        loadings <- loadings %>%
                dplyr::mutate(Communalities = communal %>%
                                      round(roundto),
                              var_labels = var_labels) %>%
                dplyr::select(var_labels, dplyr::everything()) %>%
                dplyr::rename(`Labels` = var_labels)


        # we can return our loading matrix
        return(loadings)
}
