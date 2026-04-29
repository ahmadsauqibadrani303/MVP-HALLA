-- Membuat database
CREATE DATABASE hallaq_db;
USE hallaq_db;

-- 1. Tabel Users (Diperbarui dengan role 'mitra')
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('customer', 'mitra', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabel Mitra / Barbershops (BARU: Untuk UMKM Barbershop)
CREATE TABLE barbershops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT, -- Relasi ke tabel users dengan role 'mitra'
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Tabel Barbers (Diperbarui dengan relasi ke barbershop)
CREATE TABLE barbers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    barbershop_id INT, -- Barber terikat dengan mitra barbershop tertentu
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100),
    rating DECIMAL(2,1) DEFAULT 5.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (barbershop_id) REFERENCES barbershops(id) ON DELETE CASCADE
);

-- 4. Tabel Slots (Ketersediaan waktu barber)
CREATE TABLE slots (
    id INT AUTO_INCREMENT PRIMARY KEY,
    barber_id INT,
    slot_date DATE NOT NULL,
    start_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (barber_id) REFERENCES barbers(id) ON DELETE CASCADE
);

-- 5. Tabel Bookings (Transaksi aktif)
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    barber_id INT,
    slot_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'confirmed', 'completed', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (barber_id) REFERENCES barbers(id) ON DELETE CASCADE,
    FOREIGN KEY (slot_id) REFERENCES slots(id) ON DELETE CASCADE
);

-- 6. Tabel Histori & Reviews (BARU: Untuk menyimpan histori potong rambut & rating barber)
CREATE TABLE booking_histories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    user_id INT,
    barber_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5), -- Rating 1-5 untuk barber
    review_text TEXT,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (barber_id) REFERENCES barbers(id) ON DELETE CASCADE
);