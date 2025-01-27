--
-- PostgreSQL database dump
--

-- Dumped from database version 12.14
-- Dumped by pg_dump version 12.14

-- Started on 2023-03-22 23:08:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2979 (class 1262 OID 16394)
-- Name: Bank_Database; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Bank_Database" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';


ALTER DATABASE "Bank_Database" OWNER TO postgres;

\connect "Bank_Database"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 16395)
-- Name: Bank_schema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "Bank_schema";


ALTER SCHEMA "Bank_schema" OWNER TO postgres;

--
-- TOC entry 1 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2981 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 16396)
-- Name: client; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".client (
    id_client character varying(11) NOT NULL,
    id_information_client text NOT NULL,
    name_client character varying(100) NOT NULL,
    email_client character varying(50) NOT NULL,
    address_client text NOT NULL,
    phonenumber_client character varying(15) NOT NULL,
    CONSTRAINT email_check CHECK (((email_client)::text !~~ '%^A-Za-z0-9@.%'::text)),
    CONSTRAINT id_client_check CHECK (((id_client)::text !~~ '%[^A-Z0-9]%'::text)),
    CONSTRAINT name_client_check CHECK (((name_client)::text !~~ '%[^A-Z]%'::text)),
    CONSTRAINT number_check CHECK ((((phonenumber_client)::text ~~ '+%'::text) AND ((phonenumber_client)::text !~~ '%[^0-9]%'::text)))
);


ALTER TABLE "Bank_schema".client OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16435)
-- Name: currency; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".currency (
    id_currency integer NOT NULL,
    country_currency character varying(30) NOT NULL,
    name_currency character varying(30) NOT NULL,
    CONSTRAINT country_check CHECK (((country_currency)::text !~~ '%[^a-zA-Z]%'::text)),
    CONSTRAINT name_currency_check CHECK (((name_currency)::text !~~ '%[^a-zA-Z]%'::text))
);


ALTER TABLE "Bank_schema".currency OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16600)
-- Name: currency_id_currency_seq; Type: SEQUENCE; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE "Bank_schema".currency ALTER COLUMN id_currency ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "Bank_schema".currency_id_currency_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 206 (class 1259 OID 16422)
-- Name: department; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".department (
    id_department integer NOT NULL,
    address_department text NOT NULL
);


ALTER TABLE "Bank_schema".department OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16619)
-- Name: department_id_department_seq; Type: SEQUENCE; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE "Bank_schema".department ALTER COLUMN id_department ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "Bank_schema".department_id_department_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 205 (class 1259 OID 16412)
-- Name: job; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".job (
    id_job integer NOT NULL,
    name_job character varying(30) NOT NULL,
    salary double precision NOT NULL,
    responsibilities character varying(150) NOT NULL,
    CONSTRAINT name_job_check CHECK (((name_job)::text !~~ '%[^A-Z]%'::text))
);


ALTER TABLE "Bank_schema".job OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16621)
-- Name: job_id_job_seq; Type: SEQUENCE; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE "Bank_schema".job ALTER COLUMN id_job ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "Bank_schema".job_id_job_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 208 (class 1259 OID 16440)
-- Name: loan; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".loan (
    id_loan integer NOT NULL,
    description_loan text NOT NULL,
    name_loan character varying(50) NOT NULL,
    terms_loan character varying(15) NOT NULL,
    min_loan integer NOT NULL,
    max_loan integer NOT NULL,
    low_interest_firstmonth_loan real,
    interest_loan numeric NOT NULL,
    id_currency integer NOT NULL,
    schedule_payment_loan character varying(50) NOT NULL,
    CONSTRAINT interest_loan_check CHECK (((interest_loan)::double precision > (0)::double precision)),
    CONSTRAINT low_interest_firstmonth_loan_check CHECK ((low_interest_firstmonth_loan > (0)::double precision)),
    CONSTRAINT max_loan_check CHECK ((max_loan > 0)),
    CONSTRAINT min_loan_check CHECK ((min_loan > 0)),
    CONSTRAINT terms_loan_check CHECK (((terms_loan)::text ~ '^\d+ (year|years|month|months|day|days)$'::text))
);


