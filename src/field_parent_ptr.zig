const std = @import("std");

pub const Animal = struct {
    name: []const u8,
    sayHello: *const fn (animal: *const Animal) void,
};

pub const Cat = struct {
    animal: Animal,

    favorite_food_brand: []const u8,

    pub fn sayHello(animal: *const Animal) void {
        const cat = @fieldParentPtr(Cat, "animal", animal);
        std.debug.print("Hi my name is {s} and I only eat {s}\n", .{ animal.name, cat.favorite_food_brand });
    }
};

pub const Dog = struct {
    animal: Animal,

    favorite_dog_toy: []const u8,

    pub fn sayHello(animal: *const Animal) void {
        const dog = @fieldParentPtr(Dog, "animal", animal);
        std.debug.print("Hi my name is {s} and my favorite dog toy is {s}\n", .{ animal.name, dog.favorite_dog_toy });
    }
};

test {
    const grisounette = Cat{
        .animal = .{
            .name = "Grisounette",
            .sayHello = &Cat.sayHello,
        },
        .favorite_food_brand = "grass",
    };
    const peanuts = Dog{
        .animal = Animal{
            .name = "Peanuts",
            .sayHello = &Dog.sayHello,
        },
        .favorite_dog_toy = "bone",
    };

    const my_animals = &[_]*const Animal{ &grisounette.animal, &peanuts.animal };

    for (my_animals) |animal| {
        animal.sayHello(animal);
    }
}

// When to use:
// - When you want to call a function over a single, unified interface
//
// When not to use:
// - If you have a lot of common functions but few common values; see vtable
