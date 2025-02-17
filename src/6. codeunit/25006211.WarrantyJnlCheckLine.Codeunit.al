codeunit 25006211 "Warranty Jnl.-Check Line"
{
    TableNo = 25006206;

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
    procedure RunCheck(var WarrantyJnlLine: Record "25006206")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        IF EmptyLine THEN
            EXIT;

        //TESTFIELD("Vehicle Serial No.");
        WarrantyJnlLine.TESTFIELD("Posting Date");
        //TESTFIELD("Make Code");
        //TESTFIELD("Model Code");

        IF WarrantyJnlLine."Posting Date" <> NORMALDATE(WarrantyJnlLine."Posting Date") THEN
            WarrantyJnlLine.FIELDERROR("Posting Date", Text000);

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
        IF (WarrantyJnlLine."Posting Date" < AllowPostingFrom) OR (WarrantyJnlLine."Posting Date" > AllowPostingTo) THEN
            WarrantyJnlLine.FIELDERROR("Posting Date", Text001);

        IF (WarrantyJnlLine."Document Date" <> 0D) THEN
            IF (WarrantyJnlLine."Document Date" <> NORMALDATE(WarrantyJnlLine."Document Date")) THEN
                WarrantyJnlLine.FIELDERROR("Document Date", Text000);
    end;
}

