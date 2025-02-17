table 104199 "Approval For Procurement"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Memo No."; Code[20])
        {
            TableRelation = "Procurement Memo"."Memo No.";
        }
        field(3; "User ID"; Code[50])
        {
            Caption = 'Approver ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            begin
                UserMgt.LookupUserID("User ID");
            end;
        }
        field(4; Type; Option)
        {
            OptionMembers = " ",Memo;
        }
        field(5; "Sequence No."; Integer)
        {
        }
        field(50000; Approved; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Memo No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserMgt: Codeunit "418";
}

