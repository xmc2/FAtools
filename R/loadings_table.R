#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'
# http://stackoverflow.com/questions/27947344/r-use-magrittr-pipe-operator-in-self-written-package
# FACTOR ANALYSIS TOOLS
# need to add examples

#' Factor loadings table
#'
#' Creates a factor loading table
#'
#' @param loading_frame The data frame to be edited
#' @param data_dic the rownames to be displayed, MUST contain a `Description` column and a `Name` column
#' @param loadings_no the names of the row name.
#' @param cutoff loadings whose absolute value are less than this are excluded
#' @param roundto rounding to how many digits
#' @param trim Removes the first n characters of the Description column when rendering the table.
#' @param Name variable name (to be included as a column in data_dic)
#' @param Description variable description (to be included as a column in data_dic)
#'
#'
#' @return A table with rounded factor loadings, ommiting weak loadings with variable information on the side.
#'
#'
#' @importFrom magrittr "%>%"
#' @importFrom dplyr select
#' @importFrom dplyr full_join
#' @importFrom dplyr as_data_frame
#'
#'
#' @export
loadings_table <- function(
        loading_frame,
        loadings_no = 7,
        cutoff = 0.2,
        roundto = 3,
        data_dic = NA,
        trim = 0,
        Name = NA,
        Description = NA){

        # lets round all loadings to roundto parameter
        loadings <- loading_frame[,1:loadings_no] %>%
                as.data.frame() %>%
                sapply(function(x) round(as.numeric(x), roundto))


        # store this as a data frame
        loadings <- sapply(loadings, as.numeric, 1) %>%

                # no. of columns is the number of loadings
                matrix(ncol = loadings_no) %>%
                as.data.frame()

        # Assign the rownames as var names
        rownames(loadings) <- rownames(as.data.frame(unclass(loading_frame)))

        # lets remove small loading values (small -> lower than cutoff)
        for (j in 1:ncol(loadings)){
                for (i in 1:nrow(loadings)){
                        if (abs(as.numeric(loadings[i,j])) < cutoff){
                                loadings[i,j] = ""
                        }
                }
        }

        # now we want to get human readable names from these vars
        x <- vector()


        # merging the information from data dic into our loadings df

        loadings$Name <- rownames(loadings)
        loadings <- as_data_frame(loadings)

        # if data_dic field is not NA then we can incorporate that information
        # we are only interested in the `Name` and `Description`

        if (is.data.frame(data_dic) == T){
                for (i in 1:nrow(data_dic)){
                        x <- append(x, data_dic$Name[i] %in% rownames(loadings))
                }

                data_dic <- data_dic[x,]
                data_dic$Description <- as.character(data_dic$Description)
                data_dic$Name <- as.character(data_dic$Name)

                data_dic <- data_dic %>%
                        dplyr::as_data_frame() %>%
                        dplyr::select(Name, Description)

                Encoding(data_dic$Description) <- 'latin1'

                data_dic$Description <- substr(data_dic$Description, trim,
                        nchar(data_dic$Description))

                loadings <- full_join(loadings, data_dic  %>%
                        dplyr::select(Name, Description)) %>%
                        dplyr::select(-Name)
        }
        return(loadings)
}
