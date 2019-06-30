FROM node:12-alpine

LABEL "com.github.actions.name"="EditorConfig Checker and Fixer"
LABEL "com.github.actions.description"="Check and/or fix pushed files against `.editorconfig` style specification"
LABEL "com.github.actions.icon"="eye"
LABEL "com.github.actions.color"="yellow"

LABEL "repository"="https://github.com/zbeekman/EditorConfig-Action"
LABEL "homepage"="https://github.com/zbeekman/EditorConfig-Action#README.md"
LABEL "maintainer"="Izaak \"Zaak\" Beekman <contact@izaakbeekman.com>"

RUN apk add --no-cache bash git jq ca-certificates
ENV NODE_MODULES_DIR "/node_module/s"
ENV PATH "${NODE_MODULES_DIR}/.bin:$PATH"
# COPY package.json package-lock.json ./
RUN npm install -g eclint@2.8.1 && \
	echo "eclint version: $(eclint --version)"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
