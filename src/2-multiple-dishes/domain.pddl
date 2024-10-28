(define (domain robot_chef)
    (:requirements :strips :typing :negative-preconditions :disjunctive-preconditions)

    (:types
        location - object
        item - object
        robot - object
        ingredient tool dish - item
    )

    (:predicates
        (robot-at ?r - robot ?l - location)
        (item-at ?i - item ?l - location)
        (holding ?r - robot ?i - item)
        (hand-free ?r - robot)
        (connected ?l1 ?l2 - location)

        (is-storage ?l - location)
        (is-cooking ?l - location)
        (is-serving ?l - location)
        (is-preparation ?l - location)
        (is-dishwashing ?l - location)
        (is-cutting ?l - location)
        (is-mixing ?l - location)

        (ingredient-need-mixing ?i - ingredient)
        (ingredient-need-cutting ?i - ingredient)
        (ingredient-need-cooking ?i - ingredient)

        (ingredient-mixed ?i - ingredient)
        (ingredient-cut ?i - ingredient)
        (ingredient-cooked ?i - ingredient)

        (tool-clean ?t - tool)
        (is-cutting-tool ?t - tool)
        (is-mixing-tool ?t - tool)

        (ingredient-for ?i - ingredient ?d - dish)
        (dish-ready ?d - dish)
        (dish-served ?d - dish)
    )

    (:action move
        :parameters (?r - robot ?from ?to - location)
        :precondition (and
            (robot-at ?r ?from)
            (connected ?from ?to)
        )
        :effect (and
            (not (robot-at ?r ?from))
            (robot-at ?r ?to)
        )
    )

    (:action pick-up
        :parameters (?r - robot ?i - item ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (item-at ?i ?l)
            (hand-free ?r)
        )
        :effect (and
            (not (item-at ?i ?l))
            (not (hand-free ?r))
            (holding ?r ?i)
        )
    )

    (:action put-down
        :parameters (?r - robot ?i - item ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (holding ?r ?i)
        )
        :effect (and
            (item-at ?i ?l)
            (hand-free ?r)
            (not (holding ?r ?i))
        )
    )

    (:action cut-ingredient
        :parameters (?r - robot ?i - ingredient ?t - tool ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (is-cutting ?l)
            (holding ?r ?t)
            (is-cutting-tool ?t)
            (tool-clean ?t)
            (item-at ?i ?l)
            (ingredient-need-cutting ?i)
        )
        :effect (and
            (ingredient-cut ?i)
            (not (tool-clean ?t))
        )
    )

    (:action mix-ingredient
        :parameters (?r - robot ?i - ingredient ?t - tool ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (is-mixing ?l)
            (holding ?r ?t)
            (is-mixing-tool ?t)
            (tool-clean ?t)
            (item-at ?i ?l)
            (ingredient-need-mixing ?i)
        )
        :effect (and
            (ingredient-mixed ?i)
            (not (tool-clean ?t))
        )
    )

    (:action cook-ingredient
        :parameters (?r - robot ?i - ingredient ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (is-cooking ?l)
            (item-at ?i ?l)
            (ingredient-need-cooking ?i)
        )
        :effect (ingredient-cooked ?i)
    )

    (:action clean-tool
        :parameters (?r - robot ?t - tool ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (is-dishwashing ?l)
            (holding ?r ?t)
            (not (tool-clean ?t))
        )
        :effect (tool-clean ?t)
    )

    (:action prepare-dish
        :parameters (?r - robot ?d - dish ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (is-preparation ?l)
            (forall
                (?i - ingredient)
                (imply
                    (ingredient-for ?i ?d)
                    (and
                        (item-at ?i ?l)
                        (or (not (ingredient-need-cutting ?i)) (ingredient-cut ?i))
                        (or (not (ingredient-need-mixing ?i)) (ingredient-mixed ?i))
                        (or (not (ingredient-need-cooking ?i)) (ingredient-cooked ?i))
                    )
                )
            )
        )
        :effect (dish-ready ?d)
    )

    (:action serve-dish
        :parameters (?r - robot ?d - dish ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (is-serving ?l)
            (dish-ready ?d)
        )
        :effect (dish-served ?d)
    )
)