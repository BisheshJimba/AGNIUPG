table 25006206 "Warranty Journal Line"
{
    // 12.06.2013 EDMS P8
    //   * Merged code with NAV2009
    // 
    // 2012.07.31 EDMS, P8
    //   * changed type of field 'Variable Field Run 1' - now it is decimal
    //   * added fields: 'Variable Field Run 2', 'Variable Field Run 3', 'Document Line No.', 'Plan No.'
    // 
    // 2012.04.12 EDMS P8
    //   * removed field "Resource No."(580)
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management, added fields:
    //   *   Vehicle Axle Code
    //   *   Tire Position Code
    //   *   Tire Code
    //   *   Tire Entry
    // 
    // 14.12.2011 EDMS P8
    //   * MATH DIVIDE must checked for zero before act
    // 
    // 07.11.2011 EDMS P8
    //   * VALIDATION triggers are recoded
    // 
    // 28.01.2010 EDMSB P2
    //   * Added field "Standard Time", "Campaign No.", "Amount Including VAT (LCY)"
    // 
    // 20.10.2008. EDMS P2
    //   * Added field "Deal Type Code"
    // 
    // 05.03.2008 EDMS P2
    //   * Added fields "Package No."
    //                  "Package Version No."
    //                  "Package Version Spec. Line No."
    // 
    // * Serial No. - onvalidate
    // Working with dimensions is disabled (need to think about how to realize it)
    // See another validates also

    Caption = 'Warranty Journal Line';

    fields
    {
        field(10; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Warranty Journal Template";
        }
        field(20; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Warranty Journal Batch".Name WHERE(Journal Template Name=FIELD(Journal Template Name));
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(33; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";

            trigger OnValidate()
            var
                ServiceHeader: Record "25006145";
                recMarkup: Record "25006741";
                recItemDisc: Record "7004";
                recLabTransl: Record "25006127";
                recItemTransl: Record "30";
            begin
            end;
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(60; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(70; "Debit Code"; Code[20])
        {
            Caption = 'Debit Code';
        }
        field(80; "Debit Description"; Text[50])
        {
            Caption = 'Debit Description';
        }
        field(90; "Reject Code"; Code[20])
        {
            Caption = 'Reject Code';
        }
        field(100; "Reject Description"; Text[50])
        {
            Caption = 'Reject Description';
        }
        field(110; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Approved,Rejected;
        }
        field(120; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(130; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(140; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                VALIDATE("Document Date", "Posting Date");
            end;
        }
        field(145; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                // 23.04.2015 EDMS P21 >>
                // IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                OnLookupVIN;
                // 23.04.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                //TESTFIELD(Status,Status::Open);

                // 20.02.2015 EDMS P21 >>
                IF VIN = '' THEN BEGIN
                    VALIDATE("Vehicle Serial No.", '');
                    EXIT;
                END;

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY(VIN);
                Vehicle.SETRANGE(VIN, VIN);
                IF Vehicle.FINDFIRST THEN BEGIN
                    IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                        VALIDATE("Vehicle Serial No.", Vehicle."Serial No.")
                END ELSE BEGIN
                    MessageLoc(STRSUBSTNO(Text137, Vehicle.TABLECAPTION, FIELDCAPTION(VIN), VIN), '');
                    //IF "Document Type" <> "Document Type"::Quote THEN
                    VIN := xRec.VIN;
                END;
                // 20.02.2015 EDMS P21 <<
            end;
        }
        field(150; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            begin
                Veh.GET("Vehicle Serial No.");
                Veh.CALCFIELDS("Model Commercial Name");

                Veh.TESTFIELD(Blocked, FALSE);

                "Make Code" := Veh."Make Code";
                "Model Code" := Veh."Model Code";
                "Model Version No." := Veh."Model Version No.";
            end;
        }
        field(160; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(170; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(180;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                recItem: Record "27";
                LookupMgt: Codeunit "25006003";
            begin
            end;
        }
        field(190;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle";
        }
        field(200;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(250;"Recurring Method";Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(270;"Recurring Frequency";DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(280;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";

            trigger OnValidate()
            begin
                WarrantyJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
                WarrantyJnlLine.MODIFYALL("Source Code","Source Code");
                MODIFY;
            end;
        }
        field(290;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(300;"Warranty Document No.";Code[20])
        {
            TableRelation = "Warranty Document Header";

            trigger OnValidate()
            var
                WarrantyDocumentHeader: Record "25006405";
            begin
                IF "Warranty Document No." <> xRec."Warranty Document No." THEN
                  "Warranty Document Line No." := 0;

                IF WarrantyDocumentHeader.GET("Warranty Document No.") THEN BEGIN
                  VIN := WarrantyDocumentHeader.VIN;
                  "Vehicle Serial No." := WarrantyDocumentHeader."Vehicle Serial No.";
                  "Vehicle Accounting Cycle No." := WarrantyDocumentHeader."Vehicle Accounting Cycle No.";
                  "Make Code" := WarrantyDocumentHeader."Make Code";
                  "Model Code" := WarrantyDocumentHeader."Model Code";
                  "Model Version No." := WarrantyDocumentHeader."Model Version No.";
                END;
            end;
        }
        field(310;"Warranty Document Line No.";Integer)
        {
            TableRelation = "Warranty Document Line"."Line No." WHERE (Document No.=FIELD(Warranty Document No.));
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // 26.10.2012 EDMS <<
        /*
        DimMgt.DeleteJnlLineDim(
          DATABASE::"Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0);
        */
        // 26.10.2012 EDMS <<

    end;

    trigger OnInsert()
    begin
        LOCKTABLE;
        WarrantyJnlTemplate.GET("Journal Template Name");
        WarrantyJnlBatch.GET("Journal Template Name","Journal Batch Name");
    end;

    var
        WarrantyJnlTemplate: Record "25006204";
        WarrantyJnlBatch: Record "25006205";
        WarrantyJnlLine: Record "25006206";
        Veh: Record "25006005";
        Customer: Record "18";
        GLSetup: Record "98";
        GLAcc: Record "15";
        Labor: Record "25006121";
        UnitOfMeasure: Record "204";
        ResFindUnitCost: Codeunit "220";
        ResFindUnitPrice: Codeunit "221";
        NoSeriesMgt: Codeunit "396";
        DimMgt: Codeunit "408";
        GLSetupRead: Boolean;
        Item: Record "27";
        cuVFMgt: Codeunit "25006004";
        cuLookupMgt: Codeunit "25006003";
        ServiceSetup: Record "25006120";
        ExternalService: Record "25006133";
        Currency: Record "4";
        RoundingPrecision: Decimal;
        LCYRoundingPrecision: Decimal;
        RoundingPrecisionUnit: Decimal;
        LCYRoundingPrecisionUnit: Decimal;
        FCYRate: Decimal;
        HideValidationDialog: Boolean;
        Vehicle: Record "25006005";
        LookUpMgt: Codeunit "25006003";
        NoVehicleTxt: Label 'There is no vehicle with %1 %2';
        Text137: Label 'There is no %1 with %2 %3';

    [Scope('Internal')]
    procedure EmptyLine(): Boolean
    begin
        EXIT("Document No." = '');
    end;

    [Scope('Internal')]
    procedure SetUpNewLine(LastWarrantyJnlLine: Record "25006206")
    begin
        WarrantyJnlTemplate.GET("Journal Template Name");
        WarrantyJnlBatch.GET("Journal Template Name","Journal Batch Name");
        WarrantyJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        WarrantyJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        IF WarrantyJnlLine.FINDFIRST THEN BEGIN
          "Posting Date" := LastWarrantyJnlLine."Posting Date";
          "Document Date" := LastWarrantyJnlLine."Document Date";
          "Document No." := LastWarrantyJnlLine."Document No.";
        END ELSE BEGIN
          "Posting Date" := WORKDATE;
          "Document Date" := WORKDATE;
          IF WarrantyJnlBatch."No. Series" <> '' THEN BEGIN
            CLEAR(NoSeriesMgt);
            "Document No." := NoSeriesMgt.TryGetNextNo(WarrantyJnlBatch."No. Series","Posting Date");
          END;
        END;
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
          GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(cuVFMgt);
        EXIT(cuVFMgt.IsVFActive(DATABASE::"Serv. Journal Line",intFieldNo));
    end;

    [Scope('Internal')]
    procedure MessageLoc(MessageTxt: Text[1024];RunParStr: Text[1024])
    begin
        // RunParStr not used for now
        IF NOT HideValidationDialog THEN
          MESSAGE(MessageTxt);
    end;

    [Scope('Internal')]
    procedure OnLookupVIN()
    var
        Vehicle: Record "25006005";
    begin
        IF LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") THEN
          VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");
    end;
}