ALTER TABLE "Bank_schema".loan OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16458)
-- Name: loan_contract; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".loan_contract (
    id_loan_contract integer NOT NULL,
    startdate_loan_contract date NOT NULL,
    id_client character varying(11) NOT NULL,
    id_loan integer NOT NULL,
    id_worker integer NOT NULL,
    amount_loan_contract integer NOT NULL,
    total_amount_loan_contract integer NOT NULL,
    enddate_loan_contract date NOT NULL,
    real_enddate_loan_contract date,
    interest_loan_contract integer NOT NULL,
    CONSTRAINT amount_loan_contract_check CHECK ((amount_loan_contract > 0)),
    CONSTRAINT interest_loan_contract_check CHECK ((interest_loan_contract > 0)),
    CONSTRAINT total_amount_loan_contract_check CHECK ((total_amount_loan_contract > amount_loan_contract))
);


ALTER TABLE "Bank_schema".loan_contract OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16666)
-- Name: loan_contract_id_loan_contract_seq; Type: SEQUENCE; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE "Bank_schema".loan_contract ALTER COLUMN id_loan_contract ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "Bank_schema".loan_contract_id_loan_contract_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 16664)
-- Name: loan_id_loan_seq; Type: SEQUENCE; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE "Bank_schema".loan ALTER COLUMN id_loan ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "Bank_schema".loan_id_loan_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 210 (class 1259 OID 16478)
-- Name: saving; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".saving (
    id_saving integer NOT NULL,
    name_saving character varying(50) NOT NULL,
    description_saving text NOT NULL,
    id_currency integer NOT NULL,
    terms_saving character varying(15) NOT NULL,
    schedule_payment_saving character varying(20),
    min_saving integer NOT NULL,
    interest_saving integer NOT NULL,
    max_payment_saving integer,
    amount_for_maxinterest_saving integer,
    maxinterest_saving integer,
    min_terms_saving character varying(15),
    withdrawal_saving boolean NOT NULL,
    CONSTRAINT amount_max_check CHECK ((amount_for_maxinterest_saving > 0)),
    CONSTRAINT interest_saving_check CHECK ((interest_saving > 0)),
    CONSTRAINT maxinterest_saving_check CHECK ((maxinterest_saving > 0)),
    CONSTRAINT maxpayment_saving_check CHECK ((max_payment_saving > 0)),
    CONSTRAINT min_saving_check CHECK ((min_saving >= 0)),
    CONSTRAINT min_terms_saving_check CHECK (((min_terms_saving)::text ~ '^\d+ (year|years|month|months|day|days)$'::text)),
    CONSTRAINT terms_saving_check CHECK (((terms_saving)::text ~ '^\d+ (year|years|month|months|day|days)$'::text))
);


ALTER TABLE "Bank_schema".saving OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16486)
-- Name: saving_contract; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".saving_contract (
    id_saving_contract integer NOT NULL,
    startdate_saving_contract date NOT NULL,
    id_client character varying(11) NOT NULL,
    id_saving integer NOT NULL,
    id_worker integer NOT NULL,
    start_amount_saving_contract integer NOT NULL,
    enddate_saving_contract date NOT NULL,
    real_enddate_saving_contract date,
    CONSTRAINT start_amount_check CHECK ((start_amount_saving_contract >= 0))
);


ALTER TABLE "Bank_schema".saving_contract OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16670)
-- Name: saving_contract_id_saving_contract_seq; Type: SEQUENCE; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE "Bank_schema".saving_contract ALTER COLUMN id_saving_contract ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "Bank_schema".saving_contract_id_saving_contract_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 16668)
-- Name: saving_id_saving_seq; Type: SEQUENCE; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE "Bank_schema".saving ALTER COLUMN id_saving ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "Bank_schema".saving_id_saving_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 213 (class 1259 OID 16521)
-- Name: schedule_loan_contract; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".schedule_loan_contract (
    id_loan_contract integer NOT NULL,
    date_payment_loan character varying(2) NOT NULL,
    payment_loan integer NOT NULL,
    interest_payment_loan integer NOT NULL,
    realdate_payment_loan date,
    state_payment_loan boolean NOT NULL,
    CONSTRAINT date_loan_check CHECK (((date_payment_loan)::text !~~ '%[^0-9]%'::text)),
    CONSTRAINT interest_payment_loan_check CHECK ((interest_payment_loan > 0)),
    CONSTRAINT payment_loan_check CHECK ((payment_loan > 0))
);


