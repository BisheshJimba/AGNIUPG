table 25006760 "Item Discount Group Parameter"
{
    // 10.03.2015 EDMS P21 #T029
    //   Restructured

    Caption = 'Item Discount Group Parameter';
    LookupPageID = 25006862;

    fields
    {
        field(5; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(10; "Item Discount Group Code"; Code[10])
        {
            Caption = 'Item Discount Group Code';
            TableRelation = "Item Discount Group";
        }
        field(20; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(40; "Standard Discount %"; Decimal)
        {
            Caption = 'Standard Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50; "Express Discount %"; Decimal)
        {
            Caption = 'Express Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(60; "Standard Shipment Cost %"; Decimal)
        {
            Caption = 'Standard Shipment Cost %';
        }
        field(70; "Standard Markup %"; Decimal)
        {
            Caption = 'Standard Markup %';
        }
        field(80; "Express Shipment Cost %"; Decimal)
        {
            Caption = 'Express Shipment Cost %';
        }
        field(90; "Standard Packing Cost %"; Decimal)
        {
            Caption = 'Standard Packing Cost %';
        }
        field(100; "Express Packing Cost %"; Decimal)
        {
            Caption = 'Express Packing Cost %';
        }
        field(110; "Standard Insurance Cost%"; Decimal)
        {
            Caption = 'Standard Insurance Cost%';
        }
        field(120; "Express Insurance Cost%"; Decimal)
        {
            Caption = 'Express Insurance Cost%';
        }
        field(130; "Standard Shipment Term"; DateFormula)
        {
            Caption = 'Standard Shipment Term';
        }
        field(140; "Express Shipment Term"; DateFormula)
        {
            Caption = 'Express Shipment Term';
        }
        field(150; "Express Markup %"; Decimal)
        {
            Caption = 'Express Markup %';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Item Discount Group Code", "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        tcREZ001: Label '%1 can''t be greater than %2';
}

