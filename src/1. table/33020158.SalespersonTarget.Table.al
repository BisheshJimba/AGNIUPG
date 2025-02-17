table 33020158 "Salesperson Target"
{
    Caption = 'Salesperson Target';

    fields
    {
        field(1; "Salesperson Code"; Code[10])
        {
            TableRelation = Salesperson/Purchaser;
        }
        field(2;Year;Integer)
        {
            NotBlank = true;
            TableRelation = "English Year".Code;
        }
        field(3;Month;Option)
        {
            NotBlank = true;
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(5;"Week No";Integer)
        {
        }
        field(7;C0;Integer)
        {
        }
        field(8;C1;Integer)
        {
        }
        field(9;C2;Integer)
        {
        }
        field(10;C3;Integer)
        {
        }
        field(15;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
    }

    keys
    {
        key(Key1;"Salesperson Code",Year,Month,"Week No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status,Status :: Open);
    end;

    trigger OnModify()
    begin
        TESTFIELD(Status,Status :: Open);
    end;

    trigger OnRename()
    begin
        TESTFIELD(Status,Status :: Open);
    end;
}

