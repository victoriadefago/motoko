import Float "mo:base/Float";
import Int "mo:base/Int";

actor Calculator {
  var counter : Int = 0;

  public func add(x : Int) : async Int {
    counter += x;
    return counter;
  };

  public func sub(x : Int) : async Int {
    counter -= x;
    return counter;
  };

  // public func mul(x : Float) : async Float {
  //   counter *= x;
  //   return counter;
  // };

  // public func div(x : Float) : async ?Float {
  //   if(x == 0) {
  //     return null;
  //   } else {
  //     counter /= x;
  //     return ?counter;
  //   }
  // };

  public func reset() : async Int {
    counter := 0;
    return counter;
  };

  //public func see() : async Float {
  //   return (counter)
  // };

  // public func power(x : Float) : async Float {
  //   counter := counter** x;
  //   return counter;
  // };

  // public func sqrt() : async Float {
  //   counter := Float.sqrt(counter);
  //   return counter;
  // };

  // public func floor() : async Int {
  //   counter := Float.floor(counter);
  //   return Float.toInt(counter);
  // };

};