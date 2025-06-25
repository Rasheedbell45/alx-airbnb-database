
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
