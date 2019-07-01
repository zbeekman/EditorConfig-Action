workflow "EditorConfig Audit" {
  resolves = ["EditorConfig-Action"]
  on = "push"
}

workflow "EditorConfig PR Audit" {
  resolves = ["EditorConfig-Action"]
  on = "pull_request"
}

action "EditorConfig-Action" {
  uses = "./"
  secrets = ["GITHUB_TOKEN"]
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
