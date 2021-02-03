source("_common.r")

x_ob = readLines("../runs/summit/dgemm/openblas.txt")
df_ob = process(x_ob, gpu=FALSE)

x_essl = readLines("../runs/summit/dgemm/essl.txt")
df_essl = process(x_essl, gpu=FALSE)

df = rbind(
  cbind(df_ob, Backend="OpenBLAS"),
  cbind(df_essl, Backend="ESSL")
)


plotter(df, color=nthreads, linetype=Backend) + 
  labs(color="Number of Threads", linetype="Backend") +
  ggtitle("Square Matrix Product", subtitle="OpenBLAS vs ESSL from R")

ggsave(last_plot(), file="openblas_vs_essl.pdf")
