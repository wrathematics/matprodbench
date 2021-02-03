source("_common.r")

x_ob = readLines("../runs/summit/dgemm/openblas.txt")
df_ob = process(x_ob, gpu=FALSE)

x_nl = readLines("../runs/summit/dgemm/netlib.txt")
df_nl = process(x_nl, gpu=FALSE)

df = rbind(
  cbind(subset(df_ob, nthreads==1), Backend="OpenBLAS"),
  cbind(df_nl, Backend="Netlib")
)


plotter(df, linetype=Backend) + 
  labs(linetype="Backend") +
  ggtitle("Square Matrix Product", subtitle="OpenBLAS vs Netlib from R")

ggsave(last_plot(), file="netlib_vs_openblas.pdf")
