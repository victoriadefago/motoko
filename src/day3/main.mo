import Time "mo:base/Time";
import Int "mo:base/Int";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Order "mo:base/Order";

actor Wall {

    public type Content = {
        #Text : Text;
        #Image : Blob;
        #Video : Blob;
    };

    public type Message = {
        vote : Int;
        content : Content;
        creator : Principal;
    };

    var messageId : Nat = 0;

    func _NatToHash(x : Nat) : Hash.Hash {
        Text.hash(Nat.toText(x));
    };

    var wall = HashMap.HashMap<Nat, Message>(0, Nat.equal, _NatToHash);


    // Add a new message to the wall
    public shared ({ caller }) func writeMessage(c : Content) : async Nat {

        let id : Nat = messageId;

        let message : Message = {
            vote = 0;
            content = c;
            creator = caller;
        };

        wall.put(messageId, message);
        messageId += 1;
        id;
    };


    //Get a specific message by ID
    public shared query func getMessage(messageId : Nat) : async Result.Result<Message, Text> {

        let message = wall.get(messageId);

        switch (message) {
            case (null) {
                return #err("Message not found");
            };
            case (?message) {
                return #ok(message);
            };
        };
    };


    // Update the content for a specific message by ID
    public shared({ caller }) func updateMessage(messageId : Nat, c : Content) : async Result.Result<(), Text> {

        let message : ?Message = wall.get(messageId);

        switch (message) {
            case (null) {
                return #err("Message not found");
            };
            case (?message) {
                let messageUpdated = {
                    vote = message.vote;
                    content = c;
                    creator = caller;
                };
                if(message.creator != caller) {
                    return #err("Caller ID not valid");
                };
                wall.put(messageId, messageUpdated);
                return #ok();
            };
        };
    };


    //Delete a specific message by ID
    public shared func deleteMessage(messageId : Nat) : async Result.Result<(), Text> {

        let message : ?Message = wall.get(messageId);

        switch (message) {
            case (null) {
                return #err("Message not found");
            };
            case (?message) {
                let deletedMessage = wall.remove(messageId);
                return #ok();   
            };
        };
    };


    // Voting
    public shared func upVote(messageId : Nat) : async Result.Result<(), Text> {

        let message : ?Message = wall.get(messageId);

        switch (message) {
            case (null) {
                return #err("Message not found");
            };
            case (?message) {
                let newMessage = {
                    vote = message.vote + 1;
                    content = message.content;
                    creator = message.creator;
                };
                wall.put(messageId, newMessage);
                return #ok();   
            };
        };
    };

    public shared func downVote(messageId : Nat) : async Result.Result<(), Text> {

        let message : ?Message = wall.get(messageId);

        switch (message) {
            case (null) {
                return #err("Message not found");
            };
            case (?message) {
                if(message.vote > 0) {
                    let newMessage = {
                        vote = message.vote - 1;
                        content = message.content;
                        creator = message.creator;
                    };
                    wall.put(messageId, newMessage);
                };
                return #ok();   
            };
        };
    };


    //Get all messages
    public shared query func getAllMessages() : async [Message] {
        let array : [Message] = Iter.toArray(wall.vals());
        return array;
    };


    type Order = Order.Order;
    func compareMessage(m1 : Message, m2 : Message) : Order {
        if(m1.vote == m2.vote) {
            return #equal;
        } else if(m1.vote > m2.vote) {
            return #less;
        } else {
            return #greater;
        };
    };

    public shared query func getAllMessagesRanked() : async [Message] {
        let array : [Message] = Iter.toArray(wall.vals());
        return Array.sort<Message>(array, compareMessage);
    };

};
