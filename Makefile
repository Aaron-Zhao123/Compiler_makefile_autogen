bench=polybench-c-4.2.1-beta

cc=/usr/groups/acs-software/L25/llvm-release/bin/clang
opt=/usr/groups/acs-software/L25/llvm-release/bin/opt

ccflags=-Xclang -load -Xclang ./SimplePass/Debug/SimplePass.so -c
inc= -I$(bench)/utilities -I$(bench)/linear-algebra/kernels/atax $(bench)/utilities/polybench.c

file=$(bench)/linear-algebra/kernels/2mm/2mm.c
irfile=2mm.ll

all:
	$(cc)  $(ccflags) $(inc) $(file) -O3
opt:
	$(opt) $(irfile) -debug-pass=Structure -o $(irfile) -globalopt -loop-extract-single -simplifycfg -constprop -codegenprepare -loop-unroll -deadargelim -constprop -deadargelim -argpromotion -lcssa -constmerge -lcssa -ipconstprop -loop-unroll -partial-inliner -ipsccp -indvars -loop-unroll -adce -bb-vectorize -reassociate -bb-vectorize -mergereturn -sroa -always-inline -sink -sccp -loop-reduce -lowerinvoke -sccp -break-crit-edges

ir:
	$(cc) -S -emit-llvm $(inc) $(file) -O0


f:
	$(cc) opt.ll -o opt

help:
	$(opt) --help
