table 25006288 "Schedule Item"
{
    Caption = 'Schedule Item';

    fields
    {
        field(6; Sequence; Integer)
        {
        }
        field(10; ItemID; Code[100])
        {
        }
        field(20; ItemNo; Code[20])
        {
        }
        field(30; Description; Text[30])
        {
        }
        field(40; GroupingCode; Code[20])
        {
            Caption = 'GroupingCode';

            trigger OnValidate()
            var
                Text001: Label 'Value ef %1 must have only ASCII chars.';
                DocumentManagement: Codeunit "25006000";
            begin
                IF NOT DocumentManagement.IsASCII(GroupingCode, 1, STRLEN(GroupingCode)) THEN
                    ERROR(Text001, FIELDCAPTION(GroupingCode));
            end;
        }
        field(50; Level; Integer)
        {
        }
        field(60; Current; Boolean)
        {
        }
        field(70; Parent; Boolean)
        {
        }
        field(80; Collapsed; Boolean)
        {
        }
        field(90; ForeColorR; Integer)
        {
            Description = 'Red';
        }
        field(92; ForeColorG; Integer)
        {
            Description = 'Green';
        }
        field(94; ForeColorB; Integer)
        {
            Description = 'Blue';
        }
        field(100; ScrollBarPosition; Integer)
        {
        }
        field(110; ScrollBarTotalCount; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Sequence)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

