-- Generated from generator/demo_specs/aws-philippines-retail-social-commerce.json
-- Regenerate with: python3 generator/gen_repo_docs.py aws-philippines-retail-social-commerce
-- This is the schema that is actually deployed for PH_RETAIL_SOCIAL_COMMERCE.

-- PH_RETAIL_SOCIAL_COMMERCE  (Social Commerce Analytics & Influencer Intelligence)
-- generated from generator/demo_specs/aws-philippines-retail-social-commerce.json - do not hand-edit
CREATE DATABASE IF NOT EXISTS PH_RETAIL_SOCIAL_COMMERCE;
CREATE SCHEMA IF NOT EXISTS PH_RETAIL_SOCIAL_COMMERCE.RAW;
CREATE SCHEMA IF NOT EXISTS PH_RETAIL_SOCIAL_COMMERCE.CURATED;
CREATE SCHEMA IF NOT EXISTS PH_RETAIL_SOCIAL_COMMERCE.APP;
USE DATABASE PH_RETAIL_SOCIAL_COMMERCE;

-- 5 real regions; entity names carry their region so the two always agree
