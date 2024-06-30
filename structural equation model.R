#调用用于建模的R包
#install.packages(lavaan)
library(lavaan) 
#读取自己的数据
Mydata<-read.csv(file.choose(),header=T)
head(Mydata)
#第一步，照猫画虎构建文章4中所示的模型
model<- '
# 利用被测变量(右)定义潜在变量(左)：测量模型。意思就是这几个指标构成了它们
#定义潜变量
DH =~ CAO + MGO +SIO2
#主要回归方程
PRE ~ HFL
TEM ~ HFL
VPD ~ HFL
DC ~ HFL
DH ~ HFL
SLOP ~ HFL '


#适配模型
fit <- sem(model, data = Mydata)
#查看拟合结果
summary(fit)
summary(fit, fit.measures=TRUE)
summary(fit, standardized = TRUE)

#计算拟合系数
fitMeasures(fit,c("chisq","df","pvalue","gfi","cfi","rmr","srmr","rmsea"))

