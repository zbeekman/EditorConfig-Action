workflow "EditorConfig-Action" {
  on = "push"
  resolves = ["EditorConfig Audit"]
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
  resolves = ["fearphage/shellcheck-action@0.0.1-debug6"]
  on = "push"
}

action "fearphage/shellcheck-action@0.0.1-debug6" {
  uses = "ludeeus/action-shellcheck@0.1.0"
}
