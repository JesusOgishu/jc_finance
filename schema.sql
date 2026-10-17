DROP TABLE IF EXISTS jc_recurring;
DROP TABLE IF EXISTS jc_transactions;
DROP TABLE IF EXISTS jc_contacts;
DROP TABLE IF EXISTS jc_categories;
DROP TABLE IF EXISTS jc_cards;
DROP TABLE IF EXISTS jc_accounts;
DROP TABLE IF EXISTS jc_users;
CREATE TABLE jc_users(
  id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  name VARCHAR(150) NOT NULL,
  last_name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password VARCHAR(80) NOT NULL,
  age INT DEFAULT NULL,
  sex char(1) DEFAULT "I",
  status VARCHAR(25) DEFAULT "ACTIVE",
  date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_update DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  admin_id INT DEFAULT NULL,
  CONSTRAINT fk_jc_users_admin
  FOREIGN KEY (admin_id)
  REFERENCES jc_users(id)
);
CREATE TABLE jc_accounts(
  id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  name VARCHAR(150) NOT NULL,
  initial_balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  type VARCHAR(40) NOT NULL DEFAULT "BANK",
  status VARCHAR(25) DEFAULT "ACTIVE",
  date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_update DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  user_id INT NOT NULL, 
  CONSTRAINT fk_jc_accounts_users
  FOREIGN KEY (user_id)
  REFERENCES jc_users(id)
);
CREATE TABLE jc_cards(
  id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  name VARCHAR(140) NOT NULL,
  type VARCHAR(40) NOT NULL,
  balance_limit DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  payment_day INT DEFAULT NULL,
  cut_day INT DEFAULT NULL,
  last_digits VARCHAR(4) DEFAULT NULL,
  status VARCHAR(25) DEFAULT "ACTIVE",
  date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_update DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  account_id INT DEFAULT NULL,
  user_id INT NOT NULL,
  CONSTRAINT fk_jc_cards_accounts
  FOREIGN KEY (account_id)
  REFERENCES jc_accounts(id),
  CONSTRAINT fk_jc_cards_users
  FOREIGN KEY (user_id)
  REFERENCES jc_users(id)
);
CREATE TABLE jc_categories(
  id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  name VARCHAR(150) NOT NULL,
  type VARCHAR(40) NOT NULL,
  color VARCHAR(40) DEFAULT NULL,
  status VARCHAR(25) DEFAULT "ACTIVE",
  date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_update DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  user_id INT NOT NULL, 
  CONSTRAINT fk_jc_categories_users
  FOREIGN KEY (user_id)
  REFERENCES jc_users(id)
);
CREATE TABLE jc_contacts(
  id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(150) DEFAULT NULL,
  email VARCHAR(150) DEFAULT NULL,
  clabe VARCHAR(18) DEFAULT NULL, 
  last_digits VARCHAR(4) DEFAULT NULL, 
  type VARCHAR(150) DEFAULT "CONTACT", 
  status VARCHAR(25) DEFAULT "ACTIVE",
  date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_update DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  user_id INT NOT NULL,
  CONSTRAINT uq_jc_contacts_user_email
  UNIQUE (user_id, email),
  CONSTRAINT fk_jc_contacts_user
  FOREIGN KEY (user_id)
  REFERENCES jc_users(id)
);
CREATE TABLE jc_transactions(
  id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  type VARCHAR(100) NOT NULL,
  payment_method VARCHAR(100) DEFAULT NULL,
  amount DECIMAL(15,2) NOT NULL,
  description TEXT DEFAULT NULL,
  date DATE NOT NULL,
  status VARCHAR(25) DEFAULT "ACTIVE",
  date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_update DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  card_id INT DEFAULT NULL,
  account_id INT DEFAULT NULL,
  destination_account_id INT DEFAULT NULL,
  category_id INT DEFAULT NULL,
  user_id INT NOT NULL,
  contact_id INT DEFAULT NULL,
  CONSTRAINT fk_jc_transactions_cards
  FOREIGN KEY (card_id)
  REFERENCES jc_cards(id),
  CONSTRAINT fk_jc_transactions_categories
  FOREIGN KEY (category_id)
  REFERENCES jc_categories(id),
  CONSTRAINT fk_jc_transactions_users
  FOREIGN KEY (user_id)
  REFERENCES jc_users(id),
  CONSTRAINT fk_jc_transactions_accounts
  FOREIGN KEY (account_id)
  REFERENCES jc_accounts(id),
  CONSTRAINT fk_jc_transactions_destination_accounts
  FOREIGN KEY (destination_account_id)
  REFERENCES jc_accounts(id),
  CONSTRAINT fk_jc_transactions_contacts
  FOREIGN KEY (contact_id)
  REFERENCES jc_contacts(id),
  CONSTRAINT chk_jc_transactions_amount
  CHECK (amount > 0),
  INDEX idx_transactions_user_date (user_id, date)
);
CREATE TABLE jc_recurring(
  id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  name VARCHAR(150) NOT NULL,
  type VARCHAR(100) NOT NULL,
  payment_method VARCHAR(100) DEFAULT NULL,
  amount DECIMAL(15,2) NOT NULL,
  frequency VARCHAR(50) NOT NULL DEFAULT "BIWEEKLY",
  next_date DATE NOT NULL,
  final_date DATE DEFAULT NULL,
  status VARCHAR(25) DEFAULT "ACTIVE",
  date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_update DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  card_id INT DEFAULT NULL,
  user_id INT NOT NULL,
  account_id INT DEFAULT NULL,
  category_id INT DEFAULT NULL,
  CONSTRAINT fk_jc_recurring_cards
  FOREIGN KEY (card_id)
  REFERENCES jc_cards(id),
  CONSTRAINT fk_jc_recurring_categories
  FOREIGN KEY (category_id)
  REFERENCES jc_categories(id),
  CONSTRAINT fk_jc_recurring_accounts
  FOREIGN KEY (account_id)
  REFERENCES jc_accounts(id),
  CONSTRAINT fk_jc_recurring_users
  FOREIGN KEY (user_id)
  REFERENCES jc_users(id),
  CONSTRAINT chk_jc_recurring_amount
  CHECK (amount > 0),
  INDEX idx_recurring_user_date (user_id, next_date)
);
