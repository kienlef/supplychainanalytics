# Supply Chain Analytics — Practical Data Science for Operations

Supply Chain Analytics is an educational repository by Frank Kienle about practical analytics use cases across planning, sourcing, production, risk, and delivery.

The core idea is simple:

> Analytics only creates value when it is connected to real supply-chain processes and decisions.

This repository is part of a broader knowledge system:

- YouTube lectures for explanation and context
- GitHub artifacts for technical trust
- future homepage knowledge pages for navigation
- future checklists/playbooks for practical use

No technical trust without a repo. This is the repo layer for the Supply Chain Analytics content pillar.

---

## Who this is for

This material is useful for:

- supply-chain and operations professionals who want to understand where analytics can create value,
- managers who need a structured map of analytics use cases before investing in tools or AI projects,
- students and early-career analysts learning how analytics connects to real supply-chain processes,
- data scientists who want to avoid building models detached from business decisions,
- professionals preparing for agentic automation in operations.

This is not a generic machine-learning demo collection. The focus is the business process first, then the analytics method.

---

## Business problem

Many analytics and AI projects fail before the model starts.

Typical reasons:

- the business decision is unclear,
- the process owner is not involved,
- data availability is assumed but not checked,
- the analytics use case is not linked to planning, sourcing, production, or delivery,
- dashboards are built but decisions do not change.

Supply Chain Analytics starts from the process view. It maps where analytics can support decisions across the supply chain.

---

## Course / lecture companion

The related YouTube playlist is:

Supply Chain Analytics — Practical Data Science for Operations  
https://www.youtube.com/playlist?list=PL6kUP6-NlVDKnB103rGFrH1AGes5fOeFB

The uploaded lecture series currently contains 22 videos, including:

1. Course introduction and motivation
2. Supply chain analytics overview
3. Process overview maps
4. Demand forecasting
5. Inventory management and optimization
6. Multi-echelon inventory optimization
7. Vendor-managed inventories
8. Production scheduling optimization
9. Batch size optimization
10. Overall Equipment Effectiveness analytics
11. Predictive maintenance
12. Vision systems and AI quality control
13. Digital twins
14. Information compliance and document tracking
15. Supply-chain risk management
16. Supply-chain segmentation
17. Supply-chain network design and transformation
18. S&OP and supply-chain control towers
19. Transport costs and modes
20. Delivery route optimization
21. Delivery time prediction
22. Order fulfillment analytics / OTIF

The videos are currently part of Frank's educational archive and are being connected step by step to GitHub and homepage knowledge assets.

---

## What is in this repository

Current repository contents include:

```text
Data Model/
  Deliver.sql
  Full supply chain SQL script.sql
  Full Supply Diagram.pdf
  Make.sql
  Plan.sql
  Supplier.sql

Posters/
  24_Supply_Chain_Analytics_Poster.jpg
  Supply_Chain_Analytics_Overview_Posters.pdf

README.md
LICENSE
```

### Data Model

The `Data Model/` folder contains SQL scripts and a supply-chain diagram. The scripts are structured around core supply-chain process areas:

- supplier / sourcing,
- planning,
- making / production,
- delivery.

Use these files as educational material for thinking about how supply-chain data can be structured. They are not a production data model.

### Posters

The `Posters/` folder contains visual course material for the Supply Chain Analytics overview.

---

## Supply-chain analytics use-case map

The content is organized around four major supply-chain layers.

### 1. Planning and inventories

Typical questions:

- How can demand forecasts support better planning?
- Where does inventory optimization create value?
- When is multi-echelon optimization worth the complexity?
- How can vendor-managed inventory change responsibilities and data flows?

Related lecture topics:

- Forecasts
- Inventory management
- Multi-echelon optimization
- Vendor-managed inventories

### 2. Production efficiency

Typical questions:

- How should production schedules be optimized?
- What is the economic impact of batch sizes?
- How can OEE analytics identify root causes?
- Where does predictive maintenance make operational sense?
- When can vision systems support quality control?
- What is a digital twin in an operations context?

Related lecture topics:

- Production scheduling optimization
- Batch size optimization
- OEE analytics
- Predictive maintenance
- Vision systems and AI quality control
- Digital twins

### 3. Strategic and control-tower layer

Typical questions:

- How should supplier and supply-chain risks be evaluated?
- How can segmentation improve supply-chain steering?
- What does network design change in practice?
- What can an S&OP / control tower realistically do?
- How can information compliance be tracked?

Related lecture topics:

- Supply-chain risk
- Supply-chain segmentation
- Supply-chain network design
- S&OP and control towers
- Information compliance tracking

### 4. Delivery performance

Typical questions:

- Which transport modes and costs matter?
- When does route optimization help?
- How can delivery-time prediction improve planning?
- How should order fulfillment and OTIF be analyzed?

Related lecture topics:

- Transport costs and modes
- Delivery route optimization
- Delivery time prediction
- Order fulfillment analytics

---

## How to use this repository

Recommended path:

1. Watch the playlist overview video.
2. Scan the use-case map in this README.
3. Open the SQL files in `Data Model/` to understand the process-oriented data structure.
4. Use the poster material for a high-level map of the analytics cases.
5. Pick one use case and ask three questions:
   - What decision should improve?
   - Which process owner needs the result?
   - Which data would be needed before any model makes sense?

That last step matters. The hard part is usually not the algorithm. The hard part is connecting data, process, and decision rights.

---

## Reproducibility / setup notes

This repository is currently an educational source repository, not a packaged software project.

To inspect the SQL scripts:

1. Clone the repository.
2. Open the files in `Data Model/` with a SQL editor or text editor.
3. Review `Full supply chain SQL script.sql` as the combined model.
4. Use the individual SQL files for the process-specific layers.

No database runtime is required just to read the material.

If this repository is extended later, the next useful addition would be a small reproducible example using public or synthetic data.

---

## Data and confidentiality note

This repository is based on personal educational material and generic supply-chain concepts.

It does not contain employer-confidential data, customer-confidential data, supplier-confidential data, internal dashboards, internal KPI structures, or employer-specific business logic.

Examples and structures should be treated as educational and conceptual unless explicitly stated otherwise.

---

## Homepage and knowledge packages

Planned trust-loop structure:

```text
LinkedIn post
  -> homepage knowledge page
  -> YouTube lecture / playlist
  -> GitHub repo
  -> free checklist or knowledge package
```

Planned homepage page:

```text
/supply-chain-analytics
```

Planned first related knowledge package:

```text
Supply Chain AI Use-Case Map
```

This package should help professionals decide which analytics or AI use cases are worth pursuing, which ones are premature, and which process/data boundaries must be clarified first.

---

## Related content

- YouTube playlist: https://www.youtube.com/playlist?list=PL6kUP6-NlVDKnB103rGFrH1AGes5fOeFB
- GitHub repository: https://github.com/kienlef/supplychainanalytics

Homepage link will be added after the knowledge hub architecture is decided.

---

## Author

Frank Kienle

Frank writes about practical AI, analytics, and agentic automation for supply chain and operations — grounded in real business problems, former lecturer experience, and working technical artifacts.

---

## Disclaimer

This repository is a personal educational/knowledge project by Frank Kienle. It is not affiliated with, endorsed by, or representative of any employer. Code, examples, and datasets are for learning and demonstration purposes. No employer-confidential data or internal business logic is included.

---

## License

This repository includes an MIT License. See `LICENSE` for details.
