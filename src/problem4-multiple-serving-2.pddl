(define (problem multiple_servings)
    (:domain robot_chef)

    (:objects
        storage-room cutting-room mixing-room cooking-room preparation-room serving-room dishwashing-room - room
        chef - robot
        knife spoon - tool
        rice fish vegetables noodles broth - ingredient
        sushi1 sushi2 ramen1 ramen2 ramen3 - dish
    )

    (:init
        ;; Initial robot state
        (at chef cooking-room)
        (hand-free)

        ;; Room types
        (is-storage-room storage-room)
        (is-cutting-room cutting-room)
        (is-mixing-room mixing-room)
        (is-cooking-room cooking-room)
        (is-preparation-room preparation-room)
        (is-serving-room serving-room)
        (is-dishwashing-room dishwashing-room)

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
        (adjacent storage-room cutting-room)

        ;; Tools setup
        (tool-use-room knife cutting-room)
        (tool-use-room spoon mixing-room)
        (at knife cutting-room)
        (at spoon mixing-room)
        (tool-clean knife)
        (tool-clean spoon)

        ;; Ingredient preparation requirements
        (ingredient-prep-room rice mixing-room)
        (ingredient-prep-room noodles mixing-room)
        (ingredient-prep-room broth mixing-room)

        ;; Fish and vegetables need cutting
        (ingredient-prep-room fish cutting-room)
        (ingredient-prep-room vegetables cutting-room)

        ;; Recipe definitions for sushi1
        (ingredient-used-in-dish rice sushi1)
        (ingredient-used-in-dish fish sushi1)
        (ingredient-used-in-dish vegetables sushi1)
        (require-cooked sushi1 rice)
        (require-prepared sushi1 fish)
        (require-prepared sushi1 vegetables)

        ;; Recipe definitions for sushi2
        (ingredient-used-in-dish rice sushi2)
        (ingredient-used-in-dish fish sushi2)
        (ingredient-used-in-dish vegetables sushi2)
        (require-cooked sushi2 rice)
        (require-prepared sushi2 fish)
        (require-prepared sushi2 vegetables)

        ;; Recipe definitions for ramen1
        (ingredient-used-in-dish noodles ramen1)
        (ingredient-used-in-dish broth ramen1)
        (ingredient-used-in-dish vegetables ramen1)
        (require-cooked ramen1 noodles)
        (require-cooked ramen1 broth)
        (require-prepared ramen1 vegetables)

        ;; Recipe definitions for ramen2
        (ingredient-used-in-dish noodles ramen2)
        (ingredient-used-in-dish broth ramen2)
        (ingredient-used-in-dish rice ramen2)
        (require-cooked ramen2 noodles)
        (require-cooked ramen2 broth)
        (require-cooked ramen2 rice)

        ;; Recipe definitions for ramen3
        (ingredient-used-in-dish noodles ramen3)
        (ingredient-used-in-dish broth ramen3)
        (require-cooked ramen3 noodles)
        (require-cooked ramen3 broth)

        ;; Dish priorities (ramen3 > sushi2 > ramen1 > sushi1 > ramen2)
        (prioritize-dish ramen3 sushi2)
        (prioritize-dish sushi2 ramen1)
        (prioritize-dish ramen1 sushi1)
        (prioritize-dish sushi1 ramen2)

        ;; Set initial dish to be prepared
        (next-dish ramen3)
    )

    (:goal
        (and
            (dish-served sushi1)
            (dish-served sushi2)
            (dish-served ramen1)
            (dish-served ramen2)
            (dish-served ramen3)
        )
    )
)