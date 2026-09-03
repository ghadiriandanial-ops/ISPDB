create table subscriber (    
sub_id int GENERATED ALWAYS AS IDENTITY (START WITH 100000 INCREMENT BY 1) primary key,
national_id varchar(10) unique not null,
sub_email varchar(100) ,
sub_full_name varchar(50),
sub_status boolean default false,
sub_date date default current_date,
sub_address text not null,
pass varchar(30) not null,
phone_num char(11),

constraint check_national_id_len
check (national_id ~ '^[0-9]{10}$'),
constraint check_email_format
CHECK (sub_email LIKE '%@%.%'),
CONSTRAINT chk_address_length
CHECK (length(trim(sub_address)) >= 10),
CONSTRAINT check_len_pass 
check (length(trim(pass)) > 8)
);
CREATE TYPE payment_status_enum AS ENUM (
    'در انتظار پرداخت',
    'پرداخت شده',
    'لغو شده'
);
CREATE TYPE payment_status_enum2 AS ENUM (
    'Available',
    'Reserved',
    'Sold'
);

create table payment (


pay_id int GENERATED ALWAYS as IDENTITY(START WITH 100000 INCREMENT BY 1) primary key,
pay_amount numeric,
pay_type varchar(10) default 'پرداخت آنلاین',
pay_code VARCHAR(50) unique,
pay_timestamp timestamp default now(),
pay_status  payment_status_enum ,

constraint check_pay_amount 
check (pay_amount > 0)
);


create table product (

prod_serial int primary key ,
prod_brand varchar(50) not null,
prod_model varchar(50) not null,
prod_type varchar(50),
prod_status boolean DEFAULT False 

);

create table loan_product(


prod_serial int primary key references product(prod_serial),
loan_limit smallint,
constraint checka_loan_limit 
check (loan_limit between 0 and 90)
);

create table sell_product(


prod_serial int primary key references product(prod_serial),
prod_price numeric,

constraint check_prod_price
check (prod_price > 0)
);

create table contracts (


contract_id int GENERATED ALWAYS AS IDENTITY(START WITH 100 INCREMENT by 1) primary key,
contract_date date not null ,
contract_exp date not null,
contract_address text not null,


CONSTRAINT check_contract_dates
CHECK (contract_exp >= contract_date)

);





create table labor (


labor_id int primary key GENERATED ALWAYS AS IDENTITY(START WITH 100 INCREMENT by 1),
personal_code int not null unique,
labor_education varchar(20) not null,
inner_id smallint not null unique,
hire_date date default current_date,
labor_rule varchar(20) not null,
labor_email varchar(50) not null,
labor_contract int references contracts(contract_id) not null,
pass varchar(30) not null,

constraint check_hire_date 
check (hire_date <= current_date),
constraint check_labor_email_format
check (labor_email like '%@%.%'),
CONSTRAINT check_len_pass_labor
check (length(trim(pass)) > 8)
);


create table isp_plan(


plan_id int GENERATED ALWAYS AS IDENTITY(start with 100 INCREMENT BY 1) primary key,
plan_name varchar(20),
plan_trafic numeric ,
plan_upload numeric(10) not null,
plan_download numeric(10) not null,
static_ip boolean default false,
plan_duration smallint not null,
plan_tech varchar(20) not null,
plan_price NUMERIC,
CONSTRAINT check_plan_duration
CHECK (plan_duration > 0),
CONSTRAINT check_plan_trafic
CHECK (plan_trafic > 0),
CONSTRAINT check_plan_upload
CHECK (plan_upload > 0),
CONSTRAINT check_plan_download
CHECK (plan_download > 0)

);


create table ticket(


ticket_id int GENERATED ALWAYS AS IDENTITY(start with 10000 INCREMENT 1) primary key,
ticket_description text not null,
ticket_sub int not null references subscriber(sub_id),
ticket_open date not null,
ticket_close date,
ticket_status varchar(10),


constraint check_ticket_len
CHECK (length(trim(ticket_description)) >= 10)
);

