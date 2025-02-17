table 33020154 "Test Drive Header"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
        }
        field(2; Date; Date)
        {
        }
        field(3; "Model Version No."; Code[20])
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
        field(4; "Model Version Name"; Text[50])
        {
        }
        field(5; "Driving License No."; Text[30])
        {
        }
        field(6; "Vehicle Currenty Owned"; Text[50])
        {
        }
        field(7; Views; Text[250])
        {
        }
        field(8; "Considered Vehicle (Another)"; Boolean)
        {
        }
        field(9; "Which Vehicle"; Text[50])
        {
        }
        field(10; Comparision; Text[250])
        {
        }
        field(11; "Model No."; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make));
        }
        field(12;"Sales Progress Code";Code[10])
        {
        }
        field(13;Make;Code[20])
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
        key(Key2;Date)
        {
        }
    }

    fieldgroups
    {
    }

    var
        GblLookupMgt: Codeunit "25006003";
        GblItem: Record "27";
        gblVhCRMMngt: Codeunit "33020142";
}

