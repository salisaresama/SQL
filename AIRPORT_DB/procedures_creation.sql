use AIRPORT_DB;

-- DROPPING EXISTING PROCEDURES

DROP PROCEDURE insertFlight;
DROP PROCEDURE deleteFlight;

-- CREATING NEW STORED PROCEDURES

-- Insert a new flight
CREATE PROCEDURE insertFlight (@flight_number VARCHAR(10), 
		@home_code CHAR(3), @destination_code CHAR(3), 
		@planned_departure_time VARCHAR(15), @planned_arrival_time VARCHAR(15))
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;

	BEGIN TRY
        BEGIN TRANSACTION;

			DECLARE @id INT;
			IF EXISTS (SELECT * FROM flight) SELECT @id = MAX(id) FROM flight
				ELSE SET @id = 0;
			SET @id = @id + 1;

			DECLARE @dep_time TIME, @arr_time TIME;
			SET @dep_time = CAST(@planned_departure_time AS TIME);
			SET @arr_time = CAST(@planned_arrival_time AS TIME)

			INSERT INTO flight(id, flight_number, home_code, destination_code, planned_departure_time, planned_arrival_time)
			VALUES (@id, @flight_number, @home_code, @destination_code, @dep_time, @arr_time);

        COMMIT TRANSACTION;

		RETURN @id;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        DECLARE @Message nvarchar(2048) = ERROR_MESSAGE();
        DECLARE @Severity integer = ERROR_SEVERITY();
        DECLARE @State integer = ERROR_STATE();

        RAISERROR(@Message, @Severity, @State);
        RETURN -1;
    END CATCH;
END;

-- Remove a flight by its id
CREATE PROCEDURE deleteFlight (@id INTEGER)
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;

	BEGIN TRY
        BEGIN TRANSACTION;
		
			DELETE FROM flight WHERE flight.id = @id;
			DELETE FROM departure WHERE departure.id_flight = @id;
			DELETE FROM arrival WHERE arrival.id_flight = @id;

        COMMIT TRANSACTION;

		RETURN 1;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        DECLARE @Message nvarchar(2048) = ERROR_MESSAGE();
        DECLARE @Severity integer = ERROR_SEVERITY();
        DECLARE @State integer = ERROR_STATE();

        RAISERROR(@Message, @Severity, @State);
        RETURN -1;
    END CATCH;
END;


-- TRYING OUT PROCEDURES

EXEC insertFlight 
	@flight_number = 'OK 2012',
	@home_code = 'PRG',
	@destination_code = 'LAX',
	@planned_departure_time ='1:00:00 PM',
	@planned_arrival_time = '1:00:00 AM';

SELECT * FROM flight;

EXEC deleteFlight 
	@id = 1;

SELECT * FROM flight;