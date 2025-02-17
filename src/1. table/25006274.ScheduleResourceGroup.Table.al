table 25006274 "Schedule Resource Group"
{
    Caption = 'Schedule Resource Group';
    DrillDownPageID = 25006350;
    LookupPageID = 25006350;

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(33020235; Workplace; Code[10])
        {
            TableRelation = "Serv. Workplace".Code;
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

    var
        GroupLine: Record "25006275";

    [Scope('Internal')]
    procedure FilterOnView(): Code[10]
    var
        UserProfileSetup: Record "25006067";
        UserSetup: Record "91";
    begin
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserProfileSetup.GET(UserSetup."Default User Profile Code") THEN BEGIN
                EXIT(UserProfileSetup."Default Workplace");
            END;
        END;
        EXIT('');
    end;
}

