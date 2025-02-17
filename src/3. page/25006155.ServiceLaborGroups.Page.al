page 25006155 "Service Labor Groups"
{
    Caption = 'Service Labor Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006124;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Make Code"; "Make Code")
                {
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Labor Group")
            {
                Caption = 'Labor Group';
                action("Labor Subgroups")
                {
                    Caption = 'Labor Subgroups';
                    Image = Group;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006156;
                    RunPageLink = Make Code=FIELD(Make Code),
                                  Group Code=FIELD(Code);
                    RunPageView = SORTING(Make Code,Group Code,Code);
                }
            }
        }
    }
}

