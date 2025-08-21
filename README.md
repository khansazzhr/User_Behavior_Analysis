# User Behavior Data Analysis

This project analyzes user behavior using three datasets: users, cards, and transactions.  
The workflow includes SQL for data preparation, exploratory analysis, and Looker dashboards for interactive insights into demographics, card usage, and transaction trends.

---

## Objectives
To understand user behavior, card usage patterns, and transaction trends by analyzing historical datasets.

---

## Business Questions

### Demographics (User Profile)
1. Which age group is dominant, and what does this imply for target audiences?  

### Transaction Behavior
2. What are users’ preferred payment methods?  
3. Which card brands are most frequently used?  
4. Which cities record the highest transaction volumes?  

### Trends & Quality
5. What are the yearly trends in transaction volume and amounts?  
6. Which transaction errors occur most frequently, and how do they affect user experience?  

---

## Data Sources

### Raw Datasets
- `users_data.csv`  
- `cards_data.csv`  
- `transactions_data.csv`  

### Processed Outputs (via SQL queries)
- `transactions_per_year.csv`  
- `transactions_per_city.csv`  
- `card_brands.csv`
- `cards_type.csv`  
- `transaction_errors.csv`  
- `age_groups.csv`  
- `preferred_payments.csv`  

---

## Tools & Technologies
- **SQL** → Data preparation & transformation  
- **Looker** → Interactive dashboard & visualization  
- **GitHub** → Version control & project documentation  

---

## How to Use
1. Run SQL queries to extract and preprocess the datasets.  
2. Export the processed tables as CSV files.  
3. Import the CSV files into Looker.  
4. Build dashboards to visualize user demographics, transaction trends, and error analysis.
   
---

## Key Insights
- **User Demographics:** The user base is concentrated within specific age groups, highlighting potential target market segments.  
- **Card & Payment Usage:** Certain card brands and payment methods dominate, informing partnership and marketing strategies.  
- **Geographic Trends:** Higher transaction volumes are concentrated in particular cities, reflecting regional business activity.  
- **Error Analysis:** The most common errors (e.g., insufficient balance) impact user experience and indicate opportunities for system improvements.

---

## Dashboard Preview
https://lookerstudio.google.com/reporting/9607329c-64b3-4940-bf20-5e49d6607c3c
