table 33020255 "Purchase Order Buffer"
{

    fields
    {
        field(10; "Purchase Order No."; Code[20])
        {
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(21; "Line No."; Integer)
        {
        }
        field(30; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor.No.;
        }
        field(40; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(50; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item),,External Service';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)",,"External Service";
        }
        field(60; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item),
                                     Line Type=FILTER(<>Vehicle)) Item WHERE (Item Type=CONST(Item))
                                     ELSE IF (Type=CONST(Item),
                                              Line Type=CONST(Vehicle)) Item WHERE (Item Type=CONST(Model Version))
                                              ELSE IF (Type=CONST(3)) Resource
                                              ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                              ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
                                              ELSE IF (Type=CONST(External Service)) "External Service";

            trigger OnValidate()
            var
                ICPartner: Record "413";
                ItemCrossReference: Record "5717";
                PrepmtMgt: Codeunit "441";
            begin
            end;
        }
        field(61;"VIN - COGS";Code[20])
        {

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
            end;
        }
        field(62;VIN;Code[20])
        {

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
            end;

            trigger OnValidate()
            var
                recInvSetup: Record "313";
                cuNoSeriesMgt: Codeunit "396";
                codSerialNo: Code[20];
                recVehicle: Record "25006005";
                cuVehAccCycleMgt: Codeunit "25006303";
            begin
            end;
        }
        field(63;"Document Class";Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets";
        }
        field(64;"Document Subclass";Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF (Document Class=CONST(Customer)) Customer
                            ELSE IF (Document Class=CONST(Vendor)) Vendor
                            ELSE IF (Document Class=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Document Class=CONST(Fixed Assets)) "Fixed Asset";
        }
        field(65;"COGS Type";Option)
        {
            Description = 'Used for Alternative of way of Item Charge';
            OptionCaption = ' ,ACCESSORIES-CV,ACCESSORIES-PC,BANK CHARGE-CV,BANK CHARGE-PC,BATTERY-CV,BATTERY-PC,BODY BUILDING-CV,BODY BUILDING-PC,CHASSIS REGISTR-CV,CHASSIS REGISTR-PC,CLEARING & FORW-CV,CLEARING & FORW-PC,CUSTOM DUTY-CV,CUSTOM DUTY-PC,DENT / PENT-CV,DENT / PENT-PC,DRIVER-CV,DRIVER-PC,FOREIGN CHARGE-CV,FOREIGN CHARGE-PC,FUEL & OIL-CV,FUEL & OIL-PC,INSURANCE MANAG-CV,INSURANCE MANAG-PC,INSURANCE-CV,INSURANCE-PC,,L/C & BANK CHAR-CV,L/C & BANK CHAR-PC,LUBRICANTS-CV,LUBRICANTS-PC,NEW CHASSIS REP-CV,NEW CHASSIS REP-PC,PARKING CHARGE-CV,PARKING CHARGE-PC,PRAGYANPAN-CV,PRAGYANPAN-PC,SERVICE CHARGE-CV,SERVICE CHARGE-PC,SPARES-CV,SPARES-PC,TRANSPORTATION-CV,TRANSPORTATION-PC,VEHICLE LOGISTI-CV,VEHICLE LOGISTI-PC,VEHICLE TAX-CV,VEHICLE TAX-PC';
            OptionMembers = " ","ACCESSORIES-CV","ACCESSORIES-PC","BANK CHARGE-CV","BANK CHARGE-PC","BATTERY-CV","BATTERY-PC","BODY BUILDING-CV","BODY BUILDING-PC","CHASSIS REGISTR-CV","CHASSIS REGISTR-PC","CLEARING & FORW-CV","CLEARING & FORW-PC","CUSTOM DUTY-CV","CUSTOM DUTY-PC","DENT / PENT-CV","DENT / PENT-PC","DRIVER-CV","DRIVER-PC","FOREIGN CHARGE-CV","FOREIGN CHARGE-PC","FUEL & OIL-CV","FUEL & OIL-PC","INSURANCE MANAG-CV","INSURANCE MANAG-PC","INSURANCE-CV","INSURANCE-PC",,"L/C & BANK CHAR-CV","L/C & BANK CHAR-PC","LUBRICANTS-CV","LUBRICANTS-PC","NEW CHASSIS REP-CV","NEW CHASSIS REP-PC","PARKING CHARGE-CV","PARKING CHARGE-PC","PRAGYANPAN-CV","PRAGYANPAN-PC","SERVICE CHARGE-CV","SERVICE CHARGE-PC","SPARES-CV","SPARES-PC","TRANSPORTATION-CV","TRANSPORTATION-PC","VEHICLE LOGISTI-CV","VEHICLE LOGISTI-PC","VEHICLE TAX-CV","VEHICLE TAX-PC";
        }
        field(66;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(67;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(68;"Shortcut Dimension 5 Code";Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(5));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(70;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(80;"Line Type";Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Vehicle,,,Charge (Item),G/L Account';
            OptionMembers = " ",Vehicle,,Item,"Charge (Item)","G/L Account";

            trigger OnValidate()
            var
                DocMgtDMS: Codeunit "25006000";
                Opt: Integer;
            begin
            end;
        }
        field(90;"Location Code";Code[10])
        {
            Editable = false;
            TableRelation = Location;
        }
        field(91;"Responsibility Center";Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(92;"Unit Cost";Decimal)
        {
        }
        field(100;"Imported By";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1;"Document Type","Purchase Order No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        UserSetup.GET(USERID);
        "Location Code" := UserSetup."Default Location";
        "Responsibility Center" := UserSetup."Default Responsibility Center";
        "Accountability Center" := UserSetup."Default Accountability Center";
        "Imported By" := UserSetup."User ID";
    end;

    var
        RecPurchOrderBuffer: Record "33020255";
        PreviousNo: Code[20];
        RecentNo: Code[20];
        PreviousDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        RecentDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        PurchHeader: Record "38";
        PurchLine: Record "39";
        LastUsedLineNo: Integer;
        Text000: Label 'Purchase Order Created Successfully.';
        Text001: Label 'There is no documents within the applied filter.';
        UserSetup: Record "91";
        Vehicle: Record "25006005";

    [Scope('Internal')]
    procedure ProcessBuffer(var POBuffer: Record "33020255")
    begin
        RecPurchOrderBuffer.COPYFILTERS(POBuffer);
        IF RecPurchOrderBuffer.FINDSET THEN BEGIN
         REPEAT
          RecentDocType := RecPurchOrderBuffer."Document Type";
          RecentNo := RecPurchOrderBuffer."Purchase Order No.";
          IF (RecentDocType <> PreviousDocType) OR (RecentNo <> PreviousNo) THEN BEGIN
            CreatePurchaseHeader;
          END
          ELSE IF (RecentDocType=PreviousDocType) AND (RecentNo=PreviousNo) THEN BEGIN
            CreatePurchaseLines;
          END;
          UNTIL RecPurchOrderBuffer.NEXT=0;
          DeletePOBuffer;
          MESSAGE(Text000);
        END
        ELSE
          ERROR(Text001);
    end;

    [Scope('Internal')]
    procedure CreatePurchaseHeader()
    begin
        PurchHeader.RESET;
        CLEAR(PurchHeader);
        PurchHeader.INIT;
        PurchHeader."Document Type" := RecPurchOrderBuffer."Document Type";
        PurchHeader.INSERT(TRUE);
        PurchHeader.VALIDATE("Buy-from Vendor No.",RecPurchOrderBuffer."Buy-from Vendor No.");
        PurchHeader.VALIDATE("Pay-to Vendor No.");
        PurchHeader."Document Profile" := RecPurchOrderBuffer."Document Profile";
        PurchHeader.MODIFY;
        LastUsedLineNo := 0;
        PreviousDocType := RecPurchOrderBuffer."Document Type";
        PreviousNo := RecPurchOrderBuffer."Purchase Order No.";
        CreatePurchaseLines;
    end;

    [Scope('Internal')]
    procedure CreatePurchaseLines()
    begin
        RecPurchOrderBuffer.TESTFIELD("Buy-from Vendor No.",PurchHeader."Buy-from Vendor No.");
        RecPurchOrderBuffer.TESTFIELD("Document Profile",PurchHeader."Document Profile");
        CLEAR(PurchLine);
        PurchLine.INIT;
        PurchLine."Line No." := LastUsedLineNo + 10000;
        PurchLine."Document Type" := PurchHeader."Document Type";
        PurchLine.VALIDATE("Document No.",PurchHeader."No.");
        PurchLine.VALIDATE(Type,RecPurchOrderBuffer.Type);
        IF "Line Type" <> "Line Type"::" " THEN
        PurchLine.VALIDATE("Line Type",RecPurchOrderBuffer."Line Type");
        PurchLine.VALIDATE("No.",RecPurchOrderBuffer."No.");
        PurchLine.VALIDATE(Quantity,RecPurchOrderBuffer.Quantity);
        PurchLine.VALIDATE("Direct Unit Cost",RecPurchOrderBuffer."Unit Cost");
        PurchLine.VALIDATE("VIN - COGS",RecPurchOrderBuffer."VIN - COGS");
        IF RecPurchOrderBuffer.VIN <> '' THEN  BEGIN
          Vehicle.GET(RecPurchOrderBuffer.VIN);
          PurchLine.VALIDATE("Vehicle Serial No.",RecPurchOrderBuffer.VIN);
        END;
        PurchLine."Document Class" := RecPurchOrderBuffer."Document Class";
        PurchLine."Document Subclass" := RecPurchOrderBuffer."Document Subclass";
        PurchLine.VALIDATE("Qty. to Receive",RecPurchOrderBuffer.Quantity);
        PurchLine.VALIDATE("Qty. to Invoice",RecPurchOrderBuffer.Quantity);
        PurchLine."Document Profile" := PurchHeader."Document Profile";
        PurchLine."COGS Type" := RecPurchOrderBuffer."COGS Type";
        PurchLine.INSERT(TRUE);

        IF RecPurchOrderBuffer."Shortcut Dimension 1 Code" <> '' THEN BEGIN
          PurchLine.VALIDATE("Shortcut Dimension 1 Code",RecPurchOrderBuffer."Shortcut Dimension 1 Code");
        END;
        IF RecPurchOrderBuffer."Shortcut Dimension 2 Code" <> '' THEN BEGIN
          PurchLine.VALIDATE("Shortcut Dimension 2 Code",RecPurchOrderBuffer."Shortcut Dimension 2 Code");
        END;
        IF RecPurchOrderBuffer."Shortcut Dimension 5 Code" <> '' THEN BEGIN
          PurchLine.ValidateShortcutDimCode(5,RecPurchOrderBuffer."Shortcut Dimension 5 Code");
        END;

        LastUsedLineNo := LastUsedLineNo + 10000;
    end;

    [Scope('Internal')]
    procedure DeletePOBuffer()
    begin
        RecPurchOrderBuffer.DELETEALL;
    end;
}

