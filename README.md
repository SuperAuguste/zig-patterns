# Zig Design Patterns

- [Zig Design Patterns](#zig-design-patterns)
  - [About](#about)
  - [Examples](#examples)
    - [`@fieldParentPtr`](#fieldparentptr)
    - [Inline Switch](#inline-switch)
    - [Type Function](#type-function)
    - [Virtual Table](#virtual-table)
  - [License](#license)

## About

This repository contains examples of common design patterns found in Zig's standard library and many community projects. I hope that these examples will help people new to the language gain an understanding of the many ways one can structure their programs in Zig, as well as why Zig does not prescribe a certain way to do "interfaces."

## Examples

All examples are annotated with comments. Recommendations regarding when to use the pattern shown in an example are located at the bottom of the file.

### `@fieldParentPtr`

```bash
zig build field_parent_ptr
```

![field parent ptr](.github/assets/field_parent_ptr.svg)

### Inline Switch

```bash
zig build inline_switch
```

### Type Function

```bash
zig build type_function
```

### Virtual Table

```bash
zig build vtable
```

## License

MIT
