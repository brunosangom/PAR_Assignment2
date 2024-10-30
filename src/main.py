import os
import subprocess


def run_planner(domain_file, problem_file, output_file):
    command = ["planutils", "run", "dual-bfws-ffparser", domain_file, problem_file]

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
    domain_file = os.path.join(src_path, "domain.pddl")

    # Find all problem files
    problem_files = [
        f
        for f in os.listdir(src_path)
        if f.startswith("problem") and f.endswith(".pddl")
    ]

    if not problem_files:
        print("No problem files found in the src folder.")
        return

    for problem_file in problem_files:
        problem_path = os.path.join(src_path, problem_file)
        output_file = os.path.join(
            src_path, f"{problem_file[:-5]}_dual-bfws-ffparser_output.txt"
        )

        print(f"Running dual-bfws-ffparser on {problem_file}...")
        run_planner(domain_file, problem_path, output_file)


if __name__ == "__main__":
    main()
