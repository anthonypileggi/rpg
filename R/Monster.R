#' Monster R6 Class
#' @importFrom magrittr "%>%"
#' @export
Monster <- R6::R6Class("Monster",

  public = list(

    # -- monster name
    name = NULL,

    # -- create monster (default = "slime")
    initialize = function(name = "slime") {
      if (is.na(name))
        stop("You must choose a monster!")
      self$name <- name
      private$monster()
    },

    # -- print method
    print = function(...) {
      cat("Monster: \n")
      cat("  Name: ", self$name, "\n", sep = "")
      cat("  Level: ", private$.level, "\n", sep = "")
      cat("  Attributes:\n", sep = "")
      cat(private$print_attributes(), sep = "\n")
      invisible(self)
    },

    # -- field actions
    move = function() {

    },
    fight = function() {
      # call a Monster to fight
    },
    rest = function() {
      # recover hp/mp
    },

    # -- battle actions
    attack = function() {
      private$.attributes$strength
    },
    defend = function() {
      private$.attributes$defense
    },
    escape = function() {
      # run away!
    },

    # -- battle effects
    reduce_hp = function(value = 0) {
      if (is.numeric(value)) {
        new_value <- private$.attributes$hp - value
        msg <- paste0("\tHP reduced by ", value, " (", private$.attributes$hp, " --> ", new_value, ")\n")
        cat(crayon::red(msg))
        private$.attributes$hp <- new_value
      }
    }

  ),

  active = list(
    attributes = function(value) {
      if (missing(value)) {
        private$.attributes
      } else {
        cat(crayon::red("You cannot change your attributes manually!\n"))
      }
    }
  ),

  private = list(

    # everyone starts with a Level 1 with 0 EXP
    .level = 1,
    .xp = 0,
    .attributes = dplyr::tibble(
      hp = 1,
      mp = 0,
      strength = 1,
      defense = 1,
      speed = 1,
      magic = 1,
      xp = 0
    ),

    # set the type of monster
    monster = function() {
      monsters <- monsters()
      if (!is.element(tolower(self$name), monsters$name))
        self$name <- "slime"    # default to 'slime' monster
      if (sum(tolower(self$name) %in% monsters$name) == 1) {
        private$.attributes <- dplyr::filter(monsters, name == tolower(self$name))
      } else {
        stop("You must choose a single monster!  See `monsters()` for your options.")
      }


      # if (tolower(self$name) == "slime") {
      #   private$set_attributes(
      #     hp = 2,
      #     xp = 1
      #   )
      # } else if (tolower(self$name) == "skeleton") {
      #   private$set_attributes(
      #     hp = 5,
      #     strength = 2,
      #     xp = 2
      #   )
      # } else if (tolower(self$name) == "giant") {
      #   private$set_attributes(
      #     hp = 10,
      #     strength = 4,
      #     defense = 2,
      #     xp = 3
      #   )
      # }
    },

    # set attributes
    set_attributes = function(...) {
      params <- list(...)
      if (length(params) > 0) {
        purrr::walk(
          names(params),
          function(a) {
            private$.attributes[[a]] <- params[[a]]
          }
        )
      }
    },

    # -- print helpers
    print_attributes = function() {
      purrr::map_chr(
        names(private$.attributes),
        ~paste0("\t", .x, ": ", scales::comma(private$.attributes[[.x]]))
      )
    }

  )

)
