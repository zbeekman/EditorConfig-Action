<div align="center">

# EditorConfig-Action

[![action on GH marketplace][marketplace badge]][marketplace] |
[![gpg on keybase.io][keybase badge]][keybase] |
[![GitHub release][release badge]][latest release] |
[![package.json deps][npm dep badge]][eclint npm] |
[![GitHub][LICENSE badge]][LICENSE]

</div>

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

---

<div align="center">

[![star badge][star badge]][star] |
[![zbeekman gh profile][gh follow]][gh profile] |
[![zbeekman on twitter][twitter badge]][twitter]

</div>

[EditorConfig]: https://editorconfig.org
[eclint]: https://github.com/jedmao/eclint
[@jedmao]: https://github.com/jedmao
[under an MIT license]: https://github.com/jedmao/eclint/blob/master/LICENSE
[`.editorconfig`]: https://github.com/zbeekman/EditorConfig-Action/blob/master/.editorconfig

<!--
Badges and local links
-->
[marketplace badge]: https://img.shields.io/badge/GitHub-Marketplace-lightblue.svg
[marketplace]: https://github.com/marketplace/actions/editorconfig-action
[LICENSE badge]: https://img.shields.io/github/license/zbeekman/EditorConfig-Action.svg
[LICENSE]: https://github.com/zbeekman/EditorConfig-Action/blob/master/LICENSE
[release badge]: https://img.shields.io/github/release/zbeekman/EditorConfig-Action.svg
[latest release]: https://github.com/zbeekman/EditorConfig-Action/releases/latest
[npm dep badge]: https://img.shields.io/github/package-json/dependency-version/zbeekman/EditorConfig-Action/eclint.svg
[eclint npm]: https://www.npmjs.com/package/eclint
[keybase badge]: https://img.shields.io/keybase/pgp/zbeekman.svg
[keybase]: https://keybase.io/zbeekman
[twitter badge]: https://img.shields.io/twitter/follow/zbeekman.svg?style=social
[twitter]: https://twitter.com/intent/follow?screen_name=zbeekman
[star badge]: https://img.shields.io/github/stars/zbeekman/EditorConfig-Action.svg?style=social
[star]: https://github.com/zbeekman/EditorConfig-Action
[gh follow]: https://img.shields.io/github/followers/zbeekman.svg?style=social
[gh profile]: https://github.com/zbeekman
