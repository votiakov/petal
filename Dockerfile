FROM elixir:1.10.4-alpine AS elixir1

RUN apk add make gcc libc-dev

ENV CC=gcc
ENV MIX_HOME=/opt/mix

RUN mix local.hex --force \
  && mix local.rebar --force

EXPOSE 4000

ARG MIX_ENV=prod
RUN echo ${MIX_ENV}
ENV MIX_ENV=$MIX_ENV
ENV PORT=4000

WORKDIR /root/app

# We load these things one by one so that we can load the deps first and
#   cache those layers, before we do the app build itself
ADD ./config /root/app/config
ADD ./mix.exs /root/app/
ADD ./mix.lock /root/app/
ADD ./apps/admin/mix.exs /root/app/apps/admin/
ADD ./apps/app/mix.exs /root/app/apps/app/
ADD ./apps/content/mix.exs /root/app/apps/content/
ADD ./apps/core/mix.exs /root/app/apps/core/
ADD ./_build/ /root/app/_build/
ADD ./deps/ /root/app/deps/
RUN script/restore-timestamps
RUN mix deps.get
RUN mix deps.compile

# Leave off here so that we can built assets and compile the elixir app in parallel

FROM node:15.0

# Build assets in a node container
ADD ./apps/app/assets/ /root/app/apps/app/assets/

WORKDIR /root/app/apps/app/assets/
COPY --from=0 /root/app/ /root/app/
RUN npm install
RUN npm run deploy

FROM elixir1

ADD ./apps /root/app/apps

# Resume compilation of the elixir app
ADD ./script /root/app/script
RUN MAKE=cmake mix compile

# Copy in the built assets & fingerprint them
COPY --from=1 /root/app/apps/app/priv/static/ /root/app/apps/app/priv/static
RUN mix phx.digest

RUN script/restore-timestamps

CMD ["mix", "phx.server"]
