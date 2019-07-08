<div align="center">

# EditorConfig-Action

[![action on GH marketplace][marketplace badge]][marketplace] &nbsp;
[![gpg on keybase.io][keybase badge]][keybase] &nbsp;
[![GitHub release][release badge]][latest release] &nbsp;
[![package.json deps][npm dep badge]][eclint npm] &nbsp;
[![GitHub][LICENSE badge]][LICENSE]

</div>

:mag_right: A GitHub Action to check, enforce & fix [EditorConfig] style violations

<div align="center">

  [![blinking octocat][Blinky]][marketplace]
  ![squar-heart][sq heart]
  [![EditorConfig logo][EC logo]][EditorConfig]

</div>

<details><summary><b>Table of Contents</b></summary>
<p>

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [EditorConfig-Action](#editorconfig-action)
  - [What is EditorConfig?](#what-is-editorconfig)
  - [Using EditorConfig-Action with Your Project](#using-editorconfig-action-with-your-project)
  - [Example Workflows](#example-workflows)
    - [Check Conformance of Pushed Commits with `.editorconfig`](#check-conformance-of-pushed-commits-with-editorconfig)
  - [Features and Planed Features](#features-and-planed-features)
  - [EditorConfig Resources](#editorconfig-resources)
  - [Other GitHub Actions from @zbeekman](#other-github-actions-from-zbeekman)

<!-- markdown-toc end -->

</p>
</details>

## What is EditorConfig?

From the [EditorConfig website][EditorConfig]:
> EditorConfig helps maintain consistent coding styles for multiple developers working on the same project across
various editors and IDEs. The EditorConfig project consists of a file format for defining coding styles and a collection
of text editor plugins that enable editors to read the file format and adhere to defined styles. EditorConfig files are
easily readable and they work nicely with version control systems.

Checkout this project's `.editorconfig` file [here][`.editorconfig`]. However, to use this GitHub Action, your project
should define your own `.editorconfig`.

This project uses [eclint] by Jed Mao ([@jedmao]) to lint your project. [eclint] is also
released [under an MIT license].

## Using EditorConfig-Action with Your Project

Visit the [EditorConfig-Action GitHub Marketplace page][marketplace] to get started. Use a tagged release or the master
version of this GitHub action by creating your own `.github/main.workflow` file and adding a `on = "push"` and/or
`on = "pull_request"` `workflow` that `resolves` an `action` `uses = zbeekman/EditorConfig-Action[@ref]`.
Please see [the GitHub Actions documentation] for additional information.

## Example Workflows

### Check Conformance of Pushed Commits with [`.editorconfig`]

To ensure your repository does not violate your project's [`.editorconfig`] file, you may use the
following workflow:

```workflow
workflow "PR Audit" {
  on = "pull_request"
  resolves = ["EC Audit PR"]
}

action "EC Audit PR" {
  uses = "zbeekman/EditorConfig-Action@v1.1.0"
  # secrets = ["GITHUB_TOKEN"] # Will be needed for fixing errors
  env = {
    ALWAYS_LINT_ALL_FILES = "false" # This is the default
  }
}

workflow "Push Audit" {
  on = "push"
  resolves = ["EC Audit Push"]
}

action "EC Audit Push" {
  uses = "zbeekman/EditorConfig-Action@v1.1.0"
  # secrets = ["GITHUB_TOKEN"] # Will be needed for fixing errors
  env = {
    EC_FIX_ERROR = "false" # not yet implemented
    ALWAYS_LINT_ALL_FILES = "true" # Might be slow for large repos
  }
}
```

If you omit the  `ALWAYS_LINT_ALL_FILES` variable or it is set to `false` then only files changed in
the pushed commits will be linted. If you explicitly set this to `true` then every file in the
repository will be checked. Depending on the size of the repository, this may be a bad idea.

For protected branches, it is best to set the required action to be the one created with the `on = "pull_request"`,
e.g., `"EC Audit Push"` above, since PRs from forks will not trigger a local push event.

## Features and Planed Features

Features currently in development or being considered for addition include:

  - [x] Check only files touched by commits included in the current push
  - [x] Always check all files
  - [x] Pull Request linting (lint all files in pull request) and provide PR status
  - [ ] Automatically apply fixes using `eclint fix`
  - [ ] Ability to pass search patterns to `git ls-files` for enumerating files to check
  - [ ] Ability to override project `.editorconfig` or use without an `.editorconfig` via `eclint`'s property override
      flags
  - [ ] Pass patterns of files to ignore

## [EditorConfig] Resources

  - :book: [eclint] usage : https://github.com/jedmao/eclint#features
  - :earth_americas: [EditorConfig] website : https://editorconfig.org
  - :memo: [EditorConfig] wiki : https://github.com/editorconfig/editorconfig/wiki
  - :card_file_box: [EditorConfig] properties :
    https://github.com/editorconfig/editorconfig/wiki/EditorConfig-Properties
  - :thinking: [EditorConfig] FAQs : https://github.com/editorconfig/editorconfig/wiki/FAQ
  - :pencil2: [EditorConfig] with your editor : https://editorconfig.org/#download
  - :octocat: [EditorConfig] GitHub : https://github.com/editorconfig/editorconfig
  - :bird: [EditorConfig] on twitter : https://twitter.com/EditorConfig

## Other GitHub Actions from [@zbeekman]

  - [ShellCheck-Linter-Action]

---

<div align="center">

[![star badge][star badge]][star] &nbsp;
[![zbeekman gh profile][gh follow]][gh profile] &nbsp;
[![zbeekman on twitter][twitter badge]][twitter]

</div>

[EditorConfig]: https://editorconfig.org
[eclint]: https://github.com/jedmao/eclint
[@jedmao]: https://github.com/jedmao
[@zbeekman]: https://github.com/zbeekman
[under an MIT license]: https://github.com/jedmao/eclint/blob/master/LICENSE
[`.editorconfig`]: https://github.com/zbeekman/EditorConfig-Action/blob/master/.editorconfig
[ShellCheck-Linter-Action]: https://github.com/marketplace/actions/shellcheck-linter-action
[GitHub Actions documentation]: https://developer.github.com/actions/

<!--
Artwork & Images
-->
[Blinky]: https://github.com/zbeekman/EditorConfig-Action/raw/master/assets/ocdb.gif
[sq heart]: https://github.com/zbeekman/EditorConfig-Action/raw/master/assets/sqhr.png
[EC logo]: https://github.com/zbeekman/EditorConfig-Action/raw/master/assets/ecl.png

<!--
Badges and local links
-->
[marketplace badge]: https://img.shields.io/badge/GitHub-Marketplace-lightblue.svg
[marketplace]: https://github.com/marketplace/actions/editorconfig-action
[LICENSE badge]: https://img.shields.io/github/license/zbeekman/EditorConfig-Action.svg
[LICENSE]: https://github.com/zbeekman/EditorConfig-Action/blob/master/LICENSE
[release badge]: https://img.shields.io/github/release/zbeekman/EditorConfig-Action.svg
[latest release]: https://github.com/zbeekman/EditorConfig-Action/releases/latest
[npm dep badge]:
https://img.shields.io/github/package-json/dependency-version/zbeekman/EditorConfig-Action/eclint.svg
[eclint npm]: https://www.npmjs.com/package/eclint
[keybase badge]: https://img.shields.io/keybase/pgp/zbeekman.svg
[keybase]: https://keybase.io/zbeekman
[twitter badge]: https://img.shields.io/twitter/follow/zbeekman.svg?style=social
[twitter]: https://twitter.com/intent/follow?screen_name=zbeekman
[star badge]: https://img.shields.io/github/stars/zbeekman/EditorConfig-Action.svg?style=social
[star]: https://github.com/zbeekman/EditorConfig-Action
[gh follow]: https://img.shields.io/github/followers/zbeekman.svg?style=social
[gh profile]: https://github.com/zbeekman
