(define (problem basic)
    (:domain robot_chef)

    (:objects
        storage-room preparation-room cooking-room serving-room dishwashing-room cutting-room mixing-room - room
        sushi - dish
        knife spoon - tool
        rice fish vegetable - ingredient
        chef - robot
    )

    (:init
        ;; Initial room of the robot
        (at chef cooking-room)
        (hand-free)

        ;; Ingredients in the storage
        (at rice storage-room)
        (at fish storage-room)
        (at vegetable storage-room)

        ;; Fluent ingredient quantities
        (is-free-ingredient fish)
        (is-free-ingredient rice)
        (is-free-ingredient vegetable)

        ;; Bind ingredients to specific prep/cooking room
        (ingredient-prep-room rice mixing-room); Rice must be prepared in Mixing room
        (ingredient-prep-room fish cutting-room); Fish must be cut in Cutting room
        (ingredient-prep-room vegetable cutting-room); Vegetables must be cut in Cutting room

        ;; Bind dishes to ingredients
        (ingredient-used-in-dish rice sushi)
        (ingredient-used-in-dish fish sushi)
        (ingredient-used-in-dish vegetable sushi)

        ;; Define dish requirements for its ingredient
        (require-prepared sushi vegetable)
        (require-prepared sushi fish)
        (require-cooked sushi rice)

        ;; Set each room with a predicate
        (is-storage-room storage-room)
        (is-preparation-room preparation-room)
        (is-cooking-room cooking-room)
        (is-serving-room serving-room)
        (is-dishwashing-room dishwashing-room)
        (is-cutting-room cutting-room)
        (is-mixing-room mixing-room)

        ;; Tool setup
        (tool-use-room knife cutting-room)
        (tool-use-room spoon mixing-room)
        (at knife cutting-room)
        (at spoon mixing-room)
        (tool-clean knife)
        (tool-clean spoon)

        ;; Adjacency between rooms
        (adjacent serving-room cooking-room)
        (adjacent cooking-room serving-room)
        (adjacent cooking-room dishwashing-room)
        (adjacent dishwashing-room cooking-room)
        (adjacent preparation-room dishwashing-room)
        (adjacent dishwashing-room preparation-room)
        (adjacent preparation-room cooking-room)
        (adjacent cooking-room preparation-room)
        (adjacent mixing-room preparation-room)
        (adjacent preparation-room mixing-room)
        (adjacent mixing-room cutting-room)
        (adjacent cutting-room mixing-room)
        (adjacent storage-room mixing-room)
        (adjacent mixing-room storage-room)
        (adjacent cutting-room storage-room)
        (adjacent serving-room cutting-room)

    )

    (:goal
        (and
            (dish-served sushi)
        )

    )
)