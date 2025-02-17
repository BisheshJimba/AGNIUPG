page 25006565 "Service Chart List"
{
    Caption = 'Service Chart List';
    PageType = List;
    SourceTable = Table25006201;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Profile ID"; "Profile ID")
                {
                }
                field("Codeunit ID"; "Codeunit ID")
                {
                }
                field("Chart Name"; "Chart Name")
                {
                }
                field(Enabled; Enabled)
                {
                }
            }
        }
    }

    actions
    {
    }
}

