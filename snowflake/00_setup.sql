-- ============================================================================
-- Social Commerce Analytics & Influencer Intelligence
-- Filipinos spend 4+ hours daily on social media — Snowflake analyzes social commerce sentiment with AI, extracts product mentions, scores influencer ROI, and drives personalized recommendations via Cortex Complete.
-- ============================================================================
USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS SOCIAL_COMMERCE;
CREATE WAREHOUSE IF NOT EXISTS SOCIAL_WH WAREHOUSE_SIZE = 'MEDIUM' AUTO_SUSPEND = 120 AUTO_RESUME = TRUE;
USE DATABASE SOCIAL_COMMERCE;
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS CURATED;
CREATE SCHEMA IF NOT EXISTS ML;
CREATE SCHEMA IF NOT EXISTS AI;
CREATE SCHEMA IF NOT EXISTS SEARCH;
CREATE SCHEMA IF NOT EXISTS APP;

USE WAREHOUSE SOCIAL_WH;
