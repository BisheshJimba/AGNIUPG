table 50003 "Terms And Conditions001"
{
    Caption = 'Terms And Conditions'; //Terms And Condition table already in base

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = ' ,Vehicle Purchase,Vehicle Sales,General Procurement,Spares Purchase,Spares Sales';
            OptionMembers = " ","Vehicle Purchase","Vehicle Sales","General Procurement","Spares Purchase","Spares Sales";
        }
        field(2; "No."; Integer)
        {
        }
        field(3; Description; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

