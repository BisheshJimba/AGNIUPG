table 826 "DO Payment Setup"
{
    Caption = 'Dynamics Online Payment Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Authorization Required"; Boolean)
        {
            Caption = 'Authorization Required';
        }
        field(3; "Days Before Authoriz. Expiry"; Integer)
        {
            Caption = 'Days Before Authoriz. Expiry';
            MinValue = 0;
        }
        field(4; "Credit Card Nos."; Code[10])
        {
            Caption = 'Credit Card Nos.';
            TableRelation = "No. Series";
        }
        field(5; "Charge Type"; Option)
        {
            Caption = 'Charge Type';
            OptionCaption = 'Percent,Fixed';
            OptionMembers = Percent,"Fixed";

            trigger OnValidate()
            begin
                IF NOT ("Charge Type" = "Charge Type"::Percent) THEN
                    "Max. Charge Amount (LCY)" := 0;
            end;
        }
        field(6; "Charge Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Charge Value';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
        field(7; "Max. Charge Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Max. Charge Amount (LCY)';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

