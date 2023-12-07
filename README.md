# Zig Design Patterns

- [Zig Design Patterns](#zig-design-patterns)
  - [About](#about)
  - [Examples](#examples)
  - [License](#license)

## About

This repository contains examples of common design patterns found in Zig's standard library and many community projects. I hope that these examples will help people new to the language gain an understanding of the many ways one can structure their programs in Zig, as well as why Zig does not prescribe a certain way to do "interfaces."

## Examples

All examples are annotated with comments including recommendations regarding when to use the patterns shown.

| Example | How to run |
| ----- | --- |
| [`@fieldParentPtr`](src/field_parent_ptr.zig) | `zig build field_parent_ptr` |
| [Inline Switch](src/inline_switch.zig) | `zig build inline_switch` |
| [Type Function](src/type_function.zig) | `zig build type_function` |
| [Virtual Table](src/vtable.zig) | `zig build vtable` |

## License

MIT
