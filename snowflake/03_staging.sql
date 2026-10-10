-- Validate the producer contract before building downstream objects.
USE DATABASE IDENTIFIER($DEMO_DB);
USE SCHEMA RAW;
USE WAREHOUSE IDENTIFIER($DEMO_WH);

EXECUTE IMMEDIATE $$
DECLARE
  violations INTEGER;
  invalid_source EXCEPTION (-20001, 'Synthetic source failed grain or measure validation');
BEGIN
  SELECT COUNT(*) INTO :violations FROM (
    SELECT ENTITY_ID, EVENT_DATE
    FROM RAW.CREATOR_DAILY
    GROUP BY ENTITY_ID, EVENT_DATE HAVING COUNT(*) <> 1
    UNION ALL
    SELECT observation.ENTITY_ID, observation.EVENT_DATE
    FROM RAW.CREATOR_DAILY observation
    LEFT JOIN RAW.CREATORS creator ON creator.ID = observation.ENTITY_ID
    WHERE creator.ID IS NULL OR observation.ORDER_COUNT < 0
       OR observation.GMV_PHP < 0
       OR observation.RTS_COUNT < 0 OR observation.RTS_COUNT > observation.ISSUE_COUNT
       OR observation.ISSUE_COUNT > observation.ORDER_COUNT
       OR observation.LATE_DELIVERY > observation.RTS_COUNT
       OR observation.CATALOG_SYNC_DONE > observation.CATALOG_SYNC_DUE
  );
  IF (violations > 0) THEN
    RAISE invalid_source;
  END IF;
END;
$$;
