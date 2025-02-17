page 33020553 "Attendance Journal Templates"
{
    PageType = List;
    SourceTable = Table33020552;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {
                }
                field(Description; Description)
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000011>")
            {
                Caption = 'Te&mplate';
                action("<Action1000000012>")
                {
                    Caption = 'Batches';
                    RunObject = Page 33020554;
                    RunPageLink = Journal Template Name=FIELD(Name);
                }
            }
        }
    }
}