ALTER TABLE "Bank_schema".schedule_loan_contract OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16511)
-- Name: schedule_saving_contract; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".schedule_saving_contract (
    id_saving_contract integer NOT NULL,
    date_interest_payment_saving character varying(2) NOT NULL,
    interest_payment_saving integer,
    realdate_interest_payment_saving date,
    state_payment_saving boolean,
    CONSTRAINT date_check CHECK (((date_interest_payment_saving)::text !~~ '%^0-9%'::text)),
    CONSTRAINT interest_payment_saving_check CHECK ((interest_payment_saving >= 0))
);


ALTER TABLE "Bank_schema".schedule_saving_contract OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16404)
-- Name: worker; Type: TABLE; Schema: Bank_schema; Owner: postgres
--

CREATE TABLE "Bank_schema".worker (
    id_worker integer NOT NULL,
    name_worker character varying(100) NOT NULL,
    birthdate_worker date NOT NULL,
    id_information_worker text NOT NULL,
    phonenumber_worker character varying(15) NOT NULL,
    address_worker text NOT NULL,
    id_job integer NOT NULL,
    id_departament integer NOT NULL,
    CONSTRAINT name_worker_check CHECK (((name_worker)::text !~~ '%[^A-Za-z]%'::text)),
    CONSTRAINT phone_worker_check CHECK ((((phonenumber_worker)::text ~~ '+%'::text) AND ((phonenumber_worker)::text !~~ '%[^0-9]%'::text)))
);


ALTER TABLE "Bank_schema".worker OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16672)
-- Name: worker_id_worker_seq; Type: SEQUENCE; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE "Bank_schema".worker ALTER COLUMN id_worker ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "Bank_schema".worker_id_worker_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 2955 (class 0 OID 16396)
-- Dependencies: 203
-- Data for Name: client; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".client VALUES ('12345678901', 'U.S.A. New York, New York, 2000-01-01', 'John Smith', 'johnsmith@gmail.com', '123 Main St, New York, NY 10001', '+12125551234');
INSERT INTO "Bank_schema".client VALUES ('12345678903', 'U.S.A. Chicago, Illinois, 1995-12-31', 'Michael Lee', 'michaellee@gmail.com', '789 Maple Ave, Chicago, IL 60601', '+13135556789');
INSERT INTO "Bank_schema".client VALUES ('12345678902', 'U.S.A. New York, New York, 1980-05-15', 'Jane Doe', 'janedoe@gmail.com', '456 Oak St, Los Angeles, CA 90001', '+13235556789');
INSERT INTO "Bank_schema".client VALUES ('12345678904', ' U.S.A. Washington D.C., 1998-18-10', 'John Brown', 'johnbr@gmail.com', 'Washington D.C., U.S.A., 5th Avenue 134 - 1023', '+13145678908');
INSERT INTO "Bank_schema".client VALUES ('12345678900', 'U.S.A. Boston, Massachusetts, 1985-06-30', 'Sarah Johnson', 'sarahjohn@gmail.com', '1010 Elm St, Boston, MA 02101', '+16175559876');
INSERT INTO "Bank_schema".client VALUES ('4016565668', 'Russia, Saint-Petersburg, Kolpinsliy district, 2002-23-08', 'Afonina Natalia Rubenovna', 'nato4ka02@list.ru', 'Zavodskoy pr 24, Kolpino, Saint-Petersburg, Russia', '+79110038515');
INSERT INTO "Bank_schema".client VALUES ('12345678905', 'U.K. London, 1985-05-15', 'Emma Jones', 'emmajones@outlook.com', '456 High Street, London', '+44487654312');
INSERT INTO "Bank_schema".client VALUES ('12345678906', 'Paris, 1982-10-20', 'Pierre Dubois', 'pierredubois@gmail.com', '789 Rue de la Paix, Paris', '+3334567890');
INSERT INTO "Bank_schema".client VALUES ('12345678907', 'Canada, Toronto, 2001-07-05', 'Hannah Marie Meloche', 'meloche@gmail.com', '321 Yonge Street, Toronto', '+2223456789');
INSERT INTO "Bank_schema".client VALUES ('12345678908', 'Australia, Sydney, 1995-12-25', 'Oliver Taylor', 'olivertaylor@gmail.com', '456 George Street, Sydney', '+1112223333');
INSERT INTO "Bank_schema".client VALUES ('12345678909', 'United Arab Emirates, Dubai, 1998-03-01', 'Fatima Ahmed', 'fatimaahmed@outlook.com', '789 Sheikh Zayed Road, Dubai', '+6667778888');
INSERT INTO "Bank_schema".client VALUES ('12345678910', 'Japan, Tokyo, 1980-06-18', 'Yuki Nakamura', 'yukinakamura@gmail.com', '456 Shinjuku Street, Tokyo', '+9990001111');
INSERT INTO "Bank_schema".client VALUES ('12345678911', 'U.S.A. Los-Angeles, 1999-04-23', 'Ellie Thumann', 'thumann@gmail.com', '455 Oak St, Los Angeles, CA 90001', '+11220001111');
INSERT INTO "Bank_schema".client VALUES ('12345678912', 'U.S.A. Los-Angeles, 1991-06-15', 'Miley Cyrus', 'miley@gmail.com', '236 S Crescent Dr, Los Angeles, CA 90212', '+11227801111');
INSERT INTO "Bank_schema".client VALUES ('YA123456789', 'Repubblica Italiana, Lazio, 1990-10-10', 'Marco Marcucci', 'marco01@gmail.com', 'Ladispoli, Lazio, Italy, Via Milano 3', '+39197624382');


--
-- TOC entry 2959 (class 0 OID 16435)
-- Dependencies: 207
-- Data for Name: currency; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".currency VALUES (1, 'Russia', 'RUB');
INSERT INTO "Bank_schema".currency VALUES (2, 'U.S.A.', 'USD');
INSERT INTO "Bank_schema".currency VALUES (3, 'Europe', 'EUR');
INSERT INTO "Bank_schema".currency VALUES (4, 'China', 'CNY');
INSERT INTO "Bank_schema".currency VALUES (5, 'Canada', 'CAD');


--
-- TOC entry 2958 (class 0 OID 16422)
-- Dependencies: 206
-- Data for Name: department; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".department VALUES (1, '123 Main Street, Los Angeles');
INSERT INTO "Bank_schema".department VALUES (2, '456 Wilshire Boulevard, Los Angeles');
INSERT INTO "Bank_schema".department VALUES (3, '789 Hollywood Boulevard, Los Angeles');
INSERT INTO "Bank_schema".department VALUES (4, '1010 Sunset Boulevard, Los Angeles');
INSERT INTO "Bank_schema".department VALUES (5, '1313 Beverly Boulevard, Los Angeles');


--
-- TOC entry 2957 (class 0 OID 16412)
-- Dependencies: 205
-- Data for Name: job; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".job VALUES (1, 'Teller', 30000, 'Process financial transactions for customers, create cheking and usual saving accounts with free access');
INSERT INTO "Bank_schema".job VALUES (4, 'Investment Advisor', 75000, 'Provide investment advice to clients and manage their portfolios, create saving account with limited access');
INSERT INTO "Bank_schema".job VALUES (3, 'Mortgage officer', 60000, 'Identify customers'' mortgage needs and determine the type they could afford');
INSERT INTO "Bank_schema".job VALUES (5, 'Chief Financial Officer', 150000, 'Oversee the financial operations of the entire bank and make strategic financial decisions, able to open any of saving or loan accounts');
INSERT INTO "Bank_schema".job VALUES (2, 'Loan officer', 50000, 'Evaluates loan applications and makes decisions based on credit worthiness, makes an auto loan');


--
-- TOC entry 2960 (class 0 OID 16440)
-- Dependencies: 208
-- Data for Name: loan; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".loan VALUES (4, 'Personal loan in EUR', 'Personal loan in EUR', '6 months', 500, 10000, NULL, 10, 3, 'Once a month');
INSERT INTO "Bank_schema".loan VALUES (3, 'Personal loan in RUB', 'Personal loan in RUB', '6 months', 20000, 200000, NULL, 15, 1, 'Once a month');
INSERT INTO "Bank_schema".loan VALUES (6, 'Autoloan for 3 years', 'Autoloan', '3 years', 5000, 300000, NULL, 12, 2, 'Once a month');
INSERT INTO "Bank_schema".loan VALUES (2, 'Personal loan can be used for personal expenses', 'Personal loan up to 100000', '1 year', 1000, 100000, NULL, 9, 2, 'Once a month');
INSERT INTO "Bank_schema".loan VALUES (5, 'A home loan', 'Mortgage', '10 years', 100000, 1500000, NULL, 7, 2, 'Once a month');
INSERT INTO "Bank_schema".loan VALUES (1, 'Student loan is offered to college students and their families to help cover the cost of higher education', 'Sudent loan', '5 years', 30000, 400000, NULL, 3, 2, '5 year term starts after graduation, once a month');
INSERT INTO "Bank_schema".loan VALUES (7, 'Payday loan for personal expenses', 'Payday loan', '3 months', 200, 2000, NULL, 15, 2, 'Once in 90 days');


--
-- TOC entry 2961 (class 0 OID 16458)
-- Dependencies: 209
-- Data for Name: loan_contract; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".loan_contract VALUES (1, '2023-03-17', '12345678902', 6, 5, 70000, 83700, '2026-03-17', NULL, 12);
INSERT INTO "Bank_schema".loan_contract VALUES (2, '2023-03-17', '12345678900', 5, 3, 350000, 487680, '2033-03-17', NULL, 7);
INSERT INTO "Bank_schema".loan_contract VALUES (3, '2023-03-17', '12345678901', 2, 2, 3000, 3144, '2024-03-17', NULL, 9);
INSERT INTO "Bank_schema".loan_contract VALUES (4, '2023-03-17', '12345678907', 1, 5, 200000, 215640, '2032-03-17', NULL, 3);
INSERT INTO "Bank_schema".loan_contract VALUES (5, '2023-03-17', '12345678903', 7, 8, 1000, 1026, '2023-06-17', NULL, 15);


--
-- TOC entry 2962 (class 0 OID 16478)
-- Dependencies: 210
-- Data for Name: saving; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".saving VALUES (1, 'Regular saving', 'Regular saving earns 3% interest and offers quick access to funds. Member has to maintain a minimum account balance.', 2, '5 years', 'Once a month', 100, 3, NULL, NULL, NULL, NULL, true);
INSERT INTO "Bank_schema".saving VALUES (4, 'Zero balance saving', 'Zero balance saving earns 3% interest and offers quick access to funds. Member does not have to maintain a minimum account balance.', 2, '5 years', 'Once a month', 0, 3, NULL, NULL, NULL, NULL, true);
INSERT INTO "Bank_schema".saving VALUES (2, 'Certificate of deposit', 'Certificate of deposit for 2 years has 7% interest rate but has limited access to funds', 2, '3 years', 'Once a month', 1000, 7, NULL, 100000, 10, '2 years', false);
INSERT INTO "Bank_schema".saving VALUES (3, 'Certificate of deposit in EUR', 'Certificate of deposit in EUR for 2 years has 7% interest rate but has limited access to funds', 3, '3 years', 'Once a month', 1000, 7, NULL, NULL, NULL, '2 years', false);


--
-- TOC entry 2963 (class 0 OID 16486)
-- Dependencies: 211
-- Data for Name: saving_contract; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".saving_contract VALUES (4, '2023-03-17', '4016565668', 4, 8, 0, '2028-03-17', NULL);
INSERT INTO "Bank_schema".saving_contract VALUES (1, '2023-03-17', '12345678908', 1, 9, 2000, '2028-03-17', NULL);
INSERT INTO "Bank_schema".saving_contract VALUES (2, '2023-03-17', '12345678909', 2, 7, 150000, '2026-03-17', NULL);
INSERT INTO "Bank_schema".saving_contract VALUES (3, '2023-03-17', 'YA123456789', 3, 6, 10000, '2026-03-17', NULL);


--
-- TOC entry 2965 (class 0 OID 16521)
-- Dependencies: 213
-- Data for Name: schedule_loan_contract; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".schedule_loan_contract VALUES (1, '17', 70000, 13700, NULL, false);
INSERT INTO "Bank_schema".schedule_loan_contract VALUES (2, '17', 350000, 137680, NULL, false);
INSERT INTO "Bank_schema".schedule_loan_contract VALUES (3, '17', 3000, 144, NULL, false);
INSERT INTO "Bank_schema".schedule_loan_contract VALUES (4, '17', 200000, 15640, NULL, false);
INSERT INTO "Bank_schema".schedule_loan_contract VALUES (5, '17', 1000, 26, NULL, false);


--
-- TOC entry 2964 (class 0 OID 16511)
-- Dependencies: 212
-- Data for Name: schedule_saving_contract; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".schedule_saving_contract VALUES (1, '17', 5, NULL, false);
INSERT INTO "Bank_schema".schedule_saving_contract VALUES (2, '17', 31500, NULL, false);
INSERT INTO "Bank_schema".schedule_saving_contract VALUES (3, '17', 2100, NULL, false);
INSERT INTO "Bank_schema".schedule_saving_contract VALUES (4, '17', 0, NULL, false);


--
-- TOC entry 2956 (class 0 OID 16404)
-- Dependencies: 204
-- Data for Name: worker; Type: TABLE DATA; Schema: Bank_schema; Owner: postgres
--

INSERT INTO "Bank_schema".worker VALUES (1, 'John Black', '1989-02-27', 'E1234512345, 123 Main St, Los-Angeles CA U.S.A.', '+15551234567', '456 Elm St, Los-Angeles', 1, 1);
INSERT INTO "Bank_schema".worker VALUES (2, 'Jane Willow', '1985-12-25', 'C123498765, 456 Maple St, Los-Angeles CA U.S.A.', '+16782002832', '789 Oak St, Los-Angeles', 2, 1);
INSERT INTO "Bank_schema".worker VALUES (6, 'Sarah Kim', '1993-04-20', '13579825273, 333 Maple St, Los-Angeles CA. U.S.A.', '+15556789012', '1717 Pine St, Los-Angeles', 4, 3);
INSERT INTO "Bank_schema".worker VALUES (7, 'David Johns', '1991-11-11', '97273913579, 444 Cherry St, Los-Angeles CA. U.S.A.', '+15551239012', '1717 Pine St, Los-Angeles', 5, 3);
INSERT INTO "Bank_schema".worker VALUES (3, 'Bob Johnson', '1995-07-01', 'P123445678, 789 Cherry St, Los-Angeles CA. U.S.A.', '+15553456789', '1010 Pine St, Los-Angeles', 3, 1);
INSERT INTO "Bank_schema".worker VALUES (4, 'Mary Brown', '1992-02-14', 'E1234754321, 111 Walnut St, Los-Angeles CA. U.S.A.', '+15554567890', '1313 Cedar St, Los-Angeles', 4, 1);
INSERT INTO "Bank_schema".worker VALUES (5, 'David Lee', '1988-09-30', 'M123324680, 222 Oak St, Los-Angeles CA. U.S.A.', '+15555678901', '1515 Elm St, Los-Angeles', 5, 1);
INSERT INTO "Bank_schema".worker VALUES (8, 'Amanda Smith', '1989-06-05', '1257392947,  555 Walnut St, Los-Angeles CA. U.S.A.', '+15551239012', '2121 Oak St, Los-Angeles', 2, 3);
INSERT INTO "Bank_schema".worker VALUES (9, 'Peter Brown', '1990-03-25', '1255337007,  123 Beverly St, Los-Angeles CA. U.S.A.', '+15551239012', '2121 Oak St, Los-Angeles', 1, 3);


--
-- TOC entry 2982 (class 0 OID 0)
-- Dependencies: 214
-- Name: currency_id_currency_seq; Type: SEQUENCE SET; Schema: Bank_schema; Owner: postgres
--

SELECT pg_catalog.setval('"Bank_schema".currency_id_currency_seq', 4, true);


--
-- TOC entry 2983 (class 0 OID 0)
-- Dependencies: 215
-- Name: department_id_department_seq; Type: SEQUENCE SET; Schema: Bank_schema; Owner: postgres
--

SELECT pg_catalog.setval('"Bank_schema".department_id_department_seq', 3, true);


--
-- TOC entry 2984 (class 0 OID 0)
-- Dependencies: 216
-- Name: job_id_job_seq; Type: SEQUENCE SET; Schema: Bank_schema; Owner: postgres
--

SELECT pg_catalog.setval('"Bank_schema".job_id_job_seq', 5, true);


--
-- TOC entry 2985 (class 0 OID 0)
-- Dependencies: 218
-- Name: loan_contract_id_loan_contract_seq; Type: SEQUENCE SET; Schema: Bank_schema; Owner: postgres
--

