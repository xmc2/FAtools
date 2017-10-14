#' @title Factor loadings table
#'
#' @description Creates a factor loading table
#'
#' @param loading_frame The data frame to be edited
#' @param loadings_no the names of the row name.
#' @param cutoff loadings whose absolute value are less than this are excluded
#' @param roundto rounding to how many digits
#' @param trim Removes the first n characters of the Description column when rendering the table.
#' @param Name variable name (to be included as a column in data_dic)
#' @param Communalities Should the communalities be displayed?
#'
#'
#' @return A table with rounded factor loadings, ommiting weak loadings with variable information on the side.
#'
#'
#' @importFrom magrittr "%>%"
#' @importFrom dplyr select full_join as_data_frame
#'
#'
#' @note No longer exported, replaced by loadings_table_psych
#'
loadings_table <- function(
        loading_frame,
        loadings_no = 7,
        cutoff = 0.2,
        roundto = 3,
        trim = 0,
        Name = NA,
        Communalities = F){

        if (class(loading_frame) == c("psych", "fa")){
                psych_object = loading_frame
                factors  <- ncol(psych_object$loadings)
                vars     <- nrow(psych_object$loadings)
                loadings <- psych_object$loadings[1:vars, 1:factors]
                labels   <- rownames(loadings)
                communal <- psych_object$communalities
        }

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

        # if there is not a data dictionary, but there is a description
        #       merge Description and Name to make a data dictionary

        # if (is.data.frame(data_dic) == F & length(Description) > 1){
        #         if (length(Name) == length(Description)){
        #                 data_dic <- cbind(Name, Description) %>%
        #                         as.data.frame()
        #         } else {
        #                 warning("Length of Name and length of
        #                         Description are not equal")
        #         }
        # }

        # if data_dic field is not NA then we can incorporate that information
        # we are only interested in the `Name` and `Description`

        # if (is.data.frame(data_dic) == T){
        #         for (i in 1:nrow(data_dic)){
        #                 x <- append(x, data_dic$Name[i] %in% rownames(loadings))
        #         }
        #
        #         data_dic <- data_dic[x,]
        #         data_dic$Description <- as.character(data_dic$Description)
        #         data_dic$Name <- as.character(data_dic$Name)
        #
        #         data_dic <- data_dic %>%
        #                 dplyr::as_data_frame() %>%
        #                 dplyr::select(Name, Description)
        #
        #         Encoding(data_dic$Description) <- 'latin1'
        #
        #         data_dic$Description <- substr(data_dic$Description, trim,
        #                 nchar(data_dic$Description))
        #
        #         loadings <- full_join(loadings, data_dic  %>%
        #                 dplyr::select(Name, Description), by = "Name") %>%
        #                 dplyr::select(-Name)
        # }

        return(loadings)
}
