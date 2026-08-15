-- ============================================================================
-- 08_AGENT.SQL — Cortex Agent for Social Commerce Analytics & Influencer Intelligence
-- ============================================================================
USE DATABASE SOCIAL_COMMERCE;
USE SCHEMA APP;

CREATE OR REPLACE CORTEX AGENT APP.SOCIAL_COMMERCE_AGENT
  COMMENT = 'Social Commerce Analytics & Influencer Intelligence AI Assistant'
  MODEL = 'claude-opus-4-8'
  TOOLS = (
    SEMANTIC_VIEW_TOOL(SEMANTIC_VIEW => 'SOCIAL_COMMERCE.APP.SOCIAL_COMMERCE_ANALYTICS'),    CORTEX_SEARCH_TOOL(CORTEX_SEARCH_SERVICE => 'SOCIAL_COMMERCE.SEARCH.SOCIAL_CONTENT_SEARCH', TOOL_DESCRIPTION => 'Search documents for Retail & E-Commerce information')
  )
  SYSTEM_PROMPT = 'You are the Social Commerce Intelligence Agent for a Philippine retail brand with 2,800 influencer partnerships and ₱2.1B in social commerce revenue.';
