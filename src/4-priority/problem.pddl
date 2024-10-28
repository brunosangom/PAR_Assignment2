(define (problem multiple_servings)
    (:domain robot_chef)

    (:objects
        storage-room cutting-room mixing-room cooking-room preparation-room serving-room dishwashing-room - location
        chef - robot
        knife spoon - tool
        rice1 rice2 rice3 fish1 fish2 vegetables1 vegetables2 vegetables3 noodles1 noodles2 noodles3 broth1 broth2 broth3 - ingredient
        sushi1 sushi2 ramen1 ramen2 ramen3 - dish
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
        (adjacent storage-room cutting-room) ; Added reverse direction
        (adjacent serving-room cutting-room)
        (adjacent cutting-room serving-room) ; Added reverse direction

        ; Initial ingredients location
        (item-at rice1 storage-room)
        (item-at rice2 storage-room)
        (item-at rice3 storage-room)
        (item-at fish1 storage-room)
        (item-at fish2 storage-room)
        (item-at vegetables1 storage-room)
        (item-at vegetables2 storage-room)
        (item-at vegetables3 storage-room)
        (item-at noodles1 storage-room)
        (item-at noodles2 storage-room)
        (item-at noodles3 storage-room)
        (item-at broth1 storage-room)
        (item-at broth2 storage-room)
        (item-at broth3 storage-room)

        ; Tools setup
        (item-at knife cutting-room)
        (item-at spoon mixing-room)
        (tool-clean knife)
        (tool-clean spoon)
        (is-cutting-tool knife)
        (is-mixing-tool spoon)

        ; Ingredient requirements for rice
        (ingredient-need-mixing rice1)
        (ingredient-need-cooking rice1)
        (ingredient-need-mixing rice2)
        (ingredient-need-cooking rice2)
        (ingredient-need-mixing rice3)
        (ingredient-need-cooking rice3)

        ; Ingredient requirements for fish
        (ingredient-need-cutting fish1)
        (ingredient-need-cutting fish2)

        ; Ingredient requirements for vegetables
        (ingredient-need-cutting vegetables1)
        (ingredient-need-cutting vegetables2)
        (ingredient-need-cutting vegetables3)

        ; Ingredient requirements for noodles
        (ingredient-need-mixing noodles1)
        (ingredient-need-cooking noodles1)
        (ingredient-need-mixing noodles2)
        (ingredient-need-cooking noodles2)
        (ingredient-need-mixing noodles3)
        (ingredient-need-cooking noodles3)

        ; Ingredient requirements for broth
        (ingredient-need-mixing broth1)
        (ingredient-need-cooking broth1)
        (ingredient-need-mixing broth2)
        (ingredient-need-cooking broth2)
        (ingredient-need-mixing broth3)
        (ingredient-need-cooking broth3)

        ; Recipes
        (ingredient-for rice1 sushi1)
        (ingredient-for fish1 sushi1)
        (ingredient-for vegetables1 sushi1)

        (ingredient-for rice2 sushi2)
        (ingredient-for fish2 sushi2)
        (ingredient-for vegetables2 sushi2)

        (ingredient-for noodles1 ramen1)
        (ingredient-for broth1 ramen1)
        (ingredient-for vegetables3 ramen1)

        (ingredient-for noodles2 ramen2)
        (ingredient-for broth2 ramen2)
        (ingredient-for rice3 ramen2)

        (ingredient-for noodles3 ramen3)
        (ingredient-for broth3 ramen3)

        ; Dish serving priorities (added from priority problem)
        (has-priority-over sushi1 sushi2)
        (has-priority-over sushi1 ramen1)
        (has-priority-over ramen1 ramen2)
        (has-priority-over ramen2 ramen3)
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