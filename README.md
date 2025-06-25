Readme
-- Users Table
CREATE TABLE Users (
   user_id; Primary Key, UUID, Indexed
   first_name; VARCHAR
   last_name; VARCHAR
   email; VARCHAR
   password_hash; VARCHAR
   phone_number; VARCHAR
   role; ENUM (guest, host, admin)
   created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_email ON Users(email);

-- Properties Table
CREATE TABLE Properties (
   property_id; Primary Key, UUID, Indexed
   host_id; references User(user_id)
   name; VARCHAR
   description; TEXT
   location; VARCHAR
   pricepernight; DECIMAL
   created_at; TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
   updated_at; TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

    CONSTRAINT fk_property_host FOREIGN KEY (host_id) REFERENCES Users(user_id)
);

CREATE INDEX idx_property_host ON Properties(host_id);

-- Bookings Table
CREATE TABLE Bookings (
   booking_id; Primary Key, UUID, Indexed
   property_id; references Property(property_id)
   user_id; references User(user_id)
   start_date; DATE, NOT NULL
   end_date; DATE, NOT NULL
   total_price; DECIMAL, NOT NULL
   status; ENUM (confirmed), NOT NULL
   created_at; TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE INDEX idx_booking_property ON Bookings(property_id);
CREATE INDEX idx_booking_user ON Bookings(user_id);

-- Payments Table
CREATE TABLE Payments (
    payment_id; Primary Key, UUID, Indexed
    booking_id; references Booking(booking_id)
    amount; DECIMAL, NOT NULL
    payment_date; TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
    payment_method; ENUM (credit_card, paypal, stripe), NOT NULL

    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

CREATE INDEX idx_payment_booking ON Payments(booking_id);

-- Reviews Table
CREATE TABLE Reviews (
     review_id; Primary Key, UUID, Indexed
     property_id; references Property(property_id)
     user_id; references User(user_id)
     rating; INTEGER, NOT NULL
     comment; TEXT, NOT NULL
     created_at; TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
     
    CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Messages Table
CREATE TABLE Messages (
      message_id; Primary Key, UUID, Indexed
      sender_id; references User(user_id)
      recipient_id; references User(user_id)
      message_body; TEXT, NOT NULL
      sent_at; TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
      
    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES Users(user_id)
);


-- Insert Users
INSERT INTO Users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
('11111111-1111-1111-1111-111111111111', 'Alice', 'Walker', 'alice@example.com', 'hashedpass1', '1234567890', 'host', CURRENT_TIMESTAMP),
('22222222-2222-2222-2222-222222222222', 'Bob', 'Smith', 'bob@example.com', 'hashedpass2', '0987654321', 'guest', CURRENT_TIMESTAMP),
('33333333-3333-3333-3333-333333333333', 'Charlie', 'Johnson', 'charlie@example.com', 'hashedpass3', NULL, 'admin', CURRENT_TIMESTAMP);

-- Insert Properties
INSERT INTO Properties (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
('aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Ocean View Apartment', 'Beautiful ocean view.', 'Lagos', 150.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Mountain Cabin', 'Cozy cabin in the mountains.', 'Jos', 90.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Bookings
INSERT INTO Bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
('bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', '2025-07-01', '2025-07-05', 600.00, 'confirmed', CURRENT_TIMESTAMP),
('bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', '2025-08-10', '2025-08-12', 180.00, 'pending', CURRENT_TIMESTAMP);

-- Insert Payments
INSERT INTO Payments (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('ccccccc1-cccc-cccc-cccc-cccccccccccc', 'bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 600.00, CURRENT_TIMESTAMP, 'credit_card'),
('ccccccc2-cccc-cccc-cccc-cccccccccccc', 'bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 180.00, CURRENT_TIMESTAMP, 'paypal');

-- Insert Reviews
INSERT INTO Reviews (review_id, property_id, user_id, rating, comment, created_at) VALUES
('ddddddd1-dddd-dddd-dddd-dddddddddddd', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 5, 'Amazing stay with a great view!', CURRENT_TIMESTAMP),
('ddddddd2-dddd-dddd-dddd-dddddddddddd', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 4, 'Cozy and clean!', CURRENT_TIMESTAMP);

-- Insert Messages
INSERT INTO Messages (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
('eeeeeee1-eeee-eeee-eeee-eeeeeeeeeeee', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Hi! I have a question about the apartment.', CURRENT_TIMESTAMP),
('eeeeeee2-eeee-eeee-eeee-eeeeeeeeeeee', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Sure! How can I help?', CURRENT_TIMESTAMP);
