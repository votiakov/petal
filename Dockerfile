FROM elixir:1.8.0-alpine

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

ADD ./config /root/app/config
ADD ./mix.exs /root/app/
ADD ./mix.lock /root/app/
ADD ./apps/admin/mix.exs /root/app/apps/admin/
ADD ./apps/app/mix.exs /root/app/apps/app/
ADD ./apps/content/mix.exs /root/app/apps/content/
ADD ./apps/core/mix.exs /root/app/apps/core/
RUN mix deps.get
RUN mix deps.compile

ADD ./script /root/app/script
ADD ./apps /root/app/apps

RUN MAKE=cmake mix compile
RUN mix phx.digest

CMD ["script/server"]
