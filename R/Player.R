#' Player R6 Class
#' @importFrom magrittr "%>%"
#' @export
Player <- R6::R6Class("Player",

  public = list(

    # -- player name
    name = NULL,

    # -- create/load player profile
    initialize = function(name = NA) {
      if (is.na(name))
        stop("You must choose a name for your player!")
      self$name <- name
      private$.base <- private$.attributes    # save base attributes
    },

    # -- print method
    print = function(...) {

      cat("Player: \n")
      cat("  Name: ", self$name, "\n", sep = "")
      cat("  Level: ", private$.level, "\n", sep = "")
      cat("  XP: ", private$.xp, "\n", sep = "")
      cat("  HP: ", private$.attributes$hp, "/", private$.base$hp, "\n", sep = "")
      if (!is.null(private$.monster))
        cat(crayon::red("Battling a ", private$.monster$name, "\n"))
      if (private$.attributes$hp <= 0)
        cat(crayon::red("You are dead!"))
      invisible(self)
    },

    # -- field actions
    move = function() {

    },
    fight = function(monster = "slime", auto = TRUE) {
      # call a Monster to fight a Battle
      private$.battle <- Battle$new(player = self, monster = Monster$new(monster))

      if (auto) {
        private$.battle$attack(auto)         # auto-fight
        self <- private$.battle$player   # return updated player information
      } else {
        self <- private$.battle          # return Battle object
      }

      invisible(self)
    },
    rest = function() {
      # recover hp/mp
      msg <- paste("Recovering", private$.base$hp - private$.attributes$hp, "HP")
      cat(crayon::green(msg))
      self$journal <- msg
      private$.attributes$hp <- private$.base$hp
    },
    shop = function() {
      # buy things
    },

    # -- battle actions
    attack = function() {
      private$.attributes$strength
    },
    defend = function() {
      private$.attributes$defense
    },
    item = function() {
      # use an item
    },
    escape = function() {
      # run away!
    },

    # -- battle effects
    reduce_hp = function(value = 0) {
      if (is.numeric(value)) {
        new_value <- private$.attributes$hp - value
        msg <- paste0("\tHP reduced by ", value, " (", private$.attributes$hp, " --> ", new_value, ")\n")
        self$journal <- msg
        cat(crayon::red(msg))
        private$.attributes$hp <- new_value
      }
    },
    earn_xp = function(value = 0) {
      if (is.numeric(value)) {
        msg <- paste("Earned", value, "XP!\n")
        self$journal <- msg
        cat(crayon::green(msg))
        private$.xp <- private$.xp + value
        # TODO: update player level (if enough XP earned)
      }
    }

  ),

  active = list(

    xp = function(value) {
      if (missing(value)) {
        private$.xp
      } else {
        cat(crayon::red("Fight monsters to earn experience (xp)!\n"))
      }
    },

    level = function(value) {
      if (missing(value)) {
        private$.level
      } else {
        cat(crayon::red("Earn more experience to increase your level!\n"))
      }
    },

    attributes = function(value) {
      if (missing(value)) {
        private$.attributes
      } else {
        cat(crayon::red("You cannot change your attributes manually!\n"))
      }
    },

    journal = function(value) {
      if (missing(value)) {
        private$.journal
      } else {
        if (is.character(value)) {
          private$.journal <- c(private$.journal, value)
        } else {
          cat(crayon::red("Invalid journal entry!\n"))
        }
      }
    }

  ),

  private = list(

    # everyone starts with a Level 1 with 0 EXP
    .level = 1,
    .xp = 0,
    .attributes = dplyr::tibble(
      hp = 10,
      mp = 0,
      strength = 1,
      defense = 1,
      speed = 1,
      magic = 1
    ),
    .base = NULL,
    .journal = NULL,

    # battle
    .battle = NULL,

    # -- increment/decrement attributes
    increment = function(name, value) {
      cur_value <- private$.attributes[[name]]
      if (!is.null(cur_value))
        private$.attributes[[name]] <- cur_value + value
    }

  )

)
