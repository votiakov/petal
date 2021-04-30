# Background Jobs

Background jobs and periodic jobs in Legendary are powered by [Oban](https://github.com/sorentwo/oban). See the Oban documentation for extensive information
on using Oban in your application, including:

- queue configuration
- worker configuration
- unique job constraints
- periodic jobs

The framework itself uses Oban for recurring tasks such as generating sitemaps.

Your app's Oban configuration is available in config/config.exs.