create table ticket_ans(


ans_id int not null unique references ticket(ticket_id),
ans_labor int not null references labor(labor_id),
ans_text text not null,
ans_lable varchar(20) not null,

constraint check_ans_len
CHECK (length(trim(ans_text)) >= 10)
);

CREATE TABLE orders (
    order_id INT GENERATED ALWAYS AS IDENTITY(start with 10000 INCREMENT 1) PRIMARY KEY,        
    contract_id INT not null,             
    pay_id INT not null,                     
    sub_id INT not null,
    plan_id INT not null,
    order_status VARCHAR(50) not null,
    final_price NUMERIC,
    FOREIGN KEY (contract_id) REFERENCES contracts(contract_id),
    FOREIGN KEY (pay_id) REFERENCES payment(pay_id),
    FOREIGN KEY (sub_id) REFERENCES subscriber(sub_id),
    FOREIGN KEY (plan_id) REFERENCES isp_plan(plan_id)
);

CREATE TABLE service (
    service_id INT GENERATED ALWAYS AS IDENTITY(start with 10000 INCREMENT 1),
    order_id INT not null,
    remaining_volume numeric not null,
    expiration_date DATE,
    sub_id INT not null,
    PRIMARY KEY (service_id, order_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (sub_id) REFERENCES subscriber(sub_id),
    constraint check_expiration_date 
    check (expiration_date >= current_date)

);



CREATE TABLE sub_equipment_purchase (
    serial_number INT,
    sub_id int not null,
    pay_id int not null unique,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (serial_number) REFERENCES product(prod_serial),
    FOREIGN KEY (sub_id) REFERENCES subscriber(sub_id),
    FOREIGN KEY (pay_id) REFERENCES payment(pay_id)
);


CREATE TABLE emp_equipment_purchase (
    serial_number INT,
    labor_id int not null,  
    pay_id INT not null unique  ,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (serial_number) REFERENCES product(prod_serial),
    FOREIGN KEY (labor_id) REFERENCES labor(labor_id),
    FOREIGN KEY (pay_id) REFERENCES payment(pay_id)
);



CREATE TABLE sub_equipment_loan (
    serial_number INT,
    sub_id INT ,
    from_date DATE,
    to_date DATE not null,
    PRIMARY KEY (serial_number, sub_id, from_date),
    FOREIGN KEY (serial_number) REFERENCES product(prod_serial),
    FOREIGN KEY (sub_id) REFERENCES subscriber(sub_id),
    CONSTRAINT check_sub_loan_dates
    CHECK (to_date >= from_date)

);


CREATE TABLE emp_equipment_loan (
    serial_number INT,
    labor_id INT,
    from_date DATE,
    to_date DATE not null,
    PRIMARY KEY (serial_number, labor_id, from_date),
    FOREIGN KEY (serial_number) REFERENCES product(prod_serial),
    FOREIGN KEY (labor_id) REFERENCES labor(labor_id),
    CONSTRAINT check_emp_loan_dates
    CHECK (to_date >= from_date)

);


CREATE TABLE data_usage (
    service_id INT,
    time_block TIME,
    used_volume INT not null,
    PRIMARY KEY (service_id, time_block),
    FOREIGN KEY (service_id) REFERENCES service(service_id)
);


CREATE TABLE work_shift (
    shift_id INT GENERATED ALWAYS as IDENTITY(START WITH 1000 INCREMENT BY 1) PRIMARY KEY,
    shift_day date not null,
    shift_time time not null,
    shift_type VARCHAR(50) not null
);

CREATE TABLE shift_allocation (
    labor_id INT,
    shift_id INT not null,
    PRIMARY KEY (labor_id,shift_id),
    FOREIGN KEY (labor_id) REFERENCES labor(labor_id),
    FOREIGN KEY (shift_id) REFERENCES work_shift(shift_id)
);


CREATE TABLE shift_setting (
    labor_id INT,
    shift_id INT,
    PRIMARY KEY (labor_id, shift_id),
    FOREIGN KEY (labor_id) REFERENCES labor(labor_id),
    FOREIGN KEY (shift_id) REFERENCES work_shift(shift_id)
);
--برگرداندن دستگاه های موجود
SELECT  prod_brand, prod_model, prod_status, prod_type
FROM product
WHERE prod_serial = 500007;

0-01
SELECT l.labor_id,
       w.shift_day,
       w.shift_time,
       w.shift_type
FROM shift_allocation sa
JOIN labor l ON sa.labor_id = l.labor_id
JOIN work_shift w ON sa.shift_id = w.shift_id;

INSERT INTO orders (contract_id, pay_id, sub_id, plan_id, order_status, final_price)
VALUES (101, 200001, 100005, 103, 'pending', 500000);

INSERT INTO service (order_id, remaining_volume, expiration_date, sub_id)
VALUES (10001, 300, CURRENT_DATE + INTERVAL '30 day', 100005);

INSERT INTO contracts (contract_date, contract_exp, contract_address)
VALUES ('2026-05-01','2027-05-01','Tehran, Valiasr Street')
RETURNING contract_id;

SELECT plan_id,
       plan_name,
       plan_trafic,
       plan_upload,
       plan_download,
       plan_duration,
       plan_tech
FROM isp_plan;
-- sign up 
INSERT INTO subscriber (national_id,sub_email,sub_full_name,sub_address,pass)
VALUES('1231231231','smth@email.com','danial gh','yazd abarkouh','123456789');
-- subscriber login
-- شناسه مورد نظر رو داخل یک متغیر ذخیره میکنیم تا در باقی موارد از آن استفاده کنیم
select sub_id from subscriber 
where national_id = '1231231231' and pass = '123456789';

-- labor login
select labor_id from labor
where national_id = '1231231231' and pass = '123456789';

-- active services 
select remaining_volume,plan_name,plan_trafic,expiration_date from 
service join isp_plan on service.plan_id = isp_plan.plan_id
where sub_id = '100008';
-- subscriber orders
select order_id,pay_timestamp,pay_amount,order_status,plan_name from
orders join payment on orders.pay_id = payment.pay_id join isp_plan on orders.plan_id = isp_plan.plan_id
where sub_id = '100008';
-- subscriber tickets
select ticket_id , ticket_description,ticket_open,ticket_close,ticket_ans,ticket_status from ticket 
where ticket_sub = '100008';
-- access to ticket ans 
select ans_text , ans_lable from ticket_ans 
WHERE ans_id = '10037';
-- suscriber information 
select sub_address ,sub_email , sub_full_name ,sub_id, phone_num from subscriber 
where sub_id = 100008;
-- sell-product inquiry
select CONCAT(prod_brand, '-', prod_model) as "brand-model" , prod_price ,prod_status,prod_type from 
product join sell_product on product.prod_serial = sell_product.prod_serial
where serial_number ='smth'
-- loan-product inquiry
select CONCAT(prod_brand, '-', prod_model) as "brand-model" , loan_limit ,prod_status,prod_type from 
product join loan_product on product.prod_serial = loan_product.prod_serial
where serial_number ='smth';
--finding a shift
SELECT shift_id
FROM work_shift
WHERE shift_day  = 'Sunday'
  AND shift_type = 'Night'
  AND shift_time = '08:00-14:00';

-- changing shifts
INSERT INTO shift_allocation (labor_id, shift_id)
VALUES (
    15,
    (
        SELECT shift_id
        FROM work_shift
        WHERE shift_day  = 'Sunday'
          AND shift_type = 'Night'
          AND shift_time = '08:00-14:00'
    )
)


-- delete a shift
DELETE FROM shift_allocation
WHERE labor_id = 15
  AND shift_id = (
      SELECT shift_id
      FROM work_shift
      WHERE shift_day  = 'Sunday'
        AND shift_type = 'Night'
        AND shift_time = '08:00-14:00'
  );
-- changing personal information
UPDATE subscriber
SET
    sub_full_name = :full_name,
    sub_email     = :email,
    phone_num     = :phone,
    sub_address   = :address
WHERE sub_id = :sub_id;

--curser and precuder
CREATE OR REPLACE PROCEDURE create_pending_order(
    p_sub_id INT,
    p_plan_id INT,
    INOUT p_pay_id INT DEFAULT NULL,
    INOUT p_order_id INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_plan_price NUMERIC;
    v_plan_duration SMALLINT;
    v_sub_address TEXT;
    v_contract_id INT;
BEGIN
    -- 1. دریافت اطلاعات پلن و کاربر
    SELECT plan_price, plan_duration INTO v_plan_price, v_plan_duration FROM isp_plan WHERE plan_id = p_plan_id;
    SELECT sub_address INTO v_sub_address FROM subscriber WHERE sub_id = p_sub_id;

    -- 2. ثبت پرداخت موقت
    INSERT INTO payment (pay_amount, pay_status)
    VALUES (v_plan_price, 'در انتظار پرداخت')
    RETURNING pay_id INTO p_pay_id;

    -- 3. ثبت قرارداد موقت (برای رفع محدودیت not null در جدول orders)
    INSERT INTO contracts (contract_date, contract_exp, contract_address)
    VALUES (CURRENT_DATE, CURRENT_DATE + v_plan_duration, v_sub_address)
    RETURNING contract_id INTO v_contract_id;

    -- 4. ثبت سفارش موقت
    INSERT INTO orders (contract_id, pay_id, sub_id, plan_id, order_status, final_price)
    VALUES (v_contract_id, p_pay_id, p_sub_id, p_plan_id, 'در انتظار پرداخت', v_plan_price)
    RETURNING order_id INTO p_order_id;
    
    COMMIT;
END;
$$;
CREATE OR REPLACE PROCEDURE verify_payment_and_activate(
    p_order_id INT,
    p_pay_code VARCHAR(50),
    p_start_date DATE DEFAULT CURRENT_DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_pay_id INT;
    v_sub_id INT;
    v_plan_id INT;
    v_contract_id INT;
    v_plan_duration SMALLINT;
    v_plan_trafic NUMERIC;
    v_exp_date DATE;
BEGIN
    -- 1. استخراج شناسه‌های مرتبط از سفارش
    SELECT pay_id, sub_id, plan_id, contract_id 
    INTO v_pay_id, v_sub_id, v_plan_id, v_contract_id 
    FROM orders WHERE order_id = p_order_id;

    -- 2. دریافت حجم و مدت زمان پلن
    SELECT plan_duration, plan_trafic INTO v_plan_duration, v_plan_trafic 
    FROM isp_plan WHERE plan_id = v_plan_id;
    
    v_exp_date := p_start_date + v_plan_duration;

    -- 3. ثبت کد رهگیری و تغییر وضعیت پرداخت
    UPDATE payment 
    SET pay_code = p_pay_code, pay_status = 'پرداخت شده', pay_timestamp = NOW()
    WHERE pay_id = v_pay_id;

    -- 4. قطعی کردن تاریخ‌های قرارداد
    UPDATE contracts 
    SET contract_date = p_start_date, contract_exp = v_exp_date 
    WHERE contract_id = v_contract_id;

    -- 5. تغییر وضعیت سفارش
    UPDATE orders 
    SET order_status = 'تکمیل شده'
    WHERE order_id = p_order_id;

    -- 6. ایجاد و فعال‌سازی سرویس
    INSERT INTO service (order_id, remaining_volume, expiration_date, sub_id)
    VALUES (p_order_id, v_plan_trafic, v_exp_date, v_sub_id);
    
    COMMIT;
END;
$$;
CALL create_pending_order(
    p_sub_id => 100012,                
    p_plan_id => 100    
);

--functions and triggers
CREATE OR REPLACE FUNCTION cleanup_expired_pending_orders(p_hours INT DEFAULT 3)
RETURNS VOID AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN 
        SELECT o.order_id, o.contract_id, o.pay_id 
        FROM orders o
        JOIN payment p ON o.pay_id = p.pay_id
        WHERE p.pay_status = 'در انتظار پرداخت' 
          AND p.pay_timestamp < (NOW() - (p_hours || ' hours')::INTERVAL)
    LOOP
        DELETE FROM orders WHERE order_id = rec.order_id;
        DELETE FROM contracts WHERE contract_id = rec.contract_id;
        DELETE FROM payment WHERE pay_id = rec.pay_id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT cleanup_expired_pending_orders();

-------

CREATE OR REPLACE PROCEDURE initiate_sell_equipment_order(
    p_sub_id INT,
    p_product_serials INT[],
    OUT o_pay_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_price DECIMAL := 0;
BEGIN
    -- محاسبه مجموع قیمت تجهیزات فروشی موجود
    SELECT COALESCE(SUM(p.prod_price), 0)
    INTO v_total_price
    FROM product p
    JOIN sell_product sp ON p.prod_serial = sp.prod_serial
    WHERE p.prod_serial = ANY(p_product_serials)
      AND p.prod_status = 'Available';

    -- تغییر وضعیت تجهیزات به رزرو شده
    UPDATE product
    SET prod_status = 'Reserved'
    WHERE prod_serial = ANY(p_product_serials)
      AND prod_status = 'Available';

    -- ایجاد رکورد پرداخت در وضعیت در انتظار (Pending)
    INSERT INTO payment (pay_amount, pay_type, pay_status)
    VALUES (v_total_price, 'Purchase', 'Pending')
    RETURNING pay_id INTO o_pay_id;

    -- ثبت تجهیزات خریداری شده برای مشترک
    INSERT INTO sub_equipment_purchase (sub_id, serial_number, pay_id)
    SELECT p_sub_id, unnest(p_product_serials), o_pay_id;

END;
$$;


CREATE OR REPLACE PROCEDURE finalize_sell_equipment_order(
    p_pay_id INT,
    p_transaction_code VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- تایید پرداخت
    UPDATE payment
    SET pay_status = 'Success',
        pay_code = p_transaction_code,
        pay_timestamp = CURRENT_TIMESTAMP
    WHERE pay_id = p_pay_id
      AND pay_status = 'Pending';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'پرداخت نامعتبر است یا قبلا پردازش شده است.';
    END IF;

    -- تغییر وضعیت محصولات از رزرو به فروخته شده
    UPDATE product
    SET prod_status = 'Sold'
    WHERE prod_serial IN (
        SELECT serial_number
        FROM sub_equipment_purchase
        WHERE pay_id = p_pay_id
    )
    AND prod_status = 'Reserved';

END;
$$;

--- تمرین آخر
CREATE OR REPLACE FUNCTION check_and_update_data_usage()
RETURNS TRIGGER
SECURITY DEFINER
 AS $$
DECLARE
    v_remaining NUMERIC;
BEGIN
    SELECT remaining_volume INTO v_remaining
    FROM service
    WHERE service_id = NEW.service_id;

    IF NEW.used_volume > v_remaining THEN
        RAISE EXCEPTION 'حجم مصرفی مجاز نیست! حجم درخواستی: % ، حجم باقی‌مانده: %', NEW.used_volume, v_remaining;
    END IF;

    UPDATE service
    SET remaining_volume = remaining_volume - NEW.used_volume
    WHERE service_id = NEW.service_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_data_usage
BEFORE INSERT ON data_usage
FOR EACH ROW
EXECUTE FUNCTION check_and_update_data_usage();

CREATE ROLE accounting_system WITH LOGIN PASSWORD '123456654321';
GRANT INSERT ON data_usage TO accounting_system;
REVOKE ALL PRIVILEGES ON service FROM accounting_system
GRANT SELECT (service_id, sub_id) ON service TO accounting_system;
