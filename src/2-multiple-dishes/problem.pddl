(define (problem multiple_dishes)
    (:domain robot_chef)

    (:objects
        storage-room cutting-room mixing-room cooking-room preparation-room serving-room dishwashing-room - location
        chef - robot
        knife spoon - tool
        rice fish vegetables noodles broth - ingredient
        sushi ramen - dish
    )

    (:init
        ; Robot initial location
        (robot-at chef cooking-room)
        (hand-free chef)

        ; Kitchen layout
        (is-storage storage-room)
        (is-cutting cutting-room)
        (is-mixing mixing-room)
        (is-cooking cooking-room)
        (is-preparation preparation-room)
        (is-serving serving-room)
        (is-dishwashing dishwashing-room)

        ; Initial ingredients location
        (item-at rice storage-room)
        (item-at fish storage-room)
        (item-at vegetables storage-room)
        (item-at noodles storage-room)
        (item-at broth storage-room)

        ; Tools setup
        (item-at knife cutting-room)
        (item-at spoon mixing-room)
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

        ; Room connections
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
    )

    (:goal
        (and
            (dish-served sushi)
            (dish-served ramen)
        )
    )
)