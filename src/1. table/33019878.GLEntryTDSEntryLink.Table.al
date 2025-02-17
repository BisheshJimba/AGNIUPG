table 33019878 "G/L Entry - TDS Entry Link"
{

    fields
    {
        field(1; "G/L Entry No."; Integer)
        {
            TableRelation = "G/L Entry"."Entry No.";
        }
        field(2; "TDS Entry No."; Integer)
        {
            TableRelation = "TDS Entry"."Entry No.";
        }
    }

    keys
    {
        key(Key1; "G/L Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure InsertLink(GLEntryNo: Integer; TDSEntryNo: Integer)
    var
        GLEntryTdsEntryLink: Record "33019878";
    begin
        //TDS2.00
        GLEntryTdsEntryLink.INIT;
        GLEntryTdsEntryLink."G/L Entry No." := GLEntryNo;
        GLEntryTdsEntryLink."TDS Entry No." := TDSEntryNo;
        GLEntryTdsEntryLink.INSERT;
    end;
}

