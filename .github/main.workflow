workflow "EditorConfig Audit" {
  resolves = ["EditorConfig-Action"]
  on = "push"
}

action "EditorConfig-Action" {
  uses = "./"
  #  secrets = ["GITHUB_TOKEN"] # WIll be needed for fixing errors
  env = {
    EC_FIX_ERRORS = "false" # not yet implemented
    ALWAYS_LINT_ALL_FILES = "true"
  }
}

workflow "ShellCheck Linting" {
  on = "push"
  resolves = ["ShellCheck-Linter-Action"]
}

action "ShellCheck-Linter-Action" {
  uses = "zbeekman/ShellCheck-Linter-Action@master"
  env = {
    ALWAYS_LINT_ALL_FILES = "true" # current default
  }
}
