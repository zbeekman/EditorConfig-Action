FROM node:koalaman/shellcheck-alpine:stable

LABEL "com.github.actions.name"="ShellCheck-Linter"
LABEL "com.github.actions.description"="Lint all scripts in the current project with ShellCheck"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="yellow"

LABEL "repository"="https://github.com/zbeekman/EditorConfig-Action"
LABEL "homepage"="https://github.com/zbeekman/EditorConfig-Action#README.md"
LABEL "maintainer"="Izaak \"Zaak\" Beekman <contact@izaakbeekman.com>"

RUN apk add --no-cache bash git jq ca-certificates

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
