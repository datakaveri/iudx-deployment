--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Database creation
--

CREATE DATABASE iudx_rs WITH TEMPLATE = template0 OWNER = postgres;
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect iudx_rs

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.14 (Debian 10.14-1.pgdg90+1)
-- Dumped by pg_dump version 10.14 (Debian 10.14-1.pgdg90+1)

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: databroker; Type: TABLE; Schema: public; Owner: 
--

CREATE TABLE public.databroker (
    username character varying(255) NOT NULL,
    password character varying(50) NOT NULL
);




--
-- Name: file_server_token; Type: TABLE; Schema: public; Owner: 
--

CREATE TABLE public.file_server_token (
    user_token character varying NOT NULL,
    file_token character varying NOT NULL,
    validity_date timestamp without time zone NOT NULL,
    server_id character varying NOT NULL
);




--
-- Name: COLUMN file_server_token.server_id; Type: COMMENT; Schema: public; Owner: 
--

COMMENT ON COLUMN public.file_server_token.server_id IS 'from which API is called';


--
-- Name: registercallback; Type: TABLE; Schema: public; Owner: 
--

CREATE TABLE public.registercallback (
    subscriptionid text NOT NULL,
    callbackurl text,
    entities json,
    frequency timestamp with time zone,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    "userName" text,
    password text
);




--
-- Name: databroker databroker_pkey; Type: CONSTRAINT; Schema: public; Owner: 
--

ALTER TABLE ONLY public.databroker
    ADD CONSTRAINT databroker_pkey PRIMARY KEY (username);


--
-- Name: databroker databroker_username_key; Type: CONSTRAINT; Schema: public; 
--

ALTER TABLE ONLY public.databroker
    ADD CONSTRAINT databroker_username_key UNIQUE (username);


--
-- Name: file_server_token file_server_token_pkey; Type: CONSTRAINT; Schema: public; 
--

ALTER TABLE ONLY public.file_server_token
    ADD CONSTRAINT file_server_token_pkey PRIMARY KEY (user_token);


--
-- Name: registercallback registercallback_pkey; Type: CONSTRAINT; Schema: public; 
--

ALTER TABLE ONLY public.registercallback
    ADD CONSTRAINT registercallback_pkey PRIMARY KEY (subscriptionid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; 
--



--
ALTER TABLE public.databroker OWNER TO postgres;
ALTER TABLE public.file_server_token OWNER TO postgres;
ALTER TABLE public.registercallback OWNER TO postgres;
