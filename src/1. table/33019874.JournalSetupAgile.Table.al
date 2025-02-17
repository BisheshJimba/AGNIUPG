table 33019874 "Journal Setup Agile"
{

    fields
    {
        field(1; "Table ID"; Integer)
        {
            TableRelation = Object.ID WHERE(Type = CONST(Table));
        }
        field(2; "User ID"; Code[50])
        {
            TableRelation = Table2000000002;

            trigger OnLookup()
            begin
                UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            begin
                UserMgt.ValidateUserID("User ID");
            end;
        }
        field(3; "Gen. Journal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(4; "Gen. Journal Batch Name"; Code[20])
        {

            trigger OnLookup()
            begin
                GenJnlBatch.RESET;
                GenJnlBatch.FILTERGROUP(2);
                GenJnlBatch.SETRANGE("Journal Template Name", "Gen. Journal Template Name");
                GenJnlBatch.FILTERGROUP(0);
                IF PAGE.RUNMODAL(0, GenJnlBatch) = ACTION::LookupOK THEN BEGIN
                    VALIDATE("Gen. Journal Batch Name", GenJnlBatch.Name);
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Table ID", "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserMgt: Codeunit "418";
        GenJnlBatch: Record "232";
}

