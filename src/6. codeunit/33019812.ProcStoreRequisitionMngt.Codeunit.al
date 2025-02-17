codeunit 33019812 "Proc. - Store Requisition Mngt"
{

    trigger OnRun()
    begin
    end;

    var
        GblVenorNo: Code[20];
        GblVenorNo2: Code[20];
        GblPurchOrderNo: array[5] of Code[20];
        j: Integer;

    [Scope('Internal')]
    procedure getDataStrReqSmry(PrmStrReqSmryHdr: Record "33019812")
    var
        LclStrReqSmryLine: Record "33019813";
    begin
        //Checking for vendor changes and planning accordingly.
        LclStrReqSmryLine.RESET;
        LclStrReqSmryLine.SETRANGE("Integration Type", PrmStrReqSmryHdr."Category Code");
        IF LclStrReqSmryLine.FIND('-') THEN BEGIN
            j := 1;                                             //Initializing j variable.
            REPEAT
                GblVenorNo := LclStrReqSmryLine."Vendor No.";
                IF (GblVenorNo <> GblVenorNo2) THEN BEGIN
                    GblVenorNo2 := GblVenorNo;
                    createPurchOrder(GblVenorNo2, PrmStrReqSmryHdr."Category Code");
                END;
            UNTIL LclStrReqSmryLine.NEXT = 0;
        END;

        //Calling function to update Store requisition summary status.
        updateStrReqSmryStatus(PrmStrReqSmryHdr);

        //Calling function to show completion message.
        showCompletionMsg;
    end;

    [Scope('Internal')]
    procedure createPurchOrder(PrmVndNo: Code[20]; PrmSummaryNo: Code[10])
    var
        LclStrReqSmryLine: Record "33019813";
        LclOrderNo: Code[20];
    begin
        //Creating Purchase order according to vendor and checking for FA and creating FA card.
        LclStrReqSmryLine.RESET;
        LclStrReqSmryLine.SETRANGE("Integration Type", PrmSummaryNo);
        LclStrReqSmryLine.SETRANGE("Vendor No.", PrmVndNo);
        IF LclStrReqSmryLine.FIND('-') THEN BEGIN
            LclOrderNo := createPurchHdr(LclStrReqSmryLine."Vendor No.");
            GblPurchOrderNo[j] := LclOrderNo;
            j := j + 1;                                         //Updating j variable to update Array index.
            REPEAT
                createPurchLine(LclOrderNo, LclStrReqSmryLine);
                //Calling function to update status of Store Requisition.
                updateStrReqStatusOnOrder(LclStrReqSmryLine);
            UNTIL LclStrReqSmryLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure createPurchHdr(PrmVndNo: Code[20]): Code[20]
    var
        LclPurchHdr: Record "38";
    begin
        //Creating Purchase Header.
        LclPurchHdr.INIT;
        LclPurchHdr."Document Type" := LclPurchHdr."Document Type"::Order;
        LclPurchHdr.VALIDATE("Buy-from Vendor No.", PrmVndNo);
        LclPurchHdr.INSERT(TRUE);
        EXIT(LclPurchHdr."No.");
    end;

    [Scope('Internal')]
    procedure createPurchLine(PrmOrderNo: Code[20]; PrmStrReqSmryLine: Record "33019813")
    var
        LclStrReqSmryLine: Record "33019813";
        LclPurchLine: Record "39";
        i: Integer;
        LclFANo: Code[20];
    begin
        //Creating Purchase Line.
        IF (PrmStrReqSmryLine."Is Fixed Asset") THEN BEGIN
            FOR i := 1 TO PrmStrReqSmryLine.Quantity DO BEGIN
                LclPurchLine.INIT;
                LclPurchLine."Document Type" := LclPurchLine."Document Type"::Order;
                LclPurchLine."Document No." := PrmOrderNo;
                LclPurchLine."Line No." := getPurchLineNo(PrmOrderNo) + 10000;
                LclFANo := createFixedAsset(PrmStrReqSmryLine."Transaction per Batch", PrmStrReqSmryLine."Vendor No.");
                LclPurchLine.Type := LclPurchLine.Type::"Fixed Asset";
                LclPurchLine.VALIDATE("No.", LclFANo);
                LclPurchLine.VALIDATE("Location Code", getLocation);
                LclPurchLine."Shortcut Dimension 1 Code" := getDim1Code;
                LclPurchLine."Shortcut Dimension 2 Code" := getDim2Code;
                LclPurchLine.VALIDATE(Quantity, 1);
                LclPurchLine."Summary No." := PrmStrReqSmryLine."Integration Type";
                LclPurchLine.INSERT(TRUE);
            END;
        END ELSE BEGIN
            LclPurchLine.INIT;
            LclPurchLine."Document Type" := LclPurchLine."Document Type"::Order;
            LclPurchLine."Document No." := PrmOrderNo;
            LclPurchLine."Line No." := getPurchLineNo(PrmOrderNo) + 10000;
            LclPurchLine.Type := LclPurchLine.Type::Item;
            LclPurchLine.VALIDATE("No.", PrmStrReqSmryLine."Category Purpose");
            LclPurchLine.VALIDATE("Location Code", getLocation);
            LclPurchLine."Shortcut Dimension 1 Code" := getDim1Code;
            LclPurchLine."Shortcut Dimension 2 Code" := getDim2Code;
            LclPurchLine.VALIDATE(Quantity, PrmStrReqSmryLine.Quantity);
            LclPurchLine."Summary No." := PrmStrReqSmryLine."Integration Type";
            LclPurchLine.INSERT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure createFixedAsset(PrmItemDesc: Text[30]; PrmVndNo: Code[20]): Code[20]
    var
        LclFixedAsset: Record "5600";
        LclFADeprBook: Record "5612";
    begin
        //Creating Fixed Assets Card and returning FA No. to caller function.
        LclFixedAsset.INIT;
        LclFixedAsset.Description := PrmItemDesc;
        LclFixedAsset."Vendor No." := PrmVndNo;
        LclFixedAsset.INSERT(TRUE);
        EXIT(LclFixedAsset."No.");
    end;

    [Scope('Internal')]
    procedure updateStrReqStatusOnOrder(PrmStrReqSmryLine: Record "33019813")
    var
        LclStrReqHdr: Record "33019810";
    begin
        //Updating store requisition status according to Requisition No To On Order.
        LclStrReqHdr.RESET;
        LclStrReqHdr.SETRANGE("Primary Key", PrmStrReqSmryLine."Transaction Type");
        IF LclStrReqHdr.FIND('-') THEN BEGIN
            LclStrReqHdr."Refresh Token Generated On" := LclStrReqHdr."Refresh Token Generated On"::"2";
            LclStrReqHdr.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure updateStrReqStatusPurchPost(PrmSmryNo: Code[20])
    var
        LclStrReqSmryLine: Record "33019813";
        LclStrReqHdr: Record "33019810";
    begin
        //Updating store requisition status according to Requisition No To Received.
        LclStrReqSmryLine.RESET;
        LclStrReqSmryLine.SETRANGE("Integration Type", PrmSmryNo);
        IF LclStrReqSmryLine.FIND('-') THEN BEGIN
            REPEAT
                LclStrReqHdr.RESET;
                LclStrReqHdr.SETRANGE("Primary Key", LclStrReqSmryLine."Transaction Type");
                IF LclStrReqHdr.FIND('-') THEN BEGIN
                    LclStrReqHdr."Refresh Token Generated On" := LclStrReqHdr."Refresh Token Generated On"::"3";
                    LclStrReqHdr.MODIFY;
                END;
            UNTIL LclStrReqSmryLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure updateStrReqStatusTrans(PrmSmryNo: Code[20])
    var
        LclStrReqSmryLine: Record "33019813";
        LclStrReqHdr: Record "33019810";
    begin
        //Updating store requisition status according to Requisition No To Transferred.
        LclStrReqSmryLine.RESET;
        LclStrReqSmryLine.SETRANGE("Integration Type", PrmSmryNo);
        IF LclStrReqSmryLine.FIND('-') THEN BEGIN
            REPEAT
                LclStrReqHdr.RESET;
                LclStrReqHdr.SETRANGE("Primary Key", LclStrReqSmryLine."Transaction Type");
                IF LclStrReqHdr.FIND('-') THEN BEGIN
                    LclStrReqHdr."Refresh Token Generated On" := LclStrReqHdr."Refresh Token Generated On"::"4";
                    LclStrReqHdr.MODIFY;
                END;
            UNTIL LclStrReqSmryLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure updateStrReqStatusIssue(PrmSmryNo: Code[20])
    var
        LclStrReqSmryLine: Record "33019813";
        LclStrReqHdr: Record "33019810";
    begin
        //Updating store requisition status according to Requisition No To Issued.
        LclStrReqSmryLine.RESET;
        LclStrReqSmryLine.SETRANGE("Integration Type", PrmSmryNo);
        IF LclStrReqSmryLine.FIND('-') THEN BEGIN
            REPEAT
                LclStrReqHdr.RESET;
                LclStrReqHdr.SETRANGE("Primary Key", LclStrReqSmryLine."Transaction Type");
                IF LclStrReqHdr.FIND('-') THEN BEGIN
                    LclStrReqHdr."Refresh Token Generated On" := LclStrReqHdr."Refresh Token Generated On"::"5";
                    LclStrReqHdr.MODIFY;
                END;
            UNTIL LclStrReqSmryLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure updateStrReqSmryStatus(PrmStrReqSmryHdr: Record "33019812")
    var
        LclStrReqSmryHdr: Record "33019812";
    begin
        //Updating Store Requisition Summary Header status.
        LclStrReqSmryHdr.RESET;
        LclStrReqSmryHdr.SETRANGE("Category Code", PrmStrReqSmryHdr."Category Code");
        IF LclStrReqSmryHdr.FIND('-') THEN BEGIN
            LclStrReqSmryHdr."Charge Bearer" := LclStrReqSmryHdr."Charge Bearer"::Sender;
            LclStrReqSmryHdr.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure getPurchLineNo(PrmOrderNo: Code[20]): Integer
    var
        LclPurchLine: Record "39";
    begin
        //Retrieving Line No. from Purchase Line.
        LclPurchLine.RESET;
        LclPurchLine.SETFILTER("Document Type", 'Order');
        LclPurchLine.SETRANGE("Document No.", PrmOrderNo);
        IF LclPurchLine.FIND('+') THEN
            EXIT(LclPurchLine."Line No.");
    end;

    [Scope('Internal')]
    procedure getLocation(): Code[10]
    var
        LclRespCntr: Record "5714";
        LclUserSetup: Record "91";
    begin
        //Retrieving Default Location Code for Procurement.
        LclUserSetup.GET(USERID);
        LclRespCntr.RESET;
        LclRespCntr.SETRANGE(Code, LclUserSetup."Default Responsibility Center");
        IF LclRespCntr.FIND('-') THEN
            EXIT(LclRespCntr."Location Code");
    end;

    [Scope('Internal')]
    procedure getDim1Code(): Code[20]
    var
        LclRespCntr: Record "5714";
        LclUserSetup: Record "91";
    begin
        //Retrieving Default Global Dimension 1 Code for Procurement.
        LclUserSetup.GET(USERID);
        LclRespCntr.RESET;
        LclRespCntr.SETRANGE(Code, LclUserSetup."Default Responsibility Center");
        IF LclRespCntr.FIND('-') THEN
            EXIT(LclRespCntr."Global Dimension 1 Code");
    end;

    [Scope('Internal')]
    procedure getDim2Code(): Code[20]
    var
        LclRespCntr: Record "5714";
        LclUserSetup: Record "91";
    begin
        //Retrieving Default Global Dimension 2 Code for Procurement.
        LclUserSetup.GET(USERID);
        LclRespCntr.RESET;
        LclRespCntr.SETRANGE(Code, LclUserSetup."Default Responsibility Center");
        IF LclRespCntr.FIND('-') THEN
            EXIT(LclRespCntr."Global Dimension 2 Code");
    end;

    [Scope('Internal')]
    procedure showCompletionMsg()
    var
        LclArrayLength: Integer;
        Text33019810: Label 'Purchase Order - %1 has been created successfully!';
        Text33019811: Label 'Purchase Orders - %1 to %2, have been created successfully!';
    begin
        //Retrieving array length.
        LclArrayLength := COMPRESSARRAY(GblPurchOrderNo);

        IF (LclArrayLength = 1) THEN
            MESSAGE(Text33019810, GblPurchOrderNo[1])
        ELSE
            MESSAGE(Text33019811, GblPurchOrderNo[1], GblPurchOrderNo[LclArrayLength]);
    end;
}

