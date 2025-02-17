table 33020153 "Lost Prospect"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            TableRelation = Contact;
        }
        field(2; "Code"; Code[10])
        {
        }
        field(3; Desription; Text[150])
        {
        }
        field(4; Date; Date)
        {

            trigger OnValidate()
            begin
                //Set lost prospect flag in Contact (Prospect is Contact).
                gblProspect.RESET;
                gblProspect.SETRANGE("No.", "Prospect No.");
                IF gblProspect.FIND('-') THEN BEGIN
                    gblProspect.Status := gblProspect.Status::Inactive;
                    gblProspect.MODIFY;
                END;
            end;
        }
        field(5; Selected; Boolean)
        {
        }
        field(6; "Version No."; Integer)
        {
        }
        field(7; Reprospected; Boolean)
        {
        }
        field(8; "Reprospected Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Prospect No.", "Version No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        gblProspect: Record "5050";
}

