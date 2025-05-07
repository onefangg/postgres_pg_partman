create schema partman_maint;
create schema actual;

create extension pgcrypto;
create extension pg_stat_statements;
create extension pgstattuple;

create extension pg_partman with schema partman_maint;


CREATE TABLE actual.uniform_dates (
                                      id SERIAL,
                                      random_date DATE NOT NULL
) PARTITION BY RANGE (random_date);
create index on actual.uniform_dates(random_date);

SELECT partman_maint.create_parent(
               p_parent_table => 'actual.uniform_dates',
               p_control      => 'random_date',
               p_type         => 'range',
               p_interval     => '1 year',
               p_premake      => 5);

INSERT INTO actual.uniform_dates (random_date)
SELECT
    ('2022-01-01'::date + (random() * ('2025-12-31'::date - '2022-01-01'::date)) * interval '1 day')::date
FROM
    generate_series(1, 1000000);

CREATE ROLE partman_user WITH LOGIN;
GRANT ALL ON SCHEMA partman TO partman_user;
GRANT ALL ON ALL TABLES IN SCHEMA partman TO partman_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA partman TO partman_user;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA partman TO partman_user;
GRANT ALL ON SCHEMA actual TO partman_user;
GRANT TEMPORARY ON DATABASE storage to partman_user;