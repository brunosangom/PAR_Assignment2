(define (domain robot_chef)
    (:requirements :strips :typing :negative-preconditions :disjunctive-preconditions :conditional-effects :universal-preconditions)

    ;; Define types and type hierarchy
    (:types
        room - object; Define a type for locations/rooms
        movable - object; Define a type for movable objects
        robot - movable; Define a type for the robot
        item - movable; Define a general type 'item' for anything the robot might hold
        ingredient tool dish - item; 'ingredient', 'tool', and 'dish' are subtypes of 'item'
        )

    (:predicates
        ;; Basic predicates
        (at ?movable - movable ?room - room); A movable object is in a specific room.

        (holding ?item - item); The robot is holding an item.
        (hand-free); The robot hand is free
        (adjacent ?room1 - room ?room2 - room); The rooms are adjacent.

        (tool-clean ?tool - tool); A tool is clean.

        (prioritize-dish ?dish1 ?dish2); dish1 has higher priority than dish2.
        (dish-prepared ?dish - dish); The dish is fully prepared.
        (dish-served ?dish - dish); The dish is served

        (ingredient-prepared ?ingredient - ingredient); The ingredient is prepared .
        (ingredient-cooked ?ingredient - ingredient); The ingredient is cooked.

        (is-storage-room ?room - room); The room is the storage room.
        (is-cooking-room ?room - room); The room is the cooking room.
        (is-serving-room ?room - room); The room is the serving room.
        (is-preparation-room ?room - room); The room is the preparation room.
        (is-dishwashing-room ?room - room); The room is the dishwashing room.
        (is-cutting-room ?room - room); The room is the cutting room.
        (is-mixing-room ?room - room); The room is the mixing room.

        ;; Helpers to bind specific items to rooms
        (tool-use-room ?tool -tool ?room -room); A tool is used in a specific room.
        (ingredient-prep-room ?ingredient - ingredient ?room - room); Ingredient must be prepared in a specific room.

        ;; Requirements between dishes and ingredients (define recipe)
        (ingredient-used-in-dish ?ingredient - ingredient ?dish - dish) ;; Link ingredient to a specific dish
        (require-prepared ?dish - dish ?ingredient - ingredient); The dish requires a prepared ingredient.
        (require-cooked ?dish - dish ?ingredient - ingredient); The dish requires a cooked ingredient.

        (is-free-ingredient ?ingredient - ingredient); The ingredient is free to use (not already used).
    )

    ; Actions

    ; The robot moves from its current room to an adjacent one.
    (:action move
        :parameters (?robot - robot ?from - room ?to - room)
        :precondition (and
            (at ?robot ?from)
            (adjacent ?from ?to)
        )
        :effect (and
            (at ?robot ?to)
            (not (at ?robot ?from))
        )
    )

    ;; The robot picks up a tool.
    (:action pick-up-tool
        :parameters (?robot - robot ?tool - tool ?room - room)
        :precondition (and
            (at ?robot ?room)
            (at ?tool ?room)
            (hand-free); Verify that the robot does not already hold something (limited to 1).
        )
        :effect (and
            (holding ?tool)
            (not (hand-free))
            (not (at ?tool ?room))
        )
    )

    ;; The robot picks up an ingredient.
    (:action pick-up-ingredient
        :parameters (?robot - robot ?ingredient - ingredient ?room - room)
        :precondition (and
            (at ?robot ?room)
            (at ?ingredient ?room)
            (hand-free); Verify that the robot does not already hold something (limited to 1).
            (is-free-ingredient ?ingredient)
        )
        :effect (and
            (holding ?ingredient)
            (not (hand-free))
        )
    )

    ;; The robot picks up a dish.
    (:action pick-up-dish
        :parameters (?robot - robot ?dish - dish ?room - room)
        :precondition (and
            (at ?robot ?room)
            (at ?dish ?room)
            (hand-free); Verify that the robot does not already hold something (limited to 1).
        )
        :effect (and
            (holding ?dish)
            (not (hand-free))
            (not (at ?dish ?room))
        )
    )

    ;; The robot drops a tool in its use room.
    (:action drop-tool
        :parameters (?robot - robot ?tool - tool ?room - room)
        :precondition (and
            (at ?robot ?room)
            (holding ?tool)
            (tool-use-room ?tool ?room)
        )
        :effect (and
            (not (holding ?tool))
            (hand-free)
            (at ?tool ?room)
        )
    )

    ;; The robot drops an ingredient in a room, which can only be the prep room of the ingredient or the preparation room.
    (:action drop-ingredient
        :parameters (?robot - robot ?ingredient - ingredient ?room - room)
        :precondition (and
            (at ?robot ?room)
            (holding ?ingredient)
            (or (ingredient-prep-room ?ingredient ?room) (is-preparation-room ?room))
        )
        :effect (and
            (not (holding ?ingredient))
            (hand-free)
            (at ?ingredient ?room)
        )
    )

    ;; The robot prepares an ingredient (e.g., cuts, mixes) in the appropriate room.
    (:action prepare-ingredient
        :parameters (?robot - robot ?ingredient - ingredient ?tool -tool ?room - room)
        :precondition (and
            (at ?robot ?room)
            (ingredient-prep-room ?ingredient ?room); The ingredient must be prepared in the specified room.
            (at ?ingredient ?room); The robot must hold the ingredient to prepare it.
            (holding ?tool)
            (tool-use-room ?tool ?room)
            (tool-clean ?tool)
            (is-free-ingredient ?ingredient)
            ;(not (ingredient-prepared ?ingredient)); The ingredient must not be already prepared.
        )
        :effect (and
            (ingredient-prepared ?ingredient)
            (not (tool-clean ?tool))
        )
    )

    ;; The robot cooks an ingredient in the cooking area.
    (:action cook-ingredient
        :parameters (?robot - robot ?ingredient - ingredient ?room - room)
        :precondition (and
            (is-cooking-room ?room)
            (at ?robot ?room)
            (is-free-ingredient ?ingredient)
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
            (at ?r ?room)
            (is-preparation-room ?room)
            ;; Precondition to ensure all ingredients are either prepared or cooked as required
            (forall
                (?ingredient - ingredient)
                (and
                    (imply
                        (and (ingredient-used-in-dish ?ingredient ?dish) (require-prepared ?dish ?ingredient))
                        (and (ingredient-prepared ?ingredient) (at ?ingredient ?room)))
                    (imply
                        (and (ingredient-used-in-dish ?ingredient ?dish) (require-cooked ?dish ?ingredient))
                        (and (ingredient-cooked ?ingredient) (at ?ingredient ?room)))
                    (is-free-ingredient ?ingredient)
                )
            )
        )
        :effect (and
            (dish-prepared ?dish)
            (at ?dish ?room)
        )
    )

    ;; The robot serves the finished dish in the serving area.
    (:action serve-dish
        :parameters (?robot - robot ?room - room ?dish - dish)
        :precondition (and
            (is-serving-room ?room)
            (at ?robot ?room)
            (holding ?dish)
            (dish-prepared ?dish)
            (forall
                (?other_dish - dish)
                (imply
                    (prioritize-dish ?other_dish ?dish)
                    (dish-served ?other_dish))
            )
        )
        :effect (and
            (dish-served ?dish)
            (forall
                (?ingredient - ingredient)
                (not (is-free-ingredient ?ingredient))
            )
        )
    )

    ;; The robot cleans a tool in the dishwashing area.
    (:action clean-tool
        :parameters (?robot -robot ?tool - tool ?room - room)
        :precondition (and
            (at ?robot ?room)
            (is-dishwashing-room ?room)
            (holding ?tool)
            (not (tool-clean ?tool))
        )
        :effect (and
            (tool-clean ?tool)
        )
    )
)