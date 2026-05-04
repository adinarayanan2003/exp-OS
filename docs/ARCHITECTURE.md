# Architecture

`exp-OS` is organized as a small monolithic OS for the XSM virtual machine. The
kernel is split into SPL modules that own bootstrapping, process lifecycle,
memory management, interrupt handling, filesystem calls, and privileged user
management.

## Execution Model

The machine target is XSM, a word-addressed virtual machine with registers,
physical pages, disk blocks, timer interrupts, console I/O, and explicit
privilege transitions. Kernel modules are compiled from SPL to XSM assembly.
User programs are compiled from ExpL and loaded through the filesystem image.

The boot flow starts with a boot module, loads core kernel pages, prepares the
process table and page tables, installs interrupt handlers, and creates initial
system processes. User control eventually reaches the login/shell path in
`kernel/expl/expl_progs`.

## Kernel Subsystems

| Area | Files | Responsibility |
| --- | --- | --- |
| Boot and startup | `kernel/nespl/spl_progs/boot_module_*.spl`, `os_startup_*.spl` | Load modules, initialize tables, create first processes, enter user mode |
| Scheduling | `timer_*.spl`, process table modules | Maintain ready/wait states and switch process contexts |
| Memory | `module2_*.spl`, swapper startup in `os_startup_28.spl` | Allocate pages, track free memory, release user pages, coordinate swap state |
| Filesystem | `disk_*.spl`, `int4`-`int7`, `kernel/nexfs-interface` | Disk I/O, file descriptors, root file metadata, read/write/seek/exec paths |
| Console | `console_*.spl`, console interrupts | User-visible terminal reads and writes |
| Exceptions | `exhandler_*.spl` | Handle invalid memory, process faults, and termination paths |
| Security/user state | `os_sec_*.spl`, `int16_*.spl`, login userland | Login, logout, password update, user lookup, and permission-sensitive calls |

The latest integrated generation is represented by the `_28` modules in
`kernel/nespl/spl_progs`.

## Userland

User programs live in `kernel/expl/expl_progs`. The shell uses `Fork`, `Wait`,
and `Exec` to run commands and directly dispatches account-related system calls
such as `Login`, `Logout`, `Newusr`, `Setpwd`, `Getuid`, and `Getuname`.

Notable utilities include:

- `shell.expl` and `login.expl` for interactive sessions
- `cat.expl`, `cp.expl`, `ls.expl`, and `rm.expl` for filesystem operations
- `m_sort.expl`, `m_merge.expl`, and merge variants for process/file stress
- arithmetic and process probes such as `gcd.expl`, `pid.expl`, `primes.expl`

## Toolchain

The standalone toolchain under `toolchain/` is kept separate from the integrated
kernel copy:

- `toolchain/spl`: SPL compiler for kernel modules
- `toolchain/expl`: ExpL compiler and library translator for user programs
- `toolchain/xfs-interface`: disk image interface
- `toolchain/xsm`: virtual machine simulator

This keeps the OS implementation self-contained while still exposing reusable
tooling at the repository root.
