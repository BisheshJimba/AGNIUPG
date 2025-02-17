page 25006479 "Posted Transfer Shpmnts (Veh.)"
{
    Caption = 'Posted Transfer Shipments';
    CardPageID = "Posted Transfer Shipment";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Document';
    SourceTable = Table5744;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    Visible = false;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    Visible = false;
                }
                field("Transfer Order No."; "Transfer Order No.")
                {
                }
                field(ModelVersion; ModelVersion)
                {
                    Caption = 'Model Version No.';
                }
                field(VIN; VIN)
                {
                    Caption = 'VIN';
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Receipt Date"; "Receipt Date")
                {
                    Visible = false;
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Shipment")
            {
                Caption = '&Shipment';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 5756;
                    RunPageLink = No.=FIELD(No.);
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 5750;
                                    RunPageLink = Document Type=CONST(Posted Transfer Shipment),
                                  No.=FIELD(No.);
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(TransShptHeader);
                    TransShptHeader.PrintRecords(TRUE);
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            action("&Veh.Shipment")
            {
                Caption = '&Veh.Shipment';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TransShptHeader.RESET;
                    TransShptHeader.SETRANGE("No.","No.");
                    REPORT.RUN(33020027,TRUE,TRUE,TransShptHeader);

                    //REPORT.RUN(33020027);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        TransShptLine.RESET;
        TransShptLine.SETRANGE("Document No.","No.");
        IF TransShptLine.FINDFIRST THEN BEGIN
           TransShptLine.CALCFIELDS(VIN);
           VIN := TransShptLine.VIN;
           ModelVersion := TransShptLine."Model Version No.";
        END;
    end;

    trigger OnOpenPage()
    begin
        //EDMS>>
        FILTERGROUP(3);
        SETRANGE("Document Profile","Document Profile"::"Vehicles Trade");
        //EDMS<<


        GetLocationWiseRec("Document Profile"::"Vehicles Trade");
        MARKEDONLY(TRUE);
    end;

    var
        TransShptHeader: Record "5744";
        VIN: Code[20];
        ModelVersion: Code[20];
        TransShptLine: Record "5745";
}

