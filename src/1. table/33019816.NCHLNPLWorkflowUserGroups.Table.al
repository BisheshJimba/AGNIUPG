table 33019816 "NCHL-NPL Workflow User Groups"
{

    fields
    {
        field(1; "Approval Code"; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "User ID"; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                UserSetup.GET(USERID);
                IF NOT UserSetup."Can Approve NCHL-NPI User" THEN
                    ERROR('You are not authorized to change %1', FIELDCAPTION("User ID"));
            end;
        }
        field(4; Sequence; Integer)
        {
        }
        field(5; "New User ID"; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                IF "New User ID" = "User ID" THEN
                    ERROR('%1 cannot be same as current %2', FIELDCAPTION("New User ID"), FIELDCAPTION("User ID"));
            end;
        }
        field(6; "Old User ID"; Code[50])
        {
            Description = 'value will be updated every time user change request is approved by User ID';
            TableRelation = "User Setup";
        }
    }

    keys
    {
        key(Key1; "Approval Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Sequence)
        {
        }
    }

    fieldgroups
    {
    }

    var
        UserSetup: Record "91";
}

