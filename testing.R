loadings = results2$loadings
                        colorbreaks = c(-.2,0.4,0.6,0.8,1)
                        colors = RColorBrewer::brewer.pal(4,"Greens")
                        columnlabels = cool_names
library(gplots)

heatmap.2(x = t(loadings),

          # making the rows not reorder
          Rowv = F,
          Colv = F,
          dendrogram = "none",
          scale = "none",

          # controling colors
          breaks = colorbreaks,
          col = colors,
          sepwidth = c(0,0),

          # Removing default extras
          trace = "none", # this is the key for removing all that trash
          density.info="none",
          #
          # # labeling
          # labRow = c("Factor 1", "Factor 2", "Factor 3", "Factor 4", "Factor 5"),
          # #main = "Factor loadings",
          # xlab = "Symptom",
          #
          # # we want the color key
          # key = TRUE,
          # key.title = "Loading Values",
          # key.xlab = "Loading Values", # the thing that actually gets plotted.
          # symkey = FALSE,
          # keysize = 1,
          # lmat = rbind(c(2,4),c(3,1)),
          # lwid = c(0.5,1.5),
          # lhei = c(1,2.5),
          # # adjusting color key margins
          # key.par=list(mgp=c(1, 0.5, 0),
          #              mar=c(2.5, 0, 2.5, 7)),
          #
          # # Row/Column Labeling
          # margins = c(7, 2),
          # labCol = columnlabels,
          # offsetCol = 0,
          # adjCol = c(1,1),
          # # Making the x axis angled.
          # srtCol=45
)
