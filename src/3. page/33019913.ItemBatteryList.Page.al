page 33019913 "Item Battery List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table27;
    SourceTableView = SORTING(No.)
                      ORDER(Ascending)
                      WHERE(Item For=CONST(BTD));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                }
                field(Inventory; Inventory)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
            }
        }
        area(factboxes)
        {
            part(; 33019914)
            {
                SubPageLink = No.=FIELD(No.);
                    SubPageView = SORTING(No.)
                              ORDER(Ascending);
            }
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

