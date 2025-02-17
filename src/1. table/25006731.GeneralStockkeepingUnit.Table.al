table 25006731 "General Stockkeeping Unit"
{
    // 20.11.2014 EB.P8 MERGE

    Caption = 'General Stockkeeping Unit';
    DrillDownPageID = 25006808;
    LookupPageID = 25006808;

    fields
    {
        field(1; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            NotBlank = true;
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                Item: Record "27";
            begin
                CALCFIELDS(Description);
            end;
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE(Use As In-Transit=CONST(No));

            trigger OnValidate()
            begin
                IF "Location Code" = '' THEN
                    VALIDATE("Replenishment System");
            end;
        }
        field(4; Description; Text[30])
        {
            CalcFormula = Lookup("Item Category".Description WHERE(Code = FIELD(Item Category Code)));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(33; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(34; "Reorder Point"; Decimal)
        {
            Caption = 'Reorder Point';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Maximum Inventory"; Decimal)
        {
            Caption = 'Maximum Inventory';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Reorder Quantity"; Decimal)
        {
            Caption = 'Reorder Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(62; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(64; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(65; "Global Dimension 1 Filter"; Code[20])
        {
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(66; "Global Dimension 2 Filter"; Code[20])
        {
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(5400; "Transfer-Level Code"; Integer)
        {
            Caption = 'Transfer-Level Code';
            Editable = false;
        }
        field(5410; "Discrete Order Quantity"; Integer)
        {
            Caption = 'Discrete Order Quantity';
            MinValue = 0;
        }
        field(5411; "Minimum Order Quantity"; Decimal)
        {
            Caption = 'Minimum Order Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5412; "Maximum Order Quantity"; Decimal)
        {
            Caption = 'Maximum Order Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5413; "Safety Stock Quantity"; Decimal)
        {
            Caption = 'Safety Stock Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5414; "Order Multiple"; Decimal)
        {
            Caption = 'Order Multiple';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5415; "Safety Lead Time"; DateFormula)
        {
            Caption = 'Safety Lead Time';
        }
        field(5419; "Replenishment System"; Option)
        {
            Caption = 'Replenishment System';
            OptionCaption = 'Purchase,Prod. Order,Transfer';
            OptionMembers = Purchase,"Prod. Order",Transfer;

            trigger OnValidate()
            begin
                IF ("Replenishment System" = "Replenishment System"::Transfer) AND
                  ("Location Code" = '')
                THEN
                    ERROR(
                      Text004,
                      FIELDCAPTION("Location Code"), TABLECAPTION,
                      "Replenishment System", FIELDCAPTION("Replenishment System"));
                IF "Replenishment System" IN ["Replenishment System"::Purchase, "Replenishment System"::"Prod. Order"]
                THEN BEGIN
                    "Transfer-Level Code" := 0;
                    FromLocation := "Transfer-from Code";
                    IF NOT UpdateTransferLevels(Rec) THEN
                        ShowLoopError;
                END
                ELSE
                    IF "Replenishment System" = "Replenishment System"::Transfer THEN
                        VALIDATE("Transfer-from Code");
            end;
        }
        field(5423; "Bin Filter"; Code[20])
        {
            Caption = 'Bin Filter';
            FieldClass = FlowFilter;
            TableRelation = Bin.Code WHERE(Location Code=FIELD(Location Code));
        }
        field(5428;"Reorder Cycle";DateFormula)
        {
            Caption = 'Reorder Cycle';
        }
        field(5440;"Reordering Policy";Option)
        {
            Caption = 'Reordering Policy';
            OptionCaption = ' ,Fixed Reorder Qty.,Maximum Qty.,Order,Lot-for-Lot';
            OptionMembers = " ","Fixed Reorder Qty.","Maximum Qty.","Order","Lot-for-Lot";

            trigger OnValidate()
            begin
                IF "Reordering Policy" <> "Reordering Policy"::"Lot-for-Lot" THEN
                  "Include Inventory" :=
                    ("Reordering Policy" <> "Reordering Policy"::" ") AND
                    ("Reordering Policy" <> "Reordering Policy"::Order);
            end;
        }
        field(5441;"Include Inventory";Boolean)
        {
            Caption = 'Include Inventory';
        }
        field(5700;"Transfer-from Code";Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));

            trigger OnValidate()
            var
                FromGlobalSKU: Record "25006731";
            begin
                FromGlobalSKU.SETRANGE("Location Code","Transfer-from Code");
                FromGlobalSKU.SETRANGE("Item Category Code","Item Category Code");
                IF NOT FromGlobalSKU.FINDFIRST THEN
                  "Transfer-Level Code" := -1
                ELSE
                  "Transfer-Level Code" := FromGlobalSKU."Transfer-Level Code" - 1;
                FromLocation := "Transfer-from Code";
                MODIFY(TRUE);
                IF NOT UpdateTransferLevels(Rec) THEN
                  ShowLoopError;

                IF ("Transfer-from Code" <> '') THEN
                  IF NOT TransferRouteExists("Transfer-from Code","Location Code") THEN
                    ERROR(
                      Text005,
                      TransferRoute.TABLECAPTION,
                      FIELDCAPTION("Location Code"),
                      "Transfer-from Code",
                      "Location Code");
            end;
        }
        field(7301;"Special Equipment Code";Code[10])
        {
            Caption = 'Special Equipment Code';
            TableRelation = "Special Equipment";
        }
        field(7302;"Put-away Template Code";Code[10])
        {
            Caption = 'Put-away Template Code';
            TableRelation = "Put-away Template Header";
        }
        field(7380;"Phys Invt Counting Period Code";Code[10])
        {
            Caption = 'Phys Invt Counting Period Code';
            TableRelation = "Phys. Invt. Counting Period";

            trigger OnValidate()
            var
                PhysInvtCountPeriod: Record "7381";
                PhysInvtCountPeriodMgt: Codeunit "7380";
                NextStartDate: Date;
                NextEndDate: Date;
            begin
                IF "Phys Invt Counting Period Code" <> '' THEN BEGIN
                  PhysInvtCountPeriod.GET("Phys Invt Counting Period Code");
                  PhysInvtCountPeriod.TESTFIELD("Count Frequency per Year");
                  IF "Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code" THEN BEGIN
                    IF CurrFieldNo <> 0 THEN
                      IF NOT CONFIRM(
                        Text7380,
                        FALSE,
                        FIELDCAPTION("Phys Invt Counting Period Code"),
                        FIELDCAPTION("Next Counting Period"))
                      THEN
                        ERROR(Text7381);

                    //20.11.2014 EB.P8 MERGE >>
                    NextStartDate := 0D;
                    NextEndDate := 12319999D;
                //Merge NAV 2017 W1 CU8 >>
                //    PhysInvtCountPeriodMgt.CalcPeriod(
                //      "Last Counting Period Update", NextStartDate, NextEndDate,
                //      PhysInvtCountPeriod."Count Frequency per Year",
                //      ("Last Counting Period Update" = 0D) OR
                //      ("Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code"));
                //Merge NAV 2017 W1 CU8 <<
                    PhysInvtCountPeriodMgt.CalcPeriod(
                      "Last Counting Period Update", NextStartDate, NextEndDate,
                      PhysInvtCountPeriod."Count Frequency per Year");
                    IF ((NextStartDate=0D) AND (NextEndDate=12319999D)) THEN
                      "Next Counting Period" := ''
                    ELSE
                      "Next Counting Period" := FORMAT(NextStartDate)+'..'+FORMAT(NextEndDate);
                    //20.11.2014 EB.P8 MERGE <<
                  END;
                END ELSE BEGIN
                  IF NOT CONFIRM(Text003,FALSE,FIELDCAPTION("Phys Invt Counting Period Code")) THEN
                    ERROR(Text7380);
                  "Next Counting Period" := '';
                  "Last Counting Period Update" := 0D;
                END;
            end;
        }
        field(7381;"Last Counting Period Update";Date)
        {
            Caption = 'Last Counting Period Update';
            Editable = false;
        }
        field(7382;"Next Counting Period";Text[250])
        {
            Caption = 'Next Counting Period';
            Editable = false;
        }
        field(7384;"Use Cross-Docking";Boolean)
        {
            Caption = 'Use Cross-Docking';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1;"Location Code","Item Category Code")
        {
            Clustered = true;
        }
        key(Key2;"Replenishment System","Vendor No.","Transfer-from Code")
        {
        }
        key(Key3;"Item Category Code","Location Code")
        {
        }
        key(Key4;"Item Category Code","Transfer-Level Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        StockkeepingCommentLine: Record "5701";
    begin
    end;

    trigger OnInsert()
    begin
        IF ("Location Code" = '')
        THEN
          ERROR(
            Text000,
            FIELDCAPTION("Location Code"),TABLECAPTION);

        "Last Date Modified" := TODAY;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename()
    begin
        IF ("Location Code" = '')
        THEN
          ERROR(
            Text000,
            FIELDCAPTION("Location Code"),TABLECAPTION);

        "Last Date Modified" := TODAY;
    end;

    var
        Text000: Label 'You must specify a %1 or a %2 for each %3.';
        Text003: Label 'Do you want to change %1?';
        Text004: Label 'You must specify a %1 for this %2 to use %3 as %4.';
        Text005: Label 'You must specify a %1 from %2 %3 to %2 %4.';
        Text006: Label 'A circular reference in %1 has been detected:\';
        TransferRoute: Record "5742";
        Item: Record "27";
        FromLocation: Code[10];
        ErrorString: Text[80];
        Text7380: Label 'If you change the %1, the %2 is calculated.\Do you still want to change the %1?';
        Text7381: Label 'Cancelled.';

    local procedure TransferRouteExists(TransferFromCode: Code[10];TransferToCode: Code[10]): Boolean
    begin
        TransferRoute.SETRANGE("Transfer-from Code",TransferFromCode);
        TransferRoute.SETRANGE("Transfer-to Code",TransferToCode);
        EXIT(NOT TransferRoute.ISEMPTY);
    end;

    [Scope('Internal')]
    procedure UpdateTransferLevels(FromGlobalSKU: Record "25006731"): Boolean
    var
        ToGlobalSKU: Record "25006731";
    begin
        ToGlobalSKU.SETCURRENTKEY("Replenishment System","Vendor No.","Transfer-from Code");
        ToGlobalSKU.SETRANGE("Replenishment System","Replenishment System"::Transfer);
        ToGlobalSKU.SETRANGE("Transfer-from Code",FromGlobalSKU."Location Code");
        ToGlobalSKU.SETRANGE("Item Category Code",FromGlobalSKU."Item Category Code");
        IF ToGlobalSKU.FINDSET(TRUE,FALSE) THEN
          REPEAT
            IF ToGlobalSKU."Location Code" = FromLocation THEN BEGIN
              ErrorString := ToGlobalSKU."Location Code";
              EXIT(FALSE);
            END;
            ToGlobalSKU."Transfer-Level Code" := FromGlobalSKU."Transfer-Level Code" - 1;
            ToGlobalSKU.MODIFY;
            IF NOT UpdateTransferLevels(ToGlobalSKU) THEN BEGIN
              IF (STRLEN(ErrorString) + STRLEN(ToGlobalSKU."Location Code")) >
                 (MAXSTRLEN(ErrorString) - 9)
              THEN BEGIN
                ErrorString := ErrorString + ' ->...';
                ShowLoopError;
              END;
              ErrorString := ErrorString + ' ->' + ToGlobalSKU."Location Code";
              EXIT(FALSE);
            END;
          UNTIL ToGlobalSKU.NEXT = 0;
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure ShowLoopError()
    begin
        ERROR(
          Text006+
          '%2 ->%3 ->%4',
          FIELDCAPTION("Transfer-from Code"),
          ErrorString,
          "Location Code",
          "Transfer-from Code");
    end;

    [Scope('Internal')]
    procedure UpdateTempSKUTransferLevels(FromGlobalSKU: Record "25006731";var ToGlobalSKU: Record "25006731" temporary;FromLocationCode: Code[10]): Boolean
    begin
        // Used by the planning engine to update the transfer level codes on a temporary SKU record set
        // generated based on actual transfer orders.

        ToGlobalSKU.RESET;
        ToGlobalSKU.SETCURRENTKEY("Item Category Code","Location Code");
        ToGlobalSKU.SETRANGE("Transfer-from Code",FromGlobalSKU."Location Code");
        ToGlobalSKU.SETRANGE("Item Category Code",FromGlobalSKU."Item Category Code");
        IF ToGlobalSKU.FINDSET(TRUE,FALSE) THEN
          REPEAT
            IF ToGlobalSKU."Location Code" = FromLocationCode THEN BEGIN
              ErrorString := ToGlobalSKU."Location Code";
              EXIT(FALSE);
            END;
            ToGlobalSKU."Transfer-Level Code" := FromGlobalSKU."Transfer-Level Code" - 1;
            ToGlobalSKU.MODIFY;
            IF NOT ToGlobalSKU.UpdateTempSKUTransferLevels(ToGlobalSKU,ToGlobalSKU,FromLocationCode) THEN BEGIN
              IF (STRLEN(ErrorString) + STRLEN(ToGlobalSKU."Location Code")) >
                 (MAXSTRLEN(ErrorString) - 9)
              THEN BEGIN
                ErrorString := ErrorString + ' ->...';
                ERROR(
                  Text006+
                  '%2 ->%3 ->%4',
                  FIELDCAPTION("Transfer-from Code"),
                  ErrorString,
                  "Location Code",
                  "Transfer-from Code");
              END;
              ErrorString := ErrorString + ' ->' + ToGlobalSKU."Location Code";
              EXIT(FALSE);
            END;
          UNTIL ToGlobalSKU.NEXT = 0;
        EXIT(TRUE);
    end;
}

