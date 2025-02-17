table 99003606 "Field/Control"
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
        field(6; "No."; Integer)
        {
        }
        field(7; "SubItem No."; Integer)
        {
        }
        field(8; Enabled; Boolean)
        {
        }
        field(9; Name; Text[80])
        {
        }
        field(10; Type; Option)
        {
            OptionMembers = Binary,BLOB,Boolean,CheckBox,"Code",Control,CommandButton,DataportField,Date,Decimal,Frame,"Integer",Label,MatrixBox,MenuButton,Option,OptionButton,PictureBox,SubForm,TabControl,TableBox,Text,TextBox,Time,Image,Shape,Indicator,DateFormula,TableFilter,"Table","Field",Literal,RecordID,MenuNode,BigInteger,BigText;
        }
        field(11; "Type Name"; Text[15])
        {
        }
        field(12; X; Integer)
        {
        }
        field(13; Y; Integer)
        {
        }
        field(14; Width; Integer)
        {
        }
        field(15; Height; Integer)
        {
        }
        field(16; "Property Reference No."; Integer)
        {
        }
        field(17; "Function Reference No."; Integer)
        {
        }
        field(18; "Menu Level"; Integer)
        {
        }
        field(19; "Object Consecutive No."; Integer)
        {
        }
        field(20; TagType; Option)
        {
            OptionMembers = ,Element,Attribute;
        }
        field(21; Indentation; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key2; "Reference No.", "No.", "SubItem No.", Type)
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; "Reference No.", Type)
        {
            MaintainSIFTIndex = false;
        }
        key(Key4; "Version No.", "Object Type", "Object ID", "Property Reference No.", "Function Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key5; "Version No.", "Property Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key6; "Version No.", "Function Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key7; "Reference No.", "Entry No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key8; "Version No.", "Object Type", "Object ID", Name)
        {
            MaintainSIFTIndex = false;
        }
        key(Key9; "Version No.", "Object Type", "Object ID", "No.", "SubItem No.", Name, Type)
        {
            MaintainSIFTIndex = false;
        }
        key(Key10; "Reference No.", "No.", "SubItem No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key11; "Version No.", "Reference No.", "Object Type", "Object ID", Name, Type)
        {
            MaintainSIFTIndex = false;
        }
        key(Key12; "Version No.", "Object Type", "Object ID", "No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key13; "Version No.", "Object Type", "Object ID", "SubItem No.")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

