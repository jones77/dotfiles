#!/usr/bin/env bash
# echo memory and uptime numbers, useful in .tmux.conf status-right

# BYTES
# eg 4625653760 3578519552 8369909760
set $( free -b -t -w | head -2 | tail -1 \
    | awk '{ print $3 " " $NF " " $2 }' )
used="$1" && shift
free="$1" && shift
total="$1" && shift
percent_used=$(percent.sh $used $total)

# HUMANS
# eg 361M / 7.6G used, 6.5G free
set $(free -h -t -w | head -2 | tail -1 \
    | awk '{ print $3 " " $NF " " $2 }'
)
used_h="$1" && shift
free_h="$1" && shift
total_h="$1" && shift
# eg 4.3G(3.3G)/7.8G
# echo "$mem," $(
#     uptime | sed -e 's/,//g' -e 's/.*: //'
# )

echo "$percent_used $total_h" $(uptime | sed -e 's/,//g' -e 's/.*: //')
