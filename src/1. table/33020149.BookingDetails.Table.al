table 33020149 "Booking Details"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            TableRelation = "Sales Progress Details".Field1;
        }
        field(3; Date; Date)
        {
        }
        field(4; "Model Version No."; Code[20])
        {

            trigger OnLookup()
            begin
                //Lookup Model Version.
                GblItem.RESET;
                IF GblLookupMgt.LookUpModelVersion(GblItem, "Model Version No.", Make, "Model No.") THEN
                    VALIDATE("Model Version No.", GblItem."No.");
            end;

            trigger OnValidate()
            begin
                //Code to bring model version name.
                GblItem.RESET;
                GblItem.SETRANGE("No.", "Model Version No.");
                IF GblItem.FIND('-') THEN
                    "Model Version Name" := GblItem.Description;
            end;
        }
        field(5; "Model Version Name"; Text[50])
        {
        }
        field(6; Derivative; Text[30])
        {
        }
        field(7; "Yes/No"; Boolean)
        {
        }
        field(8; "Model No."; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make));
        }
        field(9;"Sales Progress Code";Code[10])
        {
            TableRelation = "Sales Progress Details".Field2;
        }
        field(10;Make;Code[20])
        {
            TableRelation = Make;
        }
    }

    keys
    {
        key(Key1;"Prospect No.","Sales Progress Code",Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GblLookupMgt: Codeunit "25006003";
        GblItem: Record "27";
}

