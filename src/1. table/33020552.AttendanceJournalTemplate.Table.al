table 33020552 "Attendance Journal Template"
{
    LookupPageID = 33020556;

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(6; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = Object.ID WHERE(Type = CONST(2));

            trigger OnValidate()
            begin
                IF "Page ID" = 0 THEN
                    VALIDATE(Type);
            end;
        }
        field(10; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(21; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(22; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(23; Type; Option)
        {
            OptionCaption = 'Attendance';
            OptionMembers = Attendance;

            trigger OnValidate()
            begin
                SourceCodeSetup.GET;
                CASE Type OF
                    Type::Attendance:
                        BEGIN
                            "Source Code" := SourceCodeSetup."Attendance Management";
                            "Page ID" := PAGE::"Attendance Journal";
                        END;
                END;
            end;
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        SourceCodeSetup: Record "242";
}

