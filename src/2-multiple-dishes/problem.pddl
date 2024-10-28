(define (problem cook-meals)
    (:domain robot_chef)

    (:objects
        kitchen-storage kitchen-cutting kitchen-mixing kitchen-cooking kitchen-prep kitchen-serving kitchen-washing - location
        chef - robot
        knife spoon - tool
        rice fish vegetables noodles broth - ingredient
        sushi ramen - dish
    )

    (:init
        ; Robot initial location
        (robot-at chef kitchen-cooking)
        (hand-free chef)

        ; Kitchen layout
        (is-storage kitchen-storage)
        (is-cutting kitchen-cutting)
        (is-mixing kitchen-mixing)
        (is-cooking kitchen-cooking)
        (is-preparation kitchen-prep)
        (is-serving kitchen-serving)
        (is-dishwashing kitchen-washing)

        ; Room connections
        (connected kitchen-storage kitchen-mixing)
        (connected kitchen-mixing kitchen-storage)
        (connected kitchen-storage kitchen-cutting)
        (connected kitchen-cutting kitchen-storage)
        (connected kitchen-mixing kitchen-cutting)
        (connected kitchen-cutting kitchen-mixing)
        (connected kitchen-mixing kitchen-prep)
        (connected kitchen-prep kitchen-mixing)
        (connected kitchen-prep kitchen-cooking)
        (connected kitchen-cooking kitchen-prep)
        (connected kitchen-prep kitchen-washing)
        (connected kitchen-washing kitchen-prep)
        (connected kitchen-cooking kitchen-washing)
        (connected kitchen-washing kitchen-cooking)
        (connected kitchen-cooking kitchen-serving)
        (connected kitchen-serving kitchen-cooking)
        (connected kitchen-cutting kitchen-serving)
        (connected kitchen-serving kitchen-cutting)

        ; Initial ingredients location
        (item-at rice kitchen-storage)
        (item-at fish kitchen-storage)
        (item-at vegetables kitchen-storage)
        (item-at noodles kitchen-storage)
        (item-at broth kitchen-storage)

        ; Tools setup
        (item-at knife kitchen-cutting)
        (item-at spoon kitchen-mixing)
        (tool-clean knife)
        (tool-clean spoon)
        (is-cutting-tool knife)
        (is-mixing-tool spoon)

        ; Ingredient requirements
        (ingredient-need-mixing rice)
        (ingredient-need-cooking rice)
        (ingredient-need-cutting fish)
        (ingredient-need-cutting vegetables)
        (ingredient-need-mixing noodles)
        (ingredient-need-cooking noodles)
        (ingredient-need-mixing broth)
        (ingredient-need-cooking broth)

        ; Recipe definitions
        (ingredient-for rice sushi)
        (ingredient-for fish sushi)
        (ingredient-for vegetables sushi)
        (ingredient-for noodles ramen)
        (ingredient-for broth ramen)
        (ingredient-for vegetables ramen)
    )

    (:goal
        (and
            (dish-served sushi)
            (dish-served ramen)
        )
    )
)