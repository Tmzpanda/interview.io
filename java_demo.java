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






















