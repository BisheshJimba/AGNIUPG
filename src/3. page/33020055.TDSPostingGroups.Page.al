page 33020055 "TDS Posting Groups"
{
    PageType = List;
    SourceTable = Table33019849;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("TDS%"; "TDS%")
                {
                }
                field(Type; Type)
                {
                }
                field("GL Account No."; "GL Account No.")
                {
                }
                field("Effective From"; "Effective From")
                {
                }
                field(Blocked; Blocked)
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
    }
}

