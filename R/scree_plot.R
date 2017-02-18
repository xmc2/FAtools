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
#' @importFrom nFactors parallel
#' @importFrom nFactors nScree
#' @importFrom MASS mvrnorm
#'
#' @export
scree_plot <- function(corr, observations, variables){
        if(dim(corr)[1] != dim(corr)[2]){
                stop("corr is non square! ")
        }
        # using base R eigen calculation
        ev <- eigen(corr) # get eigenvalues
        ap <- nFactors::parallel(subject=observations,var=variables,
                                 rep=100,cent=.05)
        nS <- nFactors::nScree(x=ev$values, aparallel=ap$eigen$qevpea)
        return(nS)
}
