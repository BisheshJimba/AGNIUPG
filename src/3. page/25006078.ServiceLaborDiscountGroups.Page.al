page 25006078 "Service Labor Discount Groups"
{
    Caption = 'Service Labor Discount Groups';
    PageType = List;
    SourceTable = Table25006058;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
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
            group("Item &Disc. Groups")
            {
                Caption = 'Item &Disc. Groups';
                Image = Group;
                action("Service &Line Discounts")
                {
                    Caption = 'Service &Line Discounts';
                    Image = SalesLineDisc;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006077;
                    RunPageLink = Type = CONST(Labor Discount Group),
                                  Code=FIELD(Code);
                    RunPageView = SORTING(Type,Code);
                }
            }
        }
    }

    [Scope('Internal')]
    procedure GetSelectionFilter(): Text
    var
        ServiceLaborDiscountGroup: Record "25006058";
        SelectionFilterManagement: Codeunit "46";
    begin
        CurrPage.SETSELECTIONFILTER(ServiceLaborDiscountGroup);
        EXIT(SelectionFilterManagement.GetSelectionFilterForLaborDiscountGroup(ServiceLaborDiscountGroup));
    end;
}

