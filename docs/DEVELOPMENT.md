# Development

## Prerequisites

- POSIX shell
- `make`
- C compiler (`gcc` or `clang`)
- Lex/Flex-compatible scanner generator, only needed when regenerating scanners
- Yacc/Bison-compatible parser generator, only needed when regenerating parsers
- Readline development library for the XFS interface

## Build Targets

```sh
make              # build toolchain and kernel workspace
make toolchain    # build standalone SPL/ExpL/XFS/XSM tools
make kernel       # build integrated OS workspace
make clean        # remove generated binaries and objects
```

## Working With Kernel Modules

Kernel sources are in `kernel/nespl/spl_progs`. The `_28` files represent the
most complete integrated system state:

```text
boot_module_28.spl
os_startup_28.spl
timer_28.spl
console_28.spl
disk_28.spl
exhandler_28.spl
os_sec_28.spl
```

Compile SPL modules with the SPL compiler:

```sh
cd kernel/nespl
./spl spl_progs/os_startup_28.spl
```

## Working With Userland

User programs are in `kernel/expl/expl_progs`.

```sh
cd kernel/expl
./expl-bin expl_progs/shell.expl
```

The compiler emits XSM assembly that can be loaded into the filesystem image
through the XFS interface.

## Filesystem Image

The XFS interface in `kernel/nexfs-interface` manages the virtual disk image
used by the simulator. Use it to load compiled kernel modules, user programs,
and fixture files into disk blocks.

```sh
cd kernel/nexfs-interface
./xfs-interface
```

The sample data in `fixtures/` can be copied into the interface workspace when
creating or testing filesystem state.

## Simulator

The XSM simulator is available at `kernel/nexsm/xsm`.

```sh
cd kernel/nexsm
./xsm
```

Run `./xsm --help` or start the simulator from the configured disk image for
interactive testing.

## Preserved Snapshot

`spl_programs/` is intentionally preserved as-is. It is useful as historical
reference material and should not be used as the active kernel source tree.
