table 37079306 "ESL Snapshot Windows Acc. Ctrl"
{
    Caption = 'Snapshot Windows Access Control';
    DataPerCompany = false;
    DrillDownPageID = 37079306;
    LookupPageID = 37079306;

    fields
    {
        field(1; "Login SID"; Text[119])
        {
            Caption = 'Login SID';
            TableRelation = Table37079305.Field1;
        }
        field(2; "Role ID"; Code[20])
        {
            Caption = 'Role ID';
            TableRelation = "ESL Snapshot Role"."Role ID" WHERE(Snapshot No.=FIELD(Snapshot No.));
        }
        field(3;"Company Name";Text[30])
        {
            Caption = 'Company Name';
            TableRelation = "ESL Snapshot Company".Name WHERE (Snapshot No.=FIELD(Snapshot No.));
        }
        field(5;"Login ID";Text[131])
        {
            CalcFormula = Lookup(Table37079305.Field2 WHERE (Field1=FIELD(Login SID),
                                                             Field1001=FIELD(Snapshot No.)));
            Caption = 'Login ID';
            FieldClass = FlowField;
        }
        field(7;"Role Name";Text[30])
        {
            CalcFormula = Lookup("ESL Snapshot Role"."Role Name" WHERE (Role ID=FIELD(Role ID),
                                                                        Snapshot No.=FIELD(Snapshot No.)));
            Caption = 'Role Name';
            FieldClass = FlowField;
        }
        field(1001;"Snapshot No.";Code[20])
        {
            Caption = 'Snapshot No.';
            NotBlank = true;
            TableRelation = Table37079302.Field1;
        }
        field(1002;"Exists in Live";Boolean)
        {
            CalcFormula = Exist("Access Control" WHERE (User Security ID=FIELD(Login SID),
                                                        Role ID=FIELD(Role ID),
                                                        Company Name=FIELD(Company Name)));
            Caption = 'Exists in Live';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1005;"Created Date Time";DateTime)
        {
            CalcFormula = Lookup(Table37079302.Field4 WHERE (Field1=FIELD(Snapshot No.)));
            Caption = 'Created Date Time';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Snapshot No.","Login SID","Role ID","Company Name")
        {
            Clustered = true;
        }
        key(Key2;"Login SID","Role ID","Company Name")
        {
        }
        key(Key3;"Role ID","Company Name")
        {
        }
    }

    fieldgroups
    {
    }
}

