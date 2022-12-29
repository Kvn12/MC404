executavel.x: Lab03.o 

	ld.lld-12 Lab03.o -o executavel.x
	
Lab03.s: Lab03.c

	clang-12 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax Lab03.c -S -o Lab03.s
	
Lab03.o: Lab03.s

	clang-12 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax Lab03.s -c -o Lab03.o