#!/usr/bin/env python

'''
This is an example that uses angr to assist in solving a crackme, given as
a 400-level crypto challenge in WhitehatCTF in 2015. In this example, angr is
used to reduce the keyspace, allowing for a reasonable brute-force.
'''

# lots of imports
import logging
import itertools
import subprocess
import progressbar

import angr
import claripy
import simuvex

from simuvex.procedures.stubs.UserHook import UserHook

def get_possible_flags():
    # load the binary
    print '[*] loading the binary'
    p = angr.Project("whitehat_crypto400")

    p.hook(0x4018B0, angr.Hook(simuvex.SimProcedures['libc.so.6']['__libc_start_main']))
    p.hook(0x422690, angr.Hook(simuvex.SimProcedures['libc.so.6']['memcpy']))
    p.hook(0x408F10, angr.Hook(simuvex.SimProcedures['libc.so.6']['puts']))

    p.hook(0x401438, angr.Hook(simuvex.SimProcedures['stubs']['ReturnUnconstrained']), kwargs={'resolves': 'nothing'})

    def hook_length(state):
        state.regs.rax = 8
    p.hook(0x40168e, angr.Hook(UserHook, user_func=hook_length, length=5))
    p.hook(0x4016BE, angr.Hook(UserHook, user_func=hook_length, length=5))

    arg1 = claripy.BVS('arg1', 8*8)
    initial_state = p.factory.entry_state(args=["crypto400", arg1], add_options={"BYPASS_UNSUPPORTED_SYSCALL"})

    for b in arg1.chop(8):
        initial_state.add_constraints(b != 0)

    pg = p.factory.path_group(initial_state, immutable=False)

    print '[*] executing'
    pg.explore(find=0x4016A3).unstash(from_stash='found', to_stash='active')
    pg.explore(find=0x4016B7, avoid=[0x4017D6, 0x401699, 0x40167D]).unstash(from_stash='found', to_stash='active')
    pg.explore(find=0x4017CF, avoid=[0x4017D6, 0x401699, 0x40167D]).unstash(from_stash='found', to_stash='active')
    pg.explore(find=0x401825, avoid=[0x401811])

    s = pg.found[0].state

    for i in range(8):
        b = s.memory.load(0x6C4B20 + i, 1)
        s.add_constraints(b >= 0x21, b <= 0x7e)

    possible_values = [ s.se.any_n_str(s.memory.load(0x6C4B20 + i, 2), 65536) for i in range(0, 8, 2) ]

    print(possible_values)

    possibilities = tuple(itertools.product(*possible_values))
    return possibilities

def bruteforce_possibilities(possibilities):
    # let's try those values!
    print '[*] example guess: %r' % ''.join(possibilities[0])
    print '[*] brute-forcing %d possibilities' % len(possibilities)
    for guess in progressbar.ProgressBar(widgets=[progressbar.Counter(), ' ', progressbar.Percentage(), ' ', progressbar.Bar(), ' ', progressbar.ETA()])(possibilities):
        stdout,_ = subprocess.Popen(["./whitehat_crypto400", ''.join(guess)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT).communicate()
        if 'FLAG IS' in stdout:
            return filter(lambda s: ''.join(guess) in s, stdout.split())[0]

def main():
    return bruteforce_possibilities(get_possible_flags())

def test():
    assert 'nytEaTBU' in [ ''.join(p) for p in get_possible_flags() ]

if __name__ == '__main__':
    # set some debug messages so that we know what's going on
    logging.basicConfig()
    angr.path_group.l.setLevel('DEBUG')

    print main()

