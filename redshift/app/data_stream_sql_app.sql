-----------------------------------------------------------------------------------------------------------------------
-- ******************************* ONE MINUTE ******************************* --
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM_60" (
    TransactionType VARCHAR(25), SourceSystem VARCHAR(25), ServiceName VARCHAR(25), ProductId VARCHAR(25), Channel VARCHAR(25),
    EventTimestamp BIGINT, EATTimestamp TIMESTAMP,
    EventHour INTEGER, EventDay INTEGER, EventMonth INTEGER, EventYear INTEGER,
    WeekInMonth INTEGER, WeekInYear INTEGER,
    DayInWeek INTEGER, DayInMonth INTEGER, DayInYear INTEGER,
    IsWeekDay BOOLEAN, DayName VARCHAR(3), MonthName VARCHAR(3),
    WindowAggregate BOOLEAN,
    WindowSize INTEGER, ItemCount BIGINT, Amount DOUBLE
    );
  
-- One-Minute Interval Summary By Dimensions
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PUMP "Dimension_PUMP_60" AS 
INSERT INTO "DESTINATION_SQL_STREAM_60" (
    TransactionType, SourceSystem, ServiceName, ProductId, Channel,
    EventTimestamp, EATTimestamp,
    EventHour, EventDay, EventMonth, EventYear,
    WeekInMonth, WeekInYear,
    DayInWeek, DayInMonth, DayInYear,
    IsWeekDay, DayName, MonthName,
    WindowAggregate,
    WindowSize, ItemCount, Amount
    )
SELECT 
    transactionType, sourceSystem, serviceName, productId, channel,
    UNIX_TIMESTAMP(eventTimestamp), EATTimestamp, 
    EXTRACT(HOUR FROM EATTimestamp), EXTRACT(DAY FROM EATTimestamp), EXTRACT(MONTH FROM EATTimestamp), EXTRACT(YEAR FROM EATTimestamp), 
    CAST(TIMESTAMP_TO_CHAR('W',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('w',EATTimestamp) as INTEGER),
    CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('D',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('d',EATTimestamp) as INTEGER),  
    CASE 
        WHEN CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER) > 5 THEN FALSE
        ELSE TRUE
    END, TIMESTAMP_TO_CHAR('EEE',EATTimestamp), TIMESTAMP_TO_CHAR('MMM',EATTimestamp),
    false,
    WindowSize, ItemCount, Amount
FROM 
(
    SELECT stream
        saf_datastream."transactionType" as transactionType, saf_datastream."sourceSystem" as sourceSystem, saf_datastream."serviceName" as serviceName, saf_datastream."productId" as productId, saf_datastream."channel" as channel,
        STEP (saf_datastream.ROWTIME BY INTERVAL '60' SECOND) as eventTimestamp, TO_TIMESTAMP(UNIX_TIMESTAMP(CURRENT_ROW_TIMESTAMP) + 10800000) as EATTimestamp,
        60 as WindowSize, count(*) as ItemCount, sum(saf_datastream."amount") as Amount
        FROM "SOURCE_SQL_STREAM_001" as saf_datastream
        GROUP BY 
        saf_datastream."transactionType", saf_datastream."sourceSystem", saf_datastream."serviceName", saf_datastream."productId", saf_datastream."channel",
        STEP (saf_datastream.ROWTIME BY INTERVAL '60' SECOND)
);

-- One-Minute Interval Summary
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PUMP "Summary_PUMP_60" AS 
INSERT INTO "DESTINATION_SQL_STREAM_60" (
    EventTimestamp, EATTimestamp,
    EventHour, EventDay, EventMonth, EventYear,
    WeekInMonth, WeekInYear,
    DayInWeek, DayInMonth, DayInYear,
    IsWeekDay, DayName, MonthName,
    WindowAggregate,
    WindowSize, ItemCount, Amount
    )
SELECT 
    UNIX_TIMESTAMP(eventTimestamp), EATTimestamp, 
    EXTRACT(HOUR FROM EATTimestamp), EXTRACT(DAY FROM EATTimestamp), EXTRACT(MONTH FROM EATTimestamp), EXTRACT(YEAR FROM EATTimestamp), 
    CAST(TIMESTAMP_TO_CHAR('W',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('w',EATTimestamp) as INTEGER),
    CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('D',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('d',EATTimestamp) as INTEGER),  
    CASE 
        WHEN CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER) > 5 THEN FALSE
        ELSE TRUE
    END, TIMESTAMP_TO_CHAR('EEE',EATTimestamp), TIMESTAMP_TO_CHAR('MMM',EATTimestamp),
    true,
    WindowSize, ItemCount, Amount
FROM 
(
    SELECT stream
        STEP (saf_datastream.ROWTIME BY INTERVAL '60' SECOND) as eventTimestamp, TO_TIMESTAMP(UNIX_TIMESTAMP(CURRENT_ROW_TIMESTAMP) + 10800000) as EATTimestamp,
        60 as WindowSize, count(*) as ItemCount, sum(saf_datastream."amount") as Amount
        FROM "SOURCE_SQL_STREAM_001" as saf_datastream
        GROUP BY 
        STEP (saf_datastream.ROWTIME BY INTERVAL '60' SECOND)
);

-----------------------------------------------------------------------------------------------------------------------
-- ******************************* FIVE MINUTES ******************************* --
-----------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM_300" (
    TransactionType VARCHAR(25), SourceSystem VARCHAR(25), ServiceName VARCHAR(25), ProductId VARCHAR(25), Channel VARCHAR(25),
    EventTimestamp BIGINT, EATTimestamp TIMESTAMP,
    EventHour INTEGER, EventDay INTEGER, EventMonth INTEGER, EventYear INTEGER,
    WeekInMonth INTEGER, WeekInYear INTEGER,
    DayInWeek INTEGER, DayInMonth INTEGER, DayInYear INTEGER,
    IsWeekDay BOOLEAN, DayName VARCHAR(3), MonthName VARCHAR(3),
    WindowAggregate BOOLEAN,
    WindowSize INTEGER, ItemCount BIGINT, Amount DOUBLE
    );
  
-- Five-Minute Interval Summary By Dimensions
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PUMP "Dimension_PUMP_300" AS 
INSERT INTO "DESTINATION_SQL_STREAM_300" (
    TransactionType, SourceSystem, ServiceName, ProductId, Channel,
    EventTimestamp, EATTimestamp,
    EventHour, EventDay, EventMonth, EventYear,
    WeekInMonth, WeekInYear,
    DayInWeek, DayInMonth, DayInYear,
    IsWeekDay, DayName, MonthName,
    WindowAggregate,
    WindowSize, ItemCount, Amount
    )
SELECT 
    transactionType, sourceSystem, serviceName, productId, channel,
    UNIX_TIMESTAMP(eventTimestamp), EATTimestamp, 
    EXTRACT(HOUR FROM EATTimestamp), EXTRACT(DAY FROM EATTimestamp), EXTRACT(MONTH FROM EATTimestamp), EXTRACT(YEAR FROM EATTimestamp), 
    CAST(TIMESTAMP_TO_CHAR('W',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('w',EATTimestamp) as INTEGER),
    CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('D',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('d',EATTimestamp) as INTEGER),  
    CASE 
        WHEN CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER) > 5 THEN FALSE
        ELSE TRUE
    END, TIMESTAMP_TO_CHAR('EEE',EATTimestamp), TIMESTAMP_TO_CHAR('MMM',EATTimestamp),
    false,
    WindowSize, ItemCount, Amount
FROM 
(
    SELECT stream
        saf_datastream."transactionType" as transactionType, saf_datastream."sourceSystem" as sourceSystem, saf_datastream."serviceName" as serviceName, saf_datastream."productId" as productId, saf_datastream."channel" as channel,
        STEP (saf_datastream.ROWTIME BY INTERVAL '5' MINUTE) as eventTimestamp, TO_TIMESTAMP(UNIX_TIMESTAMP(CURRENT_ROW_TIMESTAMP) + 10800000) as EATTimestamp,
        300 as WindowSize, count(*) as ItemCount, sum(saf_datastream."amount") as Amount
        FROM "SOURCE_SQL_STREAM_001" as saf_datastream
        GROUP BY 
        saf_datastream."transactionType", saf_datastream."sourceSystem", saf_datastream."serviceName", saf_datastream."productId", saf_datastream."channel",
        STEP (saf_datastream.ROWTIME BY INTERVAL '5' MINUTE)
);

-- Five-Minute Interval Summary
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PUMP "Summary_PUMP_300" AS 
INSERT INTO "DESTINATION_SQL_STREAM_300" (
    EventTimestamp, EATTimestamp,
    EventHour, EventDay, EventMonth, EventYear,
    WeekInMonth, WeekInYear,
    DayInWeek, DayInMonth, DayInYear,
    IsWeekDay, DayName, MonthName,
    WindowAggregate,
    WindowSize, ItemCount, Amount
    )
SELECT 
    UNIX_TIMESTAMP(eventTimestamp), EATTimestamp, 
    EXTRACT(HOUR FROM EATTimestamp), EXTRACT(DAY FROM EATTimestamp), EXTRACT(MONTH FROM EATTimestamp), EXTRACT(YEAR FROM EATTimestamp), 
    CAST(TIMESTAMP_TO_CHAR('W',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('w',EATTimestamp) as INTEGER),
    CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('D',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('d',EATTimestamp) as INTEGER),  
    CASE 
        WHEN CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER) > 5 THEN FALSE
        ELSE TRUE
    END, TIMESTAMP_TO_CHAR('EEE',EATTimestamp), TIMESTAMP_TO_CHAR('MMM',EATTimestamp),
    true,
    WindowSize, ItemCount, Amount
FROM 
(
    SELECT stream
        STEP (saf_datastream.ROWTIME BY INTERVAL '5' MINUTE) as eventTimestamp, TO_TIMESTAMP(UNIX_TIMESTAMP(CURRENT_ROW_TIMESTAMP) + 10800000) as EATTimestamp,
        300 as WindowSize, count(*) as ItemCount, sum(saf_datastream."amount") as Amount
        FROM "SOURCE_SQL_STREAM_001" as saf_datastream
        GROUP BY 
        STEP (saf_datastream.ROWTIME BY INTERVAL '5' MINUTE)
);

-----------------------------------------------------------------------------------------------------------------------
-- ******************************* FIFTEEN MINUTES ******************************* --
-----------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM_900" (
    TransactionType VARCHAR(25), SourceSystem VARCHAR(25), ServiceName VARCHAR(25), ProductId VARCHAR(25), Channel VARCHAR(25),
    EventTimestamp BIGINT, EATTimestamp TIMESTAMP,
    EventHour INTEGER, EventDay INTEGER, EventMonth INTEGER, EventYear INTEGER,
    WeekInMonth INTEGER, WeekInYear INTEGER,
    DayInWeek INTEGER, DayInMonth INTEGER, DayInYear INTEGER,
    IsWeekDay BOOLEAN, DayName VARCHAR(3), MonthName VARCHAR(3),
    WindowAggregate BOOLEAN,
    WindowSize INTEGER, ItemCount BIGINT, Amount DOUBLE
    );
  
-- Fifteen-Minute Interval Summary By Dimensions
-----------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PUMP "Dimension_PUMP_900" AS 
INSERT INTO "DESTINATION_SQL_STREAM_900" (
    TransactionType, SourceSystem, ServiceName, ProductId, Channel,
    EventTimestamp, EATTimestamp,
    EventHour, EventDay, EventMonth, EventYear,
    WeekInMonth, WeekInYear,
    DayInWeek, DayInMonth, DayInYear,
    IsWeekDay, DayName, MonthName,
    WindowAggregate,
    WindowSize, ItemCount, Amount
    )
SELECT 
    transactionType, sourceSystem, serviceName, productId, channel,
    UNIX_TIMESTAMP(eventTimestamp), EATTimestamp, 
    EXTRACT(HOUR FROM EATTimestamp), EXTRACT(DAY FROM EATTimestamp), EXTRACT(MONTH FROM EATTimestamp), EXTRACT(YEAR FROM EATTimestamp), 
    CAST(TIMESTAMP_TO_CHAR('W',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('w',EATTimestamp) as INTEGER),
    CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('D',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('d',EATTimestamp) as INTEGER),  
    CASE 
        WHEN CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER) > 5 THEN FALSE
        ELSE TRUE
    END, TIMESTAMP_TO_CHAR('EEE',EATTimestamp), TIMESTAMP_TO_CHAR('MMM',EATTimestamp),
    FALSE,
    WindowSize, ItemCount, Amount
FROM 
(
    SELECT stream
        saf_datastream."transactionType" as transactionType, saf_datastream."sourceSystem" as sourceSystem, saf_datastream."serviceName" as serviceName, saf_datastream."productId" as productId, saf_datastream."channel" as channel,
        STEP (saf_datastream.ROWTIME BY INTERVAL '15' MINUTE) as eventTimestamp, TO_TIMESTAMP(UNIX_TIMESTAMP(CURRENT_ROW_TIMESTAMP) + 10800000) as EATTimestamp,
        900 as WindowSize, count(*) as ItemCount, sum(saf_datastream."amount") as Amount
        FROM "SOURCE_SQL_STREAM_001" as saf_datastream
        GROUP BY 
        saf_datastream."transactionType", saf_datastream."sourceSystem", saf_datastream."serviceName", saf_datastream."productId", saf_datastream."channel",
        STEP (saf_datastream.ROWTIME BY INTERVAL '15' MINUTE)
);

-- Fifteen-Minute Interval Summary
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PUMP "Summary_PUMP_900" AS 
INSERT INTO "DESTINATION_SQL_STREAM_900" (
    EventTimestamp, EATTimestamp,
    EventHour, EventDay, EventMonth, EventYear,
    WeekInMonth, WeekInYear,
    DayInWeek, DayInMonth, DayInYear,
    IsWeekDay, DayName, MonthName,
    WindowAggregate,
    WindowSize, ItemCount, Amount
    )
SELECT 
    UNIX_TIMESTAMP(eventTimestamp), EATTimestamp, 
    EXTRACT(HOUR FROM EATTimestamp), EXTRACT(DAY FROM EATTimestamp), EXTRACT(MONTH FROM EATTimestamp), EXTRACT(YEAR FROM EATTimestamp), 
    CAST(TIMESTAMP_TO_CHAR('W',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('w',EATTimestamp) as INTEGER),
    CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('D',EATTimestamp) as INTEGER), CAST(TIMESTAMP_TO_CHAR('d',EATTimestamp) as INTEGER),  
    CASE 
        WHEN CAST(TIMESTAMP_TO_CHAR('u',EATTimestamp) as INTEGER) > 5 THEN FALSE
        ELSE TRUE
    END, TIMESTAMP_TO_CHAR('EEE',EATTimestamp), TIMESTAMP_TO_CHAR('MMM',EATTimestamp),
    true,
    WindowSize, ItemCount, Amount
FROM 
(
    SELECT stream
        STEP (saf_datastream.ROWTIME BY INTERVAL '15' MINUTE) as eventTimestamp, TO_TIMESTAMP(UNIX_TIMESTAMP(CURRENT_ROW_TIMESTAMP) + 10800000) as EATTimestamp,
        900 as WindowSize, count(*) as ItemCount, sum(saf_datastream."amount") as Amount
        FROM "SOURCE_SQL_STREAM_001" as saf_datastream
        GROUP BY 
        STEP (saf_datastream.ROWTIME BY INTERVAL '15' MINUTE)
);
