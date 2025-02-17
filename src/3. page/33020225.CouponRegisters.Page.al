page 33020225 "Coupon Registers"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Navigate';
    SourceTable = Table33020178;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Registration Date"; "Registration Date")
                {
                }
                field("Petrol Pump Code"; "Petrol Pump Code")
                {
                }
                field("Petrol Pump Name"; "Petrol Pump Name")
                {
                }
                field("From Coupon No."; "From Coupon No.")
                {
                }
                field("To Coupon No."; "To Coupon No.")
                {
                }
                field("Total Coupons"; "Total Coupons")
                {
                    DrillDown = true;
                    DrillDownPageID = "Coupon List";
                }
                field("Remaining Coupons"; "Remaining Coupons")
                {
                    DrillDown = true;
                    DrillDownPageID = "Coupon List";
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("<Action1000000011>")
            {
                Caption = '&Issue Information';
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    IssueList: Page "33020226";
                    FuelIssueLines: Record "33020176";
                begin
                    CLEAR(IssueList);
                    FuelIssueLines.RESET;
                    FuelIssueLines.SETRANGE("Petrol Pump Code", "Petrol Pump Code");
                    FuelIssueLines.SETRANGE("Coupon Code", "From Coupon No.", "To Coupon No.");
                    FuelIssueLines.SETRANGE(Issued, TRUE);
                    IssueList.SETTABLEVIEW(FuelIssueLines);
                    IssueList.RUN;
                end;
            }
        }
    }
}

