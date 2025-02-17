table 33020527 "SAR Setup"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Sales GL Code"; Code[250])
        {
            FieldClass = Normal;
        }
        field(4; "Cost GL Code"; Code[250])
        {
            FieldClass = Normal;
        }
        field(5; "Report Type"; Option)
        {
            OptionCaption = ' ,Service Absorption,Dealership Expense,Depreciation';
            OptionMembers = " ","Service Absorption","Dealership Expense",Depreciation;
        }
        field(6; "Amount Type"; Option)
        {
            OptionCaption = ' ,Net Change,Balance to Date';
            OptionMembers = " ","Net Change","Balance to Date";
        }
        field(7; "Percent For Calculation"; Decimal)
        {
        }
        field(8; "Divided By"; Decimal)
        {
        }
        field(9; "Depreciation GL Code"; Code[20])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

