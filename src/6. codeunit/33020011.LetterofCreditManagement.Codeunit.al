codeunit 33020011 "Letter of Credit Management"
{
    // *** Inserted code to check the expiry date of the amended LC details if LC amended SM 06/11/2013


    trigger OnRun()
    begin
    end;

    var
        GlobalLCTerms: Record "33020014";
        GlobalLCDetails: Record "33020012";
        GlobalLCADetails: Record "33020013";
        GlobalLCADetails1: Record "33020013";
        GlobalLCAmmendments: Page "33020014";
        Text33020011: Label 'Do you want to Release?';
        Text33020012: Label 'The LC has been Released.';
        Text33020013: Label 'The LC is already Released.';
        Text33020014: Label 'Do you want to Amend this Document ?';
        Text33020015: Label 'Without releasing the previous amendment you cannot Amend again.';
        Text33020016: Label 'You cannot Amended without releasing the document.';
        Text33020017: Label 'Cannot Amend LC %1. Status is closed.';
        Text33020018: Label 'The LC has been closed.';
        Text33020019: Label 'The LC is already closed.';
        Text33020020: Label 'Do you want to close LC ?';
        Text33020021: Label 'The LC Amendment has been Released.';
        Text33020022: Label 'The LC Amendment is already Released.';
        Text33020023: Label 'Do you want to Release Amendment?';
        Text33020024: Label 'Do you want to close LC Amendment ?';
        GblLCANo: Code[20];
        Text33020025: Label 'Do you want to reopen LC ?';

    [Scope('Internal')]
    procedure ReleaseLC(ParmLCDetail: Record "33020012")
    begin
        IF CONFIRM(Text33020011) THEN
            IF NOT Released THEN BEGIN
                ParmLCDetail.TESTFIELD("Date of Issue");
                ParmLCDetail.TESTFIELD("Expiry Date");
                ParmLCDetail.TESTFIELD("LC\BG Value");
                ParmLCDetail.TESTFIELD("LC\DO No.");
                /*
                IF "Type of LC" = "Type of LC"::Inland THEN
                  TESTFIELD("Currency Code");
                  */
                Released := TRUE;
                ParmLCDetail.MODIFY;
                GlobalLCTerms.SETRANGE("LC No.", ParmLCDetail."No.");
                IF GlobalLCTerms.FIND('-') THEN BEGIN
                    GlobalLCTerms.Released := TRUE;
                    GlobalLCTerms.MODIFY;
                END;
                MESSAGE(Text33020012);
            END ELSE
                MESSAGE(Text33020012)
        ELSE
            EXIT;

    end;

    [Scope('Internal')]
    procedure AmendLC(ParmLCDetail: Record "33020012")
    var
        LCAmendDetails: Record "33020013";
        LCDetails: Record "33020012";
    begin
        IF Released THEN BEGIN
            CLEAR(GlobalLCAmmendments);
            IF Closed THEN
                ERROR(Text33020017, ParmLCDetail."LC\DO No.");
            IF CONFIRM(Text33020014) THEN BEGIN
                GlobalLCADetails.SETRANGE("No.", ParmLCDetail."No.");
                IF NOT GlobalLCADetails.FIND('-') THEN BEGIN    //If amendment is not found for this LC.
                    GlobalLCADetails1.INIT;
                    GlobalLCADetails1."Version No." := getLCAVersionNo(ParmLCDetail."No.");
                    GlobalLCADetails1."No." := ParmLCDetail."No.";
                    //GlobalLCADetails1.INSERT(TRUE);
                    GlobalLCADetails1."LC No." := ParmLCDetail."LC\DO No.";
                    GlobalLCADetails1.Description := ParmLCDetail.Description;
                    GlobalLCADetails1."Transaction Type" := ParmLCDetail."Transaction Type";
                    GlobalLCADetails1."Issued To/Received From" := ParmLCDetail."Issued To/Received From";
                    GlobalLCADetails1."Issuing Bank" := ParmLCDetail."Issuing Bank";
                    GlobalLCADetails1."Date of Issue" := "Date of Issue";
                    GlobalLCADetails1."Type of LC" := "Type of LC";
                    GlobalLCADetails1."Type of Credit Limit" := "Type of Credit Limit";
                    GlobalLCADetails1."Revolving Cr. Limit Type" := "Revolving Cr. Limit Type";
                    GlobalLCADetails1."Currency Code" := "Currency Code";
                    GlobalLCADetails1."Previous LC Value" := "LC\BG Value";
                    GlobalLCADetails1."Exchange Rate" := "Exchange Rate";
                    GlobalLCADetails1."Receiving Bank" := "Receiving Bank";
                    GlobalLCADetails1."Amended Date" := TODAY;
                    GlobalLCADetails1."Vehicle Category" := "Vehicle Category";
                    GlobalLCADetails1."Vehicle Division" := "Vehicle Division";
                    GlobalLCADetails1."Tolerance Percentage" := "Tolerance Percentage";
                    GlobalLCADetails1."Issued To/Received From Name" := "Issued To/Received From Name";
                    GlobalLCADetails1."Issue Bank Name1" := "Issue Bank Name1";
                    GlobalLCADetails1."Issue Bank Name2" := "Issue Bank Name2"; //**SM 08/08/2013 to bring name2 of lc issuing bank
                    GlobalLCADetails1."Receiving Bank Name" := "Receiving Bank Name";
                    GlobalLCADetails1.INSERT(TRUE);
                    //GlobalLCADetails1.MODIFY;
                    updateLastLCAmdNo(ParmLCDetail."No.", GlobalLCADetails1."Version No.");
                    COMMIT;
                END ELSE BEGIN              //If amendment is found for this LC.
                    GlobalLCADetails.FIND('+');
                    IF NOT GlobalLCADetails.Released THEN
                        ERROR(Text33020015);
                    GlobalLCADetails1.INIT;
                    GlobalLCADetails1."Version No." := getLCAVersionNo(ParmLCDetail."No.");
                    GlobalLCADetails1."No." := ParmLCDetail."No.";
                    //GlobalLCADetails1.INSERT(TRUE);
                    GlobalLCADetails1."LC No." := GlobalLCADetails."LC No.";
                    GlobalLCADetails1.Description := GlobalLCADetails.Description;
                    GlobalLCADetails1."Transaction Type" := GlobalLCADetails."Transaction Type";
                    GlobalLCADetails1."Issued To/Received From" := GlobalLCADetails."Issued To/Received From";
                    GlobalLCADetails1."Issuing Bank" := GlobalLCADetails."Issuing Bank";
                    GlobalLCADetails1."Date of Issue" := GlobalLCADetails."Date of Issue";
                    GlobalLCADetails1."Type of Credit Limit" := GlobalLCADetails."Type of Credit Limit";
                    GlobalLCADetails1."Type of LC" := GlobalLCADetails."Type of LC";
                    GlobalLCADetails1."Currency Code" := GlobalLCADetails."Currency Code";
                    GlobalLCADetails1."Previous LC Value" := GlobalLCADetails."LC Value";
                    GlobalLCADetails1."Exchange Rate" := GlobalLCADetails."Exchange Rate";
                    GlobalLCADetails1."Receiving Bank" := GlobalLCADetails."Receiving Bank";
                    GlobalLCADetails1."Tolerance Percentage" := GlobalLCADetails."Tolerance Percentage";
                    GlobalLCADetails1."Issued To/Received From Name" := ParmLCDetail."Issued To/Received From Name";
                    GlobalLCADetails1."Issue Bank Name1" := ParmLCDetail."Issue Bank Name1";
                    GlobalLCADetails1."Receiving Bank Name" := ParmLCDetail."Receiving Bank Name";
                    GlobalLCADetails1."Vehicle Division" := ParmLCDetail."Vehicle Division";
                    GlobalLCADetails1."Vehicle Category" := "Vehicle Category";
                    GlobalLCADetails1."Amended Date" := TODAY;
                    GlobalLCADetails1.INSERT(TRUE);
                    //GlobalLCADetails1.MODIFY;
                    updateLastLCAmdNo(ParmLCDetail."No.", GlobalLCADetails1."Version No.");
                    COMMIT;
                END;
                GlobalLCAmmendments.SETTABLEVIEW(GlobalLCADetails1);
                GlobalLCAmmendments.SETRECORD(GlobalLCADetails1);
                GlobalLCAmmendments.LOOKUPMODE(TRUE);
                IF GlobalLCAmmendments.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    GlobalLCAmmendments.GETRECORD(GlobalLCADetails1);
                    CLEAR(GlobalLCAmmendments);
                END;
            END ELSE
                EXIT;
        END ELSE
            MESSAGE(Text33020016);
    end;

    [Scope('Internal')]
    procedure CloseLC(ParmLCDetail: Record "33020012")
    begin
        //Code to Close LC Details.
        IF CONFIRM(Text33020020) THEN
            IF NOT Closed THEN BEGIN
                ParmLCDetail.TESTFIELD(Released);
                Closed := TRUE;
                ParmLCDetail.MODIFY;
                GlobalLCADetails.RESET;
                GlobalLCADetails.SETRANGE("No.", ParmLCDetail."No.");
                IF GlobalLCADetails.FIND('-') THEN
                    REPEAT
                        GlobalLCADetails.Closed := TRUE;
                        GlobalLCADetails.MODIFY;
                    UNTIL GlobalLCADetails.NEXT = 0;
                GlobalLCTerms.SETRANGE("LC No.", ParmLCDetail."No.");
                IF GlobalLCTerms.FIND('-') THEN BEGIN
                    GlobalLCTerms.Released := TRUE;
                    GlobalLCTerms.MODIFY;
                END;
                MESSAGE(Text33020018);
            END ELSE
                MESSAGE(Text33020019)
        ELSE
            EXIT;
    end;

    [Scope('Internal')]
    procedure AmendedLCRelease(ParmLCAmendments: Record "33020013")
    begin
        //Code to release Amended LC.
        IF CONFIRM(Text33020023) THEN
            IF NOT Released THEN BEGIN
                ParmLCAmendments.TESTFIELD("Expiry Date");
                ParmLCAmendments.TESTFIELD("Starting Date");
                ParmLCAmendments.TESTFIELD("Bank Amended No.");
                ParmLCAmendments.TESTFIELD("LC Value");
                Released := TRUE;
                ParmLCAmendments.MODIFY;
                MESSAGE(Text33020021);
            END ELSE
                MESSAGE(Text33020022)
        ELSE
            EXIT;
    end;

    [Scope('Internal')]
    procedure InsertLCOrderDetails(PrmPurchOrder: Record "38")
    var
        LocalLCDetail: Record "33020012";
        LocalLCAmendDetail: Record "33020013";
        Text33020011: Label 'Expected Receipt date is greater than LC Expiry Date. Please contact your system administrator.';
        LocalLCOrder: Record "33020018";
    begin
        //Inserting LC Order details while receiving vehicles.
        LocalLCDetail.GET(PrmPurchOrder."Sys. LC No.");

        //*** Inserted code to check the expiry date of the amended LC details if LC amended SM 06/11/2013
        IF NOT LocalLCDetail."Has Amendment" THEN BEGIN
            IF PrmPurchOrder."Expected Receipt Date" > LocalLCDetail."Expiry Date" THEN
                ERROR(Text33020011);
        END
        ELSE BEGIN
            LocalLCAmendDetail.RESET;
            LocalLCAmendDetail.SETRANGE("LC No.", PrmPurchOrder."Sys. LC No.");
            IF LocalLCAmendDetail.FINDLAST THEN BEGIN
                IF PrmPurchOrder."Expected Receipt Date" > LocalLCAmendDetail."Expiry Date" THEN
                    ERROR(Text33020011);
            END;
        END;

        //IF PrmPurchOrder."Expected Receipt Date" > LocalLCDetail."Expiry Date" THEN
        //  ERROR(Text33020011);

        LocalLCOrder.SETRANGE("LC No.", PrmPurchOrder."Sys. LC No.");
        LocalLCOrder.SETRANGE("Order No.", PrmPurchOrder."No.");
        IF NOT LocalLCOrder.FIND('-') THEN BEGIN
            PrmPurchOrder.CALCFIELDS(Amount);
            LocalLCOrder.INIT;
            LocalLCOrder."LC No." := LocalLCDetail."No.";
            LocalLCOrder."Bank LC No." := LocalLCDetail."LC\DO No.";
            LocalLCOrder."Trasaction Type" := LocalLCDetail."Transaction Type";
            LocalLCOrder."Issued To/Received From" := LocalLCDetail."Issued To/Received From";
            LocalLCOrder."Order No." := PrmPurchOrder."No.";
            LocalLCOrder."Shipment Date" := PrmPurchOrder."Expected Receipt Date";
            LocalLCOrder."Order Value" := PrmPurchOrder.Amount;
            LocalLCOrder.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure getLCAVersionNo(PrmLCNo: Code[20]): Code[10]
    var
        LclLCDetail: Record "33020012";
    begin
        //Returning LC Amend No.
        LclLCDetail.RESET;
        LclLCDetail.SETRANGE("No.", PrmLCNo);
        IF LclLCDetail.FIND('-') THEN BEGIN
            IF (LclLCDetail."Last Used Amendment No." <> '') THEN
                GblLCANo := INCSTR(LclLCDetail."Last Used Amendment No.")
            ELSE
                GblLCANo := '00001';
        END;

        EXIT(GblLCANo);
    end;

    [Scope('Internal')]
    procedure updateLastLCAmdNo(PrmLCNo: Code[20]; PrmNewLCAmdNo: Code[20]): Code[10]
    var
        LclLCDetail: Record "33020012";
    begin
        //Updating LC Details - Last Amendment No.
        LclLCDetail.RESET;
        LclLCDetail.SETRANGE("No.", PrmLCNo);
        IF LclLCDetail.FIND('-') THEN BEGIN
            LclLCDetail."Last Used Amendment No." := PrmNewLCAmdNo;
            LclLCDetail.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure ReopenLC(ParmLCDetail: Record "33020012")
    begin
        //Code to Reopen LC Details.
        IF CONFIRM(Text33020025) THEN
            IF Closed THEN BEGIN
                Closed := FALSE;
                ParmLCDetail.MODIFY;
                GlobalLCADetails.RESET;
                GlobalLCADetails.SETRANGE("No.", ParmLCDetail."No.");
                IF GlobalLCADetails.FIND('-') THEN
                    REPEAT
                        GlobalLCADetails.Closed := FALSE;
                        GlobalLCADetails.MODIFY;
                    UNTIL GlobalLCADetails.NEXT = 0;
                GlobalLCTerms.SETRANGE("LC No.", ParmLCDetail."No.");
                IF GlobalLCTerms.FIND('-') THEN BEGIN
                    GlobalLCTerms.Released := TRUE;
                    GlobalLCTerms.MODIFY;
                END;
                MESSAGE('The LC has been reopened.');
            END ELSE
                MESSAGE('This LC is already open.')
        ELSE
            EXIT;
    end;
}

