codeunit 25006106 "Serv. Jnl.-Check Line"
{
    // 2012.03.12 EDMS P8
    //   * Tire Management implement

    TableNo = 25006165;

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
    procedure RunCheck(var ServJnlLine: Record "25006165")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        IF EmptyLine THEN
            EXIT;

        ServJnlLine.TESTFIELD("Vehicle Serial No.");
        ServJnlLine.TESTFIELD("Posting Date");
        ServJnlLine.TESTFIELD("Make Code");
        ServJnlLine.TESTFIELD("Model Code");
        ServJnlLine.TESTFIELD("Gen. Prod. Posting Group");
        IF Type <> Type::" " THEN //Sipradi-YS
            ServJnlLine.TESTFIELD(Quantity);

        IF ServJnlLine."Posting Date" <> NORMALDATE(ServJnlLine."Posting Date") THEN
            ServJnlLine.FIELDERROR("Posting Date", Text000);

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
        IF (ServJnlLine."Posting Date" < AllowPostingFrom) OR (ServJnlLine."Posting Date" > AllowPostingTo) THEN
            ServJnlLine.FIELDERROR("Posting Date", Text001);

        IF ("Document Date" <> 0D) THEN
            IF ("Document Date" <> NORMALDATE("Document Date")) THEN
                ServJnlLine.FIELDERROR("Document Date", Text000);


        //2012.03.12 EDMS P8 >>
        IF ("Vehicle Axle Code" <> '') OR ("Tire Position Code" <> '') OR ("Tire Code" <> '') OR
          ("Tire Operation Type" > 0) OR ("New Vehicle Axle Code" <> '') OR ("New Tire Position Code" <> '') THEN BEGIN
            // ,Put on,Take off,Position Change
            ServJnlLine.TESTFIELD("Vehicle Axle Code");
            ServJnlLine.TESTFIELD("Tire Position Code");
            IF "Tire Operation Type" = "Tire Operation Type"::"Position Change" THEN BEGIN
                ServJnlLine.TESTFIELD("New Vehicle Axle Code");
                ServJnlLine.TESTFIELD("New Tire Position Code");
            END;
            IF "Tire Operation Type" = "Tire Operation Type"::"Put on" THEN
                ServJnlLine.TESTFIELD("Tire Code");
        END;
        //2012.03.12 EDMS P8 <<
    end;
}

