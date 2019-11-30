DROP DATABASE IF EXISTS uzd_book_rental;
CREATE DATABASE uzd_book_rental;
use uzd_book_rental;

CREATE TABLE staff (
	staff_id int NOT NULL AUTO_INCREMENT,
    name varchar(50) NOT NULL,
    PRIMARY KEY (staff_id)
) ENGINE=INNODB;
INSERT INTO staff (name) VALUES ("John Doorman");

CREATE TABLE customers (
	customer_id int NOT NULL AUTO_INCREMENT,
    name varchar(50) NOT NULL,
    PRIMARY KEY (customer_id)
) ENGINE=INNODB;
INSERT INTO customers (name) VALUES ("Custard Mer");

CREATE TABLE books (
	book_id int NOT NULL AUTO_INCREMENT,
    title varchar(50) NOT NULL,
    isbn bigint NOT NULL,
    PRIMARY KEY (book_id)
) ENGINE=INNODB;
INSERT INTO books (title, isbn) VALUES ("DragonBorn", 1111111111111);

CREATE TABLE rented_books (
	book_id int NOT NULL,
	customer_id int NOT NULL,
    staff_id int NOT NULL,
    FOREIGN KEY (book_id)
		REFERENCES books(book_id),
	FOREIGN KEY (customer_id)
		REFERENCES customers(customer_id),
	FOREIGN KEY (staff_id)
		References staff(staff_id)
) ENGINE=INNODB;

CREATE TABLE rent_history (
	book_id int NOT NULL,
    rented date NOT NULL,
    returned date,
    FOREIGN KEY (book_id)
		REFERENCES books(book_id)
) ENGINE=INNODB;

CREATE TABLE rent_overdue (
	book_id int NOT NULL,
    overdue_days int NOT NULL,
    fine float NOT NULL DEFAULT '0',
    registered_staff_id int NOT NULL,
    noticed_date date NOT NULL,
    FOREIGN KEY(book_id)
		REFERENCES books(book_id),
	FOREIGN KEY(sniper_staff_id)
		REFERENCES staff(staff_id)
) ENGINE=INNODB;

CREATE EVENT book_overdue_days_update
	ON SCHEDULE
		EVERY 1 DAY
		STARTS (TIMESTAMP(CURRENT_DATE)) + INTERVAL 1 DAY
	DO
		UPDATE rent_overdue
        SET overdue_days = (SELECT DATEDIFF(CURRENT_DATE, noticed_date));

