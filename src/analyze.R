setwd("~/GitHub/srp/src")

resultsFile = "data.csv"

colClasses = list(
size = "integer",
seed = "integer",
executions = "integer",
solutions = "integer",
leftmost.first.assumptions = "integer",
leftmost.first.runtime = "integer",
leftmost.first.walltime = "integer",
leftmost.all.runtime = "integer",
leftmost.all.walltime = "integer",
ff.first.assumptions = "integer",
ff.first.runtime = "integer",
ff.first.walltime = "integer",
ff.all.runtime = "integer",
ff.all.walltime = "integer",
ffc.first.assumptions = "integer",
ffc.first.runtime = "integer",
ffc.first.walltime = "integer",
ffc.all.runtime = "integer",
ffc.all.walltime = "integer")

data <- read.csv(file = resultsFile, colClasses = colClasses, fileEncoding = "UTF-8")

# Mark trials with solved (i.e. soluble) instances
data <- transform(data, solved = (solutions > 0))


# Plot portion of solved instances
dataSolvedInst <- transform(data, instances = 0)
dataSolvedInst <- aggregate(dataSolvedInst["instances"], by=dataSolvedInst[c("size","solved")], FUN=length)
dataSolvedInst <- subset(dataSolvedInst, solved == TRUE, select = -c(solved))

pdf(file = "soluble.pdf")
barplot(dataSolvedInst$instances, names.arg=dataSolvedInst$size,
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
axis(2, c(0,1,10,100),
	c("0","1","10","100"))
title("Number of executions of solving procedure")
dev.off()


# Time per execution
data <- transform(data, leftmost.first.runtime.mean = leftmost.first.runtime / executions)
data <- transform(data, leftmost.first.walltime.mean = leftmost.first.walltime / executions)
data <- transform(data, leftmost.all.runtime.mean = leftmost.all.runtime / executions)
data <- transform(data, leftmost.all.walltime.mean = leftmost.all.walltime / executions)
data <- transform(data, ff.first.runtime.mean = ff.first.runtime / executions)
data <- transform(data, ff.first.walltime.mean = ff.first.walltime / executions)
data <- transform(data, ff.all.runtime.mean = ff.all.runtime / executions)
data <- transform(data, ff.all.walltime.mean = ff.all.walltime / executions)
data <- transform(data, ffc.first.runtime.mean = ffc.first.runtime / executions)
data <- transform(data, ffc.first.walltime.mean = ffc.first.walltime / executions)
data <- transform(data, ffc.all.runtime.mean = ffc.all.runtime / executions)
data <- transform(data, ffc.all.walltime.mean = ffc.all.walltime / executions)


# Plot mean time
timeLeftmost <- aggregate(data$leftmost.first.runtime.mean, list(size = data$size), mean)
timeFf <- aggregate(data$ff.first.runtime.mean, list(size = data$size), mean)
timeFfc <- aggregate(data$ffc.first.runtime.mean, list(size = data$size), mean)

pdf(file = "time.pdf")
plot(xlab="Size (participants)",ylab="Time (ms)",xlim=c(0,88),xaxt="n",
	timeLeftmost$size,timeLeftmost$x,type="o",col="red")
points(timeFf$size,timeFf$x,type="o",col="green")
points(timeFfc$size,timeFfc$x,type="o",col="blue")
legend("topleft", title="Strategy", c("leftmost", "ff", "ffc"),
	fill=c("red", "green", "blue"))
axis(1, c(0,1,2,4,8,16,24,32,40,48,56,64,72,80,88),
	c("0","1","2","4","8","16","24","32","40","48","56","64","72","80","88"))
title("Average solving time")
dev.off()


# Extract solved instances
dataSolved <- subset(data, solved == TRUE, select = -c(solved))

# Plot mean assumptions
assumptionsLeftmost <- aggregate(dataSolved$leftmost.first.assumptions, list(size = dataSolved$size), mean)
assumptionsFf <- aggregate(dataSolved$ff.first.assumptions, list(size = dataSolved$size), mean)
assumptionsFfc <- aggregate(dataSolved$ffc.first.assumptions, list(size = dataSolved$size), mean)

pdf(file = "assumptions.pdf")
plot(xlab="Size (participants)",ylab="Number of assumptions",xlim=c(0,88),ylim=c(0,240),xaxt="n",
	assumptionsLeftmost$size,assumptionsLeftmost$x,type="o",col="red")
points(assumptionsFf$size,assumptionsFf$x,type="o",col="green")
# Number of assumptions is the same for ff and ffc
#legend("topleft", title="Strategy", c("leftmost", "ff", "ffc"), fill=c("red", "green", "blue"))
legend("topleft", title="Strategy", c("leftmost", "ff and ffc"), fill=c("red", "green"))
axis(1, c(0,1,2,4,8,16,24,32,40,48,56,64,72,80,88),
	c("0","1","2","4","8","16","24","32","40","48","56","64","72","80","88"))
title("Average number of assumptions in search for solution")
dev.off()


# Plot time boxplot
pdf(file = "ff_time.pdf")
boxplot(data$ff.first.runtime.mean~data$size)
title("Time with strategy ff")
dev.off()

boxplot(data$leftmost.first.runtime.mean~data$size)
boxplot(data$ffc.first.runtime.mean~data$size)

# Plot assumptions boxplot
pdf(file = "ff_assumptions.pdf")
boxplot(dataSolved$ff.first.assumptions~dataSolved$size)
title("Assumptions with strategy ff")
dev.off()

boxplot(dataSolved$leftmost.first.assumptions~dataSolved$size)
boxplot(dataSolved$ffc.first.assumptions~dataSolved$size)

