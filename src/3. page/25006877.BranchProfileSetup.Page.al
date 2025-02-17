page 25006877 "Branch Profile Setup"
{
    CardPageID = "Branch Profile Setup Card";
    Editable = false;
    PageType = List;
    SourceTable = Table25006876;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Branch Code"; "Branch Code")
                {
                }
                field("Profile ID"; "Profile ID")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

