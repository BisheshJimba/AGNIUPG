pageextension 50046 pageextension50046 extends "Posted Purchase Rcpt. Subform"
{
    Caption = '&Undo Item Receipt';
    layout
    {
        addafter("Control 8")
        {
            field(ABC; Rec.ABC)
            {
            }
        }
        addafter("Control 10")
        {
            field("Direct Unit Cost"; Rec."Direct Unit Cost")
            {
            }
        }
        addafter("Control 52")
        {
            field("Description 2"; Rec."Description 2")
            {
                Visible = false;
            }
            field("Tax Purchase Type"; Rec."Tax Purchase Type")
            {
            }
        }
    }
    actions
    {
        addafter("Action 1900546304")
        {
            action("&Undo GL Receipt")
            {
                Caption = '&Undo GL Receipt';

                trigger OnAction()
                begin
                    UndoGLReceiptLine;
                end;
            }
            action("<Action1000000001>")
            {
                Caption = '&Undo Item Charge Receipt';

                trigger OnAction()
                begin
                    UndoItemChargeReceiptLine;
                end;
            }
            action("&Undo External Service Receipt")
            {
                Caption = '&Undo External Service Receipt';

                trigger OnAction()
                begin
                    UndoExternalServiceReceiptLine;
                end;
            }
            action("<Action1000000003>")
            {
                Caption = '&Undo Fixed Assets Receipt';

                trigger OnAction()
                begin
                    UndoFAReceiptLine;
                end;
            }
        }
    }

    var
        UndoPurchaseReceiptLine: Codeunit "5813";

    procedure UndoGLReceiptLine()
    var
        PurchRcptLine: Record "121";
    begin
        PurchRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(PurchRcptLine);
        UndoPurchaseReceiptLine.UndoGLRcptLine(PurchRcptLine);
    end;

    procedure UndoItemChargeReceiptLine()
    var
        PurchRcptLine: Record "121";
    begin
        PurchRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(PurchRcptLine);
        UndoPurchaseReceiptLine.UndoItemChargeRcptLine(PurchRcptLine);
    end;

    procedure UndoExternalServiceReceiptLine()
    var
        PurchRcptLine: Record "121";
    begin
        PurchRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(PurchRcptLine);
        UndoPurchaseReceiptLine.UndoExternalService(PurchRcptLine);
    end;

    procedure UndoFAReceiptLine()
    var
        PurchRcptLine: Record "121";
    begin
        PurchRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(PurchRcptLine);
        UndoPurchaseReceiptLine.UndoFARcptLine(PurchRcptLine);
    end;
}

