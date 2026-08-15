-- ============================================================================
-- 05_SEARCH.SQL — Cortex Search for Social Commerce Analytics & Influencer Intelligence
-- ============================================================================
USE DATABASE SOCIAL_COMMERCE;
USE SCHEMA SEARCH;

CREATE OR REPLACE CORTEX SEARCH SERVICE SEARCH.SOCIAL_CONTENT_SEARCH
  ON POST_TEXT
  ATTRIBUTES PLATFORM, INFLUENCER_ID, PRODUCT_CATEGORY, SENTIMENT
  WAREHOUSE = SOCIAL_WH
  TARGET_LAG = '1 hour'
AS (
  SELECT * FROM RAW.SOCIAL_POSTS
);
