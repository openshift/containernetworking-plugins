#!/bin/bash
if [[ $(pwd) == *images ]]; then 
  echo "you should run this from the clone's root";
  exit 1;
fi

rsync -av --progress . ./images/supported/ --exclude images
rsync -av --progress . ./images/unsupported/ --exclude images