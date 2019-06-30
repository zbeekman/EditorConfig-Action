workflow "EditorConfig-Action" {
  resolves = ["EditorConfig Audit"]
  on = "push"
}

action "EditorConfig Audit" {
  uses = "./"
  #  secrets = ["GITHUB_TOKEN"] # WIll be needed for fixing errors
  env = {
    EC_FIX_ERRORS = "false" # not yet implemented
    ALWAYS_LINT_ALL_FILES = "false"
  }
}

workflow "ShellCheck" {
  on = "push"
  resolves = ["Lint scripts with shellcheck"]
}

action "Lint scripts with shellcheck" {
  uses = "docker://koalaman/shellcheck-alpine:stable"
  runs = "./check-scripts.sh"
}
