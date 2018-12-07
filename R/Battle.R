#' Battle R6 Class
#' @importFrom magrittr "%>%"
#' @export
Battle <- R6::R6Class("Battle",

  public = list(

    player = NULL,
    monster = NULL,

    # -- create/load player profile
    initialize = function(player = NULL, monster = NULL) {
      if (is.null(player) || class(player)[1] != "Player")
        stop("You must choose a player!")
      if (is.null(monster) || class(monster)[1] != "Monster")
        stop("You must choose a monster!")
      self$player <- player
      self$monster <- monster
    },

    # -- print method
    print = function(...) {
      cat("Battle: \n")
      cat(self$player$name, "vs.", self$monster$name, "\n")
      invisible(self)
    },

    # -- simulate battle
    battle = function() {
      # keep going until player or monster has {hp = 0}
      while (self$player$attributes$hp > 0 & self$monster$attributes$hp > 0) {
        # attack
        cat(crayon::red(private$.turn, "attacks!\n"))
        if (private$.turn == "player") {
          self$monster$reduce_hp(self$player$attack())
        } else if (private$.turn == "monster") {
          self$player$reduce_hp(self$monster$attack())
        }
        # change turns
        private$.turn <- switch(private$.turn,
          player = "monster",
          monster = "player"
          )
      }
      if (self$player$attributes$hp <= 0)
        cat(crayon::red("Player Dies!  Game Over!\n"))
      if (self$monster$attributes$hp <= 0) {
        self$player$earn_xp(self$monster$attributes$xp)
        cat(crayon::red("Player Wins!  The ", self$monster$name, " has been defeated!\n"))

      }

      invisible(self)
    }
  ),


  private = list(

    .turn = "player"    # player always goes first

  )

)