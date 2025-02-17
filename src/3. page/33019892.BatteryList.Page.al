page 33019892 "Battery List"
{
    CardPageID = "Item Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Table27;
    SourceTableView = WHERE(Item For=CONST(BTD));

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
                field("Product Group Code"; "Product Group Code")
                {
                }
                field("Product Subgroup Code"; "Product Subgroup Code")
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

    trigger OnOpenPage()
    begin
        FILTERGROUP(3);
        SETRANGE("Item For", "Item For"::BTD);
    end;

    [Scope('Internal')]
    procedure SetSelection(var Item: Record "27")
    begin
        CurrPage.SETSELECTIONFILTER(Item);
    end;

    [Scope('Internal')]
    procedure GetItem(): Code[20]
    begin
        EXIT("No.");
    end;
}

