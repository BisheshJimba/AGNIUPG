codeunit 25006110 "Ext. Service Jnl.-Check Line"
{
    TableNo = 25006143;

    trigger OnRun()
    begin
        GLSetup.GET;

        RunCheck(Rec);
    end;

    var
        Text000: Label 'cannot be a closing date';
        Text001: Label 'is not within your range of allowed posting dates';
        GLSetup: Record "98";
        UserSetup: Record "91";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;

    [Scope('Internal')]
    procedure RunCheck(var ExtServiceJnlLine: Record "25006143")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin

        ExtServiceJnlLine.TESTFIELD("Ext. Service No.");
        ExtServiceJnlLine.TESTFIELD("Posting Date");
        ExtServiceJnlLine.TESTFIELD(Quantity);

        IF ExtServiceJnlLine."Posting Date" <> NORMALDATE(ExtServiceJnlLine."Posting Date") THEN
            ExtServiceJnlLine.FIELDERROR("Posting Date", Text000);

        IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
            IF USERID <> '' THEN
                IF UserSetup.GET(USERID) THEN BEGIN
                    AllowPostingFrom := UserSetup."Allow Posting From";
                    AllowPostingTo := UserSetup."Allow Posting To";
                END;
            IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                GLSetup.GET;
                AllowPostingFrom := GLSetup."Allow Posting From";
                AllowPostingTo := GLSetup."Allow Posting To";
            END;
            IF AllowPostingTo = 0D THEN
                AllowPostingTo := 12319999D;
        END;
        IF (ExtServiceJnlLine."Posting Date" < AllowPostingFrom) OR (ExtServiceJnlLine."Posting Date" > AllowPostingTo) THEN
            ExtServiceJnlLine.FIELDERROR("Posting Date", Text001);
    end;
}

