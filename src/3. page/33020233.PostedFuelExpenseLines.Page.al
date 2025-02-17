page 33020233 "Posted Fuel Expense Lines"
{
    Caption = 'Posted Fuel Expenses';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    PromotedActionCategories = 'New,Process,Report,Cancellation';
    ShowFilter = false;
    SourceTable = Table33020176;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Cancelled; Cancelled)
                {
                }
                field("Coupon Code"; "Coupon Code")
                {
                    Editable = false;
                }
                field("Document No"; "Document No")
                {
                    Editable = false;
                }
                field(Type; Type)
                {
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Petrol Pump Code"; "Petrol Pump Code")
                {
                }
                field("Petrol Pump Name"; "Petrol Pump Name")
                {
                }
                field(Address; Address)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
                field(VIN; VIN)
                {
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                    Visible = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = false;
                }
                field("DRP No./ARE1 No."; "DRP No./ARE1 No.")
                {
                    Visible = false;
                }
                field("Engine No."; "Engine No.")
                {
                    Visible = false;
                }
                field("Quantity (Ltr.)"; "Quantity (Ltr.)")
                {
                    Editable = false;
                }
                field("Fuel Type"; "Fuel Type")
                {
                    Editable = false;
                }
                field("Date of Cancellation"; "Date of Cancellation")
                {
                }
                field("Cancelled By"; "Cancelled By")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102159014>")
            {
                Caption = '&Create Purchase Order';
                Image = CreatePutAway;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    Text000: Label 'Do you want to create Purchase Order.';
                    FuelExp: Record "33020176";
                    UnitCostEntry: Report "33020174";
                begin
                    IF CONFIRM(Text000, TRUE) THEN BEGIN
                        SetRecSelectionFilter(FuelExp);
                        UnitCostEntry.SETTABLEVIEW(FuelExp);
                        UnitCostEntry.RUN;
                        IF SetLineSelection(FuelExp) THEN
                            MESSAGE('Purchase Order Created successfully.');
                    END;
                end;
            }
            action("<Action1000000016>")
            {
                Caption = 'Cancel Coupon';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = false;

                trigger OnAction()
                begin
                    VALIDATE(Cancelled, TRUE);
                    MODIFY;
                end;
            }
            action("<Action1000000017>")
            {
                Caption = 'Undo Cancel';
                Image = EditList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = false;

                trigger OnAction()
                begin
                    VALIDATE(Cancelled, FALSE);
                    MODIFY;
                end;
            }
        }
    }

    var
        UserMgt: Codeunit "5700";

    [Scope('Internal')]
    procedure SetRecSelectionFilter(var FuelExpLine: Record "33020176")
    begin
        CurrPage.SETSELECTIONFILTER(FuelExpLine);
    end;
}

