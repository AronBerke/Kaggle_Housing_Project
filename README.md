# Kaggle Housing Project

## Introduction
For one of its competitions focusing on creative feature engineering and advanced regression techniques, Kaggle publishes a dataset containing prices for ~1400 homes in Ames, Iowa and 79 explanatory variables (https://www.kaggle.com/c/house-prices-advanced-regression-techniques). Our team participated in this competiton in order to gain experience with feature engineering, regularized regression, and tree-based models. The results are contained in this repository.

## Creation
This code was written by Aron Berke, Ashish Sharma, Austin Cheng, and Gabriel Corbal to be used for non-commercial (academic in nature) purposes.

## Layout
The EDA, Processing, and Modeling folder contains all code associated with this project. Jupyter notebooks are divided by different transformations applied to the dataset and constituent steps in the machine learning process. The letters (A-E+) at the beginning of each notebook file identify datasets that have been processed in a distinct way (e.g., various imputation, cleaning, and feature engineering), while the number and name of notebook identifies the step in the ML process for the associated dataset. The general workflow is as follows: A1, A2,...,E3,E4.

In addition, this repository includes an ensemble model that produces predictions based on a weighted average of the outputs from various regularized regression and tree-based models, taking the 'best' dataset from the above-referenced process as the input.

## Final Output
Please feel free to email us if you'd like to view a copy of the presentation associated with this project.
