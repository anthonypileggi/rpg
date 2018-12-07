
#' Monster list
monsters <- function() {
  dplyr::tribble(
    ~name,      ~hp,  ~mp, ~strength, ~defense, ~speed, ~magic, ~xp,
    "slime",      2,    0,         1,        1,      1,      1,   1,
    "skeleton",   5,    0,         1,        1,      1,      1,   2,
    "giant",      10,   0,         1,        1,      1,      1,   3
  )
}