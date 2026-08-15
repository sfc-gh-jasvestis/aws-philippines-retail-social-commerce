-- ============================================================================
-- 11_TASK_PIPELINE.SQL — Task DAG for Social Commerce Analytics & Influencer Intelligence
-- ============================================================================
USE DATABASE SOCIAL_COMMERCE;
USE SCHEMA APP;

CREATE OR REPLACE TASK APP.TASK_INGEST_SOCIAL
  WAREHOUSE = SOCIAL_WH
  SCHEDULE = 'USING CRON 0 */1 * * * UTC'
  COMMENT = 'Ingest latest social posts and engagement data'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_ANALYZE_SENTIMENT
  WAREHOUSE = SOCIAL_WH
  AFTER APP.TASK_INGEST_SOCIAL
  COMMENT = 'Run AI_SENTIMENT and AI_EXTRACT on new posts'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_UPDATE_RECOMMENDATIONS
  WAREHOUSE = SOCIAL_WH
  AFTER APP.TASK_ANALYZE_SENTIMENT
  COMMENT = 'Refresh personalized recommendations via Cortex Complete'
AS
  SELECT 1; -- Replace with actual refresh logic

ALTER TASK APP.TASK_UPDATE_RECOMMENDATIONS RESUME;
ALTER TASK APP.TASK_ANALYZE_SENTIMENT RESUME;
ALTER TASK APP.TASK_INGEST_SOCIAL RESUME;
