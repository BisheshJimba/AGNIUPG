table 37079311 "ESL Trace Event"
{
    Caption = 'Trace Event';
    DataPerCompany = false;

    fields
    {
        field(1; "Role ID"; Code[20])
        {
            Caption = 'Role ID';
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(11; Name; Text[30])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(12; ID; Integer)
        {
            Caption = 'ID';
            Editable = false;
        }
        field(13; "TextData Start"; Text[250])
        {
            Caption = 'TextData Start';
            Editable = false;
        }
        field(14; "TextData From Statement"; Text[250])
        {
            Caption = 'TextData From Statement';
            Editable = false;
        }
        field(15; Type; Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = ' ,SELECT,INSERT,UPDATE,DELETE,Object';
            OptionMembers = " ",SELECT,INSERT,UPDATE,DELETE,"Object";
        }
        field(16; "Object Type"; Option)
        {
            Caption = 'Object Type';
            Editable = false;
            OptionCaption = 'TableData,Table,Form,Report,Dataport,Codeunit,XMLport,MenuSuite,Page,Query,System';
            OptionMembers = TableData,"Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite,"Page","Query",System;
        }
        field(17; "Object ID"; Integer)
        {
            BlankZero = true;
            Caption = 'Object ID';
            Editable = false;
            TableRelation = AllObj."Object ID" WHERE(Object Type=FIELD(Object Type));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(18;"Object Caption";Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=FIELD(Object Type),
                                                                           Object ID=FIELD(Object ID)));
            Caption = 'Object Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Read Required";Boolean)
        {
            Caption = 'Read Required';
            Editable = false;
        }
        field(22;"Insert Required";Boolean)
        {
            Caption = 'Insert Required';
            Editable = false;
        }
        field(23;"Modify Required";Boolean)
        {
            Caption = 'Modify Required';
            Editable = false;
        }
        field(24;"Delete Required";Boolean)
        {
            Caption = 'Delete Required';
            Editable = false;
        }
        field(25;"Execute Required";Boolean)
        {
            Caption = 'Execute Required';
            Editable = false;
        }
        field(26;"Calculate Flowfield Required";Boolean)
        {
            Caption = 'Calculate Flowfield Required';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Role ID","Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

