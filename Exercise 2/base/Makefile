CC = gcc
CFLAGS = -Wall -Wextra -O3 -std=c11 -march=native 
LDLIBS = -lm
ASMFLAGS = -S

SRCS = mandelbrot.c
OBJS = $(SRCS:.c=.o)
ASMS = $(SRCS:.c=.s)
EXEC = mandelbrot

.PHONY: all clean asm

all: $(EXEC)


# Link object files
$(EXEC): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDLIBS)

# Generate object files
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Generate assembly files
asm: $(ASMS)

%.s: %.c
	$(CC) $(CFLAGS) $(ASMFLAGS) -o $@ $<

# Clean up
clean:
	rm -f $(EXEC) $(OBJS) $(ASMS)

# Compile for parallel execution, define the _OPENMP macro
par:
	$(MAKE) CFLAGS="$(CFLAGS) -fopenmp" DEFINE_OPENMP=1 $(EXEC)

# Compile for serial execution
ser:
	$(MAKE) CFLAGS="$(CFLAGS)" $(EXEC)

