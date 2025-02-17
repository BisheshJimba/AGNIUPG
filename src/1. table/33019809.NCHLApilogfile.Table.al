table 33019809 "NCHL Api log file"
{

    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
            Caption = 'Id';
        }
        field(2; "API URL"; Text[250])
        {
            Caption = 'API URL';
        }
        field(3; "API Credential Type"; Text[20])
        {
            Caption = 'API Credential Type';
        }
        field(4; "API Authentication"; Text[20])
        {
            Caption = 'API Authentication';
        }
        field(5; "API UserName"; Text[50])
        {
            Caption = 'API UserName';
        }
        field(6; "API Password"; Text[50])
        {
            Caption = 'API Password';
        }
        field(7; "API Body"; Text[250])
        {
            Caption = 'API Body';
        }
        field(8; "Create Date Time"; DateTime)
        {
            Caption = 'Create Date Time';
        }
        field(9; Response; Text[250])
        {
            Caption = 'Response';
        }
        field(10; Token; Text[100])
        {
            Caption = 'Token';
        }
        field(11; "API Method"; Text[10])
        {
        }
        field(12; "Response 2"; Text[250])
        {
        }
        field(13; "Document No."; Code[20])
        {
        }
        field(14; "Response Blob"; BLOB)
        {
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Create Date Time" := CURRENTDATETIME;
    end;
}

