# Tasks and Scripts

Legendary follows the [scripts to rule them all pattern](https://github.com/github/scripts-to-rule-them-all). This allows any developers familiar with the pattern,
either from other Legendary projects, or from other projects that use the pattern,
to immediately pick up a project and get it running.

Here's a summary of the scripts you'll mostly use:

1. **bootstrap** installs all the dependencies needed to run the project.
2. **update** is used to update dependencies.
3. **server** runs the server.
4. **console** runs the interactive console.
5. **test** runs the test suite.

When you run server, console, or test, the script will make sure all the right
dependencies are in place (by running bootstrap or update). This means you can
go straight to running script/server and it should just work.

We encourage you to customize these scripts to the needs of your project as it grows. A developer should only _ever_ have to run script/server to run the server,
and should not need to remember anything beyond that. script/bootstrap should always install everything you need to set up the project from scratch. If you
find yourself updating setup steps in your project's README.md, consider how you
might automate away that setup in your scripts.
