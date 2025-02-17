table 33020384 "Work Experience"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
        }
        field(2; WE1_SN; Option)
        {
            OptionMembers = " ","1","-";
        }
        field(3; WE1_Orgnization; Text[100])
        {
        }
        field(4; WE1_Department; Text[50])
        {
        }
        field(5; WE1_Position; Text[30])
        {
        }
        field(6; WE1_Duration; Text[30])
        {
        }
        field(7; WE2_SN; Option)
        {
            OptionMembers = " ","2","-";
        }
        field(8; WE2_Orgnization; Text[100])
        {
        }
        field(9; WE2_Department; Text[50])
        {
        }
        field(10; WE2_Position; Text[30])
        {
        }
        field(11; WE2_Duration; Text[30])
        {
        }
        field(12; WE3_SN; Option)
        {
            OptionMembers = " ","3","-";
        }
        field(13; WE3_Orgnization; Text[100])
        {
        }
        field(14; WE3_Department; Text[50])
        {
        }
        field(15; WE3_Position; Text[30])
        {
        }
        field(16; WE3_Duration; Text[30])
        {
        }
        field(17; WE4_SN; Option)
        {
            OptionMembers = " ","4","-";
        }
        field(18; WE4_Orgnization; Text[100])
        {
        }
        field(19; WE4_Department; Text[50])
        {
        }
        field(20; WE4_Position; Text[30])
        {
        }
        field(21; WE4_Duration; Text[30])
        {
        }
        field(22; WE5_SN; Option)
        {
            OptionMembers = " ","5","-";
        }
        field(23; WE5_Orgnization; Text[100])
        {
        }
        field(24; WE5_Department; Text[50])
        {
        }
        field(25; WE5_Position; Text[30])
        {
        }
        field(26; WE5_Duration; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

