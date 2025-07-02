-- Initial query to retrieve all bookings with user, property, and payment details
SELECT 
    b.id AS booking_id,
    b.created_at AS booking_date,
    
    -- User details
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    
    -- Property details
    p.id AS property_id,
    p.name AS property_name,
    p.location AS property_location,
    
    -- Payment details
    pay.id AS payment_id,
    pay.amount,
    pay.status,
    pay.payment_date

FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON pay.booking_id = b.id;

EXPLAIN ANALYZE
SELECT 
    b.id AS booking_id,
    b.created_at AS booking_date,
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    p.id AS property_id,
    p.name AS property_name,
    p.location AS property_location,
    pay.id AS payment_id,
    pay.amount,
    pay.status,
    pay.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON pay.booking_id = b.id;

CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);

-- Optimized query: Select only what's needed, ensure indexed fields are joined
SELECT 
    b.id AS booking_id,
    b.created_at,
    u.name AS user_name,
    p.name AS property_name,
    pay.amount

FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON pay.booking_id = b.id
ORDER BY b.created_at DESC
LIMIT 100;

CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings(created_at);
