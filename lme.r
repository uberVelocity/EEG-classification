library(R.matlab);
library(lme4);
library(languageR);
library(dplyr);
setwd("C:/Users/redth/Documents/University/Bachelor/git/bachelor-project/data_files")

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
