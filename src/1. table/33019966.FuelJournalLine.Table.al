table 33019966 "Fuel Journal Line"
{
    Caption = 'Fuel Journal Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            TableRelation = "Item Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name WHERE(Journal Template Name=FIELD(Journal Template Name));
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(4; "Entry Type"; Option)
        {
            OptionCaption = ' ,Positive Adjmt.,Negative Adjmt.';
            OptionMembers = " ","Positive Adjmt.","Negative Adjmt.";
        }
        field(5; "Item No."; Code[20])
        {
            TableRelation = Item.No. WHERE(Blocked = CONST(No));
        }
        field(6; Description; Text[50])
        {
        }
        field(7; "Document Type"; Option)
        {
            OptionCaption = 'Coupon,Stock,Cash';
            OptionMembers = Coupon,Stock,Cash;
        }
        field(8; Quantity; Decimal)
        {
        }
        field(9; "Unit of Measure"; Code[10])
        {
        }
        field(10; Rate; Decimal)
        {
        }
        field(11; Amount; Decimal)
        {
        }
        field(12; "Posting Date"; Date)
        {
        }
        field(13; "Document Date"; Date)
        {
        }
        field(14; "User ID"; Code[50])
        {
        }
        field(15; "Fuel Type"; Option)
        {
            OptionCaption = ' ,Diesel,Petrol,Kerosene,Mobile,Engine Oil,Others';
            OptionMembers = " ",Diesel,Petrol,Kerosene,Mobile,"Engine Oil",Others;
        }
        field(16; Location; Code[10])
        {
            TableRelation = "Location - Admin";
        }
        field(17; "Document No."; Code[20])
        {
        }
        field(18; "Source Code"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        SourceCodeSetup.GET;
        "Source Code" := SourceCodeSetup."Fuel Journal Line";
    end;

    var
        SourceCodeSetup: Record "242";
}

