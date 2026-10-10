# Philippines Social Commerce Operations

**Philippines - Retail Social Commerce**
Use case: Livestream order issues, returned-to-sender (RTS) orders, creator controls and creator RTS risk

> Operations monitoring for 40 fictional live-selling creators who sell a fictional Philippine retail brand's products from Quezon City, Cebu City, Davao City, Iloilo City and Cagayan de Oro: dynamic tables, a holdout-evaluated RTS classifier, an order-issue forecast and return rate anomaly detection, a Cortex Agent with SOP citations, a live order feed with an alert, and an SPCS app.

## Why Snowflake

- **Dynamic tables** reconcile orders, order issues, RTS orders, late deliveries and catalog sync compliance from RAW creator data, with checks in `run_core.py`
- **RTS classification** gives a holdout-evaluated next-7-day probability per creator
- **Order-issue forecast** projects 14 days of network-wide order issues with prediction intervals, for support staffing
- **Grounded AI**: the Cortex Agent (Analyst over a semantic view, plus Search over SOPs) shows its SQL and SOP citations
- **Live orders**: a native simulator (Snowflake only) or Firehose, S3 and Snowpipe (AWS build), then an alert and email

## What is built

| | |
|---|---|
| Dimension table | `RAW.CREATORS` (40 rows) |
| Fact table | `RAW.CREATOR_DAILY` (3,600 creator-days, 90 days) |
| Curated layer | `CURATED.KPI_SUMMARY`, `PERFORMANCE_SUMMARY`, `ISSUE_SUMMARY`, `TREND_ANALYSIS` |
| ML | `ML.RTS_RISK_SCORES`, `ML.RTS_RISK_HOLDOUT_METRICS`, `ML.ISSUE_FORECAST`, `ML.RETURN_RATE_ANOMALIES` |

Currency: PHP. Cities: Quezon City, Cebu City, Davao City, Iloilo City, Cagayan de Oro.
Categories: Fashion, Gadgets, Home and kitchen, Beauty and personal care, Snacks and pantry.

## KPI cards (live from `CURATED.KPI_SUMMARY`; no fallback values)

| Card | Value from the seeded data |
|---|---|
| Clean Order Rate | 99.92% |
| Order Issues Raised | 591 |
| RTS Orders | 187 |
| Issue RTS Rate | 31.6% |
| Late Deliveries | 77 |
| GMV (PHP M) | 548 |
| Orders Processed | 751,364 |
| Catalog Sync Compliance | 77.9% |
| Creators Monitored | 40 |
| Compliance Document Coverage | 54.9% |
| Compliance Documents Pending | 23 |

Values are synthetic. A rebuild reproduces them because the data is HASH-seeded; dates are relative to the build day.

## Demo flow

1. Executive Cockpit: KPIs, daily order issues against RTS orders, issues and RTS orders by issue type, creator table
2. Predictive: holdout metrics, risk bands, 14-day order-issue forecast, return rate anomalies
3. Controls: catalog sync compliance, creator document coverage and pending documents, catalog sync compliance against RTS orders, then generate the action memo
4. Live Orders: run `CALL APP.SIMULATE_ORDERS(20)` (Snowflake only) or `python aws/publish_orders.py --count 20` (AWS build). Then run `EXECUTE ALERT APP.LIVE_ORDER_ALERT` and show the alert log and email
5. Ask AI: the Cortex Agent answers metric questions through the semantic view and cites SOPs from Cortex Search. The SQL is shown.
6. QuickSight (AWS build): the same Snowflake tables through DIRECT_QUERY
7. Architecture: both builds side by side

## Talking points

- 99.92% of orders arrive without an issue; the 591 order issues are where operations time goes, and almost 1 in 3 of them (31.6%) end as RTS orders.
- COD refused at door issues have the highest RTS share (32 of 60), so confirming cash-on-delivery orders in the livestream chat is the first lever. Courier network disruptions hit every creator in a city at once and are always resolved.
- The risk model is evaluated on a time-based holdout: precision 0.54 and recall 0.34 at 0.5, against a 0.21 base rate. Present it as triage, not a verdict.
- Courier network disruptions are excluded from model training, because they are not creator-driven.

## Business impact

Use only the sourced references in `README.md` (Business Impact).
