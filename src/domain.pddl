(define (domain robot_cheff
        (:requirements :strips :typing :fluents)

        (:types
            robot room item ingredient tool dish
        )

        (:predicates
            ; Basic predicates
            (robot-at ?r - robot ?room - room); The robot is in a specific room.
            (ingredient-at ?ingredient - ingredient ?room - room); An ingredient is in a specific room.
            (tool-at ?tool - tool ?room - room); A tool is in a specific room.
            (tool-clean ?tool - tool); A tool is clean.
            (holding ?item - item); The robot is holding an item.
            (dish-prepared ?dish - dish); The dish is fully prepared

            (adjacent ?room1 - room ?room2 - room); The rooms are adjacent.
        )

        ; Actions

        ; Action: Move the robot between rooms
        (:action move
            :parameters (?r - robot ?from - room ?to - room)
            :precondition (and
                (at ?robot ?from)
                (adjacent ?from ?to)
            )
            :effect (and
                (at ?r ?to)
                (not (at ?r ?from))
            )
        )

        ; Action: Pick up an ingredient from the storage
        ; (:action pick-up-ingredient
        ;     :parameters (?r - robot ?i - ingredient ?storage - room)
        ;     :precondition (and (robot-at ?r ?storage) (not (holding ?r ?i)))
        ;     :effect (holding ?r ?i)
        ; )

        ; Action: Prepare an ingredient (e.g., cut, mix)
        ; (:action prepare-ingredient
        ;     :parameters (?r - robot ?i - ingredient ?prep-area - room)
        ;     :precondition (and (robot-at ?r ?prep-area) (holding ?r ?i))
        ;     :effect (ingredient-prepared ?i)
        ; )

        ; Action: Cook an ingredient
        ; (:action cook-ingredient
        ;     :parameters (?r - robot ?i - ingredient ?cooking-area - room)
        ;     :precondition (and (robot-at ?r ?cooking-area) (ingredient-prepared ?i) (holding ?r ?i))
        ;     :effect (ingredient-cooked ?i)
        ; )

        ; Action: Assemble a dish
        ; (:action assemble-dish
        ;     :parameters (?r - robot ?d - dish ?prep-area - room)
        ;     :precondition (and (robot-at ?r ?prep-area) (ingredient-cooked ?d))
        ;     :effect (dish-assembled ?d)
        ; )

        ; Action: Plate the dish
        ; (:action plate-dish
        ;     :parameters (?r - robot ?d - dish ?serving-area - room)
        ;     :precondition (and (robot-at ?r ?serving-area) (dish-assembled ?d))
        ;     :effect (dish-plated ?d)
        ; )

        ; Action: Clean a tool
        ; (:action clean-tool
        ;     :parameters (?r - robot ?t - tool ?washing-area - room)
        ;     :precondition (and (robot-at ?r ?washing-area) (not (tool-clean ?t)))
        ;     :effect (tool-clean ?t)
        ; )
    )