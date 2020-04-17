#!/usr/local/bin/zsh

if [ "$1" = "" ]; then
  echo 'Set the argument which means routing like users if you want.'
  grep="grep -e \"$1\""
else
  grep="grep -e 'Prefix' -e \"$1\""
fi

# format and display routes
docker-compose exec web bundle exec rails routes \
| eval ${grep} \
| sed -e 's/(.:format)//g' \
| awk -F'Verb|GET|POST|PUT|PATCH|DELETE' '{if(match($1, /^ *$/)){printf "\* %s\n", $0;} else print}' \
| awk '{printf "%-30s %-10s %-50s %-40s\n", $1, $2, $3, $4}'
