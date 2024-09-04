# HR Analytics Project

## Overview
This project involves analyzing employee data to gain insights into employee attrition, performance ratings, and job satisfaction. The analysis focuses on understanding the factors influencing employee turnover and the relationship between employee ratings and satisfaction.

## Project Structure

### Data Files
- **Employee.csv**: Contains employee details.
- **PerformanceRating.csv**: Contains performance ratings data.
- **EducationLevel.csv**: Contains education level information.
- **SatisfiedLevel.csv**: Contains satisfaction level information.
- **RatingLevel.csv**: Contains rating levels information.

### SQL Scripts
- **attrition_analysis.sql**: SQL script for attrition analysis.
- **performance_analysis.sql**: SQL script for performance and satisfaction analysis.

### Reports
- **HR_Analytics_Report.pdf**: Detailed report with insights, findings, and recommendations.

## Analysis Summary


### 1. Attrition Analysis
- **Objective**: Analyze employee attrition by gender, age, marital status, job role, department, and other factors.
- **Key Findings**:
  - **Attrition Rate**: High attrition rates are observed among younger employees (18-29 years) and those in the Sales and Technology departments.
  - **Gender**: The attrition rate is similar between males and females.
  - **Marital Status**: Single employees have a higher attrition rate (54%).
  - **Job Role**: Data Scientists, Sales Executives, and Software Engineers show the highest attrition rates.
  - **Overtime**: Employees with overtime have a slightly higher attrition rate, but those without overtime are more likely to leave.
  - **State**: California (CA) has the highest attrition rate (63%).

### 2. Performance and Satisfaction Analysis
- **Objective**: Explore the relationship between self-ratings, manager ratings, and overall job satisfaction.
- **Key Findings**:
  - **Self vs. Manager Ratings**: Average self-rating is 3.98, while average manager rating is 3.47. The correlation between self-ratings and manager ratings is high (0.854), indicating a strong positive relationship.
  - **Overall Satisfaction**: The combined satisfaction score (3.24) has a very weak correlation (-0.008) with manager ratings, suggesting little to no linear relationship between overall employee satisfaction and manager ratings.

### 3. Training Opportunities
- **Objective**: Assess the impact of training opportunities on employee performance.
- **Key Findings**:
  - **Training Impact**: There is no significant correlation between the number of training opportunities taken and manager ratings.

## Questions and Answers

- **Are self-ratings aligned with manager ratings?**
  - **Answer**: Self-ratings average at 3.98, while manager ratings average at 3.47. There is a strong positive correlation (0.854) between the two, indicating that higher self-ratings often correspond with higher manager ratings, but the ratings are not exactly aligned.

- **How do job satisfaction and environment satisfaction correlate with performance ratings?**
  - **Answer**: Job Satisfaction, Environment Satisfaction, and Relationship Satisfaction averages are 3.87, 3.43, and 3.43, respectively. The combined average satisfaction score is 3.24. This score shows a very weak correlation (-0.008) with manager ratings.

- **How do training opportunities impact employee performance?**
  - **Answer**: No significant correlation was found between the number of training opportunities taken and manager ratings.

## How to Run the Analysis

1. **Perform Analysis**:
   - Use the SQL scripts provided to execute queries and generate insights.

2. **Generate Reports**:
   - Review the findings in `HR_Analytics_Report.pdf` for detailed insights and recommendations.

## Tools Used
- **Database**: PostgreSQL
- **Data Analysis**: SQL
- **Reporting**: Microsoft Word 


