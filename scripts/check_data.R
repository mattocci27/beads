# Run from the project root after rendering the two data-generation notebooks.
trait <- read.csv("data/dummy_trait.csv")
soil <- read.csv("data/soil.csv")
env <- read.csv("data/site_environment.csv")
samp <- read.csv("data/samp.csv")
note <- read.csv("data/note.csv")
tree <- ape::read.tree("data/dummy_tree.newick")
reference <- ape::read.tree("data-raw/dummy_reference.newick")
stopifnot(nrow(trait) == 77L, !anyDuplicated(trait$sp),
          all(as.matrix(trait[-1]) > 0),
          identical(tree, reference), setequal(tree$tip.label, trait$sp),
          nrow(env) == 60L, !anyDuplicated(env$site),
          nrow(soil) == 77L, !"soil_p" %in% names(soil),
          identical(names(samp), c("Site", "Species", "abund")),
          nrow(samp) == 60L * 77L, !anyDuplicated(samp[c("Site", "Species")]),
          all(samp$abund >= 0 & samp$abund == floor(samp$abund)),
          setequal(samp$Site, env$site), setequal(samp$Species, trait$sp),
          setequal(note$sp, trait$sp), setequal(note$group, c("focal", "other")))
# Independently select each quadrat's four corners from the saved grid.
for (i in seq_len(nrow(env))) {
  corners <- soil[soil$x %in% c(env$col[i]-1, env$col[i]) &
                  soil$y %in% c(env$row[i]-1, env$row[i]), ]
  stopifnot(nrow(corners) == 4L)
  for (v in c("soil_n", "soil_moist")) {
    # Grid CSV is rounded to three decimals; site means retain full precision.
    stopifnot(abs(mean(corners[[v]]) - env[[v]][i]) <= 0.000501)
  }
}
mat <- tapply(samp$abund, list(samp$Site, samp$Species), sum)
stopifnot(!anyNA(mat), all(rowSums(mat) > 0))
# Physical scatter exercise: most abundance belongs in the broad valley,
# without a single species or quadrat dominating the map.
site_env <- env[match(rownames(mat), env$site), ]
stopifnot(sum(mat[site_env$topo == "valley", ]) / sum(mat) > 0.7,
          max(colSums(mat)) / sum(mat) < 0.15,
          max(rowSums(mat)) / sum(mat) < 0.1)
ridge_fraction <- colSums(mat[site_env$topo == "Ridge", ]) / colSums(mat)
stopifnot(sum(ridge_fraction > 0.5) <= 0.1 * ncol(mat))
aligned <- trait[match(colnames(mat), trait$sp), ]
cwm <- (mat %*% as.matrix(aligned[-1])) / rowSums(mat)
for (i in seq_len(nrow(mat))) {
  stopifnot(isTRUE(all.equal(unname(cwm[i, "lma"]),
                            weighted.mean(aligned$lma, mat[i, ]))))
}
cat("Validated 77 species, 60 sites, 4620 counts, four-corner means, raw-unit CWM and fixed reference tree.\n")
