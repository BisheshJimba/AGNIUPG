codeunit 33020035 "Gate Entry- Post"
{
    TableNo = 33020035;

    trigger OnRun()
    begin
        GateEntryHeader := Rec;
        GateEntryHeader.TESTFIELD("Posting Date");
        GateEntryHeader.TESTFIELD("Document Date");

        GateEntryLine.RESET;
        GateEntryLine.SETRANGE("Entry Type", GateEntryHeader."Entry Type");
        GateEntryLine.SETRANGE("Gate Entry No.", GateEntryHeader."No.");
        IF NOT GateEntryLine.FIND('-') THEN
            ERROR(Text16500);

        IF GateEntryLine.FINDSET THEN
            REPEAT
                IF GateEntryLine."Source Type" <> GateEntryLine."Source Type"::" " THEN
                    GateEntryLine.TESTFIELD("Source No.");
                IF GateEntryLine."Source Type" = GateEntryLine."Source Type"::" " THEN
                    GateEntryLine.TESTFIELD(GateEntryHeader.Description);
            UNTIL GateEntryLine.NEXT = 0;

        IF GUIALLOWED THEN
            Window.OPEN(
            '#1###########################\\' +
            Text16501);
        IF GUIALLOWED THEN
            Window.UPDATE(1, STRSUBSTNO('%1 %2', Text16502, GateEntryHeader."No."));

        IF "Posting No. Series" = '' THEN BEGIN
            GateEntryLocSetup.GET(GateEntryHeader."Entry Type", GateEntryHeader."Location Code");
            "Posting No. Series" := GateEntryLocSetup."Posting No. Series";
            GateEntryHeader.MODIFY;
            COMMIT;
        END;
        IF "Posting No." = '' THEN BEGIN
            "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", "Posting Date", TRUE);
            ModifyHeader := TRUE;
        END;
        IF ModifyHeader THEN BEGIN
            GateEntryHeader.MODIFY;
            COMMIT;
        END;

        IF GateEntryHeader.RECORDLEVELLOCKING THEN
            GateEntryLine.LOCKTABLE;

        PostedGateEntryHeader.INIT;
        PostedGateEntryHeader.TRANSFERFIELDS(GateEntryHeader);
        PostedGateEntryHeader."No." := GateEntryHeader."Posting No.";
        PostedGateEntryHeader."No. Series" := GateEntryHeader."Posting No. Series";
        PostedGateEntryHeader."Gate Entry No." := GateEntryHeader."No.";

        IF GUIALLOWED THEN
            Window.UPDATE(1, STRSUBSTNO(Text16503, GateEntryHeader."No.", PostedGateEntryHeader."No."));
        PostedGateEntryHeader.INSERT;

        // Posting Comments to posted tables.
        CopyCommentLines(GateEntryHeader."Entry Type", GateEntryHeader."Entry Type", GateEntryHeader."No.", PostedGateEntryHeader."No.");

        GateEntryLine.RESET;
        GateEntryLine.SETRANGE("Entry Type", GateEntryHeader."Entry Type");
        GateEntryLine.SETRANGE("Gate Entry No.", GateEntryHeader."No.");
        LineCount := 0;
        IF GateEntryLine.FINDSET THEN
            REPEAT
                LineCount += 1;
                IF GUIALLOWED THEN
                    Window.UPDATE(2, LineCount);
                PostedGateEntryLine.INIT;
                PostedGateEntryLine.TRANSFERFIELDS(GateEntryLine);
                PostedGateEntryLine."Entry Type" := PostedGateEntryHeader."Entry Type";
                PostedGateEntryLine."Gate Entry No." := PostedGateEntryHeader."No.";
                PostedGateEntryLine.INSERT;
            UNTIL GateEntryLine.NEXT = 0;

        IF NOT GateEntryHeader.RECORDLEVELLOCKING THEN
            GateEntryLine.LOCKTABLE(TRUE, TRUE);
        GateEntryHeader.DELETE;
        GateEntryLine.DELETEALL;
        IF GUIALLOWED THEN
            Window.CLOSE;
        Rec := GateEntryHeader;
    end;

    var
        GateEntryHeader: Record "33020035";
        GateEntryLine: Record "33020036";
        PostedGateEntryHeader: Record "33020038";
        PostedGateEntryLine: Record "33020039";
        Text16500: Label 'There is nothing to post.';
        Text16501: Label 'Posting Lines #2######\';
        Text16502: Label 'Gate Entry.';
        Text16503: Label 'Gate Entry %1 -> Posted Gate Entry %2.';
        GateEntryLocSetup: Record "33020037";
        GateEntryCommentLine: Record "33020042";
        GateEntryCommentLine2: Record "33020042";
        NoSeriesMgt: Codeunit "396";
        Window: Dialog;
        ModifyHeader: Boolean;
        LineCount: Integer;

    [Scope('Internal')]
    procedure CopyCommentLines(FromEntryType: Integer; ToEntryType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    begin
        GateEntryCommentLine.SETRANGE("Gate Entry Type", FromEntryType);
        GateEntryCommentLine.SETRANGE("No.", FromNumber);
        IF GateEntryCommentLine.FINDSET THEN
            REPEAT
                GateEntryCommentLine2 := GateEntryCommentLine;
                GateEntryCommentLine2."Gate Entry Type" := ToEntryType;
                GateEntryCommentLine2."No." := ToNumber;
                GateEntryCommentLine2.INSERT;
            UNTIL GateEntryCommentLine.NEXT = 0;
    end;
}

