import TrieMap "mo:base/TrieMap";
import Account "Account";
import BootcampLocalActor "BootcampLocalActor";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Option "mo:base/Option";


actor MotoCoin {

    public type Account = Account.Account;

    let ledger = TrieMap.TrieMap<Account, Nat>(Account.accountsEqual, Account.accountsHash);

    // Returns the name of the token 
    public shared query func name() : async Text {
        let token : Text = "MotoCoin";
        token;
    };

    // Returns the symbol of the token 
    public shared query func symbol() : async Text {
        return "MOC";
    };

    // Returns the the total number of tokens on all accounts
    public shared query func totalSupply() : async Nat {
        var sum = 0;
        for (key in ledger.vals()) {
            sum += key;
        };
        sum;
    };

    // Returns the balance of the account
    public shared query func balanceOf(account : Account) : async Nat {
        let balance = ledger.get(account);

        switch(balance) {
            case(null) {
                return 0;
            };
            case(?balance) {
                return balance;
            }
        };
    };

    // Transfer tokens to another account
    public shared func transfer(from : Account, to : Account, amount : Nat) : async Result.Result<(), Text> {
        let balanceFrom = ledger.get(from);

        switch(balanceFrom) {
            case(null) {
                return #err("Account not found");
            };
            case(?balanceFrom) {
                //if(caller != from.owner) {
                //    return #err("Operation not allowed");
                //};
                if(balanceFrom < amount) {
                    return #err("Not enough currency");
                };
                let balanceTo = ledger.get(to);
                switch(balanceTo) {
                    case(null) {
                        return #err("Account not found");
                    };
                    case(?balanceTo) {
                        ledger.put(from, balanceFrom - amount);
                        ledger.put(to, balanceTo + amount);
                        return #ok();      
                    };
                };           
            };
        };
    };

    // Airdrop 100 MotoCoin to any student that is part of the Bootcamp.
    public shared func airdrop() : async Result.Result<(), Text> {
    //public shared func airdrop() : async [Principal] {

        let motokoCanister = actor("rww3b-zqaaa-aaaam-abioa-cai") : actor {
            getAllStudentsPrincipal : shared () -> async [Principal];
        };

        try {
            var students : [Principal] = await motokoCanister.getAllStudentsPrincipal();
            for(i in students.vals()){
                var student : Account = { 
                    owner = i; 
                    subaccount = null;
                };
                ledger.put(student, Option.get(ledger.get(student),0) + 100);
            };
            #ok();
        } catch(err) {
            #err("Error processing operation");
        }; 
        //return await motokoCanister.getAllStudentsPrincipal();
    };
};