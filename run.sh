SECRETS_DIR=/run/secrets
PREFIX=ENV_

# Parse args
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    -p|--prefix)
    PREFIX="$2"
    shift
    shift
    ;;
    -d|--secrets-dir)
    SECRETS_DIR="$2"
    shift
    shift
    ;;
    *)  # unknown option
    shift
    ;;
  esac
done

PREFIX=${PREFIX^^}
PREFIX_LEN=${#PREFIX}

for file in "$SECRETS_DIR"/*
do
  filename=${file##*/}
  filename=${filename^^}

  if [ $PREFIX_LEN = 0 ] || [ $(echo $filename | cut -c1-$PREFIX_LEN) = $PREFIX ]
  then
    env_key=$filename
    if [ $PREFIX_LEN -ne 0 ]
    then
      ((PREFIX_LEN++))
      env_key=$(echo $filename | cut -c$PREFIX_LEN-${#filename})
    fi

    env_value=$(cat $file)

    echo "export $env_key=$env_value" >> .docker-secrets-env
    source ./docker-secrets-env
    rm .docker-secrets-env
  fi
done
