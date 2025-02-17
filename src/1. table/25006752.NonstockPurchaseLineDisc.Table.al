table 25006752 "Nonstock Purchase Line Disc"
{
    // 16.02.2005 EDMS P1
    //  *Added code:
    //   OnInsert()
    //   OnModify()
    //   OnDelete()
    //   OnRename()
    // 
    // 
    // 23.09.2004 EDMS P1
    //   *Added key "Item Discount Group Code"
    //   *Added field "Item Discount Group Code"

    Caption = 'Nonstock Purchase Line Disc';
    LookupPageID = 7014;

    fields
    {
        field(1; "Nonstock Item Entry No."; Code[20])
        {
            Caption = 'Nonstock Item Entry No.';
            NotBlank = true;
            TableRelation = "Nonstock Item";

            trigger OnValidate()
            begin
                IF "Nonstock Item Entry No." <> xRec."Nonstock Item Entry No." THEN BEGIN
                    "Unit of Measure Code" := '';
                END;
            end;
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF recVend.GET("Vendor No.") THEN
                    "Currency Code" := recVend."Currency Code";
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                    ERROR(Text000, FIELDCAPTION("Starting Date"), FIELDCAPTION("Ending Date"));
            end;
        }
        field(5; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(11; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                VALIDATE("Starting Date");
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(25006670; "Item Discount Group Code"; Code[10])
        {
            Caption = 'Item Discount Group Code';
            TableRelation = "Item Discount Group";
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
    }

    keys
    {
        key(Key1; "Nonstock Item Entry No.", "Vendor No.", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code")
        {
            Clustered = true;
        }
        key(Key2; "Vendor No.", "Nonstock Item Entry No.", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code")
        {
        }
        key(Key3; "Item Discount Group Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //16.02.2005 EDMS P1
        cuPurchPriceCalcMgt.NonstockPurchLineDiscToItem(Rec, xRec, 3)
    end;

    trigger OnInsert()
    begin
        TESTFIELD("Vendor No.");
        TESTFIELD("Nonstock Item Entry No.");

        //16.02.2005 EDMS P1
        cuPurchPriceCalcMgt.NonstockPurchLineDiscToItem(Rec, xRec, 0)
    end;

    trigger OnModify()
    begin
        //16.02.2005 EDMS P1
        cuPurchPriceCalcMgt.NonstockPurchLineDiscToItem(Rec, xRec, 1)
    end;

    trigger OnRename()
    begin
        TESTFIELD("Vendor No.");
        TESTFIELD("Nonstock Item Entry No.");

        //16.02.2005 EDMS P1
        cuPurchPriceCalcMgt.NonstockPurchLineDiscToItem(Rec, xRec, 2)
    end;

    var
        recVend: Record "23";
        Text000: Label '%1 cannot be after %2';
        cuPurchPriceCalcMgt: Codeunit "7010";
}

