options("matprod"="blas")

gemm_mflops = function(n, t, digits=2) round(2*n*n*n / 1000 / 1000, digits=digits)

args = commandArgs(trailingOnly=TRUE)
args = as.numeric(args)
if (length(args) != 4 || anyNA(args) || any(is.null(args))){
  stop("Usage is 'Rscript start_size end_size by num_iter'")
}

sizes = seq(from=args[1], to=args[2], by=args[3])

cat("      SIZE")
cat("             Flops")
cat("                   Time\n")

for (iter in seq_len(args[4])){
  for (n in sizes){
    x = runif(n*n)
    dim(x) = c(n, n)
    y = runif(n*n)
    dim(y) = c(n, n)
    
    t = system.time({ret = x %*% y})[3]
    
    cat(sprintf("%18s : ", paste0(n, "x", n)))
    
    cat(sprintf("%10.2f ", gemm_mflops(n, t)))
    cat("MFlops ")
    
    cat(sprintf("%10.6f ", t))
    cat("sec")
    
    cat("\n")
    
    rm(ret, x, y, n, t)
    invisible(gc(verbose=FALSE, reset=TRUE, full=TRUE))
  }
}
