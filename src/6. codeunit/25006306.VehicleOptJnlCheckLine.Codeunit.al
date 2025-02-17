codeunit 25006306 "Vehicle Opt. Jnl.-Check Line"
{
    // //==================================================================================================================================
    // MërÒis: Pirms grâmato³anas pârbaudît ¹urnâla rindu uz pareizîbu.
    // //==================================================================================================================================

    TableNo = 25006387;

    trigger OnRun()
    begin
        recGLSetup.GET;
        fRunCheck(Rec);
    end;

    var
        Text000: Label 'cannot be a closing date';
        Text001: Label 'is not within your range of allowed posting dates';
        recUserSetup: Record "91";
        datAllowPostingFrom: Date;
        datAllowPostingTo: Date;
        recGLSetup: Record "98";

    [Scope('Internal')]
    procedure fRunCheck(var recVehOptJnlLine: Record "25006387")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        recVehOptJnlLine5: Record "25006387";
        recVehicle: Record "25006005";
    begin
        //Pârbaudam datumus
        recVehOptJnlLine.TESTFIELD("Posting Date");
        recVehOptJnlLine.TESTFIELD("Document No.");
        IF recVehOptJnlLine."Posting Date" <> NORMALDATE(recVehOptJnlLine."Posting Date") THEN
            recVehOptJnlLine.FIELDERROR("Posting Date", Text000);

        recVehOptJnlLine.TESTFIELD("Vehicle Serial No.");
        recVehOptJnlLine.TESTFIELD("Make Code");
        recVehOptJnlLine.TESTFIELD("Model Code");
        recVehOptJnlLine.TESTFIELD("Model Version No.");

        //Pârbaudam grâmato³anas datuma robe¹as
        recGLSetup.GET;
        IF (datAllowPostingFrom = 0D) AND (datAllowPostingTo = 0D) THEN BEGIN
            IF USERID <> '' THEN
                IF recUserSetup.GET(USERID) THEN BEGIN
                    datAllowPostingFrom := recUserSetup."Allow Posting From";
                    datAllowPostingTo := recUserSetup."Allow Posting To";
                END;
            IF (datAllowPostingFrom = 0D) AND (datAllowPostingTo = 0D) THEN BEGIN
                datAllowPostingFrom := recGLSetup."Allow Posting From";
                datAllowPostingTo := recGLSetup."Allow Posting To";
            END;
            IF datAllowPostingTo = 0D THEN
                datAllowPostingTo := 12319999D;
        END;
        IF (recVehOptJnlLine."Posting Date" < datAllowPostingFrom) OR (recVehOptJnlLine."Posting Date" > datAllowPostingTo) THEN
            recVehOptJnlLine.FIELDERROR("Posting Date", Text001);

        IF (recVehOptJnlLine."Document Date" <> 0D) THEN
            IF (recVehOptJnlLine."Document Date" <> NORMALDATE(recVehOptJnlLine."Document Date")) THEN
                recVehOptJnlLine.FIELDERROR("Document Date", Text000);

        IF recVehOptJnlLine."Entry Type" = recVehOptJnlLine."Entry Type"::Disassemble THEN
            recVehOptJnlLine.TESTFIELD("Applies-to Entry");
        IF (recVehOptJnlLine."Entry Type" = recVehOptJnlLine."Entry Type"::Assemble) AND recVehOptJnlLine.Correction THEN
            recVehOptJnlLine.TESTFIELD("Applies-to Entry");

        recVehicle.RESET;
        recVehicle.SETCURRENTKEY("Serial No.");
        recVehicle.SETRANGE("Serial No.", recVehOptJnlLine."Vehicle Serial No.");
        IF recVehicle.FINDFIRST THEN BEGIN
            recVehicle.TESTFIELD("Make Code", recVehOptJnlLine."Make Code");
            recVehicle.TESTFIELD("Model Code", recVehOptJnlLine."Model Code");
            recVehicle.TESTFIELD("Model Version No.", "Model Version No.");
            IF recVehOptJnlLine."Option Type" = recVehOptJnlLine."Option Type"::"Own Option" THEN BEGIN
                recVehicle.CALCFIELDS(Inventory);
                recVehicle.TESTFIELD(recVehicle.Inventory, 1);
            END;
        END;
    end;
}

