FROM node:12-alpine

LABEL "com.github.actions.name"="EditorConfig Checker and Fixer"
LABEL "com.github.actions.description"="Check and/or fix pushed files against `.editorconfig` style specification"
LABEL "com.github.actions.icon"="eye"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/zbeekman/EditorConfig-Action"
LABEL "homepage"="https://github.com/zbeekman/EditorConfig-Action#README.md"
LABEL "maintainer"="Izaak \"Zaak\" Beekman <contact@izaakbeekman.com>"

RUN apk add --no-cache bash git jq yarn && yarn --version
ENV NODE_MODULES_DIR "${HOME}/node_modules"
ENV PATH "${HOME}/node_modules/.bin:$PATH"
	COPY package.json yarn.lock ./
RUN yarn install --non-interactive --frozen-lockfile --audit && \
	echo "eclint version: $(eclint --version)"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
