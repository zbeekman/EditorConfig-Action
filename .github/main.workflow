
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
