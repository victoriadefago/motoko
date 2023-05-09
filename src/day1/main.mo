import Float "mo:base/Float";

actor Calculator {
  var counter : Float = 0;

  public func add(x : Float) : async Float {
    counter += x;
    return counter;
  };

  public func sub(x : Float) : async Float {
    counter -= x;
    return counter;
  };

  public func mul(x : Float) : async Float {
    counter *= x;
    return counter;
  };

  public func div(x : Float) : async Float {
    counter /= x;
    return counter;
  };

};