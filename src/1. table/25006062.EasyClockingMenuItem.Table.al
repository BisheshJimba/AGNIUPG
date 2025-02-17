table 25006062 "Easy Clocking Menu Item"
{

    fields
    {
        field(10; "No."; Integer)
        {
        }
        field(20; Type; Option)
        {
            OptionMembers = Text,Button;
        }
        field(30; Caption; Text[100])
        {
        }
        field(35; "Run Action"; Option)
        {
            BlankZero = true;
            OptionMembers = " ","Start My Task","Start Group Task","Start Task From Order","Start Task From Line","Start Break","Start Meeting","Start Worktime","End Worktime","Set Current Time","Start Travel Task","Start Standard Task";
        }
        field(40; "Run Object Type"; Option)
        {
            OptionMembers = TableData,"Table",Form,"Report",Dataport,"Codeunit","XMLPort",MenuSuite,"Page";
        }
        field(44; "Run Object ID"; Integer)
        {
            TableRelation = Object.ID WHERE(Type = FIELD(Run Object Type));
        }
        field(60; Icon; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

