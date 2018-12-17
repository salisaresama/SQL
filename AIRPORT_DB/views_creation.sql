USE AIRPORT_DB;

-- DROP EXISTING VIEWS

DROP VIEW parked_aircraft;
DROP VIEW view_departure_schedule;
DROP VIEW view_flight_carriers;
DROP VIEW view_departures;
DROP VIEW view_arrival_schedule;
DROP VIEW view_arrivals;

-- CREATE NEW VIEWS

CREATE VIEW view_departures
	AS 
	SELECT departure.id_flight, flight.flight_number, flight.home_code, flight.destination_code, departure.id_terminal, 
		departure.expected_departure_time, flight.planned_departure_time
	FROM departure INNER JOIN flight ON departure.id_flight = flight.id;

CREATE VIEW view_flight_carriers
	AS
	SELECT flight_service.id_flight, flight.flight_number, STRING_AGG(company.company_name, ', ') carriers
	FROM flight INNER JOIN flight_service ON flight.id = flight_service.id_flight
		INNER JOIN  company on flight_service.id_company = company.id
	WHERE participation = 1
	GROUP BY flight_service.id_flight, flight.flight_number;

CREATE VIEW view_departure_schedule
	AS
		SELECT view_departures.flight_number, terminal.terminal_name, 
			view_departures.home_code, view_departures.destination_code, view_flight_carriers.carriers, 
			CAST(expected_departure_time AS TIME) expected_departure_time, planned_departure_time
		FROM view_departures INNER JOIN terminal ON view_departures.id_terminal = terminal.id
			INNER JOIN view_flight_carriers ON view_departures.id_flight = view_flight_carriers.id_flight
		WHERE expected_departure_time < DATEADD(HOUR, +12, GETDATE()) AND expected_departure_time > DATEADD(MINUTE, -30, GETDATE());
		
CREATE VIEW view_arrivals
	AS 
	SELECT arrival.id_flight, flight.flight_number, flight.home_code, flight.destination_code, arrival.id_terminal, 
		arrival.expected_arrival_time, flight.planned_arrival_time
	FROM arrival INNER JOIN flight ON arrival.id_flight = flight.id;

CREATE VIEW view_arrival_schedule
	AS
		SELECT view_arrivals.flight_number, terminal.terminal_name, 
			view_arrivals.home_code, view_arrivals.destination_code, view_flight_carriers.carriers, 
			CAST(expected_arrival_time AS TIME) expected_arrival_time, planned_arrival_time
		FROM view_arrivals INNER JOIN terminal ON view_arrivals.id_terminal = terminal.id
			INNER JOIN view_flight_carriers ON view_arrivals.id_flight = view_flight_carriers.id_flight
		WHERE expected_arrival_time < DATEADD(HOUR, +12, GETDATE()) AND expected_arrival_time > DATEADD(MINUTE, -30, GETDATE());

CREATE VIEW parked_aircraft
	AS
		SELECT airport.id AS id_airport, airport.airport_code, aircraft.id AS id_aircraft, aircraft.tail_number, aircraft.aircraft_capacity
		FROM airport INNER JOIN aircraft ON airport.id = aircraft.id_airport;