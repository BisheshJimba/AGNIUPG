page 25006173 "External Service Card"
{
    // 15.07.2008. EDMS P2
    //   * Added button Comment

    Caption = 'External Service Card';
    PageType = Card;
    SourceTable = Table25006133;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Internal Service"; "Internal Service")
                {
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Visible = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Price Includes VAT"; "Price Includes VAT")
                {
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {

                    trigger OnValidate()
                    begin
                        VATBusPostingGrPriceOnAfterVal;
                    end;
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Price/Profit Calculation"; "Price/Profit Calculation")
                {
                }
                field("Profit %"; "Profit %")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {

                    trigger OnValidate()
                    begin
                        VATProdPostingGroupOnAfterVali;
                    end;
                }
            }
            group(Tracking)
            {
                Caption = 'Tracking';
                field("Allow Tracking Nos."; "Allow Tracking Nos.")
                {
                }
                field("Tracking Nos."; "Tracking Nos.")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&External Service")
            {
                Caption = '&External Service';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = Table ID=CONST(25006133),
                                  No.=FIELD(No.);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(External Service),
                                  No.=FIELD(No.);
                }
                action("&Tracking Nos.")
                {
                    Caption = '&Tracking Nos.';
                    Image = Track;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ExtServiceTrackingNo: Record "25006153";
                    begin
                        TESTFIELD("Allow Tracking Nos.");
                        ExtServiceTrackingNo.SETRANGE(ExtServiceTrackingNo."External Service No.","No.");
                        PAGE.RUNMODAL(PAGE::"Ext. Service Tracking No. List",ExtServiceTrackingNo);
                    end;
                }
                action("<Action1190006>")
                {
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    RunObject = Page 25006154;
                                    RunPageLink = Code=FIELD(No.),
                                  Type=CONST(Ext.Serv.);
                }
            }
        }
    }

    local procedure VATBusPostingGrPriceOnAfterVal()
    begin
        CurrPage.UPDATE
    end;

    local procedure VATProdPostingGroupOnAfterVali()
    begin
        CurrPage.UPDATE
    end;
}

