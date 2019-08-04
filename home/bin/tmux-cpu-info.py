#!/usr/bin/env python3

import os
import sys

import psutil

DEBUG = False

BACKGROUND='colour17'
RED = f'#[fg=red,bg={BACKGROUND},noreverse]'
RED_REVERSE = f'#[fg=red,bg={BACKGROUND},reverse]'
MAGENTA = f'#[fg=magenta,bg={BACKGROUND},noreverse]'
EMERGENCY = f'#[fg=cyan,bg={BACKGROUND},noreverse]'
GREEN = f'#[fg=colour46,bg={BACKGROUND},noreverse]'
GREEN_REVERSE = f'#[fg=colour46,bg={BACKGROUND},reverse]'
YELLOW = f'#[fg=yellow,bg={BACKGROUND},noreverse]'
YELLOW_REVERSE = f'#[fg=yellow,bg={BACKGROUND},reverse]'
GREY = f'#[fg=colour243,bg={BACKGROUND},noreverse]'
INTRO = f'#[fg=colour243,bg={BACKGROUND},noreverse]#'

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

    stat = os.statvfs('.')
    # posix.statvfs_result(f_bsize=4096, f_frsize=4096, f_blocks=65533179,
    # f_bfree=20767004, f_bavail=20767004, f_files=131071424,
    # f_ffree=130390422, f_favail=130390422, f_flag=4096, f_namemax=255)
    du_used = int(round((1 - stat.f_bavail / stat.f_blocks) * 100))

    print(
        '{cwd_colour}{cwd}'
        '{du_colour}{du}'
        '{ram_colour}{ram_gb}G{pct_colour}{pct_str}'
        '{display}'
        .format(
            cwd_colour=GREEN,
            # TODO: Indicate path was truncated
            cwd=sys.argv[1][-30:],  # Truncate cwd starting from the back
            intro=INTRO,
            du_colour=GREEN_REVERSE,
            du=du_used,
            ram_colour=GREY,
            ram_gb=int(round(vm.total/1024/1024/1024)),
            pct_colour=GREEN_REVERSE,
            pct_str=pct_str,
            display=display))
