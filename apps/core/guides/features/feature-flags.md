# Feature Flags

Legendary comes with [Fun with Flags](https://github.com/tompave/fun_with_flags)
preconfigured for managing [feature flags](https://en.wikipedia.org/wiki/Feature_toggle).
This allows you to have more granular control over which users see which features
and when. For example, you can hide a feature which is not complete, or show it
to only a select group of testers.


Fun With Flags supports a variety of different feature gate types. From
the Fun With Flags docs:

* **Boolean**: globally on and off.
* **Actors**: on or off for specific structs or data. The `FunWithFlags.Actor` protocol can be implemented for types and structs that should have specific rules. For example, in web applications it's common to use a `%User{}` struct or equivalent as an actor, or perhaps the current country of the request.
* **Groups**: on or off for structs or data that belong to a category or satisfy a condition. The `FunWithFlags.Group` protocol can be implemented for types and structs that belong to groups for which a feature flag can be enabled or disabled. For example, one could implement the protocol for a `%User{}` struct to identify administrators.
* **%-of-Time**: globally on for a percentage of the time. It ignores actors and groups. Mutually exclusive with the %-of-actors gate.
* **%-of-Actors**: globally on for a percentage of the actors. It only applies when the flag is checked with a specific actor and is ignored when the flag is checked without actor arguments. Mutually exclusive with the %-of-time gate.

Since feature flags may be checked often (sometimes multiple times per request),
Fun With Flags uses a two-layer approach. Flags are cached in [ETS](https://erlang.org/doc/man/ets.html)
and also persisted to longer-term storage so that they are not lost when the app
restarts.

By default, Legendary caches the flags for five minutes. We use Ecto for
persistence. We also use Phoenix PubSub to inform application nodes when a flag
has been updated. This configuration is a sensible default that we would not
expect you to need to change in most cases.

## UI

We integrate the Fun With Flags UI for managing flags. You can reach it through
a link in the admin.
