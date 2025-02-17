table 33019859 "Customer Interaction Log"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = false;
            BlankZero = true;
            Editable = false;
        }
        field(2; "Contact No."; Code[20])
        {
            Editable = false;
            TableRelation = Contact;

            trigger OnValidate()
            begin
                Contact.RESET;
                Contact.SETRANGE("No.", "Contact No.");
                IF Contact.FINDFIRST THEN BEGIN
                    Name := Contact.Name;
                END;

                "User ID" := USERID;
            end;
        }
        field(3; Name; Text[50])
        {
            Editable = false;
        }
        field(4; "Line No."; Integer)
        {
            Editable = false;
        }
        field(5; "Pipeline Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Pipeline Steps";
        }
        field(6; "Date of Interaction"; Date)
        {
        }
        field(7; "Interaction Type"; Option)
        {
            OptionCaption = ' ,Phone Call,Meeting,E-mail,Fax,Memo';
            OptionMembers = " ","Phone Call",Meeting,"E-mail",Fax,Memo;
        }
        field(8; "Interaction Details"; Text[250])
        {
        }
        field(9; Remarks; Text[250])
        {
        }
        field(10; "Next Date of Interaction"; Date)
        {
        }
        field(11; "User ID"; Code[50])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Contact No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CustInteractionLog.RESET;
        IF CustInteractionLog.FINDLAST THEN BEGIN
            "Entry No." := CustInteractionLog."Entry No." + 1;
        END;
    end;

    var
        Contact: Record "5050";
        CustInteractionLog: Record "33019859";
}