SELECT pg_catalog.setval('"Bank_schema".loan_contract_id_loan_contract_seq', 1, false);


--
-- TOC entry 2986 (class 0 OID 0)
-- Dependencies: 217
-- Name: loan_id_loan_seq; Type: SEQUENCE SET; Schema: Bank_schema; Owner: postgres
--

SELECT pg_catalog.setval('"Bank_schema".loan_id_loan_seq', 6, true);


--
-- TOC entry 2987 (class 0 OID 0)
-- Dependencies: 220
-- Name: saving_contract_id_saving_contract_seq; Type: SEQUENCE SET; Schema: Bank_schema; Owner: postgres
--

SELECT pg_catalog.setval('"Bank_schema".saving_contract_id_saving_contract_seq', 1, false);


--
-- TOC entry 2988 (class 0 OID 0)
-- Dependencies: 219
-- Name: saving_id_saving_seq; Type: SEQUENCE SET; Schema: Bank_schema; Owner: postgres
--

SELECT pg_catalog.setval('"Bank_schema".saving_id_saving_seq', 4, true);


--
-- TOC entry 2989 (class 0 OID 0)
-- Dependencies: 221
-- Name: worker_id_worker_seq; Type: SEQUENCE SET; Schema: Bank_schema; Owner: postgres
--

SELECT pg_catalog.setval('"Bank_schema".worker_id_worker_seq', 4, true);


--
-- TOC entry 2778 (class 2606 OID 16403)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id_client);


--
-- TOC entry 2794 (class 2606 OID 16644)
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (id_currency);


--
-- TOC entry 2790 (class 2606 OID 16625)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id_department);


--
-- TOC entry 2780 (class 2606 OID 16532)
-- Name: client id_client; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".client
    ADD CONSTRAINT id_client UNIQUE (id_client);


--
-- TOC entry 2796 (class 2606 OID 16646)
-- Name: currency id_currency_unique; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".currency
    ADD CONSTRAINT id_currency_unique UNIQUE (id_currency);


--
-- TOC entry 2792 (class 2606 OID 16627)
-- Name: department id_department_unique; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".department
    ADD CONSTRAINT id_department_unique UNIQUE (id_department);


--
-- TOC entry 2786 (class 2606 OID 16544)
-- Name: job id_job_unique; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".job
    ADD CONSTRAINT id_job_unique UNIQUE (id_job);


--
-- TOC entry 2802 (class 2606 OID 16555)
-- Name: loan_contract id_loan_contract_unique; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".loan_contract
    ADD CONSTRAINT id_loan_contract_unique UNIQUE (id_loan_contract);


--
-- TOC entry 2798 (class 2606 OID 16548)
-- Name: loan id_loan_unique; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".loan
    ADD CONSTRAINT id_loan_unique UNIQUE (id_loan);


--
-- TOC entry 2810 (class 2606 OID 16569)
-- Name: saving_contract id_saving_contract_unique; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".saving_contract
    ADD CONSTRAINT id_saving_contract_unique UNIQUE (id_saving_contract);


--
-- TOC entry 2806 (class 2606 OID 16560)
-- Name: saving id_saving_unique; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".saving
    ADD CONSTRAINT id_saving_unique UNIQUE (id_saving);


--
-- TOC entry 2782 (class 2606 OID 16578)
-- Name: worker id_worker_unique; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".worker
    ADD CONSTRAINT id_worker_unique UNIQUE (id_worker);


--
-- TOC entry 2788 (class 2606 OID 16416)
-- Name: job job_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id_job);


--
-- TOC entry 2804 (class 2606 OID 16462)
-- Name: loan_contract loan_contract_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".loan_contract
    ADD CONSTRAINT loan_contract_pkey PRIMARY KEY (id_loan_contract);


--
-- TOC entry 2800 (class 2606 OID 16447)
-- Name: loan loan_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".loan
    ADD CONSTRAINT loan_pkey PRIMARY KEY (id_loan);


--
-- TOC entry 2812 (class 2606 OID 16490)
-- Name: saving_contract saving_contract_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".saving_contract
    ADD CONSTRAINT saving_contract_pkey PRIMARY KEY (id_saving_contract);


--
-- TOC entry 2808 (class 2606 OID 16485)
-- Name: saving saving_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".saving
    ADD CONSTRAINT saving_pkey PRIMARY KEY (id_saving);


