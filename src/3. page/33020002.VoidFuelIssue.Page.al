page 33020002 "Void Fuel Issue"
{
    PageType = List;
    SourceTable = Table33019985;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field("Coupon No."; "Coupon No.")
                {
                }
                field(Void; Void)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Function)
            {
                Caption = 'Function';
                action(Void)
                {
                    Image = VoidCheck;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        FuelIssueMngt.voidIssuedCoupon;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Setting responsibility center user wise.
        UserSetup.GET(USERID);
        IF UserSetup."Apply Rules" THEN BEGIN
            IF (UserSetup."Default Responsibility Center" <> '') THEN BEGIN
                FILTERGROUP(0);
                SETFILTER("Responsibility Center", UserSetup."Default Responsibility Center");
                FILTERGROUP(2);
            END;
        END;
    end;

    var
        FuelIssueMngt: Codeunit "33019973";
        UserSetup: Record "91";
}

