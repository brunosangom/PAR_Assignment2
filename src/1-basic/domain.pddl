(define (domain robot_chef)
    (:requirements :strips :typing :fluents :negative-preconditions :disjunctive-preconditions)

    ;; Define types and type hierarchy
    (:types
        robot; Define a type for the robot
        room; Define a type for locations/rooms
        item; Define a general type 'item' for anything the robot might hold
        ingredient tool dish - item; 'ingredient', 'tool', and 'dish' are subtypes of 'item'
        )

    (:functions
        (ingredient-quantity ?i - ingredient) ;; Fluents for managing the quantity of each ingredient.
    )

    (:predicates
        ;; Basic predicates
        (robot-at ?r - robot ?room - room); The robot is in a specific room.
        (holding ?item - item); The robot is holding an item.
        (adjacent ?room1 - room ?room2 - room); The rooms are adjacent.

        (tool-at ?tool - tool ?room - room); A tool is in a specific room.
        (tool-clean ?tool - tool); A tool is clean.

        (dish-at ?dish - dish ?room - room); A dish is in a specific room.
        (dish-prepared ?dish - dish); The dish is fully prepared.

        (ingredient-at ?ingredient - ingredient ?room - room); An ingredient is in a specific room.
        (ingredient-prepared ?ingredient - ingredient); The ingredient is prepared .
        (ingredient-cooked ?ingredient - ingredient); The ingredient is cooked.

        (is-storage-room ?room - room); The room is the storage room.
        (is-cooking-room ?room - room); The room is the cooking room.
        (is-serving-room ?room - room); The room is the serving room.
        (is-preparation-room ?room - room); The room is the preparation room.
        (is-dishwashing-room ?room - room); The room is the dishwashing room.
        (is-cutting-room ?room - room); The room is the cutting room.
        (is-mixing-room ?room - room); The room is the mixing room.

        ;; Helpers to bind specific ingredients to rooms
        (ingredient-prep-room ?ingredient - ingredient ?room - room); Ingredient must be prepared in a specific room.
        (ingredient-cook-room ?ingredient - ingredient ?room - room); Ingredient must be cooked in a specific room.

        ;; Requirements between dishes and ingredients (define recipe)
        (ingredient-used-in-dish ?ingredient - ingredient ?dish - dish) ;; Link ingredient to a specific dish
        (require-prepared ?dish - dish ?ingredient - ingredient); The dish requires a prepared ingredient.
        (require-cooked ?dish - dish ?ingredient - ingredient); The dish requires a cooked ingredient.
    )

    ; Actions

    ; The robot moves from its current room to an adjacent one.
    (:action move
        :parameters (?robot - robot ?from - room ?to - room)
        :precondition (and
            (robot-at ?robot ?from)
            (adjacent ?from ?to)
        )
        :effect (and
            (robot-at ?robot ?to)
            (not (robot-at ?robot ?from))
        )
    )

    ;; The robot picks up an ingredient from the storage area.
    (:action pick-up-ingredient
        :parameters (?robot - robot ?ingredient - ingredient ?room - room)
        :precondition (and
            (robot-at ?robot ?room)
            (ingredient-at ?ingredient ?room)
            (not (holding ?ingredient)); Verify that the robot does not already hold something (limited to 1).
            (is-storage-room ?room); ingredients are only in the storage room.
            (> (ingredient-quantity ?ingredient) 0); The quantity of ingredient must be more than 0.
        )
        :effect (and
            (holding ?ingredient)
            (not (ingredient-at ?ingredient ?room))
            (decrease (ingredient-quantity ?ingredient) 1) ;; Decrease the quantity of the picked-up ingredient.
        )
    )

    ;; The robot prepares an ingredient (e.g., cuts, mixes) in the appropriate room.
    (:action prepare-ingredient
        :parameters (?robot - robot ?ingredient - ingredient ?room - room)
        :precondition (and
            (robot-at ?robot ?room)
            (ingredient-prep-room ?ingredient ?room); The ingredient must be prepared in the specified room.
            (holding ?ingredient); The robot must hold the ingredient to prepare it.
            ;(not (ingredient-prepared ?ingredient)); The ingredient must not be already prepared.
        )
        :effect (and
            (ingredient-prepared ?ingredient)
        )
    )

    ;; The robot cooks an ingredient in the cooking area.
    (:action cook-ingredient
        :parameters (?robot - robot ?ingredient - ingredient ?room - room)
        :precondition (and
            (is-cooking-room ?room)
            (robot-at ?robot ?room)
            (ingredient-cook-room ?ingredient ?room); The ingredient must be cooked in the specified room.
            (ingredient-prepared ?ingredient); The ingredient must be prepared before cooking.
            (holding ?ingredient); The robot must hold the ingredient to cook it.
            ;(not (ingredient-cooked ?ingredient)); The ingredient must not be already cooked.
        )
        :effect (and
            (ingredient-cooked ?ingredient)
        )
    )

    ;; The robot assembles a dish from prepared ingredients in the preparation area.
    (:action assemble-dish
        :parameters (?r - robot ?dish - dish ?room - room)
        :precondition (and
            (robot-at ?r ?room)
            (is-preparation-room ?room)
            ;; Precondition to ensure all ingredients are either prepared or cooked as required
            (forall
                (?ingredient - ingredient)
                (or
                    (and (ingredient-used-in-dish ?ingredient ?dish) (require-prepared ?dish ?ingredient) (ingredient-prepared ?ingredient))
                    (and (ingredient-used-in-dish ?ingredient ?dish) (require-cooked ?dish ?ingredient) (ingredient-cooked ?ingredient)))))
        :effect (dish-prepared ?dish)
    )

    ;; The robot plates the finished dish in the serving area.
    ; (:action plate-dish
    ;     :parameters (?robot - robot ?room - room ?dish - dish)
    ;     :precondition (and
    ;         (is-preparation-room ?room)
    ;         (robot-at ?robot ?room)
    ;         (dish-prepared ?dish)
    ;     )
    ;     :effect (and

    ;     )
    ; )

    ;; The robot cleans a tool in the dishwashing area.
    ; (:action clean-tool
    ;     :parameters ()
    ;     :precondition (and

    ;     )
    ;     :effect (and

    ;     )
    ; ))
)