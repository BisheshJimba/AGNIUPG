table 37079304 "ESL Snapshot Database Acc Ctrl"
{
    Caption = 'Snapshot Database Access Control';
    DataPerCompany = false;
    DrillDownPageID = 37079304;
    LookupPageID = 37079304;

    fields
    {
        field(1; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = Table37079303.Field1 WHERE(Field1001 = FIELD(Snapshot No.));
        }
        field(2; "User Name"; Text[30])
        {
            CalcFormula = Lookup(Table37079303.Field3 WHERE(Field1 = FIELD(User ID),
                                                             Field1001=FIELD(Snapshot No.)));
            Caption = 'User Name';
            FieldClass = FlowField;
        }
        field(3;"Role ID";Code[20])
        {
            Caption = 'Role ID';
            TableRelation = "ESL Snapshot Role"."Role ID" WHERE (Snapshot No.=FIELD(Snapshot No.));
        }
        field(4;"Role Name";Text[30])
        {
            CalcFormula = Lookup("ESL Snapshot Role"."Role Name" WHERE (Role ID=FIELD(Role ID),
                                                                        Snapshot No.=FIELD(Snapshot No.)));
            Caption = 'Role Name';
            FieldClass = FlowField;
        }
        field(5;"Company Name";Text[30])
        {
            Caption = 'Company Name';
            TableRelation = "ESL Snapshot Company".Name WHERE (Snapshot No.=FIELD(Snapshot No.));
        }
        field(1001;"Snapshot No.";Code[20])
        {
            Caption = 'Snapshot No.';
            NotBlank = true;
            TableRelation = Table37079302.Field1;
        }
        field(1002;"Exists in Live";Boolean)
        {
            CalcFormula = Exist(Table2000000003 WHERE (Field1=FIELD(User ID),
                                                       Field3=FIELD(Role ID),
                                                       Field5=FIELD(Company Name)));
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
        key(Key1;"Snapshot No.","User ID","Role ID","Company Name")
        {
            Clustered = true;
        }
        key(Key2;"User ID","Role ID","Company Name")
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

