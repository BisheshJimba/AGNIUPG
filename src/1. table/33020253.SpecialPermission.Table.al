table 33020253 "Special Permission"
{
    Caption = 'Variable Field Usage';
    LookupPageID = 25006006;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(10; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = Object.ID WHERE(Type = CONST(Table));

            trigger OnLookup()
            begin
                /*LookUpMgt.LookUpVariableUsageObject("Table No.");
                VALIDATE("Table No.");*/

            end;
        }
        field(20; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field.No. WHERE(TableNo = FIELD(Table No.));

            trigger OnLookup()
            begin
                LookUpMgt.LookUpVariableUsageField("Field No.", "Table No.");
                VALIDATE("Field No.");
            end;
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        LookUpMgt: Codeunit "25006003";
}

