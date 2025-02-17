page 25006174 "External Service List"
{
    Caption = 'External Service List';
    CardPageID = "External Service Card";
    Editable = false;
    PageType = List;
    SourceTable = Table25006133;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    Visible = false;
                }
                field(Blocked; Blocked)
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Visible = false;
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("External Service")
            {
                Caption = 'External Service';
                action("<Action1190002>")
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
                        ExtServiceTrackingNo.SETRANGE(ExtServiceTrackingNo."External Service No.", "No.");
                        PAGE.RUNMODAL(PAGE::"Ext. Service Tracking No. List", ExtServiceTrackingNo);
                    end;
                }
                action("<Action1190000>")
                {
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    Promoted = true;
                    RunObject = Page 25006154;
                    RunPageLink = Code = FIELD(No.),
                                  Type=CONST(Ext.Serv.);
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        usersetup.GET(USERID);
        IF (usersetup."Default Accountability Center" = 'BID') OR (usersetup."Default Accountability Center" = 'BRR') THEN
            SETRANGE("Accountability Center", 'BID')
        ELSE
            FilterOnRecord;
    end;

    var
        usersetup: Record "91";

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        RespCenterFilter := UserMgt.GetSalesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
            FILTERGROUP(2);
            IF UserMgt.DefaultResponsibility THEN
                SETRANGE("Responsibility Center", RespCenterFilter)
            ELSE
                SETRANGE("Accountability Center", RespCenterFilter);
            FILTERGROUP(0);
        END;
    end;
}

