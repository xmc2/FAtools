context("this is the test purpose")

library(datasets)
library(psych)
library(testthat)
corr.matrix <- cor(mtcars)
results <- psych::fa(corr.matrix, 5, rotate = "varimax")

test_that("test_label", {
        # TO DO: replace this fake test with real tests..
        expect_equal(
                2,2
                )
})

