
<!-- README.md is generated from README.Rmd. Please edit that file -->
rpg <img src="man/figures/logo.svg" align="right" alt="" width="120" />
=======================================================================

Play a role playing game in the R console.

Installation
------------

``` r
# Install development version from GitHub
devtools::install_github("anthonypileggi/rpg")
```

Example
-------

``` r
library(rpg)

# Create a new player
x <- Player$new("Hero")
x
#> Player: 
#>   Name: Hero
#>   Level: 1
#>   XP: 0
#>   HP: 10/10

# Fight some monsters
x$fight("slime")
#> player attacks!
#>  HP reduced by 1 (2 --> 1)
#> monster attacks!
#>  HP reduced by 1 (10 --> 9)
#> player attacks!
#>  HP reduced by 1 (1 --> 0)
#> Earned 1 XP!
#> Player Wins!  The  slime  has been defeated!

x$fight("skeleton")
#> player attacks!
#>  HP reduced by 1 (5 --> 4)
#> monster attacks!
#>  HP reduced by 1 (9 --> 8)
#> player attacks!
#>  HP reduced by 1 (4 --> 3)
#> monster attacks!
#>  HP reduced by 1 (8 --> 7)
#> player attacks!
#>  HP reduced by 1 (3 --> 2)
#> monster attacks!
#>  HP reduced by 1 (7 --> 6)
#> player attacks!
#>  HP reduced by 1 (2 --> 1)
#> monster attacks!
#>  HP reduced by 1 (6 --> 5)
#> player attacks!
#>  HP reduced by 1 (1 --> 0)
#> Earned 2 XP!
#> Player Wins!  The  skeleton  has been defeated!

# Check your current status
x
#> Player: 
#>   Name: Hero
#>   Level: 1
#>   XP: 3
#>   HP: 5/10

# Rest to heal yourself; if your HP falls to 0 then it's GAME OVER!
x$rest()
#> Recovering 5 HP
x
#> Player: 
#>   Name: Hero
#>   Level: 1
#>   XP: 3
#>   HP: 10/10

# Watch out, it's a giant!
x$fight("giant")
#> player attacks!
#>  HP reduced by 1 (10 --> 9)
#> monster attacks!
#>  HP reduced by 1 (10 --> 9)
#> player attacks!
#>  HP reduced by 1 (9 --> 8)
#> monster attacks!
#>  HP reduced by 1 (9 --> 8)
#> player attacks!
#>  HP reduced by 1 (8 --> 7)
#> monster attacks!
#>  HP reduced by 1 (8 --> 7)
#> player attacks!
#>  HP reduced by 1 (7 --> 6)
#> monster attacks!
#>  HP reduced by 1 (7 --> 6)
#> player attacks!
#>  HP reduced by 1 (6 --> 5)
#> monster attacks!
#>  HP reduced by 1 (6 --> 5)
#> player attacks!
#>  HP reduced by 1 (5 --> 4)
#> monster attacks!
#>  HP reduced by 1 (5 --> 4)
#> player attacks!
#>  HP reduced by 1 (4 --> 3)
#> monster attacks!
#>  HP reduced by 1 (4 --> 3)
#> player attacks!
#>  HP reduced by 1 (3 --> 2)
#> monster attacks!
#>  HP reduced by 1 (3 --> 2)
#> player attacks!
#>  HP reduced by 1 (2 --> 1)
#> monster attacks!
#>  HP reduced by 1 (2 --> 1)
#> player attacks!
#>  HP reduced by 1 (1 --> 0)
#> Earned 3 XP!
#> Player Wins!  The  giant  has been defeated!

# Whew, we did it.  Now we just need to deal with one last slime...
x$fight("slime")
#> player attacks!
#>  HP reduced by 1 (2 --> 1)
#> monster attacks!
#>  HP reduced by 1 (1 --> 0)
#> Player Dies!  Game Over!
```

Bestiary
--------

Check out the full list of monsters you can fight!

``` r
bestiary()
#> # A tibble: 3 x 8
#>   name        hp    mp strength defense speed magic    xp
#>   <chr>    <dbl> <dbl>    <dbl>   <dbl> <dbl> <dbl> <dbl>
#> 1 slime        2     0        1       1     1     1     1
#> 2 skeleton     5     0        1       1     1     1     2
#> 3 giant       10     0        1       1     1     1     3
```

Shiny
-----

Coming soon...
