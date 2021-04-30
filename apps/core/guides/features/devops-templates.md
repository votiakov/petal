# DevOps Templates

Legendary includes a full set of DevOps templates designed to make it easy to
test, build, and deploy your app.

# Overview

The setup we provide is an opinionated setup based on years of experience building
Phoenix applications and deploying them at scale. It's meant to be efficient and
easy for small teams while scaling to big teams. It's meant to be lean enough
for low-traffic apps while scaling quite well to apps receiving thousands of
requests a second.

Here's the process overview:

1. You make commits using [conventional commit messages](https://www.conventionalcommits.org/).
2. The CI runs tests and builds a Docker image unique to your latest commit.
3. Should your tests pass, that Docker image is labeled with a [semantic version](https://semver.org/)
driven by your commit messages. We also tag that commit with that version so that
you can refer to it. You never need to manually tag Docker image or a commit, so
long as you follow the commit message convention.
4. You can deploy that Docker image to Kubernetes, or any other Docker-friendly hosting environment.
    - CI generates a Kubernetes manifest pointing at that new docker image. You can
      apply that manifest to your cluster manually, or use a tool like flux2 to
      automate that.
    - If you don't use Kubernetes, you can tell your Docker-ized host to pull the new image in the method provided by that host.

# CI Configuration

Legendary comes with GitLab CI settings which should work for you with minimal
setup. This config is located in .gitlab-ci.yml.

The CI script will automatically tag successful builds. To do this, you will
need to configure a [CI variable](https://docs.gitlab.com/ee/ci/variables/) named
`GITLAB_TOKEN`. This token should be a
[personal access token](https://gitlab.com/-/profile/personal_access_tokens) with
`read_repository, write_repository` permissions.

This CI configuration provides a few nice features:

- Parallel build steps. The tests run while the Docker image builds, so you don't
have to wait for one then the other.
- Fast Docker build configuration. We use Docker BuildKit and a heavily tuned Dockerfile to reduce builld times from 15+ minutes to ~3 minutes.
- Fast Elixir compile times. Out of the box, Elixir compilation can be quite
slow in CI. We employ a few tricks to reduce the compilation time by over 75%
over default CI configuration.
- Automated semantic versioning. So long as you use conventional commit messages,
we will automatically bump the version number appropriately.

# Kubernetes Manifests

We also automatically generate a Kubernetes manifest for your app on each successful build. The generate manifest is commited back to your repo at infrastructure/. You can use a tool like flux2 to automatically update the configuration in your Kubernetes cluster from there. Or you could manually apply
it whenever you choose.

The template used to generate the manifest is located in infrastructure_templates. Feel free to customize it if your application needs different Kubernetes config.
