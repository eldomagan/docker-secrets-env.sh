# Docker Secrets As Env

A shell script to export some docker secrets as environment variables

## Installation

```shell
git clone https://github.com/eldomagan/docker-secrets-env.sh.git
```

## Usage

```shell
source ./docker-secrets-as-env.sh [options]
```

**Options**

-p, --prefix prefix of secrets to exports, defaults to ENV_
-d, --secrets-dir docker secrets dir, defaults to /run/secrets

The prefix is removed from exported var and secrets names are uppercased

Exemple:
if i have the following secrets

/run/secrets/env_my_secret
/run/secrets/ENV_another_secret
/run/secrets/wont_be_exported

Exported env will be:

MY_SECRET
ANOTHER_SECRET

You can test by running

```shell
source ./docker-secrets-as-env.sh --secrets-dir ./tests/secrets && ./tests/test.sh
```

If you want to export all secrets as env, use an empty prefix like that

```shell
source ./docker-secrets-as-env.sh --secrets-dir ./tests/secrets --prefix && ./tests/test.sh
```

## Usage in docker-compose

```yaml
version: "3"

services:
  some_service:
    build: .
    secrets:
      - env_my_docker_secret
      - ENV_RANDOM_PRIVATE_KEY
    command: source ./docker-secrets-as-env.sh && entrypoint.sh
```