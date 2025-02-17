table 33019836 "Spare Analysis Setup"
{
    // There are 4 categorization on Items (Location Wise/As a Whole)
    // 1)Non Moving(0) Qty. Sales Monthly
    // 2)Slow Moving(0-2)Qty. Sales Monthly
    // 3)Medium Moving(2-5)Qty. Sales Monthly
    // 4)Fast Moving(>5)Qty. Sales Monthly
    // 
    // Average Issue := (Monthly Sales)/12
    // 
    // Fast/Medium/Slow Moving
    // 1)Minimum Level := 30 Days
    // 2)Reorder Level :=45 Days
    // 3)Max Level:=60 Days
    // 
    // Formula For Each
    // Level := (Average Issue)/30 * Days


    fields
    {
        field(1; "Item Type"; Option)
        {
            OptionCaption = 'Spare,Battery,Lube';
            OptionMembers = Spare,Battery,Lube;
        }
        field(2; Usage; Option)
        {
            OptionCaption = 'Non Moving,Slow Moving,Medium Moving,Fast Moving';
            OptionMembers = "Non Moving","Slow Moving","Medium Moving","Fast Moving";
        }
        field(3; "Min Sales Qty. per Month"; Decimal)
        {
        }
        field(4; "Max Sales Qty. per Month"; Decimal)
        {
        }
        field(5; "Minimum Level (Days)"; Integer)
        {

            trigger OnValidate()
            begin
                IF Usage <> Usage::"Non Moving" THEN
                    TESTFIELD("Minimum Level (Days)");
            end;
        }
        field(6; "Reorder Level (Days)"; Integer)
        {

            trigger OnValidate()
            begin
                IF Usage <> Usage::"Non Moving" THEN
                    TESTFIELD("Reorder Level (Days)");
            end;
        }
        field(7; "Max Level (Days)"; Integer)
        {

            trigger OnValidate()
            begin
                IF Usage <> Usage::"Non Moving" THEN
                    TESTFIELD("Max Level (Days)");
            end;
        }
    }

    keys
    {
        key(Key1; "Item Type", Usage)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

