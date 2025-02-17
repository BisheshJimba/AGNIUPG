table 37079308 "ESL Snapshot Permission"
{
    Caption = 'Snapshot Permission';
    DataPerCompany = false;
    DrillDownPageID = 37079308;
    LookupPageID = 37079308;

    fields
    {
        field(1; "Role ID"; Code[20])
        {
            Caption = 'Role ID';
            TableRelation = "ESL Snapshot Role"."Role ID" WHERE(Snapshot No.=FIELD(Snapshot No.));
        }
        field(2;"Role Name";Text[30])
        {
            CalcFormula = Lookup("ESL Snapshot Role"."Role Name" WHERE (Role ID=FIELD(Role ID),
                                                                        Snapshot No.=FIELD(Snapshot No.)));
            Caption = 'Role Name';
            FieldClass = FlowField;
        }
        field(3;"Object Type";Option)
        {
            Caption = 'Object Type';
            OptionCaption = 'TableData,Table,Form,Report,Dataport,Codeunit,XMLport,MenuSuite,Page,Query,System';
            OptionMembers = TableData,"Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite,"Page","Query",System;
        }
        field(4;"Object ID";Integer)
        {
            Caption = 'Object ID';
            TableRelation = AllObj."Object ID" WHERE (Object Type=FIELD(Object Type));
        }
        field(5;"Object Caption";Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=FIELD(Object Type),
                                                                           Object ID=FIELD(Object ID)));
            Caption = 'Object Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Read Permission";Option)
        {
            Caption = 'Read Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(7;"Insert Permission";Option)
        {
            Caption = 'Insert Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(8;"Modify Permission";Option)
        {
            Caption = 'Modify Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(9;"Delete Permission";Option)
        {
            Caption = 'Delete Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(10;"Execute Permission";Option)
        {
            Caption = 'Execute Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(11;"Security Filter";TableFilter)
        {
            Caption = 'Security Filter';
        }
        field(1001;"Snapshot No.";Code[20])
        {
            Caption = 'Snapshot No.';
            NotBlank = true;
            TableRelation = Table37079302.Field1;
        }
        field(1002;"Exists in Live";Boolean)
        {
            CalcFormula = Exist(Permission WHERE (Role ID=FIELD(Role ID),
                                                  Object Type=FIELD(Object Type),
                                                  Object ID=FIELD(Object ID)));
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
        key(Key1;"Snapshot No.","Role ID","Object Type","Object ID")
        {
            Clustered = true;
        }
        key(Key2;"Role ID","Object Type","Object ID")
        {
        }
        key(Key3;"Object Type","Object ID")
        {
        }
    }

    fieldgroups
    {
    }
}

