page 33019930 "Battery Issue List"
{
    CardPageID = "Battery From Store Header";
    Editable = false;
    PageType = List;
    SourceTable = Table33019897;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }

    var
        StoreHeader: Record "33019897";
        StoreLine: Record "33019896";
}

