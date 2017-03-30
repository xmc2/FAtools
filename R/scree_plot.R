#' @title Scree plot
#'
#' @description Easy, one function approach to creating scree plots
#'
#' @param corr The correlation matrix to be used
#' @param observations number of observations in dataset
#' @param variables number of variables in dataset
#'
#' @return A plottable scree plot object
#'
#' @importFrom nFactors parallel nScree
#' @importFrom MASS mvrnorm
#'
#' @examples
#' set.seed(100)
#' data <- matrix(rnorm(100), ncol = 10) # loading our 'data'
#' data_cor <- cor(data)
#' scree <- scree_plot(data_cor, 10, 10)
#' plot(scree)
#'
#' @export
#'
scree_plot <- function(corr, observations, variables = ncol(corr)){
        # if(dim(corr)[1] != dim(corr)[2]){
        #         stop("corr is non square! ")
        # }
        # using base R eigen calculation
        # mvrnorm <- MASS::mvrnorm
        ev <- eigen(corr) # get eigenvalues
        ap <- parallel(subject=observations,var=variables,
                                 rep=100,cent=.05)
        nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
        return(nS)
}
