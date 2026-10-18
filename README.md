# Interactive-REM-Sleep-Prediction-Dashboard
[![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-0048DA?style=for-the-badge&logo=rstudio&logoColor=white)](https://shiny.rstudio.com/)

**Live Application:** [View the interactive dashboard here](https://petros-christ-03.shinyapps.io/Rem-Sleep-App/)

## 📖 Overview
This repository contains the code and dataset for an interactive web application built with R and Shiny. The app utilizes a **Multiple Linear Regression** model to predict a patient's Rapid Eye Movement (REM) sleep percentage based on demographic and clinical variables. 

The project goes beyond a simple calculator by offering an end-to-end Data Science workflow, including Exploratory Data Analysis (EDA) and rigorous statistical model diagnostics.

## ✨ Key Features
The dashboard is divided into three main sections:
*   **REM Sleep Calculator:** A clinical-style tool where users can input patient data (Age, Awakening Index, Neck Circumference, Alcohol Consumption). It outputs the predicted REM sleep percentage.
*   **Interactive Data Analysis:** Powered by `plotly`, this tab features interactive scatter plots exploring the negative correlation between the Awakening Index (AI) and REM sleep.
*   **Model Evaluation & Diagnostics:** Transparent display of the regression model's assumptions. It includes Q-Q plots and Residuals vs. Fitted plots to visually confirm normality, linearity, and homoscedasticity.

## 📊 Statistical Insights & Suppressor Effect
A key analytical highlight of this project is the handling and interpretation of a statistical **suppressor effect**. 

During the stepwise variable selection (which improved the Adjusted R² from 0.11 to 0.16 after outlier removal), Neck Circumference emerged as a statistically significant positive predictor. Clinically, a larger neck circumference often leads to sleep apnea (worse sleep). However, the regression model evaluates this *ceteris paribus*. The negative clinical impact of a larger neck is entirely absorbed by the AI variable, leaving the neck circumference coefficient to capture a different, isolated mathematical effect.

## 🛠️ Tech Stack
*   **Language:** R
*   **Framework:** Shiny
*   **UI/UX:** `bslib` (Flatly theme)
*   **Data Visualization:** `ggplot2`, `plotly`
*   **Statistical Modeling:** Base R (`lm`, `predict` with prediction intervals)

## 🚀 How to Run Locally
To run this application on your local machine:
1. Clone this repository.
2. Ensure you have the `04_sleep.csv` dataset in the same directory as the script.
3. Install the required R packages:
   ```R
   install.packages(c("shiny", "bslib", "ggplot2", "plotly"))
