create table users_data (
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

create table cards_data (
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

create table transaction_data (
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

-- Menambah kolom baru dengan tipe data numeric
alter table users_data
    add column per_capita_incomee bigint,
    add column yearly_incomee bigint,
    add column total_debtt bigint;

-- Bersihkan data dan isi ke kolom baru
update users_data
    set 
        per_capita_incomee = replace(replace(per_capita_income, '$', ''), ',', '')::bigint,
        yearly_incomee = replace(replace(yearly_income, '$', ''), ',', '')::bigint,
        total_debtt = replace(replace(total_debt, '$', ''), ',', '')::bigint;

-- Menghapus kolom lama yang sudah tidak digunakan
alter table users_data
    drop column per_capita_income,
    drop column yearly_income,
    drop column total_debt;

-- Mengganti nama kolom agar lebih sesuai
alter table users_data
    rename column per_capita_incomee to per_capita_income,
    rename column yearly_incomee to yearly_income,
    rename column total_debtt to total_debt;

-- Menambah kolom amount_num di tabel transaction_data
alter table transaction_data
    add column amount_num numeric;

-- Mengupdate nilai amount_num dengan nilai yang sudah dibersihkan
update transaction_data
    set amount_num = cast(replace(replace(amount, '$', ''), ',', '') as numeric);

-- Menghapus kolom amount lama yang sudah tidak digunakan
alter table transaction_data
    drop column amount;

-- Mengganti nama kolom amount_num menjadi amount
alter table transaction_data
    rename column amount_num to amount;

-- Menambah kolom credit_limitt pada tabel cards_data
alter table cards_data
    add column credit_limitt bigint;

-- Mengupdate nilai credit_limitt dengan data yang sudah dibersihkan
update cards_data
    set credit_limitt = replace(replace(credit_limit, '$', ''), ',', '')::bigint;

-- Menghapus kolom credit_limit lama yang sudah tidak digunakan
alter table cards_data
    drop column credit_limit;

-- Mengganti nama kolom credit_limitt menjadi credit_limit
alter table cards_data
    rename column credit_limitt to credit_limit;

-- Menghitung jumlah transaksi berdasarkan brand kartu
select c.card_brand,
       count(t.id) as total_transactions
from cards_data c
left join transaction_data t on c.id = t.card_id
group by c.card_brand
order by total_transactions desc;

-- Menghitung distribusi metode pembayaran
select use_chip as payment_method, 
count(*) as total_transactions
from transaction_data
group by use_chip;

-- Menghitung jenis error transaksi paling sering terjadi
select errors, count(*) as num_transactions
from transaction_data
group by errors
order by num_transactions desc;

-- Top 10 kota berdasarkan by Transaction Volume
select 
    merchant_city,
    count(id) as total_transactions
from transaction_data
group by merchant_city
order by total_transactions desc
limit 10;

-- Segmentasi user berdasarkan kelompok umur
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

-- Menghitung distribusi card type
select 
    card_type,
    count(*) as total_cards
from cards_data
group by card_type
order by total_cards desc;

-- Transaksi per Tahun dan tren amount
select 
    extract(year from date) as year,
    count(*) as total_transactions,
    sum(amount) as total_amount
from transaction_data
group by extract(year from date)
order by year;
