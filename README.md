# Zig Patterns

- [Zig Patterns](#zig-patterns)
  - [About](#about)
  - [The Patterns](#the-patterns)
  - [License](#license)

## About

This repository contains examples of common patterns found in Zig's standard library and many community projects.

Note that copying (one of) these patterns verbatim into your project may not be useful; it's important to weigh the pros and cons of different patterns. If you come from another language, especially a non-systems one, you'll often find that the more unfamiliar ideas featured here may be more useful.

For example, I've seldom used interface-like patterns when designing systems in Zig, despite using such patterns dozens of times a day at my old job writing TypeScript or Go.

## The Patterns

All examples are annotated with comments including recommendations regarding when to use the patterns shown.

Example tests can be run with `zig build [name_of_pattern]`. For example, to run the tests in `typing/type_function.zig`, run `zig build type_function`.

Patterns are grouped into the following categories:
- `data` - data layout and organization techniques
- `typing` - `comptime`, runtime, or mixed `type` or type safety techniques

Some patterns may belong in multiple categories; I've selected the most fitting one in my opinion.

## License

MIT
