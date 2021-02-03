source("_common.r")

x_ob = readLines("../runs/summit/dgemm/openblas_cuda.txt")
df_ob = process(x_ob, gpu=TRUE)

x_essl = readLines("../runs/summit/dgemm/essl_cuda.txt")
df_essl = process(x_essl, gpu=TRUE)

df = rbind(
  cbind(subset(df_ob, tile=="Tile = 8192"), Backend="NVBLAS with OpenBLAS (Tile = 8192)"),
  cbind(df_essl, Backend="ESSL")
)


plotter(df, color=ngpu) +
  facet_wrap(.~Backend) +
  labs(color="Number of GPUs") +
  ggtitle("Square Matrix Product", subtitle="NVBLAS with OpenBLAS vs ESSL from R")

ggsave(last_plot(), file="nvblas_openblas_vs_essl.pdf")
