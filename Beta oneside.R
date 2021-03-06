## PS = prior success, PF = prior failure for beta dist. PS = 1, PF = 1 corresponds to uniform(0,1)
## k = number of observed successes, n = total trials
## null = what is the point-null hypothesis? null = NULL leaves it out of plots and calcs
## oneSided = Is the hypothesis one-sided? Use "less" for (0,.5), use "greater" for (.5, 1)



plot.beta <- function(PS = 1, PF = 1, k = 0, n = 0, null = NULL, oneSided = FALSE) {
        if(oneSided == FALSE){
        x = seq(0, 1, .0001)
        y1 = dbeta(x, PS, PF) # data for prior curve
        y3 = dbeta(x, PS + k, PF + n - k) # data for posterior curve
        y2 = dbeta(x, 1 + k, 1 + n - k) # data for likelihood curve, plotted as the posterior from a beta(1,1)
        }
        if(oneSided == "less"){
                x = seq(0, .5, .0001)
                y1 = 2* dbeta(x, PS, PF) # data for prior curve
                y3 = 2* dbeta(x, PS + k, PF + n - k) # data for posterior curve
                y2 = 2* dbeta(x, 1 + k, 1 + n - k) # data for likelihood curve, plotted as the posterior from a beta(1,1)
        }
        if(oneSided == "greater"){
                x = seq(.5, 1, .0001)
                y1 = 2* dbeta(x, PS, PF) # data for prior curve
                y3 = 2* dbeta(x, PS + k, PF + n - k) # data for posterior curve
                y2 = 2* dbeta(x, 1 + k, 1 + n - k) # data for likelihood curve, plotted as the posterior from a beta(1,1) 
        }
        plot(x, y1, xlim=c(min(x),max(x)), ylim=c(0,max(y1,y2,y3)+.25*(max(y1,y2,y3))), type = "l", ylab= "Density",
             xlab= "Probability of success", las=1, main="Prior-to-Posterior Transformation with Binomial Data",lwd=5,
             cex.lab=1.5, cex.main=1.5, col = "skyblue", axes=FALSE)
        axis(1, at = seq(0,1,.1))
        axis(2, las=1)
        if(mode(null) == "numeric"){
                if(n != 0){
                        if(oneSided == "greater"){
                        points(null, 2* dbeta(null, PS, PF), pch = 21, bg = "blue", cex = 1.5)
                        points(null, 2* dbeta(null, PS + k, PF + n - k), pch = 21, bg = "darkorchid", cex = 1.5)
                        }
                        if(oneSided == "less"){
                        points(null, 2* dbeta(null, PS, PF), pch = 21, bg = "blue", cex = 1.5)
                        points(null, 2* dbeta(null, PS + k, PF + n - k), pch = 21, bg = "darkorchid", cex = 1.5)
                        }
                        if(oneSided == FALSE){
                        points(null, dbeta(null, PS, PF), pch = 21, bg = "blue", cex = 1.5)
                        points(null, dbeta(null, PS + k, PF + n - k), pch = 21, bg = "darkorchid", cex = 1.5)
                        }
                }
        }
        if(n != 0){
        lines(x, y2, type = "l", col = "darkorange", lwd = 3, lty = 3)
        lines(x, y3, type = "l", col = "darkorchid1", lwd = 5)
        legend("topright", c("Prior", "Posterior", "Likelihood"), col = c("skyblue", "darkorchid1", "darkorange"),
               lty = c(1,1,3), lwd = c(5,5,3), bty = "n", inset = c(-.3, 0), y.intersp = .55,
               x.intersp = .40)
        abline(v=null, lty = 5, lwd = 1, col = "grey73")
        }
        if((oneSided == "greater" && null< .5)|(oneSided == "less" && null>.5)){
                return("No density at null value")
        }
        if(mode(null) == "numeric" && n != 0){
        ##Calculate BF using Savage-Dickey density ratio
                null.H0 <- dbeta(null, PS, PF)
                null.H1 <- dbeta(null, PS + k, PF + n - k)
        #lines(c(-.1,null), c(null.H0, null.H0), lwd=1, lty=5, col = "lightskyblue1")
        return( list("BF01" = null.H1/null.H0, "BF10" = null.H0/null.H1))
        }
}