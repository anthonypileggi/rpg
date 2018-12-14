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
    attack = function(auto = FALSE) {

      # is it over yet?
      if (private$.done) {
        cat(crayon::red("The battle is over!\n"))
        return(invisible(self))
      }

      # [auto == TRUE] keep going until player or monster has {hp = 0}
      private$act()
      while (private$.turn != "player" || (auto & !private$.done)) {
        private$act()               # take a turn (player/monster)
        private$check_status()      # check the status of player/monster
      }

      invisible(self)
    },

    # -- run away from battle
    run = function() {
      private$.done <- TRUE
    },

    # is the battle over?
    is_over = function() {
      private$.done
    }

  ),


  active = list(
    log = function(value) {
      if (missing(value)) {
        private$.log
      } else {
        private$.log <- c(private$.log, value)
      }
    }
  ),


  private = list(

    .turn = "player",    # player always goes first
    .done = FALSE,       # is it over yet?
    .log = NULL,         # battle log

    change_turns = function() {
      private$.turn <- switch(private$.turn,
        player = "monster",
        monster = "player"
      )
    },

    # check the status of player/monster
    check_status = function() {
      msg <- dplyr::case_when(
        self$player$attributes$hp <= 0 ~  paste0("Player Dies!  Game Over!\n"),
        self$monster$attributes$hp <= 0 ~ paste0("Player Wins!  The ", self$monster$name, " has been defeated!\n"),
        TRUE ~ ""
      )
      if (msg != "") {
        self$player$journal <- msg
        cat(crayon::red(msg))
        private$.done <- TRUE
        if (private$.done & self$monster$attributes$hp <= 0)
          self$player$earn_xp(self$monster$attributes$xp)
      }
    },

    # -- act [attack] (player/monster)
    act = function() {
      msg <- paste0(self[[private$.turn]]$name, " attacks for ", self[[private$.turn]]$attack(), " damage!\n")
      private$.log <- c(private$.log, msg)
      self$player$journal <- msg
      cat(crayon::red(msg))
      if (private$.turn == "player") {
        self$monster$reduce_hp(self$player$attack())
      } else if (private$.turn == "monster") {
        self$player$reduce_hp(self$monster$attack())
      }
      private$change_turns()
    }

    # -- defend
    # -- item
  )

)