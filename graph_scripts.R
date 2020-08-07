png("plots/1. Histogram_ramp_starts.png")
hist(x = grouped_selected$Max.Time, xlab = "Start time of max ramp for the day", main = "Histogram of start times of maximum ramp period")
dev.off()
plot.new()

