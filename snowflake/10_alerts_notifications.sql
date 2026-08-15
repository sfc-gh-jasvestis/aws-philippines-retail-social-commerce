-- ============================================================================
-- 10_ALERTS_NOTIFICATIONS.SQL — Alerts for Social Commerce Analytics & Influencer Intelligence
-- ============================================================================
USE DATABASE SOCIAL_COMMERCE;
USE SCHEMA APP;

-- Notification integration (email)
CREATE OR REPLACE NOTIFICATION INTEGRATION aws_philippines_retail_social_commerce_EMAIL_INT
  TYPE = EMAIL
  ENABLED = TRUE
  ALLOWED_RECIPIENTS = ('jonathan.asvestis@snowflake.com');

-- Alert: SENTIMENT_CRISIS_ALERT
CREATE OR REPLACE ALERT APP.SENTIMENT_CRISIS_ALERT
  WAREHOUSE = SOCIAL_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'Brand sentiment crisis detected on social media'
IF (EXISTS (
  SELECT 1 FROM CURATED.INFLUENCER_ROI
  WHERE 1=1 -- Condition: BRAND_SENTIMENT_24H < -0.5
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_philippines_retail_social_commerce_EMAIL_INT',
    'jonathan.asvestis@snowflake.com',
    '[ALERT] Social Commerce Analytics & Influencer Intelligence: Brand sentiment crisis detected on social media',
    'Brand sentiment crisis detected on social media'
  );

ALTER ALERT APP.SENTIMENT_CRISIS_ALERT RESUME;

-- Alert: VIRAL_PRODUCT_ALERT
CREATE OR REPLACE ALERT APP.VIRAL_PRODUCT_ALERT
  WAREHOUSE = SOCIAL_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'Product going viral — prepare inventory'
IF (EXISTS (
  SELECT 1 FROM CURATED.INFLUENCER_ROI
  WHERE 1=1 -- Condition: MENTION_VELOCITY > 10x BASELINE for any product
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_philippines_retail_social_commerce_EMAIL_INT',
    'jonathan.asvestis@snowflake.com',
    '[ALERT] Social Commerce Analytics & Influencer Intelligence: Product going viral — prepare inventory',
    'Product going viral — prepare inventory'
  );

ALTER ALERT APP.VIRAL_PRODUCT_ALERT RESUME;

