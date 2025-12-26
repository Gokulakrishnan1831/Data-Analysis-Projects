Urban Mobility & Market Shift Analysis (2024-2025)
📌 Project Overview
This project explores the intersection of traditional automotive manufacturing and modern urban mobility services. By analyzing Honda’s 2024 production-to-sales ratios alongside localized rideshare transaction data, this dashboard identifies shifts in how consumers interact with transportation—moving from ownership to on-demand services.

📊 Business Metrics & Insights
Production vs. Domestic Sales: Analyzing the gap between Honda's production volume and actual domestic sales to identify inventory surpluses or high-demand months.

Mobility Preferences: Evaluation of "Cab Economy" vs. "Auto" vs. "Parcel" services based on ride charges, distance, and frequency.

Revenue Drivers: Identification of the most popular payment methods (Paytm, Amazon Pay, QR Scans) and their impact on transaction completion rates.

Operational Efficiency: Analysis of ride cancellations and "misc_charges" to understand friction points in urban transit.

🛠️ Technical Workflow
Data Integration: Combined manufacturing Excel data (honda_sales_and_production_2024.xlsx) with granular transactional CSV data (rides_data.csv).

Advanced DAX: * Created measures for Sales-to-Production Efficiency (%).

Calculated Average Revenue per Kilometer (ARPK) for mobility services.

Developed Time-Series Intelligence to track month-over-month fluctuations in urban ride volume.

Geospatial Analysis: Visualized source and destination hubs to identify high-traffic corridors in the mobility dataset.

📂 Dataset Details
Honda Sales & Production: Monthly metrics for 2024 covering domestic sales trends and manufacturing output.

Rides Data: High-frequency transactional data including ride status (completed/cancelled), distance, duration, and total fare.

Detailed Production Data: Granular breakdown of sales vs. exports for production planning.

🚀 Strategic Recommendations
For Automotive Manufacturers: Align production cycles with peak urban mobility demand periods to capture fleet-sales opportunities.

For Mobility Providers: Optimize driver placement at "Source" hotspots identified in the corridors analysis to reduce cancellation rates (currently visible in the ride_status data).

📸 Dashboard Preview
Note to Gautam: Since this project combines two different data stories, include a "Product Analysis" view and a "Mobility Trends" view. ![Market Shift Dashboard](./screenshots/mobility_dashboard_main.png)

🛠️ How to View
Open the Final Project.pbix file in Power BI Desktop.

Navigate between the Automotive Market and Urban Mobility tabs to see the distinct analyses.

Use the Date Slicers to compare Honda's production peaks with mobility demand spikes.