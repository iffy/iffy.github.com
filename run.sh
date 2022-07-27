#!/bin/sh

set -e
docker build -t jekyll .
docker run -v "$(pwd):/src/site" -w /src/site -p 4000:4000 --env "JEKYLL_ENV=$JEKYLL_ENV" jekyll jekyll serve --host 0.0.0.0
# docker run -it -v "$(pwd):/src/site" -w /src/site -p 4000:4000 jekyll /bin/sh