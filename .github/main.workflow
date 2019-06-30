workflow "EditorConfig Audit" {
  resolves = ["EditorConfig-Action"]
  on = "push"
}

action "EditorConfig-Action" {
  uses = "./"
  #  secrets = ["GITHUB_TOKEN"] # WIll be needed for fixing errors
  env = {
    EC_FIX_ERRORS = "false" # not yet implemented
    ALWAYS_LINT_ALL_FILES = "false"
  }
}

workflow "ShellCheck Linting" {
  on = "push"
  resolves = ["ShellCheck-Lint-Action"]
}

action "ShellCheck-Lint-Action" {
  uses = "zbeekman/ShellCheck-Lint-Action@v1.0.1"
  env = {
    ALWAYS_LINT_ALL_FILES = "true" # current default
  }
}
