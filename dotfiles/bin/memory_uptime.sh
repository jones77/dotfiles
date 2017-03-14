#!/usr/bin/env bash
# echo memory and uptime numbers, useful in .tmux.conf status-right

# eg 361M / 7.6G used, 6.5G free
mem=$(free -h -t -w | head -2 | tail -1 \
    | awk '{ print $3 "(" $NF ")/" $2 }'
)

echo "$mem," $(
    uptime | sed -e 's/,//g' -e 's/.*: //'
)
