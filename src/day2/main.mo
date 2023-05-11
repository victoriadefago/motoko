import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Text "mo:base/Text";

actor Homework {

    public type Time = Time.Time;
    public type Homework = {
        title : Text;
        description : Text;
        dueDate : Time;
        completed : Bool
    };

    var homeworkDiary = Buffer.Buffer<Homework>(0);

    public shared func addHomework(homework : Homework) : async Nat {
        var id = homeworkDiary.size();
        homeworkDiary.add(homework);
        return id;
    };


    public shared query func getHomework(id : Nat) : async Result.Result<Homework, Text> {
        if(id < homeworkDiary.size()) {
            return #ok(homeworkDiary.get(id));
        } else {
            return #err("Homework not found")
        }
    };


    public shared func updateHomework(id: Nat, homework: Homework) : async Result.Result<(), Text> {
        if(id >= homeworkDiary.size()) {
            return #err("Homework not found");
        };
        
        let homeworkUpdated = {
            title = homework.title;
            description = homework.description;
            dueDate = homework.dueDate;
            completed = homework.completed;
        };

        homeworkDiary.put(id, homeworkUpdated);
        return #ok();  
    };


    public shared func markAsCompleted(id: Nat) : async Result.Result<(), Text> {
        if(id >= homeworkDiary.size()) {
            return #err("Homework not found")
        };

        let homework : Homework = homeworkDiary.get(id);
        let newHomework = {
            title = homework.title;
            description = homework.description;
            dueDate = homework.dueDate;
            completed = true;
        };

        homeworkDiary.put(id, newHomework);
        return #ok();   
    };


    public shared func deleteHomework(id: Nat) : async Result.Result<(), Text> {
        if(id >= homeworkDiary.size()) {
            return #err("Homework not found")
        };

        let deletedHomework = homeworkDiary.remove(id);
        return #ok();   
    };


    public shared query func getAllHomework() : async [Homework] {
        return Buffer.toArray(homeworkDiary);
    };


    public shared query func getPendingHomework() : async [Homework] {
        let newBuffer = Buffer.clone(homeworkDiary);
        newBuffer.filterEntries(func(_, x) = (x.completed == false));
        return Buffer.toArray(newBuffer);
    };

    public shared query func searchHomework(searchTerm : Text) : async [Homework] {
        let newBuffer = Buffer.clone(homeworkDiary);
        newBuffer.filterEntries(func(_, x) = (Text.contains(x.title, #text searchTerm) or Text.contains(x.description, #text searchTerm)));
        return Buffer.toArray(newBuffer);
    };

};