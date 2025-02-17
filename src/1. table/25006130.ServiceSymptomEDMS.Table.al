table 25006130 "Service Symptom EDMS"
{
    Caption = 'DMS Service Symptom';
    DrillDownPageID = 25006169;
    LookupPageID = 25006169;

    fields
    {
        field(9; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;
        }
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(20; Name; Text[70])
        {
            Caption = 'Name';
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(40; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(41; "Description 3"; Text[100])
        {
            Caption = 'Description 3';
        }
        field(50; "Symptom Group"; Code[20])
        {
            Caption = 'Symptom Group';
            TableRelation = "Symptom Group EDMS";

            trigger OnValidate()
            begin
                IF recGRP.GET("Symptom Group") THEN
                    "Symptom Group Name" := recGRP.Name;
            end;
        }
        field(51; "Symptom Group Name"; Text[50])
        {
            Caption = 'Symptom Group Name';
        }
        field(60; Common; Boolean)
        {
            Caption = 'Common';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recGRP: Record "25006131";
}

