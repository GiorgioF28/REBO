-- Recreate schema from scratch (Development Mode)
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-- 1. USERS
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    display_name VARCHAR(255),
    role VARCHAR(50) NOT NULL DEFAULT 'CUSTOMER' CHECK (role IN ('CUSTOMER', 'OWNER', 'STAFF', 'ADMIN')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. LOCALES
CREATE TABLE locales (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    owner_user_id BIGINT REFERENCES users(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_locales_owner ON locales(owner_user_id);

-- 3. LOCALE_STAFF
CREATE TABLE locale_staff (
    locale_id BIGINT REFERENCES locales(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    staff_role VARCHAR(50) DEFAULT 'STAFF' CHECK (staff_role IN ('STAFF', 'MANAGER')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (locale_id, user_id)
);

-- 4. MENU_CATEGORIES
CREATE TABLE menu_categories (
    id BIGSERIAL PRIMARY KEY,
    locale_id BIGINT REFERENCES locales(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(locale_id, name)
);
CREATE INDEX idx_menu_categories_locale ON menu_categories(locale_id);

-- 5. PRODUCTS
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    locale_id BIGINT REFERENCES locales(id) ON DELETE CASCADE,
    category_id BIGINT REFERENCES menu_categories(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price_cents INTEGER NOT NULL CHECK (price_cents >= 0),
    image_url VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(locale_id, name)
);
CREATE INDEX idx_products_locale ON products(locale_id);
CREATE INDEX idx_products_category ON products(category_id);

-- 6. ORDERS
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    locale_id BIGINT REFERENCES locales(id) ON DELETE RESTRICT,
    user_id BIGINT REFERENCES users(id) ON DELETE RESTRICT,
    status VARCHAR(50) DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'SUBMITTED', 'ACCEPTED', 'COMPLETED', 'CANCELED')),
    total_cents INTEGER DEFAULT 0 CHECK (total_cents >= 0),
    submitted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_orders_locale ON orders(locale_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);

-- 7. ORDER_ITEMS
CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id) ON DELETE RESTRICT,
    quantity INTEGER CHECK (quantity > 0),
    unit_cents INTEGER CHECK (unit_cents >= 0),
    line_cents INTEGER CHECK (line_cents >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(order_id, product_id)
);
CREATE INDEX idx_order_items_order ON order_items(order_id);

-- 8. REVIEWS
CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,
    locale_id BIGINT REFERENCES locales(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE RESTRICT,
    is_positive BOOLEAN NOT NULL,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_reviews_locale ON reviews(locale_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);

-- 9. LOCALE_REGULARS
CREATE TABLE locale_regulars (
    locale_id BIGINT REFERENCES locales(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (locale_id, user_id)
);

-- 10. LOCALE_PAGES
CREATE TABLE locale_pages (
    locale_id BIGINT PRIMARY KEY REFERENCES locales(id) ON DELETE CASCADE,
    content_md TEXT DEFAULT '',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. IMAGES
CREATE TABLE images (
    id BIGSERIAL PRIMARY KEY,
    owner_type VARCHAR(50) NOT NULL CHECK (owner_type IN ('LOCALE', 'PRODUCT', 'USER')),
    owner_id BIGINT NOT NULL,
    url VARCHAR(255) NOT NULL,
    alt VARCHAR(255),
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_images_owner ON images(owner_type, owner_id);
