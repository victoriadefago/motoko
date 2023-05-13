import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Int "mo:base/Int";


actor Verifier {

    // PART 1

    public type StudentProfile = {
        name : Text;
        team : Text;
        graduate : Bool;
    };

    stable var stableMap : [(Principal, StudentProfile)] = [];
    let studentProfileStore = HashMap.fromIter<Principal,StudentProfile>(stableMap.vals(), stableMap.size(), Principal.equal, Principal.hash);

    public shared ({ caller }) func addMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {

        let student : StudentProfile = {
            name = profile.name;
            team = profile.team;
            graduate = profile.graduate;
        };

        studentProfileStore.put(caller, student);
        return #ok();
    };

    public shared query func seeProfile(p : Principal) : async Result.Result<StudentProfile, Text> {
        let student = studentProfileStore.get(p);

        switch (student) {
            case (null) {
                return #err("Student not found");
            };
            case (?student) {
                return #ok(student);
            };
        };
    };

    system func preupgrade() {
        stableMap := Iter.toArray(studentProfileStore.entries());
    };

    system func postupgrade() {
        stableMap := [];
    };

    public shared ({ caller }) func updateMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
        let student : ?StudentProfile = studentProfileStore.get(caller);

        switch (student) {
            case (null) {
                #err("Student not found");
            };
            case (?student) {
                let studentUpdated = {
                    name = profile.name;
                    team = profile.team;
                    graduate = profile.graduate;
                };
                studentProfileStore.put(caller, studentUpdated);
                #ok();
            };
        };
    };

    public shared ({ caller }) func deleteMyProfile() : async Result.Result<(), Text> {
        let student : ?StudentProfile = studentProfileStore.get(caller);

        switch (student) {
            case (null) {
                #err("Student not found");
            };
            case (?student) {
                studentProfileStore.delete(caller);
                #ok();   
            };
        };
    };


    // PART 2

    public type TestResult = Result.Result<(), TestError>;
    public type TestError = {
        #UnexpectedValue : Text;
        #UnexpectedError : Text;
    };

    //e35fa-wyaaa-aaaaj-qa2dq-cai

    public shared func test(canisterId : Principal) : async TestResult {
        let calculator = actor(Principal.toText(canisterId)) : actor {
            add: (Int) -> async (Int);
            reset: () -> async (Int);
            sub: (Int) -> async (Int);
        };

        var ans : Int = 0;

        try{
            ans := await calculator.reset();
        } catch(err) {
            return #err(#UnexpectedError("Function reset is not defined"));
        };

        try{
            ans := await calculator.add(1);
        } catch(err) {
            return #err(#UnexpectedError("Function add is not defined"));
        };

        try{
            ans := await calculator.sub(1);
        } catch(err) {
            return #err(#UnexpectedError("Function sub is not defined"));
        };

        ans := await calculator.reset();
        ans := await calculator.add(1);

        if(not (ans == 1)) {
            return #err(#UnexpectedValue("Function not working"));
        };

        ans := await calculator.reset();
        ans := await calculator.sub(1);

        if(not (ans == 0)) {
            return #err(#UnexpectedValue("Function not working"));
        };

        return #ok();
    };

    // PART 3




}