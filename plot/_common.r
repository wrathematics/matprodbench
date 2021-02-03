library(ggplot2)
library(ggthemes)

str_btw = function(x, start, end) sapply(regmatches(x, regexec(paste0(start, "\\s*(.*?)\\s*", end), x)), `[`, 2)



process = function(x, gpu=FALSE)
{
  jsrun = x[grep("^jsrun", x)]
  b = x[-grep("(^jsrun|SIZE|Tile)", x)]
  
  n = as.integer(str_btw(b, " ", "x"))
  mflops = as.double(str_btw(b, ":", "MFlops"))
  runtime = as.double(str_btw(b, "MFlops", "sec"))
  
  repper = function(x, len) unlist(lapply(1:length(x), function(i) rep(x[i], len[i])))
  nruns = diff(c(grep("4096x", b), length(b)+1))
  
  if (isTRUE(gpu))
  {
    ngpu = as.integer(str_btw(jsrun, "-g", "-b"))
    tile = as.integer(str_btw(jsrun, "nvblas_", ".conf"))
    
    df = data.frame(n, mflops, runtime, ngpu=repper(ngpu, nruns), tile=repper(tile, nruns))
    df$ngpu = as.factor(df$ngpu)
    df$tile = as.factor(paste("Tile =", df$tile))
  }
  else
  {
    nthreads = as.integer(str_btw(jsrun, "THREADS=", "Rscript"))
    
    df = data.frame(n, mflops, runtime, nthreads=repper(nthreads, nruns))
    df$nthreads = as.factor(df$nthreads)
  }
  
  df
}



plotter = function(df, ...)
{
  ggplot(df, aes(n, mflops, ...)) + theme_bw() + scale_color_tableau() +
    geom_point() + geom_line() +
    scale_x_continuous(trans="log2") +
    theme(legend.position="bottom", legend.box="horizontal") +
    labs(x="Matrix Size", y="MFlops")
}
