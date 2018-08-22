# marios-binary-factory
Extremely simple (no expressions or macros) strict 3-column assembler for the Sharp SM510.

## Description

`Mario's Binary Factory` (`mbf`) is an extremely simple assembler for the Sharp SM510. It is a strictly 3-column assembler. Odd things will happen if your code breaks it's expected `[LABEL] [OPCODE] [OPERAND]` format (though a few corner cases involving comments are handled correctly).

It produces `mame`-compatible ROMs that are padded to 64 bytes per "page" and padded overall to 4096 bytes. I'm not sure of the format for the original ROMs but since these already account for the SM510's unique program counter order, conversion should be straight-forward.

## Requirements

* to assemble: [Python 3](https://www.python.org/)
* to run the ROMs: [`mame`](http://mamedev.org/) and the SVG overlay files from a suitable donor system that uses the SM510.
* to build: [haxe](https://haxe.org "Home - Haxe - The Cross-platform Toolkit")

## Example Usage

This example assembles the [test.asm](https://github.com/trevorjay/marios-binary-factory/blob/master/test.asm) program. In this example, we'll use "Mickey & Donald" as the donor system but any SM510 system that `mame` supports should work. Start by copying the needed zipfile (`gnw_mickdon.zip` in this case) to the same directory as `mbf.py`. Make sure to make a back-up of the zipfile as this process will replace the original ROM and keep only the overlay art.

### Explode `gnw_mickdon.zip` in the local directory:

```
python3 -m zipfile -e gnw_mickdon.zip .
```

### Assemble `test.asm`, overriding the original ROM: 

```
python3 mbf.py test.asm dm-53_565
```

### Re-zip `gnw_mickdon.zip` with the replacement ROM: 

```
python3 -m zipfile -c gnw_mickdon.zip dm-53_565 gnw_mickdon_*
```

### Run `mame` with the replacement ROM

```
mame -rompath . gnw_mickdon
```

Note that I haven't found a way to launch original ROMs via the GUI. However, you can do so with the command line. If you launch the ROM directly from the command line as I've done here, you'll be given a chance to type "OK" and run despite the hash not being what `mame` expects.

The test ROM should work with any SM510-based system (not just "Mickey & Donald") for which overlay art is available and should flash every (non-bs) LCD segment all at once. The filenames of the ROM to replace and the SVG to include will change from system to system.

## Features

### Comments

```
; Comments begin with ; and continue to the end of the line.
        SKIP ; Comments should be able to follow any other content.
```

### Global Labels

```
LOOP
        EXC     $0
        T       LOOP
```

or

```
LOOP    EXC     $0
        T       LOOP
```

### Global Constants

```
FOO     equ     $2
        LAX     FOO
```

### Direct writes

```
        .word   $0
```

Note that even though the CPU is 4-bit, the ROM-space is 8-bit and thus `.word` writes a full byte and _not_ a nibble.

### Location Counter Control

```
.org    $DC0
```

### Supported Opcodes

ADD, ADD11, ADX, ATBP, ATFC, ATL, ATPL, ATR, BDC, CEND, COMA, DC, DECB, EXBLA, EXC, EXCD, EXCI, IDIV, INCB, KTA, LAX, LB, LBL, LDA, RC, RM, ROT, RTN0, RTN1, SBM, SC, SKIP, SM, T, TA0, TABL, TAL, TAM, TB, TC, TF1, TF4, TIS, TL, TM, TMI, TML, WR, WS

## Limitations

### Layout

The assembler depends on a _strict_ 3-column `[LABEL] [OPCODE] [OPERAND]` format. Even having trailing space (that doesn't lead into a comment) is likely to cause problems. If you're having trouble getting correct output, look for extraneous whitespace in your assembly. This includes "empty" lines (i.e. lines which just have a newline) which are interpreted as `SKIP`s. If you want an empty line, make `;` its first character.

### Numbers

The assembler only understands hexadecimal numbers of the form `$XXXX`. It will handle shorter numbers appropriately. For example: `$0045` is 69 but so is `$45`, `$2` is 2, and so on. It doesn't do size checking. It's up to you to know if an operation can handle two bytes (`$XXXX`), a byte (`$XX`), a nibble (`$X`), 2-bits (`$X <= 3`), or a single bit (`$X <= 1`). You're always free to use leading zeroes regardless.

## Creating the Python script

The `mbf.py` script is generated from [Haxe](https://haxe.org/) source:

```
haxe build.hxml
```

## Thanks

Many thanks to [Sean Riddle](http://www.seanriddle.com/), [Paul Robson](https://www.blogger.com/profile/12278875872815047472), and [hap](https://github.com/happppp). Their research has made homebrew LCD game development and emulation "practical". 

Special thanks to everyone at the [`MAME project`](https://github.com/mamedev/mame) working hard to preserve handheld history as accurately as possible.
