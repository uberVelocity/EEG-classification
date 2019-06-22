# Import required libraries.
library(R.matlab);
library(lme4);
library(nlme);
library(languageR);
library(dplyr);
require(MASS);
library(lmerTest);

# Set working directory.
setwd("C:/Users/redth/Documents/University/Bachelor/git/bachelor-project/data_files")

# Computes standard deviation by columns.
sdCol <- function(data) {
  return(sd(data, na.rm = TRUE));
}

# Construct data frame.
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

cpy <- cbind(alpha_frame, beta_frame);
valuebinds <- cbind(cpy, theta_frame);
means <- colMeans(valuebinds, na.rm = TRUE);
sds <- apply(valuebinds, 2, sdCol);

pb <- txtProgressBar(min = 0, max = 96, initial = 0, char = "=",
               width = NA);
# Remove outliers from data. An outlier is any value that is 5 standard deviations from the mean.
clean_values = valuebinds
replaced = 0;
for(index in 1:96) {
  for (jindex in 1:154611) {
    if (!is.nan(valuebinds[[index]][jindex]) && (abs(means[index] - valuebinds[[index]][jindex])/sds[index]) >= 5) {
      replaced = replaced + 1;
      clean_values[[index]][jindex] = NaN;
    }
    setTxtProgressBar(pb, index)
  }
}

# Final_data_clean is the that used to compute the Linear-Mixed-Effects model.
final_data_clean <- cbind(df, clean_values);
final_data_clean$id <- as.factor(final_data_clean$id);
final_data_clean$anger <- as.factor(final_data_clean$anger);
final_data_clean$isExp <- as.factor(final_data_clean$isExp);

boxplot(`alpha 1` ~ isExp*anger, data = final_data_clean, outline = FALSE);

final_data_clean.model.alpha = lmer(`alpha 1` ~ isExp*anger + (1|id), data = final_data_clean);
final_data_clean.model.beta = lmer(`beta 1` ~ isExp*anger + (1|id), data = final_data_clean);
final_data_clean.model.theta = lmer(`theta 1` ~ isExp*anger + (1|id), data = final_data_clean);

boxplot(`` ~ anger*isExp, data = final_data_clean, outline = FALSE);

final_data_cleam.model.alpha.1 = summary(final_data_clean.model.alpha)
summary(final_data_clean.model.alpha)
anova(final_data_clean.model.alpha);
final_data_clean.model.beta.1 = summary(final_data_clean.model.beta)
summary(final_data_clean.model.beta)
anova(final_data_clean.model.beta);
final_data_clean.model.theta.1 = summary(final_data_clean.model.theta)
summary(final_data_clean.model.theta)
anova(final_data_clean.model.theta);

final_data_clean_beginners.alpha = lmer(`alpha 2` ~ anger + (1|id), data = final_data_clean_beginners);
summary(final_data_clean_beginners.alpha);
anova(final_data_clean_beginners.alpha);
final_data_clean_beginners.beta = lmer(`beta 2` ~ anger + (1|id), data = final_data_clean_beginners);
summary(final_data_clean_beginners.beta);
anova(final_data_clean_beginners.beta);
final_data_clean_beginners.theta = lmer(`theta 2` ~ anger + (1|id), data = final_data_clean_beginners);
summary(final_data_clean_beginners.theta);
anova(final_data_clean_beginners.theta);

final_data_clean_experienced.alpha = lmer(`alpha 2` ~ anger + (1|id), data = final_data_clean_experienced);
summary(final_data_clean_experienced.alpha);
anova(final_data_clean_experienced.alpha);
final_data_clean_experienced.beta = lmer(`beta 2` ~ anger + (1|id), data = final_data_clean_experienced);
summary(final_data_clean_experienced.beta);
anova(final_data_clean_experienced.beta);
final_data_clean_experienced.theta = lmer(`theta 2` ~ anger + (1|id), data = final_data_clean_experienced);
summary(final_data_clean_experienced.theta);
anova(final_data_clean_experienced.theta);

# Split beginners from experienced
final_data_clean_beginners = final_data_clean[72407:length(final_data_clean$isExp), 1:99];
final_data_clean_experienced = final_data_clean[1:72406, 1:99];

final_anger_experienced_sample = final_data_clean_experienced[sample(which(final_data_clean_experienced$anger == 1), 2150),];
final_peace_experienced_sample = final_data_clean_experienced[sample(which(final_data_clean_experienced$anger == 0), 2150),];

final_data_clean_beginners.alpha = lmer(`alpha 32` ~ anger + (1|id), data = final_data_clean_beginners);
final_data_clean_beginners.beta = lmer(`beta 32` ~ anger + (1|id), data = final_data_clean_beginners);
final_data_clean_beginners.theta = lmer(`theta 32` ~ anger + (1|id), data = final_data_clean_beginners);

final_data_clean_beginners.alpha.32 = summary(final_data_clean_beginners.alpha)
summary(final_data_clean_beginners.alpha)
anova(final_data_clean_beginners.alpha);
final_data_clean.beginners.beta.32 = summary(final_data_clean_beginners.beta)
summary(final_data_clean_beginners.beta)
anova(final_data_clean_beginners.beta);
final_data_clean_beginners.theta.32 = summary(final_data_clean_beginners)
summary(final_data_clean_beginners.theta)
anova(final_data_clean_beginners.theta);


final_data_clean_experienced.alpha = lmer(`alpha 32` ~ anger + (1|id), data = final_data_clean_experienced);
final_data_clean_experienced.beta = lmer(`beta 32` ~ anger + (1|id), data = final_data_clean_experienced);
final_data_clean_experienced.theta = lmer(`theta 32` ~ anger + (1|id), data = final_data_clean_experienced);

final_data_clean_experienced.alpha.32 = summary(final_data_clean_experienced.alpha)
summary(final_data_clean_experienced.alpha)
anova(final_data_clean_experienced.alpha);
final_data_clean_experienced.beta.32 = summary(final_data_clean_experienced.beta)
summary(final_data_clean_experienced.beta)
anova(final_data_clean_experienced.beta);
final_data_clean_experienced.theta.32 = summary(final_data_clean_experienced.theta)
summary(final_data_clean_experienced.theta)
anova(final_data_clean_experienced.theta);
