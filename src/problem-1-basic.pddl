(define (problem 1_basic)
    (:domain robot_chef)

    (:objects
        sa pa ca sva dwa cta mixa - location

        (:init
            ;; Initial room of the robot
            (robot-at ca)

            ;; Adjacency between rooms
            (adjacent sva ca)
            (adjacent ca sva)
            (adjacent ca dwa)
            (adjacent dwa ca)
            (adjacent pa dwa)
            (adjacent dwa pa)
            (adjacent pa ca)
            (adjacent ca pa)
            (adjacent mixa pa)
            (adjacent pa mixa)
            (adjacent mixa cta)
            (adjacent cta mixa)
            (adjacent sa mixa)
            (adjacent mixa sa)
            (adjacent cta sa)
            (adjacent sa cta)

        ) (:goal
            (and

            )
        )
    )