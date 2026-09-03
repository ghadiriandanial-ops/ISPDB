--PostgreSQL Maestro 25.9.0.1
------------------------------------------
--Host     : localhost
--Database : ISP_DB


SET SESSION AUTHORIZATION 'postgres';
SET search_path = public, pg_catalog;
DROP TRIGGER trigger_check_data_usage ON public.data_usage;
DROP TRIGGER trg_cleanup_pending_orders ON public.orders;
DROP TRIGGER pre_usage_check ON public.data_usage;
ALTER TABLE ONLY public.payment DROP CONSTRAINT payment_pay_code_key;
ALTER TABLE ONLY public.students DROP CONSTRAINT students_supervisorcode_fkey;
ALTER TABLE ONLY public.students DROP CONSTRAINT students_stmjrcode_fkey;
ALTER TABLE ONLY public.students DROP CONSTRAINT students_pkey;
ALTER TABLE ONLY public.professors DROP CONSTRAINT professors_pkey;
ALTER TABLE ONLY public.majors DROP CONSTRAINT majors_pkey;
ALTER TABLE ONLY public.shift_setting DROP CONSTRAINT shift_setting_shift_id_fkey;
ALTER TABLE ONLY public.shift_setting DROP CONSTRAINT shift_setting_labor_id_fkey;
ALTER TABLE ONLY public.shift_setting DROP CONSTRAINT shift_setting_pkey;
ALTER TABLE ONLY public.shift_allocation DROP CONSTRAINT shift_allocation_shift_id_fkey;
ALTER TABLE ONLY public.shift_allocation DROP CONSTRAINT shift_allocation_labor_id_fkey;
ALTER TABLE ONLY public.shift_allocation DROP CONSTRAINT shift_allocation_pkey;
ALTER TABLE ONLY public.work_shift DROP CONSTRAINT work_shift_pkey;
ALTER TABLE ONLY public.data_usage DROP CONSTRAINT data_usage_service_id_fkey;
ALTER TABLE ONLY public.data_usage DROP CONSTRAINT data_usage_pkey;
ALTER TABLE ONLY public.service DROP CONSTRAINT service_sub_id_fkey;
ALTER TABLE ONLY public.service DROP CONSTRAINT service_order_id_fkey;
ALTER TABLE ONLY public.service DROP CONSTRAINT service_order_id_key;
ALTER TABLE ONLY public.service DROP CONSTRAINT service_pkey;
ALTER TABLE ONLY public.emp_equipment_loan DROP CONSTRAINT emp_equipment_loan_labor_id_fkey;
ALTER TABLE ONLY public.emp_equipment_loan DROP CONSTRAINT emp_equipment_loan_serial_number_fkey;
ALTER TABLE ONLY public.emp_equipment_loan DROP CONSTRAINT emp_equipment_loan_pkey;
ALTER TABLE ONLY public.sub_equipment_loan DROP CONSTRAINT sub_equipment_loan_sub_id_fkey;
ALTER TABLE ONLY public.sub_equipment_loan DROP CONSTRAINT sub_equipment_loan_serial_number_fkey;
ALTER TABLE ONLY public.sub_equipment_loan DROP CONSTRAINT sub_equipment_loan_pkey;
ALTER TABLE ONLY public.emp_equipment_purchase DROP CONSTRAINT emp_equipment_purchase_pay_id_fkey;
ALTER TABLE ONLY public.emp_equipment_purchase DROP CONSTRAINT emp_equipment_purchase_labor_id_fkey;
ALTER TABLE ONLY public.emp_equipment_purchase DROP CONSTRAINT emp_equipment_purchase_serial_number_fkey;
ALTER TABLE ONLY public.emp_equipment_purchase DROP CONSTRAINT emp_equipment_purchase_pkey;
ALTER TABLE ONLY public.sub_equipment_purchase DROP CONSTRAINT sub_equipment_purchase_pay_id_fkey;
ALTER TABLE ONLY public.sub_equipment_purchase DROP CONSTRAINT sub_equipment_purchase_sub_id_fkey;
ALTER TABLE ONLY public.sub_equipment_purchase DROP CONSTRAINT sub_equipment_purchase_serial_number_fkey;
ALTER TABLE ONLY public.sub_equipment_purchase DROP CONSTRAINT sub_equipment_purchase_pkey;
ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_plan_id_fkey;
ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_sub_id_fkey;
ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pay_id_fkey;
ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_contract_id_fkey;
ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
ALTER TABLE ONLY public.ticket_ans DROP CONSTRAINT ticket_ans_ans_labor_fkey;
ALTER TABLE ONLY public.ticket_ans DROP CONSTRAINT ticket_ans_ans_id_fkey;
ALTER TABLE ONLY public.ticket_ans DROP CONSTRAINT ticket_ans_ans_id_key;
ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_ticket_sub_fkey;
ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_pkey;
ALTER TABLE ONLY public.isp_plan DROP CONSTRAINT isp_plan_pkey;
ALTER TABLE ONLY public.labor DROP CONSTRAINT labor_labor_contract_fkey;
ALTER TABLE ONLY public.labor DROP CONSTRAINT labor_inner_id_key;
ALTER TABLE ONLY public.labor DROP CONSTRAINT labor_personal_code_key;
ALTER TABLE ONLY public.labor DROP CONSTRAINT labor_pkey;
ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_pkey;
ALTER TABLE ONLY public.sell_product DROP CONSTRAINT sell_product_prod_serial_fkey;
ALTER TABLE ONLY public.sell_product DROP CONSTRAINT sell_product_pkey;
ALTER TABLE ONLY public.loan_product DROP CONSTRAINT loan_product_prod_serial_fkey;
ALTER TABLE ONLY public.loan_product DROP CONSTRAINT loan_product_pkey;
ALTER TABLE ONLY public.product DROP CONSTRAINT product_pkey;
ALTER TABLE ONLY public.payment DROP CONSTRAINT payment_pkey;
ALTER TABLE ONLY public.subscriber DROP CONSTRAINT subscriber_national_id_key;
ALTER TABLE ONLY public.subscriber DROP CONSTRAINT subscriber_pkey;
DROP INDEX public.idx_setting_shift;
DROP INDEX public.idx_rder_subscriber;
DROP INDEX public.idx_ticket_subscriber;
DROP FUNCTION public.finalize_sell_equipment_order (p_pay_id integer, p_transaction_code varchar);
DROP FUNCTION public.initiate_sell_equipment_order (p_sub_id integer, p_product_serials integer[]);
DROP FUNCTION public.finalize_loan_modem_order (p_pay_id integer, p_transaction_code varchar);
DROP FUNCTION public.initiate_loan_modem_order (p_sub_id integer, p_product_serials integer[]);
DROP FUNCTION public.check_and_update_data_usage ();
DROP FUNCTION public.cleanup_expired_pending_orders (p_hours integer);
DROP FUNCTION public.cleanup_old_pending_orders ();
DROP FUNCTION public.check_volume_limit ();
DROP FUNCTION public.create_pending_order (p_sub_id integer, p_plan_id integer, p_pay_id integer, p_order_id integer);
DROP FUNCTION public.verify_payment_and_activate (p_order_id integer, p_pay_code varchar, p_start_date date);
DROP FUNCTION public.get_total_used_volume (p_service_id integer);
DROP TABLE public.students;
DROP TABLE public.professors;
DROP TABLE public.majors;
DROP TABLE public.shift_setting;
DROP TABLE public.shift_allocation;
DROP TABLE public.work_shift;
DROP TABLE public.data_usage;
DROP TABLE public.service;
DROP TABLE public.emp_equipment_loan;
DROP TABLE public.sub_equipment_loan;
DROP TABLE public.emp_equipment_purchase;
DROP TABLE public.sub_equipment_purchase;
DROP TABLE public.orders;
DROP TABLE public.ticket_ans;
DROP TABLE public.ticket;
DROP TABLE public.isp_plan;
DROP TABLE public.labor;
DROP TABLE public.contracts;
DROP TABLE public.sell_product;
DROP TABLE public.loan_product;
DROP TABLE public.product;
DROP TABLE public.payment;
DROP TABLE public.subscriber;
-- Structure for table subscriber (OID = 16424):
CREATE TABLE subscriber (
    sub_id integer NOT NULL,
    national_id varchar(10) NOT NULL,
    sub_email varchar(100),
    sub_full_name varchar(50),
    sub_status boolean DEFAULT false,
    sub_date date DEFAULT CURRENT_DATE,
    sub_address text NOT NULL,
    pass varchar(30) NOT NULL,
    phone_num char(11),
    CONSTRAINT check_email_format CHECK (((sub_email)::text ~~ '%@%.%'::text)),
    CONSTRAINT check_len_pass CHECK ((length(TRIM(BOTH FROM pass)) > 8)),
    CONSTRAINT check_national_id_len CHECK (((national_id)::text ~ '^[0-9]{10}$'::text)),
    CONSTRAINT chk_address_length CHECK ((length(TRIM(BOTH FROM sub_address)) >= 10))
) WITHOUT OIDS;
ALTER TABLE ONLY public.subscriber ALTER COLUMN sub_id SET STATISTICS 0;
ALTER TABLE ONLY public.subscriber ALTER COLUMN national_id SET STATISTICS 0;
ALTER TABLE ONLY public.subscriber ALTER COLUMN sub_email SET STATISTICS 0;
ALTER TABLE ONLY public.subscriber ALTER COLUMN sub_full_name SET STATISTICS 0;
ALTER TABLE ONLY public.subscriber ALTER COLUMN sub_status SET STATISTICS 0;
ALTER TABLE ONLY public.subscriber ALTER COLUMN sub_date SET STATISTICS 0;
ALTER TABLE ONLY public.subscriber ALTER COLUMN sub_address SET STATISTICS 0;
ALTER TABLE ONLY public.subscriber ALTER COLUMN pass SET STATISTICS 0;
ALTER TABLE ONLY public.subscriber ALTER COLUMN phone_num SET STATISTICS 0;
-- Structure for table payment (OID = 16439):
CREATE TABLE payment (
    pay_id integer NOT NULL,
    pay_amount numeric,
    pay_type varchar(30) DEFAULT '?????? ??????'::character varying,
    pay_code varchar(30),
    pay_timestamp timestamp without time zone DEFAULT now(),
    pay_status varchar(30),
    CONSTRAINT check_pay_amount CHECK ((pay_amount >= (0)::numeric))
) WITHOUT OIDS;
ALTER TABLE ONLY public.payment ALTER COLUMN pay_id SET STATISTICS 0;
ALTER TABLE ONLY public.payment ALTER COLUMN pay_amount SET STATISTICS 0;
ALTER TABLE ONLY public.payment ALTER COLUMN pay_type SET STATISTICS 0;
ALTER TABLE ONLY public.payment ALTER COLUMN pay_code SET STATISTICS 0;
ALTER TABLE ONLY public.payment ALTER COLUMN pay_timestamp SET STATISTICS 0;
ALTER TABLE ONLY public.payment ALTER COLUMN pay_status SET STATISTICS 0;
-- Structure for table product (OID = 16451):
CREATE TABLE product (
    prod_serial integer NOT NULL,
    prod_brand varchar(50) NOT NULL,
    prod_model varchar(50) NOT NULL,
    prod_type varchar(50),
    prod_status varchar
) WITHOUT OIDS;
ALTER TABLE ONLY public.product ALTER COLUMN prod_serial SET STATISTICS 0;
ALTER TABLE ONLY public.product ALTER COLUMN prod_brand SET STATISTICS 0;
ALTER TABLE ONLY public.product ALTER COLUMN prod_model SET STATISTICS 0;
ALTER TABLE ONLY public.product ALTER COLUMN prod_type SET STATISTICS 0;
ALTER TABLE ONLY public.product ALTER COLUMN prod_status SET STATISTICS 0;
-- Structure for table loan_product (OID = 16457):
CREATE TABLE loan_product (
    prod_serial integer NOT NULL,
    loan_limit smallint,
    CONSTRAINT checka_loan_limit CHECK (((loan_limit >= 0) AND (loan_limit <= 90)))
) WITHOUT OIDS;
ALTER TABLE ONLY public.loan_product ALTER COLUMN prod_serial SET STATISTICS 0;
ALTER TABLE ONLY public.loan_product ALTER COLUMN loan_limit SET STATISTICS 0;
-- Structure for table sell_product (OID = 16471):
CREATE TABLE sell_product (
    prod_serial integer NOT NULL,
    prod_price numeric,
    CONSTRAINT check_prod_price CHECK ((prod_price > (0)::numeric))
) WITHOUT OIDS;
ALTER TABLE ONLY public.sell_product ALTER COLUMN prod_serial SET STATISTICS 0;
ALTER TABLE ONLY public.sell_product ALTER COLUMN prod_price SET STATISTICS 0;
-- Structure for table contracts (OID = 16504):
CREATE TABLE contracts (
    contract_id integer NOT NULL,
    contract_date date NOT NULL,
    contract_exp date NOT NULL,
    contract_address text NOT NULL
) WITHOUT OIDS;
ALTER TABLE ONLY public.contracts ALTER COLUMN contract_id SET STATISTICS 0;
ALTER TABLE ONLY public.contracts ALTER COLUMN contract_date SET STATISTICS 0;
ALTER TABLE ONLY public.contracts ALTER COLUMN contract_exp SET STATISTICS 0;
ALTER TABLE ONLY public.contracts ALTER COLUMN contract_address SET STATISTICS 0;
-- Structure for table labor (OID = 16512):
CREATE TABLE labor (
    labor_id integer NOT NULL,
    personal_code integer NOT NULL,
    labor_education varchar(20) NOT NULL,
    inner_id smallint NOT NULL,
    hire_date date DEFAULT CURRENT_DATE,
    labor_rule varchar(20) NOT NULL,
    labor_email varchar(50) NOT NULL,
    labor_contract integer NOT NULL,
    CONSTRAINT check_hire_date CHECK ((hire_date <= CURRENT_DATE)),
    CONSTRAINT check_labor_email_format CHECK (((labor_email)::text ~~ '%@%.%'::text))
) WITHOUT OIDS;
ALTER TABLE ONLY public.labor ALTER COLUMN labor_id SET STATISTICS 0;
ALTER TABLE ONLY public.labor ALTER COLUMN personal_code SET STATISTICS 0;
ALTER TABLE ONLY public.labor ALTER COLUMN labor_education SET STATISTICS 0;
ALTER TABLE ONLY public.labor ALTER COLUMN inner_id SET STATISTICS 0;
ALTER TABLE ONLY public.labor ALTER COLUMN hire_date SET STATISTICS 0;
ALTER TABLE ONLY public.labor ALTER COLUMN labor_rule SET STATISTICS 0;
ALTER TABLE ONLY public.labor ALTER COLUMN labor_email SET STATISTICS 0;
ALTER TABLE ONLY public.labor ALTER COLUMN labor_contract SET STATISTICS 0;
-- Structure for table isp_plan (OID = 16530):
CREATE TABLE isp_plan (
    plan_id integer NOT NULL,
    plan_name varchar(20),
    plan_trafic numeric,
    plan_upload numeric(10,0) NOT NULL,
    plan_download numeric(10,0) NOT NULL,
    static_ip boolean DEFAULT false,
    plan_duration smallint NOT NULL,
    plan_tech varchar(20) NOT NULL,
    plan_price numeric
) WITHOUT OIDS;
ALTER TABLE ONLY public.isp_plan ALTER COLUMN plan_id SET STATISTICS 0;
ALTER TABLE ONLY public.isp_plan ALTER COLUMN plan_name SET STATISTICS 0;
ALTER TABLE ONLY public.isp_plan ALTER COLUMN plan_trafic SET STATISTICS 0;
ALTER TABLE ONLY public.isp_plan ALTER COLUMN plan_upload SET STATISTICS 0;
ALTER TABLE ONLY public.isp_plan ALTER COLUMN plan_download SET STATISTICS 0;
ALTER TABLE ONLY public.isp_plan ALTER COLUMN static_ip SET STATISTICS 0;
ALTER TABLE ONLY public.isp_plan ALTER COLUMN plan_duration SET STATISTICS 0;
ALTER TABLE ONLY public.isp_plan ALTER COLUMN plan_tech SET STATISTICS 0;
ALTER TABLE ONLY public.isp_plan ALTER COLUMN plan_price SET STATISTICS 0;
-- Structure for table ticket (OID = 16544):
CREATE TABLE ticket (
    ticket_id integer NOT NULL,
    ticket_description text NOT NULL,
    ticket_sub integer NOT NULL,
    ticket_open date NOT NULL,
    ticket_close date,
    ticket_status varchar(10),
    CONSTRAINT check_ticket_len CHECK ((length(TRIM(BOTH FROM ticket_description)) >= 10))
) WITHOUT OIDS;
ALTER TABLE ONLY public.ticket ALTER COLUMN ticket_id SET STATISTICS 0;
ALTER TABLE ONLY public.ticket ALTER COLUMN ticket_description SET STATISTICS 0;
ALTER TABLE ONLY public.ticket ALTER COLUMN ticket_sub SET STATISTICS 0;
ALTER TABLE ONLY public.ticket ALTER COLUMN ticket_open SET STATISTICS 0;
ALTER TABLE ONLY public.ticket ALTER COLUMN ticket_close SET STATISTICS 0;
ALTER TABLE ONLY public.ticket ALTER COLUMN ticket_status SET STATISTICS 0;
-- Structure for table ticket_ans (OID = 16560):
CREATE TABLE ticket_ans (
    ans_id integer NOT NULL,
    ans_labor integer NOT NULL,
    ans_text text NOT NULL,
    ans_lable varchar(20) NOT NULL,
    CONSTRAINT check_ans_len CHECK ((length(TRIM(BOTH FROM ans_text)) >= 10))
) WITHOUT OIDS;
ALTER TABLE ONLY public.ticket_ans ALTER COLUMN ans_id SET STATISTICS 0;
ALTER TABLE ONLY public.ticket_ans ALTER COLUMN ans_labor SET STATISTICS 0;
ALTER TABLE ONLY public.ticket_ans ALTER COLUMN ans_text SET STATISTICS 0;
ALTER TABLE ONLY public.ticket_ans ALTER COLUMN ans_lable SET STATISTICS 0;
-- Structure for table orders (OID = 16586):
CREATE TABLE orders (
    order_id integer NOT NULL,
    contract_id integer NOT NULL,
    pay_id integer NOT NULL,
    sub_id integer NOT NULL,
    plan_id integer NOT NULL,
    order_status varchar(50) NOT NULL,
    final_price numeric(18,0)
) WITHOUT OIDS;
ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET STATISTICS 0;
ALTER TABLE ONLY public.orders ALTER COLUMN contract_id SET STATISTICS 0;
ALTER TABLE ONLY public.orders ALTER COLUMN pay_id SET STATISTICS 0;
ALTER TABLE ONLY public.orders ALTER COLUMN sub_id SET STATISTICS 0;
ALTER TABLE ONLY public.orders ALTER COLUMN plan_id SET STATISTICS 0;
ALTER TABLE ONLY public.orders ALTER COLUMN order_status SET STATISTICS 0;
ALTER TABLE ONLY public.orders ALTER COLUMN final_price SET STATISTICS 0;
-- Structure for table sub_equipment_purchase (OID = 16628):
CREATE TABLE sub_equipment_purchase (
    serial_number integer NOT NULL,
    sub_id integer NOT NULL,
    pay_id integer NOT NULL
) WITHOUT OIDS;
ALTER TABLE ONLY public.sub_equipment_purchase ALTER COLUMN serial_number SET STATISTICS 0;
ALTER TABLE ONLY public.sub_equipment_purchase ALTER COLUMN sub_id SET STATISTICS 0;
ALTER TABLE ONLY public.sub_equipment_purchase ALTER COLUMN pay_id SET STATISTICS 0;
-- Structure for table emp_equipment_purchase (OID = 16648):
CREATE TABLE emp_equipment_purchase (
    serial_number integer NOT NULL,
    labor_id integer NOT NULL,
    pay_id integer NOT NULL
) WITHOUT OIDS;
ALTER TABLE ONLY public.emp_equipment_purchase ALTER COLUMN serial_number SET STATISTICS 0;
ALTER TABLE ONLY public.emp_equipment_purchase ALTER COLUMN labor_id SET STATISTICS 0;
ALTER TABLE ONLY public.emp_equipment_purchase ALTER COLUMN pay_id SET STATISTICS 0;
-- Structure for table sub_equipment_loan (OID = 16668):
CREATE TABLE sub_equipment_loan (
    serial_number integer NOT NULL,
    sub_id integer NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    CONSTRAINT check_sub_loan_dates CHECK ((to_date >= from_date))
) WITHOUT OIDS;
ALTER TABLE ONLY public.sub_equipment_loan ALTER COLUMN serial_number SET STATISTICS 0;
ALTER TABLE ONLY public.sub_equipment_loan ALTER COLUMN sub_id SET STATISTICS 0;
ALTER TABLE ONLY public.sub_equipment_loan ALTER COLUMN from_date SET STATISTICS 0;
ALTER TABLE ONLY public.sub_equipment_loan ALTER COLUMN to_date SET STATISTICS 0;
-- Structure for table emp_equipment_loan (OID = 16684):
CREATE TABLE emp_equipment_loan (
    serial_number integer NOT NULL,
    labor_id integer NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    CONSTRAINT check_emp_loan_dates CHECK ((to_date >= from_date))
) WITHOUT OIDS;
ALTER TABLE ONLY public.emp_equipment_loan ALTER COLUMN serial_number SET STATISTICS 0;
ALTER TABLE ONLY public.emp_equipment_loan ALTER COLUMN labor_id SET STATISTICS 0;
ALTER TABLE ONLY public.emp_equipment_loan ALTER COLUMN from_date SET STATISTICS 0;
ALTER TABLE ONLY public.emp_equipment_loan ALTER COLUMN to_date SET STATISTICS 0;
-- Structure for table service (OID = 16721):
CREATE TABLE service (
    service_id integer NOT NULL,
    order_id integer NOT NULL,
    remaining_volume numeric NOT NULL,
    expiration_date date,
    sub_id integer NOT NULL,
    CONSTRAINT check_expiration_date CHECK ((expiration_date >= CURRENT_DATE))
) WITHOUT OIDS;
ALTER TABLE ONLY public.service ALTER COLUMN service_id SET STATISTICS 0;
ALTER TABLE ONLY public.service ALTER COLUMN order_id SET STATISTICS 0;
ALTER TABLE ONLY public.service ALTER COLUMN remaining_volume SET STATISTICS 0;
ALTER TABLE ONLY public.service ALTER COLUMN expiration_date SET STATISTICS 0;
ALTER TABLE ONLY public.service ALTER COLUMN sub_id SET STATISTICS 0;
REVOKE ALL ON TABLE service FROM PUBLIC;
REVOKE ALL ON TABLE service FROM postgres;
GRANT INSERT,SELECT,UPDATE,DELETE,REFERENCES,TRIGGER,TRIGGER,SELECT ON TABLE service TO postgres;
-- Structure for table data_usage (OID = 16739):
CREATE TABLE data_usage (
    service_id integer NOT NULL,
    time_block time without time zone NOT NULL,
    used_volume integer NOT NULL
) WITHOUT OIDS;
ALTER TABLE ONLY public.data_usage ALTER COLUMN service_id SET STATISTICS 0;
ALTER TABLE ONLY public.data_usage ALTER COLUMN time_block SET STATISTICS 0;
ALTER TABLE ONLY public.data_usage ALTER COLUMN used_volume SET STATISTICS 0;
REVOKE ALL ON TABLE data_usage FROM PUBLIC;
REVOKE ALL ON TABLE data_usage FROM postgres;
GRANT INSERT,SELECT,UPDATE,DELETE,REFERENCES,TRIGGER,TRIGGER,SELECT ON TABLE data_usage TO postgres;
GRANT INSERT,TRIGGER,SELECT ON TABLE data_usage TO accounting_system;
-- Structure for table work_shift (OID = 16750):
CREATE TABLE work_shift (
    shift_id integer NOT NULL,
    shift_day varchar(20) NOT NULL,
    shift_time varchar(50) NOT NULL,
    shift_type varchar(50) NOT NULL
) WITHOUT OIDS;
ALTER TABLE ONLY public.work_shift ALTER COLUMN shift_id SET STATISTICS 0;
ALTER TABLE ONLY public.work_shift ALTER COLUMN shift_day SET STATISTICS 0;
ALTER TABLE ONLY public.work_shift ALTER COLUMN shift_time SET STATISTICS 0;
ALTER TABLE ONLY public.work_shift ALTER COLUMN shift_type SET STATISTICS 0;
-- Structure for table shift_allocation (OID = 16755):
CREATE TABLE shift_allocation (
    labor_id integer NOT NULL,
    shift_id integer
) WITHOUT OIDS;
ALTER TABLE ONLY public.shift_allocation ALTER COLUMN labor_id SET STATISTICS 0;
ALTER TABLE ONLY public.shift_allocation ALTER COLUMN shift_id SET STATISTICS 0;
-- Structure for table shift_setting (OID = 16770):
CREATE TABLE shift_setting (
    labor_id integer NOT NULL,
    shift_id integer NOT NULL
) WITHOUT OIDS;
ALTER TABLE ONLY public.shift_setting ALTER COLUMN labor_id SET STATISTICS 0;
ALTER TABLE ONLY public.shift_setting ALTER COLUMN shift_id SET STATISTICS 0;
-- Structure for table majors (OID = 16788):
CREATE TABLE majors (
    majorcode integer NOT NULL,
    majortitle varchar(30)
) WITHOUT OIDS;
ALTER TABLE ONLY public.majors ALTER COLUMN majorcode SET STATISTICS 0;
ALTER TABLE ONLY public.majors ALTER COLUMN majortitle SET STATISTICS 0;
-- Structure for table professors (OID = 16794):
CREATE TABLE professors (
    profid integer NOT NULL,
    proffullname varchar(40),
    depid integer
) WITHOUT OIDS;
ALTER TABLE ONLY public.professors ALTER COLUMN profid SET STATISTICS 0;
ALTER TABLE ONLY public.professors ALTER COLUMN proffullname SET STATISTICS 0;
ALTER TABLE ONLY public.professors ALTER COLUMN depid SET STATISTICS 0;
-- Structure for table students (OID = 16809):
CREATE TABLE students (
    stid char(6) NOT NULL,
    stfname varchar(20),
    stlname varchar(20),
    gender varchar(10),
    stmjrcode integer,
    supervisorcode integer,
    CONSTRAINT check_gender CHECK (((gender)::text = ANY ((ARRAY['Male'::character varying, 'Female'::character varying])::text[])))
) WITHOUT OIDS;
ALTER TABLE ONLY public.students ALTER COLUMN stid SET STATISTICS 0;
ALTER TABLE ONLY public.students ALTER COLUMN stfname SET STATISTICS 0;
ALTER TABLE ONLY public.students ALTER COLUMN stlname SET STATISTICS 0;
ALTER TABLE ONLY public.students ALTER COLUMN gender SET STATISTICS 0;
ALTER TABLE ONLY public.students ALTER COLUMN stmjrcode SET STATISTICS 0;
ALTER TABLE ONLY public.students ALTER COLUMN supervisorcode SET STATISTICS 0;
-- Definition for function get_total_used_volume (OID = 24587):
SET check_function_bodies = false;
CREATE FUNCTION get_total_used_volume (p_service_id integer) RETURNS integer
    AS '', '
DECLARE
    total_used INT;
BEGIN
    SELECT COALESCE(SUM(used_volume), 0)
    INTO total_used
    FROM data_usage
    WHERE service_id = p_service_id;

    RETURN total_used;
END;
'
    LANGUAGE plpgsql;
-- Definition for function verify_payment_and_activate (OID = 32789):
CREATE FUNCTION verify_payment_and_activate (p_order_id integer, p_pay_code varchar, p_start_date date) RETURNS void
    AS '', '
DECLARE
    v_pay_id INT;
    v_sub_id INT;
    v_plan_id INT;
    v_contract_id INT;
    v_plan_duration SMALLINT;
    v_plan_trafic NUMERIC;
    v_exp_date DATE;
    -- v_final_price NUMERIC; -- ??? ??????? ?? ????? ?? ???????
BEGIN
    -- 1. ??????? ????????? ????? ?? ?????
    SELECT pay_id, sub_id, plan_id, contract_id -- , final_price
    INTO v_pay_id, v_sub_id, v_plan_id, v_contract_id -- , v_final_price
    FROM orders WHERE order_id = p_order_id;

    -- 2. ?????? ??? ? ??? ???? ???
    SELECT plan_duration, plan_trafic INTO v_plan_duration, v_plan_trafic
    FROM isp_plan WHERE plan_id = v_plan_id;

    v_exp_date := p_start_date + v_plan_duration;

    -- 3. ??? ?? ?????? ? ????? ????? ??????
    UPDATE payment
    SET pay_code = p_pay_code, pay_status = ''?????? ???'', pay_timestamp = NOW()
    WHERE pay_id = v_pay_id;

    -- 4. ???? ???? ????????? ???????
    UPDATE contracts
    SET contract_date = p_start_date, contract_exp = v_exp_date
    WHERE contract_id = v_contract_id;

    -- 5. ????? ????? ?????
    UPDATE orders
    SET order_status = ''????? ???''
    WHERE order_id = p_order_id;

    -- 6. ????? ? ????????? ?????
    INSERT INTO service (order_id, remaining_volume, expiration_date, sub_id)
    VALUES (p_order_id, v_plan_trafic, v_exp_date, v_sub_id);

    COMMIT;
END;
'
    LANGUAGE plpgsql;
-- Definition for function create_pending_order (OID = 32790):
CREATE FUNCTION create_pending_order (p_sub_id integer, p_plan_id integer, p_pay_id integer, p_order_id integer) RETURNS record
    AS '', '
DECLARE
    v_plan_price NUMERIC;
    v_plan_duration SMALLINT;
    v_sub_address TEXT;
    v_contract_id INT;
BEGIN
    -- 1. ?????? ??????? ??? ? ?????
    SELECT plan_price, plan_duration INTO v_plan_price, v_plan_duration FROM isp_plan WHERE plan_id = p_plan_id;
    SELECT sub_address INTO v_sub_address FROM subscriber WHERE sub_id = p_sub_id;

    -- 2. ??? ?????? ????
    INSERT INTO payment (pay_amount, pay_status)
    VALUES (v_plan_price, ''?? ?????? ??????'') -- ??? ??????? pay_status boolean ????
    RETURNING pay_id INTO p_pay_id;

    -- 3. ??? ??????? ????
    INSERT INTO contracts (contract_date, contract_exp, contract_address)
    VALUES (CURRENT_DATE, CURRENT_DATE + v_plan_duration, v_sub_address)
    RETURNING contract_id INTO v_contract_id;

    -- 4. ??? ????? ???? ?? final_price
    INSERT INTO orders (contract_id, pay_id, sub_id, plan_id, order_status, final_price)
    VALUES (v_contract_id, p_pay_id, p_sub_id, p_plan_id, ''?? ?????? ??????'', v_plan_price) -- v_plan_price ?? ????? final_price
    RETURNING order_id INTO p_order_id;

    COMMIT;
END;
'
    LANGUAGE plpgsql;
-- Definition for type payment_status_enum (OID = 32792):
CREATE TYPE payment_status_enum (
    INTERNALLENGTH = 4,
    INPUT = enum_in,
    OUTPUT = enum_out,
    ALIGNMENT = int4,
    STORAGE = plain,
    PASSEDBYVALUE
);
-- Definition for function check_volume_limit (OID = 32850):
CREATE FUNCTION check_volume_limit () RETURNS trigger
    AS '', '
DECLARE
    v_remaining NUMERIC;
BEGIN
    -- ???? ???? ??? ??????????
    SELECT remaining_volume INTO v_remaining 
    FROM service WHERE service_id = NEW.service_id;

    IF NEW.used_volume > v_remaining THEN
        RAISE EXCEPTION ''??? ????? ??? ?? ?????? ?????????? ???!'';
    END IF;

    -- ??? ?????? ?? ??? ?????????? ?? ???? ?????
    UPDATE service 
    SET remaining_volume = remaining_volume - NEW.used_volume
    WHERE service_id = NEW.service_id;

    RETURN NEW;
END;
'
    LANGUAGE plpgsql;
-- Definition for function cleanup_old_pending_orders (OID = 32852):
CREATE FUNCTION cleanup_old_pending_orders () RETURNS trigger
    AS '', '
BEGIN
    -- ??????? ?? CTE ???? ??? ???? ?????? ?????? ?????? ? ???????
    -- ??? ?? ??? ??? ?? ???? payment ???? ???? (??? created_at ?? pay_timestamp) ????
    -- ??? ?? ???? orders ???? ????? ??? ?????? ????????? ??? ???? ?? ??? ?? ???????
    
    WITH deleted_orders AS (
        DELETE FROM orders
        WHERE order_status = ''?? ?????? ??????''
          -- ???? ???? ????????? ?? ??? ?? 1 ??? ?? ???????? ????? ???
          AND pay_id IN (
              SELECT pay_id 
              FROM payment 
              WHERE pay_status = ''?? ?????? ??????'' 
                -- ??? ???? ????? ??? ??????? ?????? ??? ?? ?? ????? ??????? ????
                AND pay_timestamp < NOW() - INTERVAL ''1 day''
          )
        RETURNING pay_id, contract_id
    ),
    deleted_payments AS (
        DELETE FROM payment 
        WHERE pay_id IN (SELECT pay_id FROM deleted_orders)
    )
    DELETE FROM contracts 
    WHERE contract_id IN (SELECT contract_id FROM deleted_orders);

    RETURN NEW;
END;
'
    LANGUAGE plpgsql;
-- Definition for function cleanup_expired_pending_orders (OID = 32854):
CREATE FUNCTION cleanup_expired_pending_orders (p_hours integer) RETURNS void
    AS '', '
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN 
        SELECT o.order_id, o.contract_id, o.pay_id 
        FROM orders o
        JOIN payment p ON o.pay_id = p.pay_id
        WHERE p.pay_status = ''?? ?????? ??????'' 
          AND p.pay_timestamp < (NOW() - (p_hours || '' hours'')::INTERVAL)
    LOOP
        DELETE FROM orders WHERE order_id = rec.order_id;
        DELETE FROM contracts WHERE contract_id = rec.contract_id;
        DELETE FROM payment WHERE pay_id = rec.pay_id;
    END LOOP;
END;
'
    LANGUAGE plpgsql;
-- Definition for function check_and_update_data_usage (OID = 32855):
CREATE FUNCTION check_and_update_data_usage () RETURNS trigger
    AS '', '
DECLARE
    v_remaining NUMERIC;
BEGIN
    SELECT remaining_volume INTO v_remaining
    FROM service
    WHERE service_id = NEW.service_id;

    IF NEW.used_volume > v_remaining THEN
        RAISE EXCEPTION ''??? ????? ???? ????! ??? ????????: % ? ??? ??????????: %'', NEW.used_volume, v_remaining;
    END IF;

    UPDATE service
    SET remaining_volume = remaining_volume - NEW.used_volume
    WHERE service_id = NEW.service_id;

    RETURN NEW;
END;
'
    LANGUAGE plpgsql SECURITY DEFINER;
-- Definition for function initiate_loan_modem_order (OID = 32858):
CREATE FUNCTION initiate_loan_modem_order (p_sub_id integer, p_product_serials integer[]) RETURNS record
    AS '', '
DECLARE
    v_total_deposit DECIMAL := 0;
    v_deposit_amt DECIMAL;
    v_serial INT;
BEGIN

    FOR v_serial, v_deposit_amt IN
        SELECT p.prod_serial, lp.loan_deposit
        FROM product p
        JOIN loan_product lp ON p.prod_serial = lp.prod_serial
        WHERE p.prod_serial = ANY(p_product_serials)
          AND p.prod_status = ''Available''
    LOOP
        v_total_deposit := v_total_deposit + v_deposit_amt;

        UPDATE product
        SET prod_status = ''Reserved''
        WHERE prod_serial = v_serial;
    END LOOP;

    INSERT INTO payment (pay_amount, pay_type, pay_status)
    VALUES (v_total_deposit, ''Deposit'', ''Pending'')
    RETURNING pay_id INTO o_pay_id;

    INSERT INTO sub_equipment_purchase (sub_id, serial_number, pay_id)
    SELECT p_sub_id, unnest(p_product_serials), o_pay_id;

END;
'
    LANGUAGE plpgsql;
-- Definition for function finalize_loan_modem_order (OID = 32859):
CREATE FUNCTION finalize_loan_modem_order (p_pay_id integer, p_transaction_code varchar) RETURNS void
    AS '', '
BEGIN

    UPDATE payment
    SET pay_status = ''Success'',
        pay_code = p_transaction_code,
        pay_timestamp = CURRENT_TIMESTAMP
    WHERE pay_id = p_pay_id
      AND pay_status = ''Pending'';

    IF NOT FOUND THEN
        RAISE EXCEPTION ''Invalid or already processed payment'';
    END IF;

    UPDATE product
    SET prod_status = ''Loaned''
    WHERE prod_serial IN (
        SELECT serial_number
        FROM sub_equipment_purchase
        WHERE pay_id = p_pay_id
    )
    AND prod_status = ''Reserved'';

END;
'
    LANGUAGE plpgsql;
-- Definition for function initiate_sell_equipment_order (OID = 32860):
CREATE FUNCTION initiate_sell_equipment_order (p_sub_id integer, p_product_serials integer[]) RETURNS record
    AS '', '
DECLARE
    v_total_price DECIMAL := 0;
BEGIN
    -- ?????? ????? ???? ??????? ????? ?????
    SELECT COALESCE(SUM(sp.prod_price), 0)
    INTO v_total_price
    FROM product p
    JOIN sell_product sp ON p.prod_serial = sp.prod_serial
    WHERE p.prod_serial = ANY(p_product_serials)
      AND p.prod_status = ''Available'';

    -- ????? ????? ??????? ?? ???? ???
    UPDATE product
    SET prod_status = ''Reserved''
    WHERE prod_serial = ANY(p_product_serials)
      AND prod_status = ''Available'';

    -- ????? ????? ?????? ?? ????? Pending
    INSERT INTO payment (pay_amount, pay_type, pay_status)
    VALUES (v_total_price, ''Purchase'', ''Pending'')
    RETURNING pay_id INTO o_pay_id;

    -- ??? ??????? ??????? ??? ???? ?????
    INSERT INTO sub_equipment_purchase (sub_id, serial_number, pay_id)
    SELECT p_sub_id, unnest(p_product_serials), o_pay_id;

END;
'
    LANGUAGE plpgsql;
-- Definition for function finalize_sell_equipment_order (OID = 32861):
CREATE FUNCTION finalize_sell_equipment_order (p_pay_id integer, p_transaction_code varchar) RETURNS void
    AS '', '
BEGIN
    -- ????? ??????
    UPDATE payment
    SET pay_status = ''Success'',
        pay_code = p_transaction_code,
        pay_timestamp = CURRENT_TIMESTAMP
    WHERE pay_id = p_pay_id
      AND pay_status = ''Pending'';

    IF NOT FOUND THEN
        RAISE EXCEPTION ''?????? ??????? ??? ?? ???? ?????? ??? ???.'';
    END IF;

    -- ????? ????? ??????? ?? ???? ?? ?????? ???
    UPDATE product
    SET prod_status = ''Sold''
    WHERE prod_serial IN (
        SELECT serial_number
        FROM sub_equipment_purchase
        WHERE pay_id = p_pay_id
    )
    AND prod_status = ''Reserved'';

END;
'
    LANGUAGE plpgsql;
-- Definition for type payment_status_enum2 (OID = 32863):
CREATE TYPE payment_status_enum2 (
    INTERNALLENGTH = 4,
    INPUT = enum_in,
    OUTPUT = enum_out,
    ALIGNMENT = int4,
    STORAGE = plain,
    PASSEDBYVALUE
);
--
-- Data for blobs (OID = 16424) (LIMIT 0,12)
--
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100000, '1234567890', 'ali.ahmadi@gmail.com', 'Ali Ahmadi', true, '5/9/2026', 'Tehran Valiasr Street No 12', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100001, '2345678901', 'sara.moradi@yahoo.com', 'Sara Moradi', false, '5/9/2026', 'Mashhad Sajjad Boulevard Alley 5', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100002, '3456789012', 'reza.karimi@gmail.com', 'Reza Karimi', true, '5/9/2026', 'Isfahan Chaharbagh Abbasi Street', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100003, '4567890123', 'mina.rostami@outlook.com', 'Mina Rostami', true, '5/9/2026', 'Shiraz Zand Street Building 18', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100004, '5678901234', 'hossein.nikfar@gmail.com', 'Hossein Nikfar', false, '5/9/2026', 'Tabriz Imam Street Block 21', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100005, '6789012345', 'fatemeh.rahimi@yahoo.com', 'Fatemeh Rahimi', true, '5/9/2026', 'Karaj Azimieh Street Unit 4', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100006, '7890123456', 'mehdi.taheri@gmail.com', 'Mehdi Taheri', false, '5/9/2026', 'Qom Bahonar Boulevard No 9', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100007, '8901234567', 'niloofar.heydari@outlook.com', 'Niloofar Heydari', true, '5/9/2026', 'Ahvaz Kianpars Street Building 2', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100008, '9012345678', 'amir.hosseini@gmail.com', 'Amir Hosseini', true, '5/9/2026', 'Rasht Golsar Main Avenue', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100009, '0123456789', 'zahra.jafari@yahoo.com', 'Zahra Jafari', false, '5/9/2026', 'Kerman Shahid Beheshti Street', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100011, '1231231231', 'smth@email.com', 'danial gh', false, '5/14/2026', 'yazd abarkouh', '123456789', NULL);
INSERT INTO subscriber (sub_id, national_id, sub_email, sub_full_name, sub_status, sub_date, sub_address, pass, phone_num) VALUES (100012, '5030128451', 'danial@gmail.com', 'danial gh', true, '6/13/2026', '2emdkndvk djkv  vaasfdf', '123456789', '09135958699');
COMMIT;
--
-- Data for blobs (OID = 16439) (LIMIT 0,19)
--
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100000, 120000, '?????? ??????', '200001', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100001, 85000, '?????? ??????', '200002', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100002, 56000, '???? ?? ????', '200003', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100003, 99000, '?????? ??????', '200004', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100004, 150000, '???? ?? ????', '200005', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100005, 73000, '?????? ??????', '200006', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100006, 42000, '?????? ??????', '200007', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100007, 110000, '???? ?? ????', '200008', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100008, 68000, '?????? ??????', '200009', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100009, 135000, '???? ?? ????', '200010', '5/9/2026 12:33:33 PM', NULL);
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100015, NULL, '?????? ??????', 'TRX-123456789', '6/13/2026 7:03:03 AM', '?????? ???');
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100017, NULL, '?????? ??????', 'TRX-123456779', '6/13/2026 7:03:33 AM', '?????? ???');
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100018, NULL, '?????? ??????', NULL, '6/13/2026 7:29:34 AM', '?? ?????? ??????');
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100019, NULL, '?????? ??????', 'TRX-123444789', '6/13/2026 7:30:38 AM', '?????? ???');
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100020, NULL, '?????? ??????', 'TRX-123459999', '6/13/2026 7:40:32 AM', '?????? ???');
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100021, NULL, '?????? ??????', 'TRX-1234589', '6/13/2026 7:41:51 AM', '?????? ???');
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100022, NULL, '?????? ??????', NULL, '6/13/2026 7:44:39 AM', '?? ?????? ??????');
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100023, 100000, '?????? ??????', 'TRX-1232789', '6/13/2026 7:49:27 AM', '?????? ???');
INSERT INTO payment (pay_id, pay_amount, pay_type, pay_code, pay_timestamp, pay_status) VALUES (100030, 1500000, 'Purchase', 'TXN-ABC-123', '6/13/2026 12:44:22 PM', 'Success');
COMMIT;
--
-- Data for blobs (OID = 16451) (LIMIT 0,10)
--
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500002, 'Huawei', 'MA5608T', 'OLT', 'Available');
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500003, 'ZTE', 'F660', 'ONT', 'Available');
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500004, 'ZTE', 'ZXHN H168N', 'Modem', 'Sold');
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500005, 'TP-Link', 'Archer VR400', 'Modem Router', 'Available');
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500006, 'D-Link', 'DSL-2750U', 'Modem', 'Sold');
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500007, 'MikroTik', 'hAP lite', 'Router', 'Available');
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500008, 'Cisco', 'RV340', 'Router', 'Available');
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500009, 'Ubiquiti', 'EdgeRouter X', 'Router', 'Sold');
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500010, 'Netgear', 'Nighthawk R7000', 'Router', 'Available');
INSERT INTO product (prod_serial, prod_brand, prod_model, prod_type, prod_status) VALUES (500001, 'Huawei', 'HG8245H', 'ONT', 'Sold');
COMMIT;
--
-- Data for blobs (OID = 16457) (LIMIT 0,10)
--
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500001, 30);
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500002, 60);
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500003, 45);
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500004, 15);
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500005, 90);
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500006, 20);
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500007, 50);
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500008, 70);
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500009, 10);
INSERT INTO loan_product (prod_serial, loan_limit) VALUES (500010, 40);
COMMIT;
--
-- Data for blobs (OID = 16471) (LIMIT 0,10)
--
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500001, 1500000);
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500002, 3500000);
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500003, 1200000);
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500004, 800000);
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500005, 1100000);
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500006, 650000);
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500007, 450000);
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500008, 2200000);
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500009, 300000);
INSERT INTO sell_product (prod_serial, prod_price) VALUES (500010, 1500000);
COMMIT;
--
-- Data for blobs (OID = 16504) (LIMIT 0,18)
--
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (100, '1/1/2025', '12/31/2025', 'Tehran, Valiasr St');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (101, '1/15/2025', '1/15/2026', 'Shiraz, Zand Blvd');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (102, '2/1/2025', '8/1/2025', 'Tabriz, Imam St');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (103, '2/10/2025', '11/10/2025', 'Mashhad, Ahmadabad St');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (104, '3/5/2025', '3/5/2026', 'Isfahan, Chaharbagh Ave');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (105, '3/20/2025', '9/20/2025', 'Karaj, Azadi St');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (106, '4/1/2025', '4/1/2026', 'Ahvaz, Kianpars Blvd');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (107, '4/12/2025', '10/12/2025', 'Qom, Ammar Yasir St');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (108, '5/1/2025', '5/1/2026', 'Rasht, Golsar Blvd');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (109, '5/18/2025', '12/18/2025', 'Kerman, Shariati St');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (113, '6/13/2026', '7/13/2026', 'Tehran Valiasr Street No 12');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (115, '6/13/2026', '7/13/2026', 'Tehran Valiasr Street No 12');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (116, '6/13/2026', '7/13/2026', 'Tehran Valiasr Street No 12');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (117, '6/13/2026', '7/13/2026', '2emdkndvk djkv  vaasfdf');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (118, '6/13/2026', '7/13/2026', '2emdkndvk djkv  vaasfdf');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (119, '6/13/2026', '7/13/2026', '2emdkndvk djkv  vaasfdf');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (120, '6/13/2026', '7/13/2026', '2emdkndvk djkv  vaasfdf');
INSERT INTO contracts (contract_id, contract_date, contract_exp, contract_address) VALUES (121, '6/13/2026', '7/13/2026', '2emdkndvk djkv  vaasfdf');
COMMIT;
--
-- Data for blobs (OID = 16512) (LIMIT 0,10)
--
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (100, 2001, 'Bachelor', 1, '1/10/2023', 'Technician', 'ali.rezaei@mail.com', 100);
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (101, 2002, 'Master', 2, '5/15/2022', 'Engineer', 'sara.moradi@mail.com', 101);
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (102, 2003, 'Diploma', 3, '9/20/2021', 'Support', 'mehdi.karimi@mail.com', 102);
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (103, 2004, 'Bachelor', 4, '3/12/2023', 'Installer', 'hossein.ahmadi@mail.com', 103);
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (104, 2005, 'Master', 5, '11/5/2020', 'Manager', 'maryam.hashemi@mail.com', 104);
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (105, 2006, 'Bachelor', 6, '1/8/2024', 'Engineer', 'reza.najafi@mail.com', 105);
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (106, 2007, 'Diploma', 7, '7/14/2023', 'Technician', 'amir.golami@mail.com', 106);
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (107, 2008, 'Bachelor', 8, '12/1/2022', 'Support', 'fatemeh.yousefi@mail.com', 107);
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (108, 2009, 'Master', 9, '4/18/2021', 'Engineer', 'navid.taheri@mail.com', 108);
INSERT INTO labor (labor_id, personal_code, labor_education, inner_id, hire_date, labor_rule, labor_email, labor_contract) VALUES (109, 2010, 'Bachelor', 10, '6/30/2023', 'Installer', 'leila.kazemi@mail.com', 109);
COMMIT;
--
-- Data for blobs (OID = 16530) (LIMIT 0,10)
--
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (100, 'Basic ADSL', 100, 10, 50, false, 30, 'ADSL', 100000);
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (101, 'Basic Plus', 150, 15, 70, false, 30, 'ADSL', 100000);
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (102, 'Silver VDSL', 200, 20, 100, false, 30, 'VDSL', 100000);
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (103, 'Gold VDSL', 300, 30, 150, true, 30, 'VDSL', 100000);
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (104, 'Fiber Basic', 400, 50, 300, false, 30, 'FTTH', 100000);
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (105, 'Fiber Plus', 600, 70, 500, true, 30, 'FTTH', 100000);
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (106, 'Fiber Pro', 800, 100, 700, true, 60, 'FTTH', 100000);
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (107, 'Economy LTE', 80, 8, 40, false, 30, 'LTE', 100000);
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (108, 'Business LTE', 250, 40, 200, true, 30, 'LTE', 100000);
INSERT INTO isp_plan (plan_id, plan_name, plan_trafic, plan_upload, plan_download, static_ip, plan_duration, plan_tech, plan_price) VALUES (109, 'Enterprise Fiber', 1000, 200, 900, true, 90, 'FTTH', 100000);
COMMIT;
--
-- Data for blobs (OID = 16544) (LIMIT 0,10)
--
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10030, 'Internet connection is very slow today', 100000, '1/5/2025', '1/6/2025', 'closed');
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10031, 'Cannot connect to modem after restart', 100001, '1/10/2025', '1/11/2025', 'closed');
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10032, 'Frequent disconnection during evening', 100002, '2/2/2025', NULL, 'open');
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10033, 'Need help configuring router settings', 100003, '2/15/2025', '2/16/2025', 'closed');
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10034, 'Packet loss detected in online games', 100004, '3/1/2025', NULL, 'open');
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10035, 'Requesting upgrade to higher speed plan', 100005, '3/5/2025', '3/7/2025', 'closed');
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10036, 'Internet completely ??? ??? ???', 100006, '3/12/2025', NULL, 'open');
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10037, 'WiFi signal weak in some rooms', 100007, '3/20/2025', '3/21/2025', 'closed');
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10038, 'Billing problem after last payment', 100008, '4/1/2025', NULL, 'open');
INSERT INTO ticket (ticket_id, ticket_description, ticket_sub, ticket_open, ticket_close, ticket_status) VALUES (10039, 'Need technician to check connection', 100009, '4/10/2025', NULL, 'open');
COMMIT;
--
-- Data for blobs (OID = 16560) (LIMIT 0,10)
--
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10030, 100, 'The issue was checked and the connection was restored.', 'resolved');
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10031, 101, 'Router settings were reviewed and updated successfully.', 'closed');
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10032, 102, 'The disconnection issue is under investigation now.', 'pending');
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10033, 103, 'Configuration help was provided to the subscriber.', 'resolved');
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10034, 104, 'Network quality test was done and reported.', 'pending');
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10035, 105, 'The upgrade request was submitted to sales team.', 'forwarded');
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10036, 106, 'A technician was assigned to inspect the line.', 'open');
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10037, 107, 'WiFi coverage suggestions were sent to the customer.', 'closed');
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10038, 108, 'Billing issue was reviewed and correction applied.', 'resolved');
INSERT INTO ticket_ans (ans_id, ans_labor, ans_text, ans_lable) VALUES (10039, 109, 'Support request registered and awaiting follow-up.', 'open');
COMMIT;
--
-- Data for blobs (OID = 16586) (LIMIT 0,18)
--
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10030, 100, 100000, 100001, 101, 'completed', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10031, 101, 100001, 100002, 102, 'completed', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10032, 102, 100002, 100003, 103, 'pending', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10033, 103, 100003, 100004, 104, 'completed', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10034, 104, 100004, 100005, 105, 'cancelled', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10035, 105, 100005, 100006, 106, 'completed', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10036, 106, 100006, 100007, 107, 'pending', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10037, 107, 100007, 100008, 108, 'completed', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10038, 108, 100008, 100009, 109, 'completed', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10039, 109, 100009, 100000, 100, 'completed', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10041, 113, 100015, 100000, 101, '????? ???', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10043, 115, 100017, 100000, 101, '????? ???', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10044, 116, 100018, 100000, 101, '?? ?????? ??????', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10045, 117, 100019, 100012, 100, '????? ???', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10046, 118, 100020, 100012, 100, '????? ???', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10047, 119, 100021, 100012, 100, '????? ???', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10048, 120, 100022, 100012, 100, '?? ?????? ??????', NULL);
INSERT INTO orders (order_id, contract_id, pay_id, sub_id, plan_id, order_status, final_price) VALUES (10049, 121, 100023, 100012, 100, '????? ???', 100000);
COMMIT;
--
-- Data for blobs (OID = 16628) (LIMIT 0,1)
--
INSERT INTO sub_equipment_purchase (serial_number, sub_id, pay_id) VALUES (500001, 100000, 100030);
COMMIT;
--
-- Data for blobs (OID = 16721) (LIMIT 0,16)
--
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10040, 10030, 120, '7/1/2026', 100001);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10041, 10031, 90, '7/5/2026', 100002);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10042, 10032, 150, '7/10/2026', 100003);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10043, 10033, 80, '7/15/2026', 100004);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10044, 10034, 200, '7/20/2026', 100005);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10045, 10035, 60, '7/25/2026', 100006);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10046, 10036, 110, '8/1/2026', 100007);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10047, 10037, 75, '8/5/2026', 100008);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10048, 10038, 140, '8/10/2026', 100009);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10049, 10039, 95, '8/15/2026', 100000);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10050, 10041, 150, '7/13/2026', 100000);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10051, 10043, 150, '7/13/2026', 100000);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10052, 10045, 100, '7/13/2026', 100012);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10053, 10046, 100, '7/13/2026', 100012);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10054, 10047, 100, '7/13/2026', 100012);
INSERT INTO service (service_id, order_id, remaining_volume, expiration_date, sub_id) VALUES (10055, 10049, 100, '7/13/2026', 100012);
COMMIT;
--
-- Data for blobs (OID = 16788) (LIMIT 0,3)
--
INSERT INTO majors (majorcode, majortitle) VALUES (1, 'CE');
INSERT INTO majors (majorcode, majortitle) VALUES (2, 'CS');
INSERT INTO majors (majorcode, majortitle) VALUES (3, 'EE');
COMMIT;
--
-- Data for blobs (OID = 16794) (LIMIT 0,3)
--
INSERT INTO professors (profid, proffullname, depid) VALUES (100, 'larijani', 1);
INSERT INTO professors (profid, proffullname, depid) VALUES (101, 'nadjafikhah', 2);
INSERT INTO professors (profid, proffullname, depid) VALUES (102, 'farnoosh', 3);
COMMIT;
--
-- Data for blobs (OID = 16809) (LIMIT 0,3)
--
INSERT INTO students (stid, stfname, stlname, gender, stmjrcode, supervisorcode) VALUES ('931234', 'puria', 'ahmadi', 'Male', 3, 100);
INSERT INTO students (stid, stfname, stlname, gender, stmjrcode, supervisorcode) VALUES ('941122', 'amir', 'hoseini', 'Male', 2, 102);
INSERT INTO students (stid, stfname, stlname, gender, stmjrcode, supervisorcode) VALUES ('931235', 'sarina', 'farahani', 'Female', 1, 101);
COMMIT;
-- Definition for index idx_ticket_subscriber (OID = 24588):
CREATE INDEX idx_ticket_subscriber ON public.ticket USING btree (ticket_sub);
-- Definition for index idx_rder_subscriber (OID = 24589):
CREATE INDEX idx_rder_subscriber ON public.orders USING btree (sub_id);
-- Definition for index idx_setting_shift (OID = 24591):
CREATE INDEX idx_setting_shift ON public.shift_setting USING btree (shift_id);
-- Definition for index subscriber_pkey (OID = 16434):
ALTER TABLE ONLY subscriber
    ADD CONSTRAINT subscriber_pkey PRIMARY KEY (sub_id);
-- Definition for index subscriber_national_id_key (OID = 16436):
ALTER TABLE ONLY subscriber
    ADD CONSTRAINT subscriber_national_id_key UNIQUE (national_id);
-- Definition for index payment_pkey (OID = 16447):
ALTER TABLE ONLY payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (pay_id);
-- Definition for index product_pkey (OID = 16455):
ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (prod_serial);
-- Definition for index loan_product_pkey (OID = 16461):
ALTER TABLE ONLY loan_product
    ADD CONSTRAINT loan_product_pkey PRIMARY KEY (prod_serial);
-- Definition for index loan_product_prod_serial_fkey (OID = 16463):
ALTER TABLE ONLY loan_product
    ADD CONSTRAINT loan_product_prod_serial_fkey FOREIGN KEY (prod_serial) REFERENCES product(prod_serial);
-- Definition for index sell_product_pkey (OID = 16477):
ALTER TABLE ONLY sell_product
    ADD CONSTRAINT sell_product_pkey PRIMARY KEY (prod_serial);
-- Definition for index sell_product_prod_serial_fkey (OID = 16479):
ALTER TABLE ONLY sell_product
    ADD CONSTRAINT sell_product_prod_serial_fkey FOREIGN KEY (prod_serial) REFERENCES product(prod_serial);
-- Definition for index contracts_pkey (OID = 16509):
ALTER TABLE ONLY contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (contract_id);
-- Definition for index labor_pkey (OID = 16518):
ALTER TABLE ONLY labor
    ADD CONSTRAINT labor_pkey PRIMARY KEY (labor_id);
-- Definition for index labor_personal_code_key (OID = 16520):
ALTER TABLE ONLY labor
    ADD CONSTRAINT labor_personal_code_key UNIQUE (personal_code);
-- Definition for index labor_inner_id_key (OID = 16522):
ALTER TABLE ONLY labor
    ADD CONSTRAINT labor_inner_id_key UNIQUE (inner_id);
-- Definition for index labor_labor_contract_fkey (OID = 16524):
ALTER TABLE ONLY labor
    ADD CONSTRAINT labor_labor_contract_fkey FOREIGN KEY (labor_contract) REFERENCES contracts(contract_id);
-- Definition for index isp_plan_pkey (OID = 16536):
ALTER TABLE ONLY isp_plan
    ADD CONSTRAINT isp_plan_pkey PRIMARY KEY (plan_id);
-- Definition for index ticket_pkey (OID = 16550):
ALTER TABLE ONLY ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (ticket_id);
-- Definition for index ticket_ticket_sub_fkey (OID = 16552):
ALTER TABLE ONLY ticket
    ADD CONSTRAINT ticket_ticket_sub_fkey FOREIGN KEY (ticket_sub) REFERENCES subscriber(sub_id);
-- Definition for index ticket_ans_ans_id_key (OID = 16566):
ALTER TABLE ONLY ticket_ans
    ADD CONSTRAINT ticket_ans_ans_id_key UNIQUE (ans_id);
-- Definition for index ticket_ans_ans_id_fkey (OID = 16568):
ALTER TABLE ONLY ticket_ans
    ADD CONSTRAINT ticket_ans_ans_id_fkey FOREIGN KEY (ans_id) REFERENCES ticket(ticket_id);
-- Definition for index ticket_ans_ans_labor_fkey (OID = 16573):
ALTER TABLE ONLY ticket_ans
    ADD CONSTRAINT ticket_ans_ans_labor_fkey FOREIGN KEY (ans_labor) REFERENCES labor(labor_id);
-- Definition for index orders_pkey (OID = 16589):
ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);
-- Definition for index orders_contract_id_fkey (OID = 16591):
ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES contracts(contract_id);
-- Definition for index orders_pay_id_fkey (OID = 16596):
ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pay_id_fkey FOREIGN KEY (pay_id) REFERENCES payment(pay_id);
-- Definition for index orders_sub_id_fkey (OID = 16601):
ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_sub_id_fkey FOREIGN KEY (sub_id) REFERENCES subscriber(sub_id);
-- Definition for index orders_plan_id_fkey (OID = 16606):
ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES isp_plan(plan_id);
-- Definition for index sub_equipment_purchase_pkey (OID = 16631):
ALTER TABLE ONLY sub_equipment_purchase
    ADD CONSTRAINT sub_equipment_purchase_pkey PRIMARY KEY (serial_number, pay_id);
-- Definition for index sub_equipment_purchase_serial_number_fkey (OID = 16633):
ALTER TABLE ONLY sub_equipment_purchase
    ADD CONSTRAINT sub_equipment_purchase_serial_number_fkey FOREIGN KEY (serial_number) REFERENCES product(prod_serial);
-- Definition for index sub_equipment_purchase_sub_id_fkey (OID = 16638):
ALTER TABLE ONLY sub_equipment_purchase
    ADD CONSTRAINT sub_equipment_purchase_sub_id_fkey FOREIGN KEY (sub_id) REFERENCES subscriber(sub_id);
-- Definition for index sub_equipment_purchase_pay_id_fkey (OID = 16643):
ALTER TABLE ONLY sub_equipment_purchase
    ADD CONSTRAINT sub_equipment_purchase_pay_id_fkey FOREIGN KEY (pay_id) REFERENCES payment(pay_id);
-- Definition for index emp_equipment_purchase_pkey (OID = 16651):
ALTER TABLE ONLY emp_equipment_purchase
    ADD CONSTRAINT emp_equipment_purchase_pkey PRIMARY KEY (serial_number, pay_id);
-- Definition for index emp_equipment_purchase_serial_number_fkey (OID = 16653):
ALTER TABLE ONLY emp_equipment_purchase
    ADD CONSTRAINT emp_equipment_purchase_serial_number_fkey FOREIGN KEY (serial_number) REFERENCES product(prod_serial);
-- Definition for index emp_equipment_purchase_labor_id_fkey (OID = 16658):
ALTER TABLE ONLY emp_equipment_purchase
    ADD CONSTRAINT emp_equipment_purchase_labor_id_fkey FOREIGN KEY (labor_id) REFERENCES labor(labor_id);
-- Definition for index emp_equipment_purchase_pay_id_fkey (OID = 16663):
ALTER TABLE ONLY emp_equipment_purchase
    ADD CONSTRAINT emp_equipment_purchase_pay_id_fkey FOREIGN KEY (pay_id) REFERENCES payment(pay_id);
-- Definition for index sub_equipment_loan_pkey (OID = 16672):
ALTER TABLE ONLY sub_equipment_loan
    ADD CONSTRAINT sub_equipment_loan_pkey PRIMARY KEY (serial_number, sub_id, from_date);
-- Definition for index sub_equipment_loan_serial_number_fkey (OID = 16674):
ALTER TABLE ONLY sub_equipment_loan
    ADD CONSTRAINT sub_equipment_loan_serial_number_fkey FOREIGN KEY (serial_number) REFERENCES product(prod_serial);
-- Definition for index sub_equipment_loan_sub_id_fkey (OID = 16679):
ALTER TABLE ONLY sub_equipment_loan
    ADD CONSTRAINT sub_equipment_loan_sub_id_fkey FOREIGN KEY (sub_id) REFERENCES subscriber(sub_id);
-- Definition for index emp_equipment_loan_pkey (OID = 16688):
ALTER TABLE ONLY emp_equipment_loan
    ADD CONSTRAINT emp_equipment_loan_pkey PRIMARY KEY (serial_number, labor_id, from_date);
-- Definition for index emp_equipment_loan_serial_number_fkey (OID = 16690):
ALTER TABLE ONLY emp_equipment_loan
    ADD CONSTRAINT emp_equipment_loan_serial_number_fkey FOREIGN KEY (serial_number) REFERENCES product(prod_serial);
-- Definition for index emp_equipment_loan_labor_id_fkey (OID = 16695):
ALTER TABLE ONLY emp_equipment_loan
    ADD CONSTRAINT emp_equipment_loan_labor_id_fkey FOREIGN KEY (labor_id) REFERENCES labor(labor_id);
-- Definition for index service_pkey (OID = 16725):
ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (service_id);
-- Definition for index service_order_id_key (OID = 16727):
ALTER TABLE ONLY service
    ADD CONSTRAINT service_order_id_key UNIQUE (order_id);
-- Definition for index service_order_id_fkey (OID = 16729):
ALTER TABLE ONLY service
    ADD CONSTRAINT service_order_id_fkey FOREIGN KEY (order_id) REFERENCES orders(order_id);
-- Definition for index service_sub_id_fkey (OID = 16734):
ALTER TABLE ONLY service
    ADD CONSTRAINT service_sub_id_fkey FOREIGN KEY (sub_id) REFERENCES subscriber(sub_id);
-- Definition for index data_usage_pkey (OID = 16742):
ALTER TABLE ONLY data_usage
    ADD CONSTRAINT data_usage_pkey PRIMARY KEY (service_id, time_block);
-- Definition for index data_usage_service_id_fkey (OID = 16744):
ALTER TABLE ONLY data_usage
    ADD CONSTRAINT data_usage_service_id_fkey FOREIGN KEY (service_id) REFERENCES service(service_id);
-- Definition for index work_shift_pkey (OID = 16753):
ALTER TABLE ONLY work_shift
    ADD CONSTRAINT work_shift_pkey PRIMARY KEY (shift_id);
-- Definition for index shift_allocation_pkey (OID = 16758):
ALTER TABLE ONLY shift_allocation
    ADD CONSTRAINT shift_allocation_pkey PRIMARY KEY (labor_id);
-- Definition for index shift_allocation_labor_id_fkey (OID = 16760):
ALTER TABLE ONLY shift_allocation
    ADD CONSTRAINT shift_allocation_labor_id_fkey FOREIGN KEY (labor_id) REFERENCES labor(labor_id);
-- Definition for index shift_allocation_shift_id_fkey (OID = 16765):
ALTER TABLE ONLY shift_allocation
    ADD CONSTRAINT shift_allocation_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES work_shift(shift_id);
-- Definition for index shift_setting_pkey (OID = 16773):
ALTER TABLE ONLY shift_setting
    ADD CONSTRAINT shift_setting_pkey PRIMARY KEY (labor_id, shift_id);
-- Definition for index shift_setting_labor_id_fkey (OID = 16775):
ALTER TABLE ONLY shift_setting
    ADD CONSTRAINT shift_setting_labor_id_fkey FOREIGN KEY (labor_id) REFERENCES labor(labor_id);
-- Definition for index shift_setting_shift_id_fkey (OID = 16780):
ALTER TABLE ONLY shift_setting
    ADD CONSTRAINT shift_setting_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES work_shift(shift_id);
-- Definition for index majors_pkey (OID = 16791):
ALTER TABLE ONLY majors
    ADD CONSTRAINT majors_pkey PRIMARY KEY (majorcode);
-- Definition for index professors_pkey (OID = 16797):
ALTER TABLE ONLY professors
    ADD CONSTRAINT professors_pkey PRIMARY KEY (profid);
-- Definition for index students_pkey (OID = 16813):
ALTER TABLE ONLY students
    ADD CONSTRAINT students_pkey PRIMARY KEY (stid);
-- Definition for index students_stmjrcode_fkey (OID = 16815):
ALTER TABLE ONLY students
    ADD CONSTRAINT students_stmjrcode_fkey FOREIGN KEY (stmjrcode) REFERENCES majors(majorcode);
-- Definition for index students_supervisorcode_fkey (OID = 16820):
ALTER TABLE ONLY students
    ADD CONSTRAINT students_supervisorcode_fkey FOREIGN KEY (supervisorcode) REFERENCES professors(profid);
-- Definition for index payment_pay_code_key (OID = 32841):
ALTER TABLE ONLY payment
    ADD CONSTRAINT payment_pay_code_key UNIQUE (pay_code);
-- Definition for trigger pre_usage_check (OID = 32851):
CREATE TRIGGER pre_usage_check
    BEFORE INSERT ON data_usage
    FOR EACH ROW
    EXECUTE PROCEDURE check_volume_limit ();
-- Definition for trigger trg_cleanup_pending_orders (OID = 32853):
CREATE TRIGGER trg_cleanup_pending_orders
    AFTER INSERT ON orders
    FOR EACH ROW
    EXECUTE PROCEDURE cleanup_old_pending_orders ();
-- Definition for trigger trigger_check_data_usage (OID = 32856):
CREATE TRIGGER trigger_check_data_usage
    BEFORE INSERT ON data_usage
    FOR EACH ROW
    EXECUTE PROCEDURE check_and_update_data_usage ();
SET search_path = pg_catalog, pg_catalog;
COMMENT ON SCHEMA public IS 'standard public schema';
