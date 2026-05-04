.PHONY: all toolchain kernel clean clean-toolchain clean-kernel

all: toolchain kernel

toolchain:
	$(MAKE) -C toolchain/expl
	$(MAKE) -C toolchain/spl
	$(MAKE) -C toolchain/xfs-interface
	$(MAKE) -C toolchain/xsm

kernel:
	$(MAKE) -C kernel

clean: clean-toolchain clean-kernel

clean-toolchain:
	$(MAKE) -C toolchain/expl clean
	$(MAKE) -C toolchain/spl clean
	$(MAKE) -C toolchain/xfs-interface clean
	$(MAKE) -C toolchain/xsm clean

clean-kernel:
	$(MAKE) -C kernel clean
