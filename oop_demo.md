## Java
```java

// *************************************************** Abstract Class **************************************************************//
// abstract class
abstract class Animal {
    // abstract methods
    abstract void move();
    abstract void eat();

    // concrete method
    void label() {
        System.out.println("Animal's data:");
    }
}

// inheritance
class Bird extends Animal {
    @Override                               // override
    void label() {
        super.label();                      // super
        System.out.println("Bird's data:");   

    void move() {
        System.out.println("Moves by flying.");
    }
    void eat() {
        System.out.println("Eats birdfood.");
    } 
}

// instantiate
class Solution {
    public static void main(String[] args) {
        Animal myBird = new Bird();

        myBird.label();
        myBird.move();
        myBird.eat();
    }
}
// *************************************************** Interface ************************************************************** //

// interface
interface Animal {
	public void eat();
	public void sound();
}

interface Bird {
  // static final fields
	int numberOfLegs = 2;
	String outerCovering = "feather";

  // abstract methods
	public void fly();
}

// implements
class Eagle implements Animal, Bird {       // multiple inplementations
	public void eat() {
		System.out.println("Eats reptiles and amphibians.");
	}
	public void sound() {
		System.out.println("Has a high-pitched whistling sound.");
	}
	public void fly() {
		System.out.println("Flies up to 10,000 feet.");
	}
}

// instantiate
class Solution {
	public static void main(String[] args) {
		Eagle myEagle = new Eagle();

		myEagle.eat();
		myEagle.sound();
		myEagle.fly();

		System.out.println("Number of legs: " + Bird.numberOfLegs);
		System.out.println("Outer covering: " + Bird.outerCovering);
	}
}

```




## Python

``` python 
# ***************************************************** Class ************************************************************** #
# class
class Dog:
    # class attribute
    species = "Canis familiaris"
    
    # instance attribute
    def __init__(self, name, age):	
        self.name = name
        self.age = age
	
    # instance method
    def speak(self, sound):
        return f"{self.name} says {sound}"
	
    # dunder method
    def __str__(self):
        return f"{self.name} is {self.age} years old"
	
	
# inheritance
class Bulldog(Dog):
    def __init__(self, name, age, breed):	
        super().__init__(self, name, age) # super
	self.breed = breed
	
    def speak(self, sound="Arf"):	# override
        return super().speak(sound)	# super
	
	
# multiple inheritance
class Base1:
    pass

class Base2:
    pass

class MultiDerived(Base1, Base2):
    pass


# *************************************************** Abstract Class ************************************************************** #
# abstract class
from abc import ABC, abstractmethod
class Abstract(ABC):
    # abstract method
    @abstractmethod
    def foo(self):
        pass
	
    # concrete method
    def show(self):
        print("Concrete Method in Abstract Base Class")
	
class Derived(Abstract):
    def foo(self):
        print('Hooray!')



````





















