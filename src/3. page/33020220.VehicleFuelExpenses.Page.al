page 33020220 "Vehicle Fuel Expenses"
{
    CardPageID = "Vehicle Fuel Expense Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Coupon Registration';
    SourceTable = Table33020175;
    SourceTableView = WHERE(Fuel Expenses Charged=FILTER(No));

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
        area(processing)
        {
            group(Posting)
            {
                Caption = 'Posting';
                action("<Action75>")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        Text000: Label 'Do you want post the Document %1?';
                    begin
                        IF CONFIRM(Text000,TRUE,"No.") THEN
                          PostDocument(Rec);
                    end;
                }
            }
            group("<Action1000000002>")
            {
                Caption = 'Functions';
                action("Register Coupon")
                {
                    Caption = 'Register Coupon';
                    Image = AdjustItemCost;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CreateCoupon.RUNMODAL;
                        CLEAR(CreateCoupon);
                    end;
                }
            }
        }
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
        CreateCoupon: Report "33020173";
}

