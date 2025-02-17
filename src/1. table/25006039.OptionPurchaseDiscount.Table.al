table 25006039 "Option Purchase Discount"
{
    // 11.04.2013 EDMS P8
    //   * added field 'Option Subtype', to primary as well
    // 
    // 08.02.05 AB
    // *Jauns lauks Payment Method Code

    Caption = 'Option Purchase Discount';
    LookupPageID = 25006039;

    fields
    {
        field(10; "Option Code"; Code[50])
        {
            Caption = 'Option Code';
            NotBlank = true;
            TableRelation = IF ("Option Type" = CONST("Manufacturer Option")) "Manufacturer Option"."Option Code" WHERE("Make Code" = FIELD("Make Code"),
                                                                                                                   "Model Code" = FIELD("Model Code"),
                                                                                                                   "Model Version No." = FIELD("Model Version No."))
            ELSE IF ("Option Type" = CONST("Own Option")) "Own Option"."Option Code" WHERE("Make Code" = FIELD("Make Code"),
                                                                                                                                                                                             "Model Code" = FIELD("Model Code"));
        }
        field(20; "Vendor No."; Code[20])
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
        field(30; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                    ERROR(Text000, FIELDCAPTION("Starting Date"), FIELDCAPTION("Ending Date"));
            end;
        }
        field(40; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(60; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                VALIDATE("Starting Date");
            end;
        }
        field(70; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option';
            OptionMembers = "Manufacturer Option","Own Option";

            trigger OnValidate()
            begin
                IF xRec."Option Type" <> "Option Type" THEN
                    VALIDATE("Option Code", '');
            end;
        }
        field(75; "Option Subtype"; Option)
        {
            Caption = 'Option Subtype';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(80; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(90; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE("Make Code" = FIELD("Make Code"));
        }
        field(100; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." WHERE("Item Type" = CONST("Model Version"),
                                            "Make Code" = FIELD("Make Code"),
                                            "Model Code" = FIELD("Model Code"));
        }
        field(110; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(120; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
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
        key(Key1; "Make Code", "Model Code", "Model Version No.", "Option Type", "Option Subtype", "Option Code", "Vendor No.", "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TESTFIELD("Option Code");
        TESTFIELD("Vendor No.");
    end;

    trigger OnRename()
    begin
        TESTFIELD("Option Code");
        TESTFIELD("Vendor No.");
    end;

    var
        Text000: Label '%1 cannot be after %2';
        Cust: Record "18";
        Text001: Label '%1 must be blank.';
        Campaign: Record "5071";
        Text003: Label 'You can only change the %1 and %2 from the Campaign Card when %3 = %4';
        recVend: Record "23";
        cuPurchPriceCalcMgt: Codeunit 7010;
}

