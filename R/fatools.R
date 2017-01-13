# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

# FACTOR ANALYSIS TOOLS

#' Scree plot
#'
#' Easy, one function approach to creating scree plots
#'
#' @param corr The correlation matrix to be used
#' @param observations number of observations in dataset
#' @param variables number of variables in dataset
#'
#' @return a plot
#'
#' @examples
#' df_rename(
#'      data.frame(letters[1:5], 1:5),
#'      LETTERS[1:5],
#'      "CAPS"
#' )
#'
#' @export
scree_plot <- function(corr, observations, variables){
        library(nFactors)
        ev <- eigen(corr) # get eigenvalues
        ap <- nFactors::parallel(subject=observations,var=variables,
                                 rep=100,cent=.05)
        nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
        return(nS)
}

#' Factor loadings table
#'
#' Creates a factor loading table
#'
#' @param loading_frame The data frame to be edited
#' @param data_dic the rownames to be displayed
#' @param loadings_no the names of the row name.
#' @param cutoff loadings whose absolute value are less than this are excluded
#' @param roundto rounding to how many digits
#'
#' @return None
#'
#' @examples
#' df_rename(
#'      data.frame(letters[1:5], 1:5),
#'      LETTERS[1:5],
#'      "CAPS"
#' )
#'
#' @export
loadings_table <- function(loading_frame, data_dic,
        loadings_no = 7,
        cutoff = 0.2,
        roundto = 3){


        # lets round all loadings to the round to number
        bl_loadings <- loading_frame[,1:loadings_no] %>%
                as.data.frame() %>%
                sapply(function(x) round(as.numeric(x), roundto))

        # lets remove small loading values (small -> lower than cutoff)
        for (j in 1:ncol(bl_loadings)){
                for (i in 1:nrow(bl_loadings)){
                        if (abs(as.numeric(bl_loadings[i,j])) < cutoff){
                                bl_loadings[i,j] = ""
                        }
                }
        }

        # store this as a data frame
        bl_loadings <- sapply(bl_loadings, as.numeric, 1) %>%

                # no. of columns is the number of loadings
                matrix(ncol = loadings_no) %>%
                as.data.frame()

        # Assign the rownames as var names
        rownames(bl_loadings) <- rownames(as.data.frame(unclass(loading_frame)))

        # now we want to get human readable names from these vars
        x <- vector()

        for (i in 1:nrow(data_dic)){
                x <- append(x, data_dic$Name[i] %in% rownames(bl_loadings))
        }

        data_dic <- data_dic[x,]

        # merging the information from data dic into our loadings df

        bl_loadings$Name <- rownames(bl_loadings)
        bl_loadings <- as_data_frame(bl_loadings)

        # we are only interested in the `name` and `description`
        data_dic <- data_dic %>%
                dplyr::select(Name, Description)

        Encoding(data_dic$Description) <- 'latin1'


        data_dic$Description <- substr(data_dic$Description, 3, nchar(data_dic$Description))

        bl_loadings <- full_join(bl_loadings, data_dic  %>%
                                         dplyr::select(Name, Description)) %>%
                dplyr::select(-Name)

        return(bl_loadings)
}