--
-- TOC entry 2816 (class 2606 OID 16525)
-- Name: schedule_loan_contract schedule_loan_contract_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".schedule_loan_contract
    ADD CONSTRAINT schedule_loan_contract_pkey PRIMARY KEY (id_loan_contract);


--
-- TOC entry 2814 (class 2606 OID 16515)
-- Name: schedule_saving_contract schedule_saving_contract_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".schedule_saving_contract
    ADD CONSTRAINT schedule_saving_contract_pkey PRIMARY KEY (id_saving_contract);


--
-- TOC entry 2784 (class 2606 OID 16411)
-- Name: worker worker_pkey; Type: CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".worker
    ADD CONSTRAINT worker_pkey PRIMARY KEY (id_worker);


--
-- TOC entry 2820 (class 2606 OID 16463)
-- Name: loan_contract id_client; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".loan_contract
    ADD CONSTRAINT id_client FOREIGN KEY (id_client) REFERENCES "Bank_schema".client(id_client) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2824 (class 2606 OID 16496)
-- Name: saving_contract id_client; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".saving_contract
    ADD CONSTRAINT id_client FOREIGN KEY (id_client) REFERENCES "Bank_schema".client(id_client) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2819 (class 2606 OID 16647)
-- Name: loan id_currency; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".loan
    ADD CONSTRAINT id_currency FOREIGN KEY (id_currency) REFERENCES "Bank_schema".currency(id_currency) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2823 (class 2606 OID 16652)
-- Name: saving id_currency; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".saving
    ADD CONSTRAINT id_currency FOREIGN KEY (id_currency) REFERENCES "Bank_schema".currency(id_currency) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2818 (class 2606 OID 16628)
-- Name: worker id_department; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".worker
    ADD CONSTRAINT id_department FOREIGN KEY (id_departament) REFERENCES "Bank_schema".department(id_department) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2817 (class 2606 OID 16417)
-- Name: worker id_job; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".worker
    ADD CONSTRAINT id_job FOREIGN KEY (id_job) REFERENCES "Bank_schema".job(id_job) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2822 (class 2606 OID 16473)
-- Name: loan_contract id_loan; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".loan_contract
    ADD CONSTRAINT id_loan FOREIGN KEY (id_loan) REFERENCES "Bank_schema".loan(id_loan) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2828 (class 2606 OID 16526)
-- Name: schedule_loan_contract id_loan_contract; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".schedule_loan_contract
    ADD CONSTRAINT id_loan_contract FOREIGN KEY (id_loan_contract) REFERENCES "Bank_schema".loan_contract(id_loan_contract) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2825 (class 2606 OID 16501)
-- Name: saving_contract id_saving; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".saving_contract
    ADD CONSTRAINT id_saving FOREIGN KEY (id_saving) REFERENCES "Bank_schema".saving(id_saving) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2827 (class 2606 OID 16516)
-- Name: schedule_saving_contract id_saving_contract; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".schedule_saving_contract
    ADD CONSTRAINT id_saving_contract FOREIGN KEY (id_saving_contract) REFERENCES "Bank_schema".saving_contract(id_saving_contract) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2821 (class 2606 OID 16468)
-- Name: loan_contract id_worker; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".loan_contract
    ADD CONSTRAINT id_worker FOREIGN KEY (id_worker) REFERENCES "Bank_schema".worker(id_worker) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2826 (class 2606 OID 16506)
-- Name: saving_contract id_worker; Type: FK CONSTRAINT; Schema: Bank_schema; Owner: postgres
--

ALTER TABLE ONLY "Bank_schema".saving_contract
    ADD CONSTRAINT id_worker FOREIGN KEY (id_worker) REFERENCES "Bank_schema".worker(id_worker) MATCH FULL ON UPDATE CASCADE;


--
-- TOC entry 2980 (class 0 OID 0)
-- Dependencies: 2979
-- Name: DATABASE "Bank_Database"; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON DATABASE "Bank_Database" FROM postgres;
GRANT CREATE,CONNECT ON DATABASE "Bank_Database" TO postgres;
GRANT TEMPORARY ON DATABASE "Bank_Database" TO postgres WITH GRANT OPTION;


-- Completed on 2023-03-22 23:08:12

--
-- PostgreSQL database dump complete
--

