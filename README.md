# Verilog formatOf-ConvertFromInt(int)

## Description

Convert 32-bit signed integer to IEEE 754 binary64 format.

Because the significand of binary64 values has more significant digits
than the integer being converted no rounding is necessary.

If needed, it is easy to modify this code support converting unsigned
integers to float. Also, it is trivial to modify this code to convert
* 8-bit integers to binary16,
* 16-bit integers to binary32, and
* 64-bit integers to binary128.

In practice, because this code is most likely to be used to implement a
RISC processor, and RISC processors use a load/store architecture, once
8-bit and 16-bit values are read from memory into a register and the
register is likely to be a 32- or 64-bit register, the need for
instructions to convert 8- and 16-bit integers into float would be very
limited.

Because the results of this code are exact it works, as is, for all
rounding attributes: roundTiesToEven, roundTowardZero,
roundTowardPositive, roundTowardNegative, and roundTiesToAway. Because
the results are always exact, and there will never be an overflow there
is no need for the module to signal either the inexact or overflow
exceptions.

## Manifest

|   Filename   |                        Description                        |
|--------------|-----------------------------------------------------------|
| README.md | This file. |
| ieee-754-flags.v | Include file which defines the position of each of the individual IEEE type flags within the bit vector. Also defines symbolic names for quantities defined by IEEE 754. The definitions calculate these values from NEXP and NSIG. It's because these values are calculated from NEXP and NSIG dynamically that this module is able to support all of the IEEE 754 binary types instead having a different module for each type. |
| cvtdw.sv | Code to implement MIPS cvt.d.w instruction. |

## Copyright

:copyright: Chris Larsen, 2019-2022
