page 33020216 "Posted Veh. Registration Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table33020173;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field("Agent Code"; "Agent Code")
                {
                }
                field(Name; Name)
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
            }
            part(; 33020217)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
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
                begin
                    IF CONFIRM(Text000, TRUE) THEN
                        CreatePurchOrder(Rec);
                end;
            }
            action("<Action1000000001>")
            {
                Caption = '&Requisition';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    VehRegHdr.RESET;
                    VehRegHdr.SETRANGE("No.", "No.");
                    VehRegHdr.SETRANGE("Posting Date", "Posting Date");
                    REPORT.RUN(33020023, TRUE, TRUE, VehRegHdr);
                end;
            }
            action("&Settlement")
            {
                Caption = '&Settlement';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    VehRegHdr.RESET;
                    VehRegHdr.SETRANGE("No.", "No.");
                    VehRegHdr.SETRANGE("Posting Date", "Posting Date");
                    REPORT.RUNMODAL(33020045, TRUE, TRUE, VehRegHdr);
                end;
            }
            action("<Action1000000004>")
            {
                Caption = '&Create Journal Lines';
                Image = CreatePutAway;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF CONFIRM(Text001, TRUE) THEN
                        CreateJournalLines(Rec);
                end;
            }
        }
    }

    var
        VehRegHdr: Record "33020173";
        Text001: Label 'Do you really want to create Journal Lines?';
}

