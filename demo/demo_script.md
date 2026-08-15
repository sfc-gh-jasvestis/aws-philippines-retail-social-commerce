# Demo Script: Social Commerce Analytics & Influencer Intelligence
## ~4-Minute Recorded Walkthrough
**Format**: Screen recording with voiceover
**Target**: Customer meeting / booth loop / social share
**Narrative**: "Snowflake processes social commerce data from Amazon Comprehend pipeline, replaces it with native AI_SENTIMENT + AI_EXTRACT, builds influencer ROI scores, and uses Cortex Complete for personalized product recommendations"
**Demo Mode**: Open app with `?demo=true` for presenter notes

---

## Two Personas

| Persona | Role | Tool | What they care about |
|---|---|---|---|
| **Samantha Kaye Ong** | Head of Digital Commerce | React App (SPCS) | Social conversion rates, influencer ROI, trending products, campaign performance |
| **Patrick Bryan Mendoza** | Social Commerce Analyst | Amazon QuickSight | Content performance, audience engagement, sentiment shifts, product-content alignment |

---

## What's Built

| Layer | Component | Detail |
|---|---|---|
| **RAW** | 6 tables | INFLUENCERS (2800), SOCIAL_POSTS (1200000), CAMPAIGN_EVENTS (45000), SOCIAL_ORDERS (680000), PRODUCT_CATALOG (15000), AUDIENCE_SEGMENTS (1500000) |
| **CURATED** | 4 Dynamic Tables | INFLUENCER_ROI, TRENDING_PRODUCTS, CONTENT_PERFORMANCE, AUDIENCE_AFFINITY |
| **ML** | ML.CLASSIFICATION + ML.FORECAST | Forecasting + anomaly detection |
| **AI** | AI_SENTIMENT, AI_EXTRACT, COMPLETE | Classification + extraction |
| **Search** | Cortex Search | 1200000 documents indexed |
| **Agent** | SOCIAL_COMMERCE_AGENT | Semantic View + Search tools |


---

## The Story

Filipinos are the world's most active social media users — 4.1 hours per day across Facebook, TikTok, Instagram, and YouTube. Social commerce in the Philippines hit ₱280B in 2023. A leading retail brand partners with 2,800 influencers but can't tell which ones drive actual purchases vs. just engagement. Snowflake connects social sentiment and content analysis directly to commerce outcomes.

---

## Script

### [0:00–0:45] EXECUTIVE COCKPIT

**Show**: Executive Cockpit tab

> "₱2.1 billion social commerce revenue this quarter — 2,800 active influencer partnerships."

**Action**: Point at ₱2.1B revenue KPI

### [0:45–1:30] INFLUENCER ROI

**Show**: Influencer ROI tab

> "Top 10% of influencers drive 62% of attributed revenue — nano-influencers have highest ROAS."

**Action**: Show influencer tier ROAS comparison

### [1:30–2:15] TRENDS & CONTENT

**Show**: Trends & Content tab

> "AI_SENTIMENT + AI_EXTRACT processing 1.2M posts — trending now: Korean skincare bundles."

**Action**: Show trending products word cloud

### [2:15–3:00] ASK AI

**Show**: Ask AI tab

> "Samantha asks: 'Which influencer campaign had the highest ROI this month?'"

**Action**: Type: 'Best influencer campaign this month?'

### [3:00–3:45] ARCHITECTURE & DATA

**Show**: Architecture & Data tab

> "Social feeds → AI_SENTIMENT + AI_EXTRACT → Dynamic Tables → Cortex Complete recommendations."

**Action**: Walk through architecture diagram


---

## Key Demo Differentiators

1. **AI_SENTIMENT + AI_EXTRACT on social posts** — Replaces Amazon Comprehend with native Snowflake AI — zero data movement
2. **Cortex Complete for personalized recommendations** — Replaces Amazon Personalize with LLM-powered recommendations
3. **Influencer ROI attribution** — Connects social engagement directly to commerce purchases
4. **Philippine social commerce context** — #1 social media users globally — TikTok Shop, live selling, nano-influencers
5. **1.2M social posts searchable** — Cortex Search across social content for trend discovery


---

## Demo Prep Checklist

### Data Verification
- [ ] `SELECT COUNT(*) FROM SOCIAL_COMMERCE.RAW.SOCIAL_POSTS` → 1200000
- [ ] `SELECT COUNT(*) FROM SOCIAL_COMMERCE.RAW.SOCIAL_ORDERS` → 680000
- [ ] `SELECT COUNT(*) FROM SOCIAL_COMMERCE.CURATED.INFLUENCER_ROI WHERE ROAS > 4.0` → >100

### ML Model Verification
- [ ] `SELECT COUNT(*) FROM SOCIAL_COMMERCE.ML.CONVERSION_CLASSIFICATION_RESULTS` → >0

### AI/Agent Verification
- [ ] `SELECT COUNT(*) FROM SOCIAL_COMMERCE.AI.POST_SENTIMENT_SCORES` → 1200000
- [ ] `SELECT COUNT(*) FROM SOCIAL_COMMERCE.AI.EXTRACTED_PRODUCT_MENTIONS` → >0

