#!/usr/bin/env python3.7

import os
import sys

import psutil

DEBUG = False

RED = f'#[fg=red]'
RED_REVERSE = f'#[fg=red,reverse]'
MAGENTA = f'#[fg=colour13]'
PINK = f'#[fg=colour217,nobold]'
CYAN = f'#[fg=colour75]'
GREEN = f'#[fg=colour36,nobold]'
GREEN = f'#[fg=colour36,nobold]'
GREEN_BOLD = f'#[fg=colour36,bold]'
GREEN_REVERSE = f'#[fg=colour36,reverse]'
YELLOW = f'#[fg=colour227,noreverse]'
YELLOW_REVERSE = f'#[fg=colour227,reverse]'
GREY = f'#[fg=colour243]'
GREY_REVERSE = f'#[fg=colour243,reverse]'
EMERGENCY = f'#[fg=red,bold]'
CWD_LEN = 30


def cpu_viz():
    """cpu_viz returns a tmux visualization of cpu usage."""
    cpu_usage = "_▁▂▃▄▅▆▇██"  # ascending cpu usage indicators
    cpu_list = sorted(psutil.cpu_percent(interval=0.5, percpu=True))
    cpu_string = PINK  # tmux "visualization"

    for cpu in cpu_list:
        cpu_usage_index = int(cpu // len(cpu_usage))
        if cpu_usage_index >= len(cpu_usage):
            # Coerce to last element, cpu_usage can be >= 100.0
            cpu_usage_index = len(cpu_usage) - 1
        if cpu_usage_index == len(cpu_usage) - 1:
            cpu_string += EMERGENCY
        elif cpu_usage_index > (len(cpu_usage) // 2):
            cpu_string += PINK
        else:
            cpu_string += GREEN
        cpu_string += cpu_usage[cpu_usage_index]

    return cpu_string


if __name__ == '__main__':
    cwd = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    if len(cwd) > CWD_LEN:
        cwd = '…' + cwd[-CWD_LEN-1:]
    # cwd = cwd.replace('/', f'{YELLOW}/{GREEN}') + YELLOW + '/'

    vm = psutil.virtual_memory()
    memory_used = 1 - (vm.available / vm.total)
    mem_digit = '{0:.0}'.format(memory_used)
    if mem_digit.startswith('0.'):
        mem_digit = mem_digit[2:]
    else:
        mem_digit = '!' + mem_digit + '!'

    stat = os.statvfs('.')
    du_used = int(round((1 - stat.f_bavail / stat.f_blocks) * 100))

    ram_gb=int(round(vm.total/1024/1024/1024))

    cpu_string = cpu_viz()

    print(
        f'{YELLOW}{cwd}'
        f'{PINK}{du_used}'
        f'{GREEN}{ram_gb}'
        f'{YELLOW}{mem_digit}'
        f'{cpu_string}{YELLOW}'
    )
