source("_common.r")
x = readLines("../runs/summit/dgemm/openblas.txt")
df = process(x, gpu=FALSE)


plotter(df, color=nthreads) + 
  labs(color="Number of Threads") +
  ggtitle("Square Matrix Product", subtitle="OpenBLAS from R")

ggsave(last_plot(), file="openblas.pdf")
