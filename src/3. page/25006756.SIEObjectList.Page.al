page 25006756 "SIE Object List"
{
    Caption = 'SIE Object List';
    CardPageID = "SIE Object Card";
    Editable = false;
    PageType = List;
    SourceTable = Table25006707;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SIE No."; "SIE No.")
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                }
                field(Category; Category)
                {
                }
                field(Description; Description)
                {
                }
                field("NAV No."; "NAV No.")
                {
                }
                field("NAV No. 2"; "NAV No. 2")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

