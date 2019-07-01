workflow "EditorConfig Audit" {
  resolves = ["EditorConfig-Action"]
  on = "push"
}

action "EditorConfig-Action" {
  uses = "./"
  env = {
    EC_FIX_ERRORS = "false" # not yet implemented
    ALWAYS_LINT_ALL_FILES = "true"
  }
}

workflow "EditorConfig PR" {
  resolves = ["EditorConfig Audit PR"]
  on = "pull_request"
}

action "EditorConfig Audit PR" {
  uses = "./"
  env = {
    ALWAYS_LINT_ALL_FILES = "false"
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
