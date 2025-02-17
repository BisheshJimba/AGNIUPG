table 52102 "Adapter Option Value"
{
    // JETAD10.03, 05/03/2011, Index 1, JDL - Increase option tex from 80 to 250 to allow longer option strings.

    DataPerCompany = false;

    fields
    {
        field(1; "Table No."; Integer)
        {
        }
        field(2; "Field No."; Integer)
        {
        }
        field(3; "Option Value"; Integer)
        {
        }
        field(4; "Text Value"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.", "Option Value")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

