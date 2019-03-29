#!/usr/bin/env python3.7

import sys

import psutil


DEBUG = False
RED = '#[fg=red,bg=black,noreverse]'
RED_REVERSE = '#[fg=red,bg=black,reverse]'
MAGENTA = '#[fg=magenta,bg=black,noreverse]'
EMERGENCY = '#[fg=cyan,bg=black,noreverse]'
GREEN = '#[fg=colour46,bg=black,noreverse]'
GREEN_REVERSE = '#[fg=colour46,bg=black,reverse]'
YELLOW = '#[fg=yellow,bg=black,noreverse]'
YELLOW_REVERSE = '#[fg=yellow,bg=black,reverse]'
GREY = '#[fg=colour243,bg=black,noreverse]'
INTRO = '#[fg=colour243,bg=black,noreverse]#'

ALERT_FMT = '#[fg=white,bg=black,reverse]#{alert}'


CPU_LOW = GREEN
CPU_HIGH = YELLOW
CPU_110 = RED
CPU_CRAZY = EMERGENCY

if __name__ == '__main__':
    cpu_list = sorted(
        psutil.cpu_percent(interval=0.1, percpu=True),
    )
    # print(cpu_list)
    vm = psutil.virtual_memory()
    fmts = []
    for cpu in cpu_list:
        if cpu < 50.0:
            fmts.append(CPU_LOW)
        elif cpu >= 50.0 and cpu < 100.0:
            fmts.append(CPU_HIGH)
        elif cpu >= 100.0 and cpu < 110.0:
            fmts.append('{}'.format(CPU_110))
        elif cpu >= 110.0:
            fmts.append('{}'.format(CPU_CRAZY))
    # print(fmts)

    # FIXME: Do fmts with deciles

    deciles = []  # string collection of cpu percentages
    for cpu in cpu_list:
        # TODO: Add option to use just "traffic lights" and no numbers
        decile_cpu = str(int(cpu / 10))
        if len(decile_cpu) == 1:
            deciles.append('{}'.format(decile_cpu))
        elif decile_cpu == '10':
            deciles.append('*')
        elif decile_cpu == '11':
            deciles.append('!')
        else:
            deciles.append('<{}>'.format(decile_cpu))

    display = ''
    counter = 0
    for i, decile in enumerate(deciles):
        display += fmts[i]
        display += decile

    pct = vm.available / vm.total
    pct_str = '{0:.0}'.format(pct)
    if pct_str.startswith('0.'):
        pct_str = pct_str[2:]
    else:
        pct_str = '!' + pct_str + '!'

    print(
        '{dir_colour}{dir}'
        '{ram_colour}{ram_gb}G{pct_colour}{pct_str}'
        '{display}'
        .format(
            dir_colour=GREEN,
            # TODO: Indicate path was truncated
            dir=sys.argv[1][-30:],  # Truncate cwd starting from the back
            intro=INTRO,
            ram_colour=GREY,
            ram_gb=int(round(vm.total/1024/1024/1024)),
            pct_colour=GREEN_REVERSE,
            pct_str=pct_str,
            display=display))
