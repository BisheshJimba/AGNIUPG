table 33019975 "QR Scan for Verification"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(3; "QR Code Text"; Code[250])
        {
        }
        field(4; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(5; "Item Description"; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(Item No.)));
            FieldClass = FlowField;
        }
        field(6;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(Item No.),
                                                                  Location Code=FIELD(Location Code),
                                                                  Lot No.=FIELD(Lot No.)));
            FieldClass = FlowField;
        }
        field(7;"Lot No.";Code[20])
        {
        }
        field(8;"QR Status";Option)
        {
            OptionCaption = ' ,Verified,Lost';
            OptionMembers = " ",Verified,Lost;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Do you want to delete all scanned data from %1 location?';
        Text002: Label 'Do you want to process all scanned data from %1 location?';
        Text003: Label 'Do you want to reset all verified data from %1 location?';
        Text004: Label 'You have scanned Item %1 with lot no %2 multiple times.';

    [Scope('Internal')]
    procedure FilterData()
    var
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Location");
        FILTERGROUP(2);
        SETRANGE("Location Code",UserSetup."Default Location");
        FILTERGROUP(0);
    end;

    [Scope('Internal')]
    procedure InsertData(QRText: Text[250])
    var
        UserSetup: Record "91";
        QRScanforVerification: Record "33019975";
        EntryNo: Integer;
        ItemNo: Code[20];
        WorkString: Text[250];
        TrimmedString: Text[250];
        Supplier: Code[10];
        ItemCategory: Record "5722";
        Item: Record "27";
        Found: Boolean;
        ParentLotNo: Code[30];
        ActualLotNo: Code[20];
        ItemLedgerEntry: Record "32";
    begin
        IF QRText = '' THEN
          EXIT;
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Location");

        WorkString := CONVERTSTR(QRText,'/',',');
        WorkString := CONVERTSTR(WorkString,'|',',');
        IF STRPOS(WorkString,',') > 0 THEN BEGIN
          Supplier := SELECTSTR(1,WorkString);
          TrimmedString := COPYSTR(WorkString,STRPOS(WorkString,',') + 1,STRLEN(WorkString));
          IF STRPOS(TrimmedString,',') > 0 THEN BEGIN
            ItemNo := SELECTSTR(1,TrimmedString);
            TrimmedString := COPYSTR(TrimmedString,STRPOS(TrimmedString,',') + 1,STRLEN(TrimmedString));
          END;
          IF STRPOS(TrimmedString,',') > 0 THEN BEGIN
            ParentLotNo := SELECTSTR(1,TrimmedString);
            TrimmedString := COPYSTR(TrimmedString,STRPOS(TrimmedString,',') + 1,STRLEN(TrimmedString));
          END;
          IF STRPOS(TrimmedString,',') > 0 THEN BEGIN
            ActualLotNo := CONVERTSTR(TrimmedString,',','/');
          END;
        END;

        IF Supplier = 'HMIPP' THEN
          Supplier := 'HPP'
        ELSE IF Supplier = 'TH' THEN
          Supplier := 'THA';

        ItemCategory.RESET;
        ItemCategory.SETRANGE("Supplier Code",Supplier);
        IF ItemCategory.FINDSET THEN REPEAT
          IF STRLEN(ItemNo+'-'+ItemCategory.Code) < 21 THEN BEGIN
            Item.RESET;
            Item.SETFILTER("No.",'%1',ItemNo+'-'+ItemCategory.Code);
            Item.SETRANGE("Supplier Code",Supplier);
            IF Item.FINDFIRST THEN BEGIN
              ItemNo := Item."No.";
              Found := TRUE;
            END;
          END;
        UNTIL (ItemCategory.NEXT = 0) OR (Found = TRUE);

        QRScanforVerification.RESET;
        QRScanforVerification.SETCURRENTKEY("Item No.","Location Code","Lot No.");
        QRScanforVerification.SETRANGE("Item No.",ItemNo);
        QRScanforVerification.SETRANGE("Location Code",UserSetup."Default Location");
        QRScanforVerification.SETRANGE("Lot No.",ActualLotNo);
        IF NOT QRScanforVerification.ISEMPTY THEN BEGIN
          ERROR(Text004,ItemNo,ActualLotNo);
          EXIT;
        END;

        EntryNo := 0;
        QRScanforVerification.RESET;
        IF QRScanforVerification.FINDLAST THEN
          EntryNo := QRScanforVerification."Entry No.";

        CLEAR(QRScanforVerification);
        QRScanforVerification.INIT;
        QRScanforVerification."Entry No." := EntryNo + 1;
        QRScanforVerification."Location Code" := UserSetup."Default Location";
        QRScanforVerification."Item No." := ItemNo;
        QRScanforVerification."Lot No." := ActualLotNo;
        QRScanforVerification."QR Code Text" := QRText;
        QRScanforVerification.INSERT;

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code","Location Code","Item Tracking","Lot No.","Serial No.");
        ItemLedgerEntry.SETRANGE("Item No.",QRScanforVerification."Item No.");
        ItemLedgerEntry.SETRANGE(Open,TRUE);
        ItemLedgerEntry.SETRANGE("Location Code",QRScanforVerification."Location Code");
        ItemLedgerEntry.SETRANGE("Lot No.",QRScanforVerification."Lot No.");
        IF ItemLedgerEntry.FINDSET THEN REPEAT
          ItemLedgerEntry."QR Status" := ItemLedgerEntry."QR Status"::Verified;
          ItemLedgerEntry.MODIFY;
          QRScanforVerification."QR Status" := QRScanforVerification."QR Status"::Verified;
        UNTIL ItemLedgerEntry.NEXT = 0;
        IF QRScanforVerification."QR Status" = QRScanforVerification."QR Status"::" " THEN
          QRScanforVerification."QR Status" := QRScanforVerification."QR Status"::Lost;
        QRScanforVerification.MODIFY;
    end;

    [Scope('Internal')]
    procedure VerifyItems()
    var
        QRScanforVerification: Record "33019975";
        UserSetup: Record "91";
        ItemLedgerEntry: Record "32";
        ItemLedgerEntry2: Record "32";
        ProgressWindow: Dialog;
        TotalCount: Integer;
        Text50000: Label '#1############### of #2###############';
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Location");
        IF NOT CONFIRM(Text002,FALSE,UserSetup."Default Location") THEN
          EXIT;

        ProgressWindow.OPEN(Text50000);
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code","Location Code","Item Tracking","Lot No.","Serial No.");
        ItemLedgerEntry.SETRANGE(Open,TRUE);
        ItemLedgerEntry.SETRANGE("Location Code",UserSetup."Default Location");
        ProgressWindow.UPDATE(2,ItemLedgerEntry.COUNT);
        IF ItemLedgerEntry.FINDSET(TRUE,FALSE) THEN REPEAT
          TotalCount += 1;
          ProgressWindow.UPDATE(1,TotalCount);
          IF ItemLedgerEntry."QR Status" = ItemLedgerEntry."QR Status"::" " THEN BEGIN
            ItemLedgerEntry2 := ItemLedgerEntry;
            ItemLedgerEntry2."QR Status" := ItemLedgerEntry2."QR Status"::Lost;
            ItemLedgerEntry2.MODIFY;
          END;
        UNTIL ItemLedgerEntry.NEXT = 0;
        ProgressWindow.CLOSE;
    end;

    [Scope('Internal')]
    procedure DeleteData()
    var
        QRScanforVerification: Record "33019975";
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Location");
        IF NOT CONFIRM(Text001,FALSE,UserSetup."Default Location") THEN
          EXIT;
        QRScanforVerification.RESET;
        QRScanforVerification.SETRANGE("Location Code",UserSetup."Default Location");
        QRScanforVerification.DELETEALL(TRUE);
    end;

    [Scope('Internal')]
    procedure ResetVerificationInILE()
    var
        QRScanforVerification: Record "33019975";
        UserSetup: Record "91";
        ItemLedgerEntry: Record "32";
        ItemLedgerEntry2: Record "32";
        ProgressWindow: Dialog;
        TotalCount: Integer;
        Text50000: Label '#1############### of #2###############';
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Location");
        IF NOT CONFIRM(Text003,FALSE,UserSetup."Default Location") THEN
          EXIT;

        ProgressWindow.OPEN(Text50000);
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code","Location Code","Item Tracking","Lot No.","Serial No.");
        ItemLedgerEntry.SETRANGE(Open,TRUE);
        ItemLedgerEntry.SETRANGE("Location Code",UserSetup."Default Location");
        ProgressWindow.UPDATE(2,ItemLedgerEntry.COUNT);
        IF ItemLedgerEntry.FINDSET(TRUE,FALSE) THEN REPEAT
          TotalCount += 1;
          ProgressWindow.UPDATE(1,TotalCount);
          ItemLedgerEntry2 := ItemLedgerEntry;
          ItemLedgerEntry2."QR Status" := ItemLedgerEntry2."QR Status"::" ";
          ItemLedgerEntry2.MODIFY;
        UNTIL ItemLedgerEntry.NEXT = 0;
        ProgressWindow.CLOSE;
    end;

    [Scope('Internal')]
    procedure OpenLostItems()
    var
        ItemLedgerEntries: Page "38";
                               ItemLedgerEntry: Record "32";
                               UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Location");
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Location Code",UserSetup."Default Location");
        ItemLedgerEntry.SETRANGE(Open,TRUE);
        ItemLedgerEntry.SETRANGE("QR Status",ItemLedgerEntry."QR Status"::Lost);
        CLEAR(ItemLedgerEntries);
        ItemLedgerEntries.SETTABLEVIEW(ItemLedgerEntry);
        ItemLedgerEntries.RUNMODAL;
    end;
}

