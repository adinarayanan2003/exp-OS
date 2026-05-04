# exp-OS

`exp-OS` is a compact operating system built for the XSM virtual machine. The
repository contains the kernel, user-space programs, language toolchain,
filesystem interface, and simulator needed to build and run the system from
source.

The implementation is intentionally close to the metal: kernel code is written
in SPL, user programs are written in ExpL, and the system boots into a virtual
machine with explicit page tables, process state, disk blocks, interrupts, and
system calls.

## What It Includes

- Multistage boot path with a secondary loader and OS startup module
- Process table, ready/wait states, scheduler, context switching, and idle tasks
- Demand-style memory management with page tables and a swapper daemon
- Disk, console, timer, and exception handlers
- File operations for create, open, read, write, seek, close, delete, and exec
- User management flows for login, logout, password updates, and user lookup
- Shell and userland utilities including `cat`, `cp`, `ls`, `rm`, sort/merge,
  arithmetic demos, and file stress programs
- Complete local toolchain: SPL compiler, ExpL compiler, XFS interface, and XSM
  simulator

## Repository Layout

```text
.
|-- kernel/                  # OS implementation and custom userland
|   |-- nespl/               # Kernel modules, boot code, interrupt handlers
|   |-- expl/                # User-space programs and ExpL compiler copy
|   |-- nexfs-interface/     # Filesystem image tooling
|   `-- nexsm/               # XSM simulator copy used with the OS tree
|-- toolchain/               # Standalone toolchain components
|   |-- spl/                 # SPL compiler
|   |-- expl/                # ExpL compiler
|   |-- xfs-interface/       # XFS disk image interface
|   `-- xsm/                 # XSM virtual machine
|-- fixtures/                # Sample disk/userland data files
|-- docs/                    # Architecture and operating notes
`-- spl_programs/            # Preserved historical SPL/XSM snapshots
```

## Build

The top-level Makefile builds both the standalone toolchain and the integrated
kernel workspace.

```sh
make
```

Build only the reusable tools:

```sh
make toolchain
```

Build only the OS workspace:

```sh
make kernel
```

Clean generated binaries and object files:

```sh
make clean
```

The build expects a C compiler and `make`. Parser/scanner C files are checked in
for bootstrap reliability; install Lex/Flex and Yacc/Bison only when editing the
grammar sources.

## Running The System

The kernel tree keeps the final boot modules and user programs under
`kernel/nespl/spl_progs` and `kernel/expl/expl_progs`. The simulator and disk
interface live alongside them in `kernel/nexsm` and `kernel/nexfs-interface`.

Useful entrypoints:

```sh
make kernel
cd kernel/nexsm
./xsm --help
```

See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for a practical runbook and
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the subsystem map.

## Design Notes

The project targets the XSM/eXpOS machine model, which makes OS internals
visible instead of hiding them behind host abstractions. That gives the kernel a
small but complete surface area: explicit boot loading, page tables, disk block
movement, interrupt dispatch, kernel modules, and user-mode system calls.

The `spl_programs` directory is intentionally left as a historical snapshot.
The current OS workspace is under `kernel/`.
