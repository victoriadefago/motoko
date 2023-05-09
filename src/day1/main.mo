import Float "mo:base/Float";

actor Calculator {
  var counter : Float = 0;
  public query func add(x : Float) : async Float {
    counter := counter + x;
    return counter;
  };
};