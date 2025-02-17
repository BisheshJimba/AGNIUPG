table 25006751 "Nonstock Purchase Price"
{
    Caption = 'Nonstock Item Purchase Price';
    LookupPageID = 7012;

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
        field(5; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
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
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        cuPurchPriceCalcMgt.NonstockPurchPriceToItem(Rec, xRec, 3);
    end;

    trigger OnInsert()
    begin
        TESTFIELD("Vendor No.");
        TESTFIELD("Nonstock Item Entry No.");
        cuPurchPriceCalcMgt.NonstockPurchPriceToItem(Rec, xRec, 0);
    end;

    trigger OnModify()
    begin
        cuPurchPriceCalcMgt.NonstockPurchPriceToItem(Rec, xRec, 1);
    end;

    trigger OnRename()
    begin
        TESTFIELD("Vendor No.");
        TESTFIELD("Nonstock Item Entry No.");

        cuPurchPriceCalcMgt.NonstockPurchPriceToItem(Rec, xRec, 2);
    end;

    var
        recVend: Record "23";
        Text000: Label '%1 cannot be after %2';
        cuPurchPriceCalcMgt: Codeunit "7010";
}

