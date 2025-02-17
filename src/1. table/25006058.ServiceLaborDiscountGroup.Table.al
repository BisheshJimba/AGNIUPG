table 25006058 "Service Labor Discount Group"
{
    Caption = 'Service Labor Discount Group';
    LookupPageID = 25006078;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
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

    trigger OnDelete()
    var
        SalesLineDiscount: Record "25006057";
    begin
        SalesLineDiscount.SETRANGE(Type, SalesLineDiscount.Type::"Labor Discount Group");
        SalesLineDiscount.SETRANGE(Code, Code);
        SalesLineDiscount.DELETEALL(TRUE);
    end;
}

