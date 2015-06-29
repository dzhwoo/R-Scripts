
data(pressure)
data<-pressure

fit<-loess(data$pressure ~ data$temperature, data = data)

plot(data$pressure ~ data$temperature, data=data,pch=19,cex=0.1)
j <- order(data$pressure)
lines(data$pressure[j],fit$fitted[j],col="red",lwd=3)


cars.lo <- loess(dist ~ speed, cars, span =0.2)
#predict(cars.lo, data.frame(speed = seq(5, 30, 1)), se = TRUE)

plot(dist ~ speed, data=cars,pch=19,cex=0.1)
j <- order(cars$speed)
lines(cars$speed[j],cars.lo$fitted[j],col="red",lwd=3)

predict(cars.lo2, data.frame(speed = seq(5, 30, 1)), se = TRUE)