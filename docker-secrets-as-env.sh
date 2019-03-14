SECRETS_DIR=/run/secrets
PREFIX=ENV_

# Parse args
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

PREFIX=$(printf $PREFIX | tr [a-z] [A-Z])
PREFIX_LEN=$(printf $PREFIX | wc -m)

for file in "$SECRETS_DIR"/*
do
  filename=${file##*/}
  filename=$(printf $filename | tr [a-z] [A-Z])

  if [ $PREFIX_LEN = 0 ] || [ $(echo $filename | cut -c1-$PREFIX_LEN) = $PREFIX ]
  then
    env_key=$filename
    if [ $PREFIX_LEN -ne 0 ]
    then
      env_key=$(echo $filename | cut -c$((PREFIX_LEN+1))-$(printf $filename | wc -m))
    fi

    env_value=$(cat $file)

    export $env_key="${env_value}"
  fi
done
