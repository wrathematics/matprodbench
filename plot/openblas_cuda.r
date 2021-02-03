source("_common.r")
x = readLines("../runs/summit/dgemm/openblas_cuda.txt")
df = process(x, gpu=TRUE)


plotter(df, color=ngpu) + 
  facet_wrap(.~tile) +
  labs(color="Number of GPUs") +
  ggtitle("Square Matrix Product", subtitle="NVBLAS from R")

ggsave(last_plot(), file="nvblas.pdf")
