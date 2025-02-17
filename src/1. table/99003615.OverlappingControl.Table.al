table 99003615 "Overlapping Control"
{

    fields
    {
        field(1; "Object Type"; Option)
        {
            OptionMembers = "Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite;
        }
        field(2; "Object ID"; Integer)
        {
        }
        field(3; "Type First Control"; Option)
        {
            OptionMembers = Binary,BLOB,Boolean,CheckBox,"Code",Control,CommandButton,DataportField,Date,Decimal,Frame,"Integer",Label,MatrixBox,MenuButton,Option,OptionButton,PictureBox,SubForm,TabControl,TableBox,Text,TextBox,Time,Image,Shape,Indicator,DateFormula;
        }
        field(4; "No. First Control"; Integer)
        {
        }
        field(5; "Name First Control"; Text[50])
        {
        }
        field(6; "Page No. First Control"; Integer)
        {
        }
        field(7; "Type Second Control"; Option)
        {
            OptionMembers = Binary,BLOB,Boolean,CheckBox,"Code",Control,CommandButton,DataportField,Date,Decimal,Frame,"Integer",Label,MatrixBox,MenuButton,Option,OptionButton,PictureBox,SubForm,TabControl,TableBox,Text,TextBox,Time,Image,Shape,Indicator,DateFormula;
        }
        field(8; "No. Second Control"; Integer)
        {
        }
        field(9; "Name Second Control"; Text[50])
        {
        }
        field(10; "Page No. Second Control"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Object Type", "Object ID", "No. First Control", "No. Second Control")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

