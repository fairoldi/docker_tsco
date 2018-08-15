ALTER SYSTEM SET max_connections = 300;
ALTER SYSTEM SET default_statistics_target = 50;
ALTER SYSTEM SET constraint_exclusion = on;
ALTER SYSTEM SET checkpoint_timeout = '15min';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET log_min_messages = 'fatal';
ALTER SYSTEM SET log_min_error_statement = 'fatal';