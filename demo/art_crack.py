import logging

import angr
import claripy
import simuvex

def art_of_war():
    p = angr.Project('./artofwar', load_options={"auto_load_libs" : False})

    start_addr = 0x8048495
    puts1      = 0x80484aa
    puts2      = 0x8048518
    puts3      = 0x8048561
    loop       = 0x8048530

    state = p.factory.blank_state(addr=start_addr)
    state.regs.ebp = state.regs.esp
    state.regs.esp = state.regs.esp - 0x10

    data = state.se.BVS('data', 32)
    state.memory.store(state.regs.ebp - 0x14, data, endness='Iend_LE')
    magic = state.se.BVS('magic', 100*8)
    state.memory.store(state.regs.ebp - 0x18, magic, endness='Iend_LE')

    pg = p.factory.path_group(state)

    r = pg.explore(find=puts1, avoid=loop)
    pg.explore(find=puts2, avoid=loop)
    # pg.explore(find=puts3)

    for i in range(len(r.found)):
        ss = r.found[i].state
        print "data = %r" % ss.se.any_str(data)
        print "magic = %d" % ss.se.any_int(magic)
    if len (r.found) < 1:
        print "Found nothing"

if __name__ == '__main__':
    logging.basicConfig()
    angr.path_group.l.setLevel('DEBUG')

    art_of_war()
