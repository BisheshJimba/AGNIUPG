table 14125600 "Dimension Setup Table"
{

    fields
    {
        field(1; "Table ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));

            trigger OnValidate()
            begin
                IF "Table ID" = 0 THEN
                    "Table Caption" := ''
                ELSE BEGIN
                    RecRef.OPEN("Table ID");
                    "Table Caption" := RecRef.CAPTION;
                END;
            end;
        }
        field(2; "Dimension 1 - Field No."; Integer)
        {
        }
        field(3; "Dimension 2 - Field No."; Integer)
        {
        }
        field(4; "Dimension 3 - Field No."; Integer)
        {
        }
        field(5; "Dimension 4 - Field No."; Integer)
        {
        }
        field(6; "Dimension 5 - Field No."; Integer)
        {
        }
        field(7; "Dimension 6 - Field No."; Integer)
        {
        }
        field(8; "Dimension 7 - Field No."; Integer)
        {
        }
        field(9; "Dimension 8 - Field No."; Integer)
        {
        }
        field(10; "Document No. Field No."; Integer)
        {
        }
        field(11; "Dimension Set Id - Field No."; Integer)
        {
        }
        field(12; "Primary Key 1"; Integer)
        {
        }
        field(13; "Primary Key 2"; Integer)
        {
        }
        field(14; "Primary Key 3"; Integer)
        {
        }
        field(15; "Primary Key 4"; Integer)
        {
        }
        field(20; Skip; Boolean)
        {
        }
        field(21; "Table Caption"; Text[30])
        {
        }
        field(22; "Entry No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Table ID")
        {
            Clustered = true;
        }
        key(Key2; "Table Caption")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Table ID", "Table Caption")
        {
        }
    }

    var
        RecRef: RecordRef;
}

