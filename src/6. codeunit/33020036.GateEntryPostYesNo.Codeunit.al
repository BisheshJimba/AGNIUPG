codeunit 33020036 "Gate Entry- Post (Yes/No)"
{
    TableNo = 33020035;

    trigger OnRun()
    begin
        GateEntryHeader.COPY(Rec);
        Code;
        Rec := GateEntryHeader;
        MESSAGE(Text16501);
    end;

    var
        Text16500: Label 'Do you want to Post the Gate Entry?';
        GateEntryHeader: Record "33020035";
        GateEntryPost: Codeunit "33020035";
        Text16501: Label 'Gate Entry Posted successfully.';

    local procedure "Code"()
    begin
        IF NOT CONFIRM(Text16500, FALSE) THEN
            EXIT;
        GateEntryPost.RUN(GateEntryHeader);
        COMMIT;
    end;
}

