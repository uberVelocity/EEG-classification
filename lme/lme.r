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

# Split beginners from experienced
final_data_clean_beginners = final_data_clean[72407:length(final_data_clean$isExp), 1:99];
final_data_clean_experienced = final_data_clean[1:72406, 1:99];

# convert cell array into matrix
final_data_matrix_beginners = as.matrix(sapply(final_data_clean_beginners, as.numeric));
final_data_matrix_experienced = as.matrix(sapply(final_data_clean_experienced, as.numeric));

# split beginners by frequency
# init alpha matrix
final_data_clean_beginners_alpha = matrix(nrow = length(final_data_clean_beginners$`alpha 1`), ncol = 32);

# save clean beginner alpha as matrix
for (column in 1:32) {
  final_data_clean_beginners_alpha[, column] <- final_data_matrix_beginners[, column+3];
}

# init beta matrix
final_data_clean_beginners_beta = matrix(nrow = length(final_data_clean_beginners$`beta 1`), ncol = 32);

# save clean beginner beta as matrix
for (column in 1:32) {
  final_data_clean_beginners_beta[, column] <- final_data_matrix_beginners[, column+35];
}

# init theta matrix
final_data_clean_beginners_theta = matrix(nrow = length(final_data_clean_beginners$`theta 1`), ncol = 32);

# save clean beginner theta as matrix
for (column in 1:32) {
  final_data_clean_beginners_theta[, column] <- final_data_matrix_beginners[, column+67];
}

# init clean beginner anger alpha
final_data_clean_beginners_anger_alpha = matrix(nrow = 2150, ncol = 32);

# save clean beginner anger alpha as matrix
for (column in 1:32) {
  final_data_clean_beginners_anger_alpha[, column] <- final_data_matrix_beginners[which(final_data_clean_beginners$anger == 1), column+3];
}

# init clean beginner anger beta
final_data_clean_beginners_anger_beta = matrix(nrow = 2150, ncol = 32);

# save clean beginner anger beta as matrix
for (column in 1:32) {
  final_data_clean_beginners_anger_beta[, column] <- final_data_matrix_beginners[which(final_data_clean_beginners$anger == 1), column + 35];
}

# init clean beginner anger theta
final_data_clean_beginners_anger_theta = matrix(nrow = 2150, ncol = 32);

# save clean beginner anger theta as matrix
for (column in 1:32) {
  final_data_clean_beginners_anger_theta[, column] <- final_data_matrix_beginners[which(final_data_clean_beginners$anger == 1), column+67];
}

########################################################################
# init clean beginner anger alpha 
final_data_clean_beginners_anger_alpha = matrix(nrow = 2150, ncol = 32);

# save clean beginner anger alpha as matrix
for (column in 1:32) {
  final_data_clean_beginners_anger_alpha[, column] <- final_data_matrix_beginners[which(final_data_clean_beginners$anger == 1), column+3];
}

# init clean beginner anger beta
final_data_clean_beginners_anger_beta = matrix(nrow = 2150, ncol = 32);

# save clean beginner anger beta as matrix
for (column in 1:32) {
  final_data_clean_beginners_anger_beta[, column] <- final_data_matrix_beginners[which(final_data_clean_beginners$anger == 1), column + 35];
}

# init clean beginner anger theta
final_data_clean_beginners_anger_theta = matrix(nrow = 2150, ncol = 32);

# save clean beginner anger theta as matrix
for (column in 1:32) {
  final_data_clean_beginners_anger_theta[, column] <- final_data_matrix_beginners[which(final_data_clean_beginners$anger == 1), column+67];
}
##########################################################################
# save clean beginner non-angry alpha

final_data_clean_beginners_peace_alpha = matrix(nrow = 80055, ncol = 32);
final_data_clean_beginners_peace_beta = matrix(nrow = 80055, ncol = 32);
final_data_clean_beginners_peace_theta = matrix(nrow = 80055, ncol = 32);

for (column in 1:32) {
  final_data_clean_beginners_peace_alpha[, column] <- final_data_matrix_beginners[which(final_data_clean_beginners$anger == 0), column+3];
  final_data_clean_beginners_peace_beta[, column] <- final_data_matrix_beginners[which(final_data_clean_beginners$anger == 0), column+35];
  final_data_clean_beginners_peace_theta[, column] <- final_data_matrix_beginners[which(final_data_clean_beginners$anger == 0), column+67];
}
###########################################################

final_data_clean_experienced_anger_alpha = matrix(nrow = 1701, ncol = 32);
final_data_clean_experienced_anger_beta = matrix(nrow = 1701, ncol = 32);
final_data_clean_experienced_anger_theta = matrix(nrow = 1701, ncol = 32);

for (column in 1:32) {
  final_data_clean_experienced_anger_alpha[, column] <- final_data_matrix_experienced[which(final_data_clean_experienced$anger == 1), column + 3];
  final_data_clean_experienced_anger_beta[, column] <- final_data_matrix_experienced[which(final_data_clean_experienced$anger == 1), column + 35];
  final_data_clean_experienced_anger_theta[, column] <- final_data_matrix_experienced[which(final_data_clean_experienced$anger == 1), column + 67];
}

final_data_clean_experienced_nonanger_alpha = matrix(nrow = 70705, ncol = 32);
final_data_clean_experienced_nonanger_beta = matrix(nrow = 70705, ncol = 32);
final_data_clean_experienced_nonanger_theta = matrix(nrow = 70705, ncol = 32);

for (column in 1:32) {
  final_data_clean_experienced_nonanger_alpha[, column] <- final_data_matrix_experienced[which(final_data_clean_experienced$anger == 0), column + 3];
  final_data_clean_experienced_nonanger_beta[, column] <- final_data_matrix_experienced[which(final_data_clean_experienced$anger == 0), column + 35];
  final_data_clean_experienced_nonanger_theta[, column] <- final_data_matrix_experienced[which(final_data_clean_experienced$anger == 0), column + 67];
}

# save matrices
write.csv(final_data_clean_beginners_anger_alpha, file = "angryBeginnersAlpha.csv");
write.csv(final_data_clean_beginners_anger_beta, file = "angryBeginnersBeta.csv");
write.csv(final_data_clean_beginners_anger_theta, file = "angryBeginneresTheta.csv");

write.csv(final_data_clean_beginners_peace_alpha, file = "nonangryBeginnersAlpha.csv");
write.csv(final_data_clean_beginners_peace_beta, file = "nonangryBeginnersBeta.csv");
write.csv(final_data_clean_beginners_peace_theta, file = "nonangryBeginnersTheta.csv");

write.csv(final_data_clean_experienced_anger_alpha, file = "angryExperiencedAlpha.csv");
write.csv(final_data_clean_experienced_anger_beta, file = "angryExperiencedBeta.csv");
write.csv(final_data_clean_experienced_anger_theta, file = "angryExperiencedTheta.csv");

write.csv(final_data_clean_experienced_nonanger_alpha, file = "nonangryExperiencedAlpha.csv");
write.csv(final_data_clean_experienced_nonanger_beta, file = "nonangryExperiencedBeta.csv");
write.csv(final_data_clean_experienced_nonanger_theta, file = "nonangryExperiencedTheta.csv");

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
