# Muyumoqo Archaeological Project

This repository contains lithic and obsidian geochemical data from the Muyumoqo archaeological site, along with R analysis scripts and exploratory visualizations.

## Project Overview

The Muyumoqo project investigates obsidian tool production and consumption patterns at an Andean archaeological site. The assemblage consists primarily of obsidian debitage (production debris) and a small number of formal tools, recovered from domestic (house) contexts, temple areas, and other features.

## Repository Structure

```
├── analysis/
│   ├── data_inventory.Rmd    # Comprehensive data dictionary and variable definitions
│   ├── about.Rmd
│   └── index.Rmd
├── data/
│   ├── lithic_analysis.csv           # Cleaned lithic analysis data (1,200 obsidian artifacts)
│   └── lithic_analysis_enhanced.csv  # Enhanced version with derived variables
├── output/
│   ├── exploratory_spatial_plots.png    # Spatial distribution visualizations
│   ├── exploratory_debris_plots.png     # Debris type and weight analyses
│   └── exploratory_location_tools.png   # Inside/outside comparisons & tool types
├── code/                     # Analysis scripts
├── docs/                     # Generated documentation
├── obsidian_data_26.xlsx     # XRF geochemical sourcing data (multi-sheet)
├── 2023_muyumoqo fichas - UE5.csv  # Excavation feature records
└── renv/                     # R environment management
```

## Data Files

### `data/lithic_analysis.csv`

Primary lithic analysis dataset containing 1,200 obsidian artifacts with 23 variables:

| Category | Variables |
|----------|-----------|
| **Provenience** | `Unidad` (excavation unit), `Cuad` (quadrant), `Nivel` (depth), `Rasgo` (feature), `Excavador`, `Fecha` |
| **Fragment info** | `N frag.`, `Tamaño frag.` (size class) |
| **Morphometrics** | `Length`, `Width`, `Thickness`, `Weight` |
| **Technology** | `Material`, `Technological Type`, `Debris`, `Platform Type`, `Termination`, `% Cortex`, `Portion`, `Modification` |
| **Documentation** | `Notes`, `Foto` |

See `analysis/data_inventory.Rmd` for complete variable definitions and code equivalences.

### `data/lithic_analysis_enhanced.csv`

Enhanced version with derived variables for analysis:

| New Variable | Description |
|--------------|-------------|
| `House_Num` | Extracted house number (House 1-8) from Rasgo |
| `Location_Type` | Spatial position: Inside, Outside, Above, Below, Unspecified (House), Other, Unknown |
| `Context_Type` | Functional context: Domestic, Temple, EP, Public Building, Burial, etc. |
| `Debris_Label` | Human-readable debris classification: Proximal flake, Flake shatter, Angular debris |

### `obsidian_data_26.xlsx`

Multi-sheet Excel workbook containing XRF geochemical data for obsidian sourcing:
- **Artifacts raw**: 326 artifacts with elemental composition
- **Sources**: 181 reference source samples
- **provenience FINAL**: 2,146 curated samples (recommended for analysis)

## Exploratory Analysis Summary

### Key Findings

1. **Assemblage composition**: 94% debris (production waste), 6% formal tools
   - Proximal flakes: 49%
   - Angular debris: 23%
   - Flake shatter: 22%
   - Formal tools: 71 specimens (mostly combination flake tools)

2. **Spatial distribution**: Units 7 and 8 contain 85% of all fragments
   - Debris type proportions are consistent across excavation units
   - No evidence for spatially segregated production areas

3. **Inside vs. Outside houses**:
   - Subtle difference in debris proportions (more proximal flakes inside)
   - Similar fragment weights in both contexts
   - Suggests similar activities occurred in both locations

4. **Domestic focus**: 53% of assemblage from house contexts; formal tools concentrate in domestic areas

### Visualizations

- `output/exploratory_spatial_plots.png`: Heatmap of fragment density, unit-level distributions, debris by context
- `output/exploratory_debris_plots.png`: Weight distributions, house-level debris patterns, total obsidian by context
- `output/exploratory_location_tools.png`: Inside/outside comparisons, formal tool types and distribution

## Suggested Next Steps

1. **Statistical testing**: Chi-square tests for debris type differences between houses or Inside/Outside
2. **Stratigraphic analysis**: Examine changes in technology across excavation levels (Nivel)
3. **Source integration**: Link lithic morphology to XRF sourcing data to test if different sources were treated differently
4. **Spatial modeling**: Density mapping and cluster analysis within excavation units

## R Environment

This project uses `renv` for dependency management.

```bash
# Restore the project environment
Rscript -e "renv::restore()"

# Install a package and snapshot
Rscript -e "renv::install('dplyr'); renv::snapshot()"

# Open in RStudio
open Archaeology.Rproj
```

## Data Quality Notes

- Date formats vary (DD-MM-YY and YYYY-MM-DD) — standardization recommended
- Missing values represented as empty cells
- Spanish terminology used in feature names and notes
- `Context` column should be ignored (not used for analyses)

## Contact

For questions about this dataset, contact the project PI or see the thesis document for full methodology.
