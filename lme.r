library(R.matlab);
library(lme4);
library(nlme);
library(languageR);
library(dplyr);
require(MASS);
library(lmerTest);
setwd("C:/Users/redth/Documents/University/Bachelor/git/bachelor-project/data_files")

findOutlier <- function(data, cutoff = 3) {
  ## Calculate the sd
  sds <- apply(data, 2, sd, na.rm = TRUE)
  ## Identify the cells with value greater than cutoff * sd (column wise)
  result <- mapply(function(d, s) {
    which(d > cutoff * s)
  }, data, sds)
  result
}

removeOutlier <- function(data, outliers) {
  result <- mapply(function(d, o) {
    res <- d
    res[o] <- NA
    return(res)
  }, data, outliers)
  return(as.data.frame(result))
}

# data$alphaResults[1,] returns all values on row 1.
# data$alphaResults[,1] returns al values on column 1.

id = data[["id"]][,];
anger = data[["anger"]][,];
isExp = data[["isExp"]][,];

df <- data.frame("id" = id, "anger" = anger, "isExp" = isExp);
transposed_alpha <- data$alphaResults;
transposed_alpha <- t(transposed_alpha);

transposed_beta <- data$betaResults;
transposed_beta <- t(transposed_beta);

transposed_theta <- data$thetaResults;
transposed_theta <- t(transposed_theta);



alpha_frame <- as.data.frame(transposed_alpha);
beta_frame <- as.data.frame(transposed_beta);
theta_frame <- as.data.frame(transposed_theta);

alphaname <- seq(1, 32, by=1);
betaname <- seq(1, 32, by=1);
thetaname<- seq(1, 32, by=1);

for (index in 1:32) {
  alphaname[index] <- paste("alpha", alphaname[index]);
  betaname[index] <- paste("beta", betaname[index]);
  thetaname[index] <- paste("theta", thetaname[index]);
}

colnames(alpha_frame) <- alphaname;
colnames(beta_frame) <- betaname;
colnames(theta_frame) <- thetaname;

new <- cbind(df, alpha_frame);
new2 <- cbind(new, beta_frame);
final_data <- cbind(new2, theta_frame);

saveRDS(final_data, file = "final_data.rds");

boxplot(`theta 1` ~ anger, data = final_data, outline = TRUE);

final_data.model = lmer(`alpha 1` ~ anger*isExp + (1|id), data = final_data);
summary(final_data.model)
anova(final_data.model);

qqnorm(final_data$`alpha 1`, pch = 1, frame = FALSE)
qqline(final_data$`alpha 1`, col = "steelblue", lwd = 2)
plot(fitted(final_data.model), residuals(final_data.model))

