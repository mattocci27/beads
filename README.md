[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

# Beads

Dummy plant communities for a community-analysis exercise following the
phylogenetic and functional diversity lecture in `phy-fun-div`.
Species names identify fictional trait values and abundances; these are not
observations of the named species.

## Student exercise

Open this directory as an RStudio project or set it as the working directory.
Install the packages once before class:

```r
install.packages(c("tidyverse", "picante", "janitor", "DT"))
```

Open `community_analysis.qmd` and run its chunks in order. The supplied CSVs
and Newick tree are ready to use; students do not need to regenerate data or
restore the instructor's `renv` environment. If the project activates `renv`,
use its library and install the packages there. Pre-rendered HTML files are
provided for reading the instructions and results without running R.

The example covers richness, Shannon diversity, PD/MPD/MNTD, CWM, and functional
distance with a null model. CWM uses raw traits in their original units;
functional distances use transformed and standardized traits.
High richness is intentional: presence/absence diversity may be identical
between sites despite differences in abundance and CWM. Soil N is a spatially
structured variable without a direct effect in the abundance model. Moisture
and topography are associated, so their separate effects cannot be inferred
from simple correlations alone. These simulated patterns do not uniquely
identify assembly processes.

## Data

- `data/dummy_trait.csv`: 77 species × 8 traits; units are listed in the notebooks.
- `data/dummy_tree.newick`: the same 77 species; arbitrary branch-length units.
- `data/samp.csv`: `Site, Species, abund`, including zero counts (60 × 77 rows).
- `data/site_environment.csv`: one row per site, with coordinates, habitat,
  and four-corner means of soil N (%) and moisture (unitless).
- `data/soil.csv`: 77 grid-corner measurements on an 11 × 7 grid. These are
  not site rows. Site `(col, row)` uses corners `(col-1, row-1)`, `(col, row-1)`,
  `(col-1, row)`, and `(col, row)`.
- `data/note.csv`: `focal` species have extreme LMA or seed mass; `other`
  denotes the remaining species. These labels do not describe abundance.

Join site-level analysis results to `site_environment.csv` by `Site = site`,
not by row position. A community matrix has sites in rows and species in columns.

## Instructor R environment

The lockfile records R 4.6.1 and renv 1.3.1. Open the project directory in
RStudio, then run:

```r
renv::restore()
renv::status()
```

`.Rprofile` activates the project library and uses the portable CRAN mirror
`https://cloud.r-project.org`. Container caches can be set explicitly with
`RENV_PATHS_CACHE`; no operating-system or R-version-specific library path is
injected at startup. The lockfile contains the dependencies used by the current
notebooks, including their rendering dependencies.

The legacy `.devcontainer` configuration still uses the custom R 4.4.1 image;
it is not the R 4.6.1 environment described here. Use local R 4.6.1 for this
lockfile until that container is rebuilt separately.

## Regenerate teaching materials

With Quarto and the packages above installed, run from this directory:

```sh
quarto render dummy_data.qmd
quarto render dummy_com.qmd
quarto render community_analysis.qmd
Rscript scripts/check_data.R
```

Run in this order: trait generation overwrites the trait CSV, and community
generation then overwrites the community, environment, and species-note CSVs.
Trait generation uses seed 123; community abundance uses seed 456 independently
of environmental generation. The 77-species pool is retained. The abundance
model is tuned for scattering beads by eye: most species occupy broad valley areas, with a few ridge-preferring
species. Moisture and ridge × forest effects are moderated to avoid a single
species dominating small dry patches. The maps are relative distribution guides;
no exact bead counts need to be followed. Numerical results differ from the old
handout because LL, moisture averaging, reproducibility, and abundance
coefficients have been corrected.

`data-raw/dummy_reference.newick` is an unchanged snapshot of the previously
supplied `data/dummy_tree.newick`, retained as a stable input. It is **not** a
recovery of the missing original `qjzad.tre`. Regeneration fixes this snapshot's
topology and branch lengths rather than rerunning tree dating or randomly
resolving polytomies. Trait values and species assignments are regenerated.

## Companion lecture correction

`patches/phy-fun-div-cwm.patch` changes the companion notebook to use raw traits
for CWM, corrects its matrix-orientation explanation, and fixes trait-unit typos.
From the `phy-fun-div` directory, apply it and regenerate its handout:

```sh
git apply ../beads/patches/phy-fun-div-cwm.patch
quarto render diversity_example.qmd
```

The patch does not replace the lecture repository's separate, small example
dataset. To analyze the 60-site dataset, use this repository's exercise.
