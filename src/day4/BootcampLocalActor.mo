import Principal "mo:base/Principal";

actor class BootcampLocalActor() {
    public query func getAllStudentsPrincipal() : async [Principal] {
        return [Principal.fromText("wo5qg-ysjiq-5da"), Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai")];
    }
}