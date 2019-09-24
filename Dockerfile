FROM node:12-alpine

LABEL "com.github.actions.name"="EditorConfig-Action"
LABEL "com.github.actions.description"="Check and/or fix pushed files against `.editorconfig` style specification"
LABEL "com.github.actions.icon"="eye"
LABEL "com.github.actions.color"="yellow"

LABEL "repository"="https://github.com/zbeekman/EditorConfig-Action"
LABEL "homepage"="https://github.com/zbeekman/EditorConfig-Action#README.md"
LABEL "maintainer"="Izaak \"Zaak\" Beekman <contact@izaakbeekman.com>"

RUN apk add --no-cache bash git jq ca-certificates
COPY package.json package-lock.json ./
RUN npm install --no-save . && \
	ln -s $(npm bin)/eclint /usr/local/bin && \
	echo "eclint version: $(eclint --version)"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
