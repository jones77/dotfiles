#!/usr/bin/env python3

import psutil

DEBUG = False
RED = "#[fg=red,bg=black]"
GREEN = "#[fg=colour46,bg=black]"
YELLOW = "#[fg=yellow,bg=black]"

if __name__ == '__main__':
    cpu_list = psutil.cpu_percent(interval=0.1, percpu=True)
    # print(cpu_list)
    vm = psutil.virtual_memory()
    fmts = []
    for cpu in cpu_list:
        if cpu < 50.0:
            fmts.append(GREEN)
        elif cpu >= 50.0 and cpu <= 100.0:
            fmts.append(RED)
        elif cpu >= 100.0:
            fmts.append('!{}!'.format(YELLOW))
    # print(fmts)

    deciles = []  # string collection of cpu percentages
    for cpu in cpu_list:
        decile_cpu = str(int(cpu / 10))
        if len(decile_cpu) == 1:
            deciles.append('{}'.format(decile_cpu))
        else:
            deciles.append('!{}!'.format(decile_cpu))
    # print(deciles)

    display = ''
    counter = 0
    for i, decile in enumerate(deciles):
        display += fmts[i]
        display += decile

    pct = vm.available / vm.total
    pct_fmt = '{0:.0%}'.format(pct)
    print('{pct_fmt}{display}'.format(
        pct_fmt=pct_fmt,
        display=display))
