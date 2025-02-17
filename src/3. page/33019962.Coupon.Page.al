page 33019962 Coupon
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Coupon';
    SourceTable = Table33019962;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Location; Location)
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Petrol Pump Code"; "Petrol Pump Code")
                {
                }
                field("Petrol Pump Name"; "Petrol Pump Name")
                {
                }
                field("Range From"; "Range From")
                {
                }
                field("Range To"; "Range To")
                {
                }
                field("Last Issued Date"; "Last Issued Date")
                {
                    Editable = false;
                }
                field("Last Issued No."; "Last Issued No.")
                {
                    Editable = false;
                }
                field(Open; Open)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Lost_Coupon)
            {
                Caption = 'Lost Coupon';
                Image = Track;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33019964;
                RunPageLink = Code = FIELD(Code);
            }
        }
        area(reporting)
        {
            action("<Action1102159024>")
            {
                Caption = 'Coupon';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 33019968;
            }
            action("<Action1102159025>")
            {
                Caption = 'Lost Coupon';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 33019969;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Setting responsibility center user wise.
        GblUserSetup.GET(USERID);
        IF GblUserSetup."Apply Rules" THEN BEGIN
            IF (GblUserSetup."Default Responsibility Center" <> '') THEN BEGIN
                FILTERGROUP(0);
                SETFILTER("Responsibility Center", GblUserSetup."Default Responsibility Center");
                FILTERGROUP(2);
            END;
        END;
    end;

    var
        GblUserSetup: Record "91";
}

