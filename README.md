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

- `data/actual_abund.csv`: observed species totals (`latin, n`), used only to
  weakly calibrate species baselines. This local instructor input is excluded
  from Git and is not needed for the student exercise. Unlisted species are
  not assumed absent.
- `data/abundance_adjustment.csv`: matched observed counts and the baseline
  multiplier for each simulated species (approximately 0.47–2.12).
- `data/dummy_trait.csv`: 77 species × 8 traits; units are listed in the notebooks.
- `data-raw/seed_mass_ranges.csv`: genus-specific seed mass bounds (mg per seed),
  used as teaching assumptions rather than measured species limits. Seed masses
  span small seeds to nuts; rounded species anchors and sources are explained in
  `dummy_data.qmd`. They are not measured dry masses.
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

Instructor-only regeneration requires the local `data/actual_abund.csv`
(`latin, n`), which is intentionally excluded from Git. Keep the supplied
generated CSVs for class; students do not need that local input.

With that input, Quarto and the packages above installed, run from this directory:

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
no exact bead counts need to be followed. Species baselines receive a weak
observed-abundance correction: standardize `log(n + 1)` over species with exact
name matches, clip to ±1.5, and add half this value to the log-scale intercept.
Unmatched species receive no correction. Habitat coefficients are retained;
within-species expected spatial proportions are preserved. This does not
reconstruct the observed community. Numerical results differ from the old
handout because LL, moisture averaging, reproducibility, and abundance
coefficients have been corrected.

`data-raw/dummy_reference.newick` is an unchanged snapshot of the previously
supplied `data/dummy_tree.newick`, retained as a stable input. It is **not** a
recovery of the missing original `qjzad.tre`. Regeneration fixes this snapshot's
topology and branch lengths rather than rerunning tree dating or randomly
resolving polytomies. Trait values and species assignments are regenerated.

## Companion lecture

The companion lecture intentionally uses log-trait CWM. Do not apply
`patches/phy-fun-div-cwm.patch`: it is an older proposal that changes that
teaching choice. This repository's exercise uses raw-unit CWM and a separate
60-site community dataset. Its regenerated trait values are not automatically
synchronized with the companion lecture.

## Classroom readiness

Use `dummy_com.html` for the habitat and species distribution maps, and
`community_analysis.qmd` / `.html` for analysis. Scatter beads by the relative
patterns in the maps rather than following literal simulated counts.
Prepare R packages before class; the supplied HTML can be read without R.

In the current data, richness ranges from 65 to 77 species and 46 of 60 sites
contain the full species pool. Their unweighted functional MPD SES is undefined
and displayed as NA. Use abundance-sensitive metrics (Shannon and CWM) to
compare those sites; do not expect every presence/absence metric to differ.
Run `Rscript scripts/check_data.R` to check the supplied data. Without the local
observed-abundance file, it validates the saved calibration bounds but skips
comparison against the original private input.
