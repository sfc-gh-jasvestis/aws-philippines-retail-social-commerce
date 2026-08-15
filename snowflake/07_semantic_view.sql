-- ============================================================================
-- 07_SEMANTIC_VIEW.SQL — Semantic View for Social Commerce Analytics & Influencer Intelligence
-- ============================================================================
USE DATABASE SOCIAL_COMMERCE;
USE SCHEMA APP;

CREATE OR REPLACE SEMANTIC VIEW APP.SOCIAL_COMMERCE_ANALYTICS
  COMMENT = 'Social commerce, influencer ROI, sentiment, and content performance analytics'
AS
  TABLES (
    CURATED.INFLUENCER_ROI AS influencer_roi,CURATED.TRENDING_PRODUCTS AS trending_products,CURATED.CONTENT_PERFORMANCE AS content_performance,CURATED.AUDIENCE_AFFINITY AS audience_affinity
  );
