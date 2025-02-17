page 33020221 "Posted Vehicle Fuel Expenses"
{
    CardPageID = "Posted Veh. Fuel Expense Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = Table33020175;
    SourceTableView = WHERE(Fuel Expenses Charged=FILTER(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Agent Code";"Agent Code")
                {
                }
                field(Name;Name)
                {
                }
                field(Address;Address)
                {
                }
                field("Phone No.";"Phone No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Document Date";"Document Date")
                {
                }
                field("Posting Date";"Posting Date")
                {
                }
                field("Fuel Expenses Charged";"Fuel Expenses Charged")
                {
                }
                field("Assigned User ID";"Assigned User ID")
                {
                }
                field("Purchase Order Created";"Purchase Order Created")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(;Notes)
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
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          IF UserMgt.DefaultResponsibility THEN
            SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter())
          ELSE
            SETRANGE("Accountability Center",UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
    end;

    var
        UserMgt: Codeunit "5700";

    [Scope('Internal')]
    procedure SetRecSelectionFilter(var FuelExpHeader: Record "33020175")
    begin
        CurrPage.SETSELECTIONFILTER(FuelExpHeader);
    end;
}

