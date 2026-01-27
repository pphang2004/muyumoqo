# Archaeology Data (R project)

This folder contains CSV data and an `renv` environment for R.

Quick commands:

- Restore the project environment:

```bash
Rscript -e "renv::restore()"
```

- Install a package into the project and snapshot:

```bash
Rscript -e "renv::install('dplyr'); renv::snapshot()"
```

- Open the project in RStudio by opening `Archaeology.Rproj`.
