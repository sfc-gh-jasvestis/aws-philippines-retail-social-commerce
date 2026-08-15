-- ============================================================================
-- 04_DYNAMIC_TABLES.SQL — Curated layer for Social Commerce Analytics & Influencer Intelligence
-- ============================================================================
USE DATABASE SOCIAL_COMMERCE;
USE SCHEMA CURATED;

-- INFLUENCER_ROI: Influencer performance with attributed revenue and ROAS
-- Source: INFLUENCERS, CAMPAIGN_EVENTS, SOCIAL_ORDERS
CREATE OR REPLACE DYNAMIC TABLE CURATED.INFLUENCER_ROI
  TARGET_LAG = '5 minutes'
  WAREHOUSE = SOCIAL_WH
AS
SELECT * FROM RAW.INFLUENCERS;
-- TODO: Replace with actual join/aggregation logic per demo

-- TRENDING_PRODUCTS: Products trending in social mentions with velocity scores
-- Source: SOCIAL_POSTS, PRODUCT_CATALOG
CREATE OR REPLACE DYNAMIC TABLE CURATED.TRENDING_PRODUCTS
  TARGET_LAG = '5 minutes'
  WAREHOUSE = SOCIAL_WH
AS
SELECT * FROM RAW.SOCIAL_POSTS;
-- TODO: Replace with actual join/aggregation logic per demo

-- CONTENT_PERFORMANCE: Content format and type performance by engagement and conversion
-- Source: SOCIAL_POSTS, SOCIAL_ORDERS
CREATE OR REPLACE DYNAMIC TABLE CURATED.CONTENT_PERFORMANCE
  TARGET_LAG = '5 minutes'
  WAREHOUSE = SOCIAL_WH
AS
SELECT * FROM RAW.SOCIAL_POSTS;
-- TODO: Replace with actual join/aggregation logic per demo

-- AUDIENCE_AFFINITY: Audience segment-to-product affinity scores
-- Source: AUDIENCE_SEGMENTS, SOCIAL_ORDERS, PRODUCT_CATALOG
CREATE OR REPLACE DYNAMIC TABLE CURATED.AUDIENCE_AFFINITY
  TARGET_LAG = '5 minutes'
  WAREHOUSE = SOCIAL_WH
AS
SELECT * FROM RAW.AUDIENCE_SEGMENTS;
-- TODO: Replace with actual join/aggregation logic per demo

