# Users, Cards, and Transactions Database

This project provides SQL scripts to manage and analyze user, credit card, and transaction data. The scripts handle data cleaning, type conversion, and analytics queries.

---

## Tables

1. **users_data**  
   Stores information about users.
   Columns include:
   - `id` (primary key)
   - `current_age`
   - `retirement_Age`
   - `birth_year`
   - `birth_month`
   - `gender`
   -  `address`
   -  `latitude`
   -   `longitude`
   - `per_capita_income`
   -  `yearly_income`
   -   `total_debt`
   - `credit_score`
   -  `num_credit_cards` 

3. **cards_data**  
   Stores information about credit cards.
   Columns include:
   - `id` (primary key)
   - `client_id`
   - `card_brand`
   - `card_type`
   - `card_number`
   - `expires`
   - `cvv`
   - `has_chip`
   - `num_cards_issued`
   - `credit_limit`
   - `acct_open_date`
   - `year_pin_last_changed`
   - `card_on_dark_web`

5. **transaction_data**  
   Stores information about transactions.
   - `id` (primary key)
   - `date`
   - `client_id`
   - `card_id`
   - `amount`
   - `use_chip`
   - `merchant_id`
   - `merchant_city`
   - `merchant_state`
   - `zip`
   - `mcc`
   - `errors`

## Data Cleaning and Transformation

- Convert string-based numeric columns (`per_capita_income`, `yearly_income`, `total_debt`, `amount`, `credit_limit`) to numeric types.  
- Remove old string columns after cleaning.  
- Rename cleaned columns for consistency.
- Handle `$` and `,` in numeric fields.

## Analytics Queries
The scripts include queries to:
- Count transactions per card brand.  
- Analyze distribution of payment methods.  
- Identify most common transaction errors.  
- Top 10 merchant cities by transaction volume.  
- Segment users by age groups.  
- Count card types.  
- Analyze yearly transaction trends including total transaction amount.

## How to Run

1. Create table creation statements:

```sql
-- users_data
CREATE TABLE users_data (
   id int primary key,
   current_age int,
   retirement_age int,
   birth_year int,
   birth_month int,
   gender varchar(10),
   address varchar(250),
   latitude float,
   longitude float,
   per_capita_income varchar(20),
   yearly_income varchar(20),
   total_debt varchar(20),
   credit_score int,
   num_credit_cards int
);

-- cards_data
CREATE TABLE cards_data (
   id int primary key,
   client_id int references users_data(id),
   card_brand varchar(30),
   card_type varchar(30),
   card_number varchar(50) unique,
   expires varchar(10),
   cvv varchar(10),
   has_chip boolean,
   num_cards_issued int,
   credit_limit varchar(20),
   acct_open_date varchar(10),               
   year_pin_last_changed int,
   card_on_dark_web boolean
);

-- transaction_data
CREATE TABLE transaction_data (
   id int primary key,
    date timestamp,                   
    client_id int references users_data(id),
    card_id int references cards_data(id),
    amount varchar(20),          
    use_chip varchar(30),
    merchant_id int,
    merchant_city varchar(50),
    merchant_state varchar(50),
    zip varchar(10),
    mcc int,
    errors varchar(250)
);
```

2. Clean and Transform Data:

```sql
-- users_data
alter table users_data
    add column per_capita_incomee bigint,
    add column yearly_incomee bigint,
    add column total_debtt bigint;
update users_data
    set 
        per_capita_incomee = replace(replace(per_capita_income, '$', ''), ',', '')::bigint,
        yearly_incomee = replace(replace(yearly_income, '$', ''), ',', '')::bigint,
        total_debtt = replace(replace(total_debt, '$', ''), ',', '')::bigint;
alter table users_data
    drop column per_capita_income,
    drop column yearly_income,
    drop column total_debt;
alter table users_data
    rename column per_capita_incomee to per_capita_income,
    rename column yearly_incomee to yearly_income,
    rename column total_debtt to total_debt;

-- cards_data
alter table cards_data
    add column credit_limitt bigint;
update cards_data
    set credit_limitt = replace(replace(credit_limit, '$', ''), ',', '')::bigint;
alter table cards_data
    drop column credit_limit;
alter table cards_data
    rename column credit_limitt to credit_limit;

-- transaction_data
alter table transaction_data
    add column amount_num numeric;
update transaction_data
    set amount_num = cast(replace(replace(amount, '$', ''), ',', '') as numeric);
alter table transaction_data
    drop column amount;
alter table transaction_data
    rename column amount_num to amount;
```

3. Run the analytics queries to generate reports:

```sql
-- transactions by card brand
select c.card_brand,
       count(t.id) as total_transactions
from cards_data c
left join transaction_data t on c.id = t.card_id
group by c.card_brand
order by total_transactions desc;

-- Distribution of payment methods
select use_chip as payment_method, 
count(*) as total_transactions
from transaction_data
group by use_chip;

-- Most common transaction errors
select errors, count(*) as num_transactions
from transaction_data
group by errors
order by num_transactions desc;

-- Top 10 cities by transaction volume
select 
    merchant_city,
    count(id) as total_transactions
from transaction_data
group by merchant_city
order by total_transactions desc
limit 10;

-- Segment users by age group
select 
    case 
        when current_age between 18 and 25 then '18-25'
        when current_age between 26 and 35 then '26-35'
        when current_age between 36 and 45 then '36-45'
        when current_age between 46 and 55 then '46-55'
        when current_age between 56 and 65 then '56-65'
        else '65+' 
    end as age_group,
    count(*) as num_users
from users_data
group by age_group
order by age_group;

-- Distribution of card types
select 
    card_type,
    count(*) as total_cards
from cards_data
group by card_type
order by total_cards desc;

-- Yearly transactions and total amount
select 
    extract(year from date) as year,
    count(*) as total_transactions,
    sum(amount) as total_amount
from transaction_data
group by extract(year from date)
order by year;
```

## Notes

- Currency fields are assumed to be in USD.
- Data must be imported before running queries.
- Scripts handle cleaning `$` and `,` from numeric fields.
- Ensure that foreign key references are consistent:
 (`cards_data.client_id → users_data.id` and `transaction_data.card_id → cards_data.id`).


