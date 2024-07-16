FROM docker-docs-build AS build

RUN sed -i 's/enableGitInfo: true/enableGitInfo: false/g' hugo.yaml
RUN hugo --gc --minify -e staging -d /out -b /

ARG PAGEFIND_VERSION=1.1.0
RUN cp -a  /out ./public
RUN npx pagefind@v${PAGEFIND_VERSION} --output-path "/pagefind"

FROM python:3.11-alpine AS release
WORKDIR /app
COPY --from=build /out .
COPY --from=build /pagefind ./pagefind
EXPOSE 4000
ENTRYPOINT [ "python","-m","http.server","--bind","0.0.0.0","4000" ]