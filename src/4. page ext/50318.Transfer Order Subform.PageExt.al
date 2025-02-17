pageextension 50318 pageextension50318 extends "Transfer Order Subform"
{
    // 08.09.2014 Elva Baltic P8 #S0005 EDMS
    //   * Add color to field "Reserved Quantity Outbnd."
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     CheckDocumentProfile
    //   Added code to:
    //     OnInsertRecord
    // 
    // 27.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added Page Action:
    //     CreateOrderPromising
    // 
    // 19.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed "Reserved Quantity Outbnd." Control StyleExpr property
    //   Added code to:
    //     OnAfterGetRecord()
    Editable = true;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = StyleTxt;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

        modify("Control 7")
        {
            Visible = false;
        }
        addafter("Control 2")
        {
            field("QR Enabled"; "QR Enabled")
            {
                Editable = false;
                Enabled = false;
            }
            field("Old Lot"; "Old Lot")
            {
            }
        }
        addafter("Control 4")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
            }
        }
        addafter("Control 44")
        {
            field(Inventory; Inventory)
            {
            }
        }
        addafter("Control 6")
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
            }
        }
        addafter("Control 8")
        {
            field("Unit Price"; "Unit Price")
            {
            }
            field(Amount; Amount)
            {
            }
        }
        addafter("Control 28")
        {
            field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
            {
                Visible = false;
            }
        }
        addafter("Control 310")
        {
            field("Reason Code"; "Reason Code")
            {
            }
            field("From Location Dimension 1 Code"; "From Location Dimension 1 Code")
            {
            }
            field("From Location Dimension 2 Code"; "From Location Dimension 2 Code")
            {
            }
            field("To Location Dimension 1 Code"; "To Location Dimension 1 Code")
            {
            }
            field("To Location Dimension 2 Code"; "To Location Dimension 2 Code")
            {
            }
            field("Qty. to Receive (Base)"; Rec."Qty. to Receive (Base)")
            {
            }
            field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
            {
            }
            field("Document Date"; "Document Date")
            {
                Editable = false;
            }
            field(CBM; CBM)
            {
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("Action 1900295404")
        {
            action(CreateOrderPromising)
            {
                Caption = 'Create Order Promising';
                Image = CreateInventoryPickup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TransferHeader.GET(Rec."Document No.");
                    CapabletoPromise.CreateReqLinesFromTransfer(TransferHeader, TRUE, Rec."Line No.");
                end;
            }
            action("QR Specifications")
            {
                Image = SpecialOrder;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+Q';

                trigger OnAction()
                var
                    QRScan: Page "50011";
                    TransferHeader: Record "5740";
                begin
                    TransferHeader.GET(Rec."Document No.");
                    QRScan.SetPageCaption(Rec."Document No." + ', ' + TransferHeader."Transfer-to Name");
                    QRScan.SetTransferHeader(TransferHeader);
                    QRScan.RUNMODAL;
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    var
        StyleTxt: Text[30];
        CapabletoPromise: Codeunit "99000886";
        TransferHeader: Record "5740";
        Text001: Label 'You can''t insert Transfer Line if Document Profile is Service!';
        Text002: Label 'You have selected %1 record lines.';


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);

    StyleTxt := GetReservationColor;                                  // 19.03.2014 Elva Baltic P21
    */
    //end;


    //Unsupported feature: Code Insertion on "OnInsertRecord".

    //trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    //begin
    /*
    //CheckDocumentProfile;                                             // 28.03.2014 Elva Baltic P21
    */
    //end;

    procedure CheckDocumentProfile()
    begin
        TransferHeader.GET(Rec."Document No.");
        IF TransferHeader."Document Profile" = TransferHeader."Document Profile"::Service THEN
            ERROR(Text001);
    end;

    procedure _ShowReservation()
    begin
        Rec.FIND;
        Rec.ShowReservation;
    end;

    procedure ShowReservation()
    begin
        Rec.FIND;
        Rec.ShowReservation;
    end;
}

