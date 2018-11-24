USE AIRPORT_DB;

-- Dropping tables

DROP TABLE reservation;
DROP TABLE flight_service;
DROP TABLE aircraft_assignment;
DROP TABLE departure;
DROP TABLE arrival;
DROP TABLE terminal;
DROP TABLE aircraft_state_value;
DROP TABLE aircraft;
DROP TABLE airport;
DROP TABLE flight;
DROP TABLE company;
DROP TABLE client;
DROP TABLE aircraft_state;

-- Creating tables

CREATE TABLE airport
(
	id INTEGER NOT NULL CHECK(id > 0),
	airport_code CHAR(3) NOT NULL CHECK(airport_code NOT LIKE ' *' AND airport_code NOT LIKE '* ' AND airport_code <> ''),
	country_code CHAR(3) NOT NULL CHECK(country_code NOT LIKE ' *' AND country_code NOT LIKE '* ' AND country_code <> ''),
	flight_type VARCHAR(30) NOT NULL CHECK(flight_type NOT LIKE ' *' AND flight_type NOT LIKE '* ' AND flight_type <> ''),
	city VARCHAR(50) CHECK(city NOT LIKE ' *' AND city NOT LIKE '* ' AND city <> ''),
	PRIMARY KEY (id),
	UNIQUE (airport_code)
);

CREATE TABLE flight
(
	id INTEGER NOT NULL CHECK(id > 0),
	flight_number VARCHAR(10) NOT NULL CHECK(flight_number NOT LIKE ' *' AND flight_number NOT LIKE '* ' AND flight_number <> ''),
	planned_departure_time TIME NOT NULL,
	planned_arrival_time TIME NOT NULL,
	PRIMARY KEY (id),
	UNIQUE (flight_number)
);

CREATE TABLE company
(
	id INTEGER NOT NULL CHECK(id > 0),
	registration_number VARCHAR(20) NOT NULL CHECK(registration_number NOT LIKE ' *' AND registration_number NOT LIKE '* ' AND registration_number <> ''),
	company_name VARCHAR(50) CHECK(company_name NOT LIKE ' *' AND company_name NOT LIKE '* ' AND company_name <> ''),
	PRIMARY KEY (id),
	UNIQUE (registration_number)
);

CREATE TABLE client
(
	id INTEGER NOT NULL CHECK(id > 0),
	client_name VARCHAR(30) NOT NULL CHECK(client_name NOT LIKE ' *' AND client_name NOT LIKE '* ' AND client_name <> ''),
	passport_number VARCHAR(10) NOT NULL CHECK(passport_number NOT LIKE ' *' AND passport_number NOT LIKE '* ' AND passport_number <> ''),
	email VARCHAR(30) CHECK(email NOT LIKE ' *' AND email NOT LIKE '* ' AND email <> ''),
	telephone_number VARCHAR(15) CHECK(telephone_number NOT LIKE ' *' AND telephone_number NOT LIKE '* ' AND telephone_number <> ''),
	PRIMARY KEY (id),
	UNIQUE (client_name, passport_number)
);

CREATE TABLE aircraft_state
(
	id INTEGER NOT NULL CHECK(id > 0),
	state_title VARCHAR(30) NOT NULL CHECK(state_title NOT LIKE ' *' AND state_title NOT LIKE '* ' AND state_title <> ''),
	PRIMARY KEY (id),
	UNIQUE (state_title)
);

CREATE TABLE aircraft
(
	id INTEGER NOT NULL CHECK(id > 0),
	tail_number VARCHAR(30) NOT NULL CHECK(tail_number NOT LIKE ' *' AND tail_number NOT LIKE '* ' AND tail_number <> ''),
	id_airport INTEGER NOT NULL CHECK(id_airport > 0),
	id_company INTEGER NOT NULL CHECK(id_company > 0),
	aircraft_type VARCHAR(30) NOT NULL CHECK(aircraft_type NOT LIKE ' *' AND aircraft_type NOT LIKE '* ' AND aircraft_type <> ''),
	aircraft_capacity INTEGER CHECK(aircraft_capacity > 0),
	PRIMARY KEY (id),
	UNIQUE (tail_number),
	FOREIGN KEY (id_airport) REFERENCES AIRPORT(id) ON UPDATE CASCADE,
	FOREIGN KEY (id_company) REFERENCES COMPANY(id) ON UPDATE CASCADE
);

CREATE TABLE aircraft_state_value
(
	id_aircraft INTEGER NOT NULL CHECK(id_aircraft > 0),
	id_state INTEGER NOT NULL CHECK(id_state > 0),
	PRIMARY KEY (id_aircraft, id_state),
	FOREIGN KEY (id_aircraft) REFERENCES AIRCRAFT(id) ON UPDATE CASCADE,
	FOREIGN KEY (id_state) REFERENCES AIRCRAFT_STATE(id) ON UPDATE CASCADE
);

CREATE TABLE terminal
(
	id INTEGER NOT NULL CHECK(id > 0),
	terminal_name VARCHAR(30) NOT NULL CHECK(terminal_name NOT LIKE ' *' AND terminal_name NOT LIKE '* ' AND terminal_name <> ''),
	terminal_type VARCHAR(30) NOT NULL CHECK(terminal_type NOT LIKE ' *' AND terminal_type NOT LIKE '* ' AND terminal_type <> ''),
	id_airport INTEGER NOT NULL CHECK(id_airport > 0),
	PRIMARY KEY (id),
	UNIQUE (terminal_name),
	FOREIGN KEY (id_airport) REFERENCES AIRPORT(id) ON UPDATE CASCADE
);

CREATE TABLE arrival
(
	id INTEGER NOT NULL CHECK(id > 0),
	id_flight INTEGER NOT NULL CHECK(id_flight > 0),
	id_terminal INTEGER NOT NULL CHECK(id_terminal > 0),
	expected_arrival_time TIME NOT NULL,
	expected_arrival_date DATE NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id_flight) REFERENCES flight(id) ON UPDATE CASCADE,
	FOREIGN KEY (id_terminal) REFERENCES terminal(id) ON UPDATE CASCADE,
);

CREATE TABLE departure
(
	id INTEGER NOT NULL CHECK(id > 0),
	id_flight INTEGER NOT NULL CHECK(id_flight > 0),
	id_terminal INTEGER NOT NULL CHECK(id_terminal > 0),
	expected_departure_time TIME NOT NULL,
	expected_departure_date DATE NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id_flight) REFERENCES flight(id) ON UPDATE CASCADE,
	FOREIGN KEY (id_terminal) REFERENCES terminal(id) ON UPDATE CASCADE,
);

CREATE TABLE aircraft_assignment
(
	id_flight INTEGER NOT NULL CHECK(id_flight > 0),
	id_aircraft INTEGER NOT NULL CHECK(id_aircraft > 0),
	assigned BIT NOT NULL,
	PRIMARY KEY (id_flight, id_aircraft),
	FOREIGN KEY (id_flight) REFERENCES flight(id) ON UPDATE CASCADE,
	FOREIGN KEY (id_aircraft) REFERENCES aircraft(id) ON UPDATE CASCADE
);

CREATE TABLE flight_service
(
	id_flight INTEGER NOT NULL CHECK(id_flight > 0),
	id_company INTEGER NOT NULL CHECK(id_company > 0),
	participation BIT NOT NULL,
	PRIMARY KEY (id_flight, id_company),
	FOREIGN KEY (id_flight) REFERENCES flight(id) ON UPDATE CASCADE,
	FOREIGN KEY (id_company) REFERENCES company(id) ON UPDATE CASCADE
);

CREATE TABLE reservation
(
	id_departure INTEGER NOT NULL CHECK(id_departure > 0),
	id_client INTEGER NOT NULL CHECK(id_client > 0),
	payment BIT NOT NULL,
	payment_value DECIMAL NOT NULL CHECK(payment_value > 0),
	PRIMARY KEY (id_departure, id_client),
	FOREIGN KEY (id_departure) REFERENCES departure(id) ON UPDATE CASCADE,
	FOREIGN KEY (id_client) REFERENCES client(id) ON UPDATE CASCADE
);