table 344 "Setup Checklist Line"
{
    Caption = 'Setup Checklist Line';
    DataCaptionfields = "Table Name";
    // DrillDownPageID = 531;
    //LookupPageID = 531;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = true;
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(3; "Table Name"; Text[80])
        {
            Caption = 'Table Name';
            Editable = false;
        }
        field(4; "Company Filter"; Text[30])
        {
            Caption = 'Company Filter';
            fieldClass = FlowFilter;
            TableRelation = Company;
        }
        field(6; "Company Filter (Source Table)"; Text[30])
        {
            Caption = 'Company Filter (Source Table)';
            fieldClass = FlowFilter;
            TableRelation = Company;
        }
        field(8; "No. of Records"; Integer)
        {
            Caption = 'No. of Records';
            Editable = false;
            BlankZero = true;
            //fieldClass = Flowfield;
            //CalcFormula = Lookup("Table Information"."No. of Records" where("Company Name"=field("Company Filter"),"Table No."=field("Table ID"),"No. of Records"=FILTER(<>0))); //internal scope issue
        }
        field(9; "No. of Records (Source Table)"; Integer)
        {
            Caption = 'No. of Records (Source Table)';
            Editable = false;
            BlankZero = true;
            // fieldClass = Flowfield;
            // CalcFormula = Lookup("Table Information"."No. of Records" where ("Company Name"=field("Company Filter (Source Table)"),"Table No."=field("Table ID"),"No. of Records"=FILTER(<>0))); //internal scope issue
        }
        field(10; "Licensed Table"; Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("License Permission" where("Object Type" = const(TableData), "Object Number" = field("License Table ID"), "Read Permission" = const(Yes), "Insert Permission" = const(Yes), "Modify Permission" = const(Yes), "Delete Permission" = const(Yes)));
            Caption = 'Licensed Table';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(13; "Copying Available"; Boolean)
        {
            Caption = 'Copying Available';
            Editable = true;
        }
        field(14; "Form ID"; Integer)
        {
            Caption = 'Form ID';
            Editable = false;
            // TableRelation = AllObj."Object ID" where ("Object Type"=const("2")); //object type 2 error
        }
        field(15; "Form Name"; Text[80])
        {
            Caption = 'Form Name';
            Editable = false;
        }
        field(16; "License Table ID"; Integer)
        {
            Caption = 'License Table ID';
            Editable = false;
            TableRelation = AllObj."Object ID" where("Object Type" = const("Table"));
        }
        field(17; "License Table Name"; Text[80])
        {
            Caption = 'License Table Name';
            Editable = false;
        }
        field(18; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" <> 0D) AND (xRec."Starting Date" <> 0D) AND ("Ending Date" <> 0D) THEN
                    "Ending Date" := "Ending Date" + ("Starting Date" - xRec."Starting Date");
            end;
        }
        field(19; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(20; "Responsible ID"; Code[20])
        {
            Caption = 'Responsible ID';
            //TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.LookupUserID("Responsible ID");
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.ValidateUserID("Responsible ID");
            end;
        }
        field(21; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Planning,Started,Completed,Not Used';
            OptionMembers = " ",Planning,Started,Completed,"Not Used";
        }
        field(22; Comments; Boolean)
        {
            Caption = 'Comments';
            Editable = false;
            BlankZero = true;
            // fieldClass = Flowfield;
            // CalcFormula = Exist("Setup Checklist Comment" where ("Table ID"=field("Table ID")));

        }
        field(23; "Application Area ID"; Integer)
        {
            Caption = 'Application Area ID';
            Editable = false;
            TableRelation = "Application Area Line";
        }
        field(24; "Application Area Name"; Text[80])
        {
            CalcFormula = Lookup("Application Area Line".Name where(ID = field("Application Area ID")));
            Caption = 'Application Area Name';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(25; "Vertical Sorting"; Integer)
        {
            Caption = 'Vertical Sorting';
        }
        field(26; "Data Origin"; Text[50])
        {
            Caption = 'Data Origin';
        }
        field(30; "Licensed Form"; Boolean)
        {
            Caption = 'Licensed Form';
            Editable = false;
            fieldClass = Flowfield;
            CalcFormula = Exist("License Permission" where("Object Type" = const("LimitedUsageTableData"), "Object Number" = field("Form ID"), "Execute Permission" = const(Yes))); //object type 2
        }
    }

    keys
    {
        key(Key1; "Table ID")
        {
            Clustered = true;
        }
        key(Key2; "Line No.")
        {
        }
        key(Key3; "Table Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CommentLine.SETRANGE("Table ID", "Table ID");
        CommentLine.DELETEALL;
    end;

    var
        CommentLine: Record "Setup Checklist Comment";
}

