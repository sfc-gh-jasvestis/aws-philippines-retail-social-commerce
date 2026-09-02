# Social Commerce Analytics & Influencer Intelligence

**Philippines - Retail & E-Commerce**
Use case: Social Commerce

> Filipinos spend 4+ hours daily on social media — Snowflake analyzes social commerce sentiment with AI, extracts product mentions, scores influencer ROI, and drives personalized recommendations via Cortex Complete.

## Why Snowflake

Snowflake processes social commerce data from Amazon Comprehend pipeline, replaces it with native AI_SENTIMENT + AI_EXTRACT, builds influencer ROI scores, and uses Cortex Complete for personalized product recommendations

- **AI_SENTIMENT + AI_EXTRACT on social posts** - Replaces Amazon Comprehend with native Snowflake AI — zero data movement
- **Cortex Complete for personalized recommendations** - Replaces Amazon Personalize with LLM-powered recommendations
- **Influencer ROI attribution** - Connects social engagement directly to commerce purchases
- **Philippine social commerce context** - #1 social media users globally — TikTok Shop, live selling, nano-influencers
- **1.2M social posts searchable** - Cortex Search across social content for trend discovery

## What is deployed

| | |
|---|---|
| Database | `PH_RETAIL_SOCIAL_COMMERCE` |
| Service | `PH_RETAIL_SOCIAL_COMMERCE_APP` |
| Compute pool | `SEA_DEMOS_PHILIPPINES_POOL` |
| Dimension table | `RAW.INFLUENCERS` (20 rows) |
| Fact table | `RAW.AUDIENCE_SEGMENTS` (250,000 rows, 90 days) |
| Curated layer | `CURATED.PERFORMANCE_SUMMARY`, `CURATED.TREND_ANALYSIS`, `CURATED.KPI_SUMMARY` |
| Currency | PHP (₱) |

Regions in play: Metro Manila, Cebu, Davao, Pampanga, Iloilo
Segments: Live Selling, Influencer Post, Group Buy, Chat Commerce

Dynamic tables are created suspended and refreshed on demand:

```bash
./refresh_demo_data.sh PH_RETAIL_SOCIAL_COMMERCE
```

## KPI cards

Every card below is served live from `CURATED.KPI_SUMMARY`. The app keeps the
original literal as a fallback, so it still renders if Snowflake is unreachable.

| Card | Value | Backed by |
|---|---|---|
| Social GMV | `₱2.4B` | total across Influencers |
| Live Streams (MTD) | `4,200` | total across Influencers |
| Influencer Partners | `847` | total across Influencers |
| Social Conversion | `4.8%` | average per event |
| Avg Viewers/Stream | `4.2K` | average per event |
| Stream Conversion | `8.4%` | average per event |
| Replay Revenue | `₱420M` | total across Influencers |


## Demo flow

1. Executive Cockpit
2. Influencer ROI
3. Trends & Content
4. Ask AI
5. Architecture & Data

## Talking points

- **₱2.1B** - social commerce revenue this quarter
- **2,800** - active influencer partnerships
- **1.2M posts** - analyzed by AI_SENTIMENT + AI_EXTRACT
- **4.2x ROAS** - average for nano-influencer campaigns
- **38%** - of social commerce from TikTok Shop
- **3.2x** - higher conversion for live selling format

## Business impact

- Philippines has world's highest social media usage at 4.1 hours/day per user (We Are Social / DataReportal)
- Philippine social commerce market reached ₱280B in 2023 with 45% growth (Google-Temasek SEA)
- TikTok Shop Philippines grew 85% in GMV during 2023 (TikTok for Business)
- Nano-influencers (1K-10K followers) deliver 2-3x higher engagement than mega-influencers (Later/Influencer Marketing Hub)

---
Generated from `generator/demo_specs/aws-philippines-retail-social-commerce.json`. Do not hand-edit: run
`python3 generator/gen_repo_docs.py aws-philippines-retail-social-commerce` instead.
