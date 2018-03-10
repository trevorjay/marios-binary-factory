# marios-binary-factory
Extremely simple (no expressions or macros) strict 3-column assembler for the Sharp SM510.

## Description

`Mario's Binary Factory` (`mbf`) is an extremely simple assembler for the Sharp SM510. It is a strictly 3-column assembler. Odd things will happen if your code breaks it's expected `[LABEL] [OPCODE] [OPERAND]` format (though a few corner cases involving comments are handled correctly).

It produces `mame`-compatible ROMs that are padded to 64 bytes per "page" and padded overall to 4096 bytes. I'm not sure of the format for the original ROMS but since these already account for the SM510's unique program counter, conversion shouldn't be too difficult.

## Requirements

* to build: [haxe](https://haxe.org "Home - Haxe - The Cross-platform Toolkit")
* to assemble: Python 3
* to run the ROMs: `mame` and the original ROMs from a suitable donar system.

## Compilation

```
haxe build.hxml
```

### Example Usage

This example assembles the [test.asm](https://github.com/trevorjay/marios-binary-factory/blob/master/test.asm) program. As our donor system we'll use "Mickey & Donald" by copying the needed ROM (`gnw_mickdon.zip`) to the same directory as mbf.py. Make sure to make a back-up of `gnw_mickdon.zip` as this process will override it.

#### Explode `gnw_mickdon.zip` in the local directory:

```
python3 -m zipfile -e gnw_mickdon.zip .
```

#### Assemble `test.asm`, overriding the original: 

```
python3 mbf.py test.asm dm-53_565
```

#### Re-zip `gnw_mickdon.zip` with the modified ROM: 

```
python3 -m zipfile -c gnw_mickdon.zip dm-53_565 gnw_mickdon_*
```

#### Run `mame` with the replacement ROM

```
mame -rompath . gnw_mickdon
```

Note that I haven't found a way to launch modified ROMs via the GUI. However, if you launch the ROM directly from the command line as I've done here, you'll be given a chance to type "OK" despite the fact that the ROM hash doesn't match `mame`'s expectations.

The test ROM should work with any SM510-based system (not just "Mickey & Donald") and should flash every (non-bs) LCD segment all at once.
