#!/usr/bin/env python3.7

import sys

import psutil


DEBUG = False
RED = '#[fg=red,bg=black]'
MAGENTA = '#[fg=magenta,bg=black]'
EMERGENCY = '#[fg=cyan,bg=black]'
GREEN = '#[fg=colour46,bg=black]'
YELLOW = '#[fg=yellow,bg=black]'
GREY = '#[fg=colour243,bg=black]'
INTRO = '#[fg=colour243,bg=black]#'


if __name__ == '__main__':
    cpu_list = sorted(
        psutil.cpu_percent(interval=0.1, percpu=True),
    )
    # print(cpu_list)
    vm = psutil.virtual_memory()
    fmts = []
    for cpu in cpu_list:
        if cpu < 50.0:
            fmts.append(GREEN)
        elif cpu >= 50.0 and cpu < 100.0:
            fmts.append(YELLOW)
        elif cpu >= 100.0 and cpu < 110.0:
            fmts.append('{}'.format(RED))
        elif cpu >= 110.0:
            fmts.append('{}'.format(EMERGENCY))
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
    pct_fmt = '{0:.0%}'.format(pct)
    print('{dir_colour}{dir}'
          '{ram_colour}{ram_gb}G{pct_colour}{pct_fmt}'
          '{cpu_colour}{display_len}CPU{display}'.format(
              dir_colour=GREEN,
              dir=sys.argv[1][-30:],  # Truncate cwd starting from the back
              intro=INTRO,
              ram_colour=GREY,
              ram_gb=int(round(vm.total/1024/1024/1024)),
              pct_colour=GREEN,
              pct_fmt=pct_fmt,
              cpu_colour=GREY,
              display_len=len(deciles),
              display=display))
