setwd("~/GitHub/srp/src")

resultsFile = "result.csv"

colClasses = list(
size = "integer",
seed = "integer",
executions = "integer",
strategy = "factor",
assumptions = "integer",
solutions = "integer",
runtime_one = "numeric",
walltime_one = "numeric",
runtime_all = "numeric",
walltime_all = "numeric")

data <- read.csv(file = resultsFile, colClasses = colClasses, fileEncoding = "UTF-8")

# Discard invalid columns
data <- subset(data, select = -c(runtime_all, walltime_all))

# Found at least solutions?
# Otherwise, assumptions and times are invalid.
data <- transform(data, solved = (solutions > 0))


# Plot portion of solved instances
dataSolved <- transform(data, instances = 0)
dataSolved <- aggregate(dataSolved["instances"], by=dataSolved[c("size","solved")], FUN=length)
dataSolved <- transform(dataSolved, instances = instances / 3)
dataSolved <- subset(dataSolved, solved == TRUE, select = -c(solved))

pdf(file = "soluble.pdf")
barplot(dataSolved$instances, names.arg=dataSolved$size,
	xlab="Size (participants)",ylab="Soluble instances (out of 10)",
	yaxt="n")
axis(2, c(0,5,7,8,9,10),
	c("0","5","7","8","9","10"))
title("Portion of soluble instances")
dev.off()


# Plot numbers of executions
dataExecutions <- aggregate(data$executions, list(size = data$size), min)

pdf(file = "executions.pdf")
barplot(dataExecutions$x, names.arg=dataExecutions$size,
	xlab="Size (participants)",ylab="Executions",
	yaxt="n")
axis(2, c(0,10,100),
	c("0","10","100"))
title("Number of executions of solving procedure")
dev.off()


# Filter out trials with instances without solution
dataValid <- subset(data, solved == TRUE, select = -c(solved))

# Time for first solution per execution
dataValid <- transform(dataValid, tf = runtime_one / executions)


# Plot mean time
tfMean <- aggregate(dataValid$tf, list(size = dataValid$size, strategy = dataValid$strategy), mean)
tfMeanLeftmost <- subset(tfMean, strategy == "leftmost", select = -c(strategy))
tfMeanFf <- subset(tfMean, strategy == "ff", select = -c(strategy))
tfMeanFfc <- subset(tfMean, strategy == "ffc", select = -c(strategy))

#postscript(file = "time.eps")
pdf(file = "time.pdf")
plot(xlab="Size (participants)",ylab="Time (ms)",xlim=c(0,64),ylim=c(0,100),xaxt="n",
	tfMeanLeftmost$size,tfMeanLeftmost$x,type="o",col="red")
points(tfMeanFf$size,tfMeanFf$x,type="o",col="green")
points(tfMeanFfc$size,tfMeanFfc$x,type="o",col="blue")
legend("topleft", title="Strategy", c("leftmost", "ff", "ffc"),
	fill=c("red", "green", "blue"))
axis(1, c(0,1,2,4,8,16,24,32,40,48,56,64),
	c("0","1","2","4","8","16","24","32","40","48","56","64"))
title("Average solving time")
dev.off()


# Plot mean assumptions
assumptionsMean <- aggregate(dataValid$assumptions, list(size = dataValid$size, strategy = dataValid$strategy), mean)
assumptionsMeanLeftmost <- subset(assumptionsMean, strategy == "leftmost", select = -c(strategy))
assumptionsMeanFf <- subset(assumptionsMean, strategy == "ff", select = -c(strategy))
assumptionsMeanFfc <- subset(assumptionsMean, strategy == "ffc", select = -c(strategy))

pdf(file = "assumptions.pdf")
plot(xlab="Size (participants)",ylab="Number of assumptions",xlim=c(0,64),ylim=c(0,240),xaxt="n",
	assumptionsMeanLeftmost$size,assumptionsMeanLeftmost$x,type="o",col="red")
points(assumptionsMeanFf$size,assumptionsMeanFf$x,type="o",col="green")
# Number of assumptions is the same for ff and ffc
#points(assumptionsMeanFfc$size,assumptionsMeanFfc$x,type="o",col="blue")
#legend("topleft", title="Strategy", c("leftmost", "ff", "ffc"), fill=c("red", "green", "blue"))
legend("topleft", title="Strategy", c("leftmost", "ff and ffc"), fill=c("red", "green"))
axis(1, c(0,1,2,4,8,16,24,32,40,48,56,64),
	c("0","1","2","4","8","16","24","32","40","48","56","64"))
title("Average number of assumptions in search for solution")
dev.off()


# Plot time boxplot
pdf(file = "leftmost_time.pdf")
boxplot(dataValid$tf~dataValid$size, subset = dataValid$strategy == "leftmost")
title("Time with strategy leftmost")
dev.off()

boxplot(dataValid$tf~dataValid$size, subset = dataValid$strategy == "ff")
boxplot(dataValid$tf~dataValid$size, subset = dataValid$strategy == "ffc")

# Plot assumptions boxplot
pdf(file = "leftmost_assumptions.pdf")
boxplot(dataValid$assumptions~dataValid$size, subset = dataValid$strategy == "leftmost")
title("Assumptions with strategy leftmost")
dev.off()

boxplot(dataValid$assumptions~dataValid$size, subset = dataValid$strategy == "ff")
boxplot(dataValid$assumptions~dataValid$size, subset = dataValid$strategy == "ffc")

