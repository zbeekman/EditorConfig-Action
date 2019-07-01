# EditorConfig-Action

GitHub Action for checking, enforcing and fixing [EditorConfig] style constraints

Currently, this project uses [eclint] by Jed Mao ([@jedmao]) to lint your project. [eclint] is also
released [under an MIT license].

## Example Workflows

### Check Conformance of Pushed Commits with [`.editorconfig`]

To ensure your repository does not violate your project's [`.editorconfig`] file, you may use the
following workflow:

```workflow
workflow "EditorConfig Audit" {
  on = "push"
  resolves = ["EditorConfig-Action"]
}

action "EditorConfig-Action" {
  uses = "zbeekman/EditorConfig-Action@v1.0.0"
  # secrets = ["GITHUB_TOKEN"] # Will be needed for fixing errors
  env = {
    EC_FIX_ERROR = "false" # not yet implemented
    ALWAYS_LINT_ALL_FILES = "false" # This is the default
  }
}
```

If you omit the  `ALWAYS_LINT_ALL_FILES` variable or it is set to `false` then only files changed in
the pushed commits will be linted. If you explicitly set this to `true` then every file in the
repository will be checked. Depending on the size of the repository, this may be a bad idea.

## Future Plans

I plan to implement an option to apply EditorConfig fixes automatically in the future. This will
require opening a pull request on behalf of the user if the branch is protected, or pushing to an
unprotected branch on behalf of the user, if given permission.


[EditorConfig]: https://editorconfig.org
[eclint]: https://github.com/jedmao/eclint
[@jedmao]: https://github.com/jedmao
[under an MIT license]: https://github.com/jedmao/eclint/blob/master/LICENSE
[`.editorconfig`]: https://github.com/zbeekman/EditorConfig-Action/blob/master/.editorconfig
