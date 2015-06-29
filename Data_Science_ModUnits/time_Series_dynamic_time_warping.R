library(dtw)

## A noisy sine wave as query
idx<-seq(0,6.28,len=100);
query<-sin(idx)+runif(100)/10;

query

## A cosine is for reference; sin and cos are offset by 25 samples
reference<-cos(idx)
plot(reference); lines(query,col="blue");

## Find the best match
alignment<-dtw(query,reference);


## Display the mapping, AKA warping function - may be multiple-valued
## Equivalent to: plot(alignment,type="alignment")
plot(alignment$index1,alignment$index2,main="Warping function");

## Confirm: 25 samples off-diagonal alignment
lines(1:100-25,col="red")




library("dtw")
data("aami3a")
ref <- window(aami3a,start=0,end=2)
plot(ref)
test <- window(aami3a,start=2.7,end=5)
plot(test)
plot(ref); lines(test,col="blue");
plot(dtw(query,reference,k=TRUE),type="two",off=1,match.lty=2,match.indices=20)


topicA<-c(6,
          5.94,
          5.8806,
          4.057614,
          4.01703786,
          3.976867481,
          2.744038562,
          2.716598177,
          2.689432195,
          1.855708214,
          1.837151132,
          1.818779621,
          1.254957938,
          1.242408359,
          1.229984275,
          0.84868915)
plot(topicA)

topicB<-c(6,
          5.94,
          5.8806,
          5.821794,
          5.76357606,
          5.705940299,
          3.937098807,
          3.897727819,
          3.85875054,
          3.820163035,
          3.781961405,
          3.744141791,
          2.583457835,
          2.557623257,
          2.532047025,
          2.506726554
)
plot(topicB)


library("dtw")
plot(test)
plot(ref); lines(test,col="blue");
plot(dtw(topicB,topicA,k=TRUE),type="two",off=1,match.lty=2,match.indices=20)

plot(dtw(topicB,topicA,k=TRUE),type="two",match.lty=2,match.indices=20)




