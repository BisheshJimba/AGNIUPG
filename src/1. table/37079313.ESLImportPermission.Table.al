table 37079313 "ESL Import Permission"
{
    Caption = 'Import Permission';
    DataPerCompany = false;
    DrillDownPageID = 37079334;
    LookupPageID = 37079334;

    fields
    {
        field(1; "Role ID"; Code[20])
        {
            Caption = 'Role ID';
            TableRelation = Table37079312.Field1;
        }
        field(2; "Role Name"; Text[30])
        {
            CalcFormula = Lookup(Table37079312.Field2 WHERE(Field1 = FIELD(Role ID)));
            Caption = 'Role Name';
            FieldClass = FlowField;
        }
        field(3; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionCaption = 'TableData,Table,Form,Report,Dataport,Codeunit,XMLport,MenuSuite,Page,Query,System';
            OptionMembers = TableData,"Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite,"Page","Query",System;
        }
        field(4; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = AllObj."Object ID" WHERE(Object Type=FIELD(Object Type));
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
        field(1002;"Exists in Live";Boolean)
        {
            CalcFormula = Exist(Permission WHERE (Role ID=FIELD(Role ID),
                                                  Object Type=FIELD(Object Type),
                                                  Object ID=FIELD(Object ID)));
            Caption = 'Exists in Live';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1003;"Existing Live Permission";Boolean)
        {
            Caption = 'Existing Live Permission';
        }
        field(1004;"Identical Live Permission";Boolean)
        {
            Caption = 'Identical Live Permission';
        }
        field(1005;"Live Read Permission";Option)
        {
            CalcFormula = Lookup(Permission."Read Permission" WHERE (Role ID=FIELD(Role ID),
                                                                     Object Type=FIELD(Object Type),
                                                                     Object ID=FIELD(Object ID)));
            Caption = 'Live Read Permission';
            Editable = false;
            FieldClass = FlowField;
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(1006;"Live Insert Permission";Option)
        {
            CalcFormula = Lookup(Permission."Insert Permission" WHERE (Role ID=FIELD(Role ID),
                                                                       Object Type=FIELD(Object Type),
                                                                       Object ID=FIELD(Object ID)));
            Caption = 'Live Insert Permission';
            Editable = false;
            FieldClass = FlowField;
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(1007;"Live Modify Permission";Option)
        {
            CalcFormula = Lookup(Permission."Modify Permission" WHERE (Role ID=FIELD(Role ID),
                                                                       Object Type=FIELD(Object Type),
                                                                       Object ID=FIELD(Object ID)));
            Caption = 'Live Modify Permission';
            Editable = false;
            FieldClass = FlowField;
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(1008;"Live Delete Permission";Option)
        {
            CalcFormula = Lookup(Permission."Delete Permission" WHERE (Role ID=FIELD(Role ID),
                                                                       Object Type=FIELD(Object Type),
                                                                       Object ID=FIELD(Object ID)));
            Caption = 'Live Delete Permission';
            Editable = false;
            FieldClass = FlowField;
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(1009;"Live Execute Permission";Option)
        {
            CalcFormula = Lookup(Permission."Execute Permission" WHERE (Role ID=FIELD(Role ID),
                                                                        Object Type=FIELD(Object Type),
                                                                        Object ID=FIELD(Object ID)));
            Caption = 'Live Execute Permission';
            Editable = false;
            FieldClass = FlowField;
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
    }

    keys
    {
        key(Key1;"Role ID","Object Type","Object ID")
        {
            Clustered = true;
        }
        key(Key2;"Object Type","Object ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        UpdateStatistics;
    end;

    trigger OnModify()
    begin
        UpdateStatistics;
    end;

    trigger OnRename()
    begin
        UpdateStatistics;
    end;

    [Scope('Internal')]
    procedure UpdateStatistics()
    var
        Permission: Record "2000000005";
    begin
        "Existing Live Permission" := FALSE;
        "Identical Live Permission" := FALSE;
        IF Permission.GET("Role ID","Object Type","Object ID") THEN BEGIN
          "Existing Live Permission" := TRUE;
          IF (Permission."Read Permission" = "Read Permission") AND
             (Permission."Insert Permission" = "Insert Permission") AND
             (Permission."Modify Permission" = "Modify Permission") AND
             (Permission."Delete Permission" = "Delete Permission") AND
             (Permission."Execute Permission" = "Execute Permission")
          THEN
            "Identical Live Permission" := TRUE;
        END;
    end;
}

