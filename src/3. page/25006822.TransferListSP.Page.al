page 25006822 "Transfer List SP"
{
    Caption = 'Transfer List (Spare Parts)';
    CardPageID = "Transfer Order";
    Editable = false;
    PageType = List;
    SourceTable = Table5740;

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
                field("In-Transit Code"; "In-Transit Code")
                {
                }
                field(Status; Status)
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(1);
                    end;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(2);
                    end;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                    Visible = false;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    Visible = false;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                    Visible = false;
                }
                field("Receipt Date"; "Receipt Date")
                {
                    Visible = false;
                }
                field("Document Profile"; "Document Profile")
                {
                    Visible = false;
                }
                field("Source Type"; "Source Type")
                {
                    Visible = false;
                }
                field("Source Subtype"; "Source Subtype")
                {
                    Visible = false;
                }
                field("Source No."; "Source No.")
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 5755;
                    RunPageLink = No.=FIELD(No.);
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 5750;
                                    RunPageLink = Document Type=CONST(Transfer Order),
                                  No.=FIELD(No.);
                }
                action("S&hipments")
                {
                    Caption = 'S&hipments';
                    Image = Shipment;
                    RunObject = Page 5752;
                                    RunPageLink = Transfer Order No.=FIELD(No.);
                }
                action("Re&ceipts")
                {
                    Caption = 'Re&ceipts';
                    Image = PostedReceipts;
                    RunObject = Page 5753;
                                    RunPageLink = Transfer Order No.=FIELD(No.);
                }
                action("Whse. Shi&pments")
                {
                    Caption = 'Whse. Shi&pments';
                    Image = Shipment;
                    RunObject = Page 7341;
                                    RunPageLink = Source Type=CONST(5741),
                                  Source Subtype=CONST(0),
                                  Source No.=FIELD(No.);
                    RunPageView = SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                }
                action("&Whse. Receipts")
                {
                    Caption = '&Whse. Receipts';
                    Image = Receipt;
                    RunObject = Page 7342;
                                    RunPageLink = Source Type=CONST(5741),
                                  Source Subtype=CONST(1),
                                  Source No.=FIELD(No.);
                    RunPageView = SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    Caption = 'In&vt. Put-away/Pick Lines';
                    Image = InventoryJournal;
                    RunObject = Page 5774;
                                    RunPageLink = Source Document=FILTER(Inbound Transfer|Outbound Transfer),
                                  Source No.=FIELD(No.);
                    RunPageView = SORTING(Source Document,Source No.,Location Code);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Create &Whse. Receipt")
                {
                    Caption = 'Create &Whse. Receipt';
                    Image = Receipt;

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "5751";
                    begin
                        GetSourceDocInbound.CreateFromInbndTransferOrder(Rec);
                    end;
                }
                action("Create Whse. S&hipment")
                {
                    Caption = 'Create Whse. S&hipment';
                    Image = Shipment;

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "5752";
                    begin
                        GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                    end;
                }
                action("Create Inventor&y Put-away/Pick")
                {
                    Caption = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;

                    trigger OnAction()
                    begin
                        CreateInvtPutAwayPick;
                    end;
                }
                action("Get Bin Content")
                {
                    Caption = 'Get Bin Content';
                    Ellipsis = true;
                    Image = GetBinContent;

                    trigger OnAction()
                    var
                        BinContent: Record "7302";
                        GetBinContent: Report "7391";
                    begin
                        BinContent.SETRANGE("Location Code","Transfer-from Code");
                        GetBinContent.SETTABLEVIEW(BinContent);
                        GetBinContent.InitializeTransferHeader(Rec);
                        GetBinContent.RUNMODAL;
                    end;
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit 5708;
                    ShortCutKey = 'Ctrl+F9';
                }
                action("Reo&pen")
                {
                    Caption = 'Reo&pen';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseTransferDoc: Codeunit "5708";
                    begin
                        ReleaseTransferDoc.Reopen(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit 5706;
                    ShortCutKey = 'F9';
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit 5707;
                    ShortCutKey = 'Shift+F9';
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocPrint: Codeunit "229";
                begin
                    DocPrint.PrintTransferHeader2(Rec);
                end;
            }
        }
        area(reporting)
        {
            action("Inventory - Inbound Transfer")
            {
                Caption = 'Inventory - Inbound Transfer';
                Image = TransferToLines;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 5702;
            }
        }
    }

    trigger OnOpenPage()
    begin

        GetLocationWiseRec("Document Profile"::"Spare Parts Trade");
        MARKEDONLY(TRUE);
        //EDMS>>
        FILTERGROUP(3);
        //SETRANGE("Document Profile","Document Profile"::"Spare Parts Trade");
        SETFILTER("Document Profile",'%1|%2',"Document Profile"::"Spare Parts Trade","Document Profile"::Service);
        //EDMS<<
    end;

    var
        DimMgt: Codeunit "408";
        TransferHeader: Record "5740";
}

