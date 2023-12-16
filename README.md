# Zig Design Patterns

- [Zig Design Patterns](#zig-design-patterns)
  - [About](#about)
  - [Examples](#examples)
  - [License](#license)

## About

This repository contains examples of common design patterns found in Zig's standard library and many community projects.

Note that copying (one of) these patterns verbatim into your project may not be useful; it's important to weigh the pros and cons of different patterns. If you come from another language, especially a non-systems one, you'll often find that the more unfamiliar ideas featured here may be more useful.

For example, I've seldom used interface-like patterns when designing systems in Zig, despite using such patterns dozens of times a day at work writing TypeScript or Go.

## Examples

All examples are annotated with comments including recommendations regarding when to use the patterns shown.

| Example | How to run |
| ----- | --- |
| [`@fieldParentPtr`](src/field_parent_ptr.zig) | `zig build field_parent_ptr` |
| [Inline Switch](src/inline_switch.zig) | `zig build inline_switch` |
| [MultiArrayList](src/multi_array_list.zig) | `zig build multi_array_list` |
| [Type Function](src/type_function.zig) | `zig build type_function` |
| [Virtual Table](src/vtable.zig) | `zig build vtable` |

## License

MIT
