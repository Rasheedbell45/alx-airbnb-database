-- Drop original table (if needed for reset/demo)
DROP TABLE IF EXISTS booking CASCADE;

-- Create the partitioned table
CREATE TABLE booking (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50)
) PARTITION BY RANGE (start_date);

-- Create partitions by month
CREATE TABLE booking_2024_01 PARTITION OF booking
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE booking_2024_02 PARTITION OF booking
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE booking_2024_03 PARTITION OF booking
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

-- Test query with EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT *
FROM booking
WHERE start_date >= '2024-02-01'
  AND start_date < '2024-03-01';

-- Report:
-- Query now only scans booking_2024_02 partition.
-- Reduced execution time compared to scanning all rows.
