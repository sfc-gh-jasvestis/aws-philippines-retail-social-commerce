-- Synthetic creator-day observations for the social commerce network of a fictional Philippine retail brand.
-- A creator is one fictional live-selling creator selling from one Philippine city in one category.
-- Nothing is seeded as a prediction. Randomness is HASH-seeded, so every rebuild
-- is reproducible: per-creator RTS propensity, listing drift between
-- catalog syncs, missed catalog syncs, category-weighted order issue types,
-- issues resolved without an RTS order, and two city-wide courier disruptions.
USE DATABASE IDENTIFIER($DEMO_DB);
USE SCHEMA RAW;
USE WAREHOUSE IDENTIFIER($DEMO_WH);

CREATE TABLE RAW.CREATORS AS
WITH creators AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS CREATOR_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 40))
), draws AS (
  SELECT CREATOR_INDEX,
         MOD(ABS(HASH(CREATOR_INDEX, 'phsoc-age')), 1000000) / 1e6 AS U_AGE,
         MOD(ABS(HASH(CREATOR_INDEX, 'phsoc-rate')), 1000000) / 1e6 AS U_RATE,
         MOD(ABS(HASH(CREATOR_INDEX, 'phsoc-sync')), 1000000) / 1e6 AS U_SYNC,
         MOD(ABS(HASH(CREATOR_INDEX, 'phsoc-discipline')), 1000000) / 1e6 AS U_DISCIPLINE,
         MOD(ABS(HASH(CREATOR_INDEX, 'phsoc-tier')), 1000000) / 1e6 AS U_TIER
  FROM creators
)
SELECT 'CRT-' || LPAD(CREATOR_INDEX::VARCHAR, 4, '0') AS ID,
       'Synthetic creator ' || LPAD(CREATOR_INDEX::VARCHAR, 4, '0') AS NAME,
       -- Deterministic spread (5 and 8 are coprime): every city and category is present.
       CASE MOD(CREATOR_INDEX, 5) WHEN 0 THEN 'Quezon City' WHEN 1 THEN 'Cebu City'
            WHEN 2 THEN 'Davao City' WHEN 3 THEN 'Iloilo City' ELSE 'Cagayan de Oro' END AS REGION,
       CASE MOD(CREATOR_INDEX, 8) WHEN 0 THEN 'Fashion' WHEN 1 THEN 'Fashion'
            WHEN 2 THEN 'Fashion' WHEN 3 THEN 'Gadgets' WHEN 4 THEN 'Gadgets'
            WHEN 5 THEN 'Home and kitchen' WHEN 6 THEN 'Beauty and personal care' ELSE 'Snacks and pantry' END AS CATEGORY,
       CREATOR_INDEX,
       1 + FLOOR(U_TIER * 3) AS RISK_TIER,
       ROUND(0.2 + U_AGE * 5.8, 1) AS CREATOR_TENURE_YEARS,
       -- Base daily probability of an RTS order 0.4%-3%; ~15% of creators are
       -- chronically weak (x3).
       (0.004 + U_RATE * 0.026) * IFF(U_RATE > 0.85, 3, 1) AS BASE_RTS_RATE,
       7 * (1 + FLOOR(U_SYNC * 3)) AS CATALOG_SYNC_INTERVAL_DAYS,
       0.55 + U_DISCIPLINE * 0.45 AS CATALOG_SYNC_COMPLETION_PROB,
       'Active' AS STATUS
FROM draws;

CREATE TABLE RAW.CREATOR_DAILY AS
WITH days AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS DAY_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 90))
), city_events AS (
  -- Two city-wide courier disruptions; every creator in the city raises an order
  -- issue that is resolved once deliveries resume.
  SELECT * FROM VALUES (27, 'Iloilo City'), (64, 'Cagayan de Oro') AS o(DAY_INDEX, REGION)
), base AS (
  SELECT s.ID AS ENTITY_ID, s.CREATOR_INDEX, s.CATEGORY, s.REGION, s.CREATOR_TENURE_YEARS,
         s.BASE_RTS_RATE, s.CATALOG_SYNC_INTERVAL_DAYS, s.CATALOG_SYNC_COMPLETION_PROB,
         d.DAY_INDEX,
         DATEADD('day', d.DAY_INDEX - 89, CURRENT_DATE()) AS EVENT_DATE,
         MOD(d.DAY_INDEX + s.CREATOR_INDEX * 5, s.CATALOG_SYNC_INTERVAL_DAYS) AS DAYS_SINCE_SYNC,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'phsoc-cancel')), 1000000) / 1e6 AS U_RTS,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'phsoc-detect')), 1000000) / 1e6 AS U_DETECT,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'phsoc-resolve')), 1000000) / 1e6 AS U_RESOLVE,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'phsoc-type')), 1000000) / 1e6 AS U_TYPE,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'phsoc-done')), 1000000) / 1e6 AS U_DONE,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'phsoc-volume')), 1000000) / 1e6 AS U_VOLUME,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'phsoc-noise')), 1000000) / 1e6 AS U_NOISE,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'phsoc-late')), 1000000) / 1e6 AS U_LATE,
         e.REGION IS NOT NULL AS CITY_EVENT
  FROM RAW.CREATORS s CROSS JOIN days d
  LEFT JOIN city_events e ON e.DAY_INDEX = d.DAY_INDEX AND e.REGION = s.REGION
), sync AS (
  SELECT *,
         IFF(DAYS_SINCE_SYNC = 0, 1, 0) AS CATALOG_SYNC_DUE,
         IFF(DAYS_SINCE_SYNC = 0 AND U_DONE < CATALOG_SYNC_COMPLETION_PROB, 1, 0) AS CATALOG_SYNC_DONE,
         -- Listing drift (stock shown versus stock held) rises between stock
         -- syncs; weak sync discipline carries it over.
         DAYS_SINCE_SYNC / CATALOG_SYNC_INTERVAL_DAYS + (1 - CATALOG_SYNC_COMPLETION_PROB) AS DRIFT
  FROM base
), rts_draws AS (
  SELECT *,
         CASE WHEN U_RTS < LEAST(0.5, BASE_RTS_RATE * (0.4 + 1.6 * DRIFT) * (1 + 1 / (1 + CREATOR_TENURE_YEARS))) / 4 THEN 2
              WHEN U_RTS < LEAST(0.5, BASE_RTS_RATE * (0.4 + 1.6 * DRIFT) * (1 + 1 / (1 + CREATOR_TENURE_YEARS))) THEN 1
              ELSE 0 END AS RTS_RISK_COUNT
  FROM sync
), issues AS (
  SELECT *,
         -- About 85% of at-risk orders raise an issue and end as RTS orders; the
         -- rest are delivered late without an issue.
         IFF(CITY_EVENT, 0, IFF(U_DETECT < 0.85, RTS_RISK_COUNT, 0)) AS RTS_COUNT,
         -- Issues resolved without an RTS order: higher for high-volume categories.
         IFF(CITY_EVENT, 1, IFF(U_RESOLVE < CASE CATEGORY WHEN 'Snacks and pantry' THEN 0.20
                                                         WHEN 'Beauty and personal care' THEN 0.12
                                                         WHEN 'Gadgets' THEN 0.14 ELSE 0.08 END, 1, 0)) AS RESOLVED_COUNT
  FROM rts_draws
), measured AS (
  SELECT *,
         RTS_COUNT + RESOLVED_COUNT AS ISSUE_COUNT,
         ROUND(CASE CATEGORY WHEN 'Snacks and pantry' THEN 320 WHEN 'Beauty and personal care' THEN 260
                             WHEN 'Gadgets' THEN 90 WHEN 'Home and kitchen' THEN 110 ELSE 240 END
               * (0.7 + 0.6 * U_VOLUME) * (1 + 0.8 * RTS_RISK_COUNT)) AS ORDER_COUNT,
         CASE CATEGORY WHEN 'Snacks and pantry' THEN 380 WHEN 'Beauty and personal care' THEN 520
                       WHEN 'Gadgets' THEN 1850 WHEN 'Home and kitchen' THEN 960 ELSE 640 END
           * (0.8 + 0.4 * U_NOISE) AS AVG_ORDER_PHP
  FROM issues
)
SELECT ENTITY_ID || '-' || TO_CHAR(EVENT_DATE, 'YYYYMMDD') AS EVENT_ID,
       ENTITY_ID, EVENT_DATE,
       ORDER_COUNT,
       ROUND(ORDER_COUNT * AVG_ORDER_PHP, 0) AS GMV_PHP,
       ISSUE_COUNT, RTS_COUNT,
       IFF(RTS_COUNT > 0 AND U_LATE < 0.6, 1, 0) AS LATE_DELIVERY,
       CASE WHEN ISSUE_COUNT = 0 THEN 'None'
            WHEN CITY_EVENT THEN 'Courier network disruption'
            WHEN CATEGORY = 'Fashion' THEN IFF(U_TYPE < 0.4, 'Wrong size or variant', IFF(U_TYPE < 0.75, 'COD refused at door', 'Counterfeit report'))
            WHEN CATEGORY = 'Gadgets' THEN IFF(U_TYPE < 0.45, 'Item not as shown on live', IFF(U_TYPE < 0.8, 'Damaged in transit', 'Counterfeit report'))
            WHEN CATEGORY = 'Home and kitchen' THEN IFF(U_TYPE < 0.55, 'Damaged in transit', 'Oversold during livestream')
            WHEN CATEGORY = 'Beauty and personal care' THEN IFF(U_TYPE < 0.45, 'Near-expiry item', IFF(U_TYPE < 0.8, 'Oversold during livestream', 'Counterfeit report'))
            ELSE IFF(U_TYPE < 0.5, 'Oversold during livestream', IFF(U_TYPE < 0.75, 'Damaged in transit', 'Item not as shown on live')) END AS ISSUE_TYPE,
       CATALOG_SYNC_DUE, CATALOG_SYNC_DONE,
       ROUND(0.5 + 2.0 * DRIFT + 3.0 * RTS_RISK_COUNT + U_NOISE * 0.8, 2) AS RETURN_RATE_PCT,
       ROUND(18 + 12 * DRIFT + 14 * RTS_RISK_COUNT + U_NOISE * 6, 1) AS AVG_DISPATCH_HRS,
       CURRENT_TIMESTAMP() AS LOADED_AT
FROM measured;

-- Creator compliance document coverage (snapshot).
CREATE TABLE RAW.COMPLIANCE_DOCUMENTS AS
SELECT ID AS ENTITY_ID,
       CASE CATEGORY WHEN 'Fashion' THEN 'Brand affiliate agreement'
                     WHEN 'Gadgets' THEN 'Warranty card template'
                     WHEN 'Home and kitchen' THEN 'Product safety declaration'
                     WHEN 'Beauty and personal care' THEN 'Ingredient list declaration'
                     ELSE 'Food handling declaration' END AS DOC_TYPE,
       1 + MOD(ABS(HASH(ID, 'phsoc-req')), 4) AS REQUIRED_QTY,
       MOD(ABS(HASH(ID, 'phsoc-file')), 5) AS ON_FILE_QTY,
       IFF(MOD(ABS(HASH(ID, 'phsoc-file')), 5) < 1 + MOD(ABS(HASH(ID, 'phsoc-req')), 4),
           MOD(ABS(HASH(ID, 'phsoc-pending')), 3), 0) AS PENDING_QTY,
       CURRENT_DATE() AS SNAPSHOT_DATE
FROM RAW.CREATORS;
