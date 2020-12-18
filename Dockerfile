FROM elixir:1.8.0-alpine

RUN apk add make gcc libc-dev

ENV CC=gcc
ENV MIX_HOME=/opt/mix

RUN mix local.hex --force \
  && mix local.rebar --force

WORKDIR /root/app

ADD ./ /root/app/

EXPOSE 4000

ARG MIX_ENV=prod
RUN echo ${MIX_ENV}
ENV MIX_ENV=$MIX_ENV
ENV PORT=4000

RUN mix deps.get
RUN mix deps.compile
RUN MAKE=cmake mix compile
RUN mix phx.digest

CMD ["script/server"]
