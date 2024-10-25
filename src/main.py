import os
from InquirerPy import prompt
import subprocess


def list_planners():
    return [
        # "optic", Does not support ADL
        # "downward", Does not support Fluents
        "delfi",
        # "ff", Does not support Fluents
        # "lama",
        "metric-ff",
        "dual-bfws-ffparser",
        "enhsp",
        "tfd",
    ]


def find_pddl_directories(src_path):
    directories = []
    for entry in os.scandir(src_path):
        if entry.is_dir():
            domain_path = os.path.join(entry.path, "domain.pddl")
            problem_path = os.path.join(entry.path, "problem.pddl")
            if os.path.isfile(domain_path) and os.path.isfile(problem_path):
                directories.append(entry.name)
    return directories


def run_planner(planner, domain_file, problem_file):
    command = f"planutils run {planner} {domain_file} {problem_file}"
    print(f"Executing command: {command}")

    try:
        result = subprocess.run(command, shell=True, text=True, capture_output=True)
        print("Command execution completed.")

        if result.stdout:
            print("Planner Output:")
            print("---------------")
            print(result.stdout)

        if result.stderr:
            print("Error/Debug Information:")
            print("------------------------")
            print(result.stderr)

        if result.returncode != 0:
            print(f"Execution failed with return code: {result.returncode}")

    except Exception as e:
        print(f"An error occurred when running the planner: {e}")


def main():
    src_path = "src"
    planners = list_planners()
    directories = find_pddl_directories(src_path)

    if not directories:
        print("No directories with PDDL files found in the src folder.")
        return

    questions = [
        {
            "type": "list",
            "name": "planner",
            "message": "Select a planner",
            "choices": planners,
        },
        {
            "type": "list",
            "name": "directory",
            "message": "Select a problem (directory containing domain.pddl and problem.pddl)",
            "choices": directories,
        },
    ]

    answers = prompt(questions)
    selected_planner = answers["planner"]
    selected_directory = answers["directory"]
    domain_file = os.path.join(src_path, selected_directory, "domain.pddl")
    problem_file = os.path.join(src_path, selected_directory, "problem.pddl")

    print(
        f"Running planner '{selected_planner}' on directory '{selected_directory}'..."
    )
    run_planner(selected_planner, domain_file, problem_file)


if __name__ == "__main__":
    main()
