table 99003604 Variable
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Version No."; Integer)
        {
        }
        field(3; "Reference No."; Integer)
        {
        }
        field(4; "Object Type"; Option)
        {
            OptionMembers = "Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite;
        }
        field(5; "Object ID"; Integer)
        {
        }
        field(6; "Local"; Boolean)
        {
        }
        field(7; "Array"; Boolean)
        {
        }
        field(8; Temporarily; Boolean)
        {
        }
        field(9; "Var"; Boolean)
        {
        }
        field(10; "Function Parameter"; Boolean)
        {
        }
        field(11; "Function Return Type"; Boolean)
        {
        }
        field(12; Type; Option)
        {
            OptionMembers = "Record",Form,"Report",Dataport,"Codeunit",System,"Code",Text,"Integer",Boolean,Decimal,Date,DateFormula,TextConst,Time,Option,Dialog,File,"Action",OCX,Char,Binary,Automation,TransactionType,InStream,OutStream,Variant,RecordRef,FieldRef,KeyRef,RowID,GUID,DateTime,Duration,BigInteger,"XMLport",MenuSuite,BigText,RecordID;
        }
        field(13; SubType; Text[250])
        {
        }
        field(14; Name; Text[50])
        {
        }
        field(15; Size; Integer)
        {
        }
        field(16; Dimension; Text[10])
        {
        }
        field(17; "SubType ID"; Integer)
        {
        }
        field(20; "SubType Name"; Text[30])
        {
            CalcFormula = Lookup(Table99003600.Field5 WHERE(Field2 = FIELD(Version No.),
                                                             Field3=FIELD(Type),
                                                             Field4=FIELD(SubType ID)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Property Reference No.";Integer)
        {
        }
        field(22;"Object Consecutive No.";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key2;"Reference No.","Local","Function Parameter",Name,Type,"SubType ID")
        {
            MaintainSIFTIndex = false;
        }
        key(Key3;"Version No.","Object Type","Object ID",Name)
        {
            MaintainSIFTIndex = false;
        }
        key(Key4;"Version No.",Type,"SubType ID")
        {
            MaintainSIFTIndex = false;
        }
        key(Key5;"Version No.","Property Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key6;"Version No.","Reference No.","Object Type","Object ID","Entry No.","Local","Function Parameter",Name,"Function Return Type")
        {
            MaintainSIFTIndex = false;
        }
        key(Key7;"Reference No.","Entry No.")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

