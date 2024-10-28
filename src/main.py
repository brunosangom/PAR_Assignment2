import os
import subprocess
from InquirerPy import prompt


def list_planners():
    return [
        "dual-bfws-ffparser",
        "ff",
        "downward",
        # TODO: other planners
    ]


def find_pddl_problems(src_path):
    problems = []
    for entry in os.scandir(src_path):
        if entry.is_dir():
            problem_path = os.path.join(entry.path, "problem.pddl")
            if os.path.isfile(problem_path):
                problems.append(entry.name)
    return problems


def run_planner(planner, domain_file, problem_file, output_file):

    if planner == "enhsp":
        command = ["planutils", "run", planner, "-o", domain_file, "-f", problem_file]
    else:
        command = ["planutils", "run", planner, domain_file, problem_file]

    try:
        with open(output_file, "w") as f:
            result = subprocess.run(command, text=True, capture_output=True)
            f.write("Command execution completed.\n\n")

            if result.stdout:
                f.write("Planner Output:\n")
                f.write("---------------\n")
                f.write(result.stdout)
                f.write("\n")

            if result.stderr:
                f.write("Error/Debug Information:\n")
                f.write("------------------------\n")
                f.write(result.stderr)
                f.write("\n")

            if result.returncode != 0:
                f.write(f"Execution failed with return code: {result.returncode}\n")

        print(f"Planner output saved to {output_file}")

    except Exception as e:
        print(f"An error occurred when running the planner: {e}")


def main():
    src_path = os.path.dirname(os.path.abspath(__file__))
    planners = list_planners()
    problems = find_pddl_problems(src_path)

    if not problems:
        print("No directories with problem.pddl files found in the src folder.")
        return

    problems.sort(reverse=False)

    questions = [
        {
            "type": "list",
            "name": "planner",
            "message": "Select a planner",
            "choices": planners,
        },
        {
            "type": "list",
            "name": "problem",
            "message": "Select a problem (directory containing problem.pddl)",
            "choices": problems,
        },
    ]

    answers = prompt(questions)
    selected_planner = answers["planner"]
    selected_problem = answers["problem"]
    domain_file = os.path.join(src_path, "domain.pddl")
    problem_file = os.path.join(src_path, selected_problem, "problem.pddl")
    output_file = os.path.join(
        src_path, selected_problem, f"{selected_planner}_output.txt"
    )
    output_file = os.path.join(
        src_path, selected_problem, f"{selected_planner}_output.txt"
    )

    print(f"Running planner '{selected_planner}' on problem '{selected_problem}'...")
    run_planner(selected_planner, domain_file, problem_file, output_file)


if __name__ == "__main__":
    main()
