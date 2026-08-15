-- ============================================================================
-- 03_STAGING.SQL — Generate synthetic data for Social Commerce Analytics & Influencer Intelligence
-- Country: PHILIPPINES | Currency: PHP
-- ============================================================================
USE DATABASE SOCIAL_COMMERCE;
USE SCHEMA RAW;

-- Data generation scripts are demo-specific.
-- See the handcrafted SQL in the aws-malaysia-semiconductor-yield demo for
-- the full pattern: GENERATOR + UNIFORM + LATERAL for distribution,
-- Cortex Complete for text generation, engineered key demo numbers.

-- Target row counts:
-- INFLUENCERS: 2,800 rows — Influencer profiles (nano to mega) with metrics
-- SOCIAL_POSTS: 1,200,000 rows — Social media posts mentioning brand/products
-- CAMPAIGN_EVENTS: 45,000 rows — Influencer campaign events with spend and attribution
-- SOCIAL_ORDERS: 680,000 rows — Orders attributed to social commerce channels
-- PRODUCT_CATALOG: 15,000 rows — Product catalog with categories and margins
-- AUDIENCE_SEGMENTS: 1,500,000 rows — Audience profiles from social platform pixels
