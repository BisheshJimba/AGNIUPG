pageextension 50142 pageextension50142 extends "Item Ledger Entries"
{
    // 07.10.2016 EB.P30 EDMS
    //   Added fields:
    //     "Source Type"
    //     "Source No."
    // 
    // 25.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Added VIN field
    // 
    // 14.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Added field "External Document No."
    // 
    // 09.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Added fields "Transfer Source Type","Transfer Source Subtype","Transfer Source No."
    Editable = IsVisible;
    Editable = IsVisible;
    Editable = IsVisible;
    Editable = IsVisible;

    //Unsupported feature: Property Modification (SourceTableView) on ""Item Ledger Entries"(Page 38)".

    layout
    {
        addafter("Control 6")
        {
            field("External Document No."; Rec."External Document No.")
            {
            }
            field("Value Entry Reason Code"; "Value Entry Reason Code")
            {
            }
        }
        addafter("Control 68")
        {
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field("Vehicle Registration No."; "Vehicle Registration No.")
            {
                Visible = false;
            }
        }
        addafter("Control 14")
        {
            field(VIN; VIN)
            {
            }
            field("Make Code"; Rec."Make Code")
            {
                Visible = false;
            }
            field("Model Code"; Rec."Model Code")
            {
                Visible = false;
            }
            field("Model Version No."; "Model Version No.")
            {
                Visible = false;
            }
        }
        addafter("Control 1002")
        {
            field("Transfer Source Type"; "Transfer Source Type")
            {
                Visible = false;
            }
            field("Transfer Source Subtype"; "Transfer Source Subtype")
            {
                Visible = false;
            }
            field("Transfer Source No."; "Transfer Source No.")
            {
            }
            field("Source No."; Rec."Source No.")
            {
                Visible = false;
            }
            field("Source Type"; Rec."Source Type")
            {
                Visible = false;
            }
            field("QR Code Text"; Rec."QR Code Text")
            {
            }
            field("QR Code Blob"; Rec."QR Code Blob")
            {
            }
            field("QR Code Printed"; Rec."QR Code Printed")
            {
            }
            field("QR No. of Times Printed"; Rec."QR No. of Times Printed")
            {
            }
            field("QR Status"; Rec."QR Status")
            {
            }
        }
    }
    actions
    {
        addafter("Action 59")
        {
            action("<Action1101904000>")
            {
                Caption = 'Change Veh. Acc. Cycle';
                Image = Change;

                trigger OnAction()
                var
                    VehCycleMgt: Codeunit "25006303";
                begin
                    //EDMS
                    CLEAR(VehCycleMgt);
                    VehCycleMgt.ChangeCycleInItemLedgerEntry(Rec);
                end;
            }
        }
        addafter("Action 32")
        {
            action("QR Print")
            {
                Caption = '&QR Print';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemLedgEntries: Record "32";
                    QRPrint: Report "50074";
                    QRSpecification: Record "33019974" temporary;
                    QRMgt: Codeunit "50006";
                begin
                    CLEAR(ItemLedgEntries);
                    CurrPage.SETSELECTIONFILTER(ItemLedgEntries);

                    CLEAR(QRMgt);
                    QRMgt.GenerateILEPrintDataset(ItemLedgEntries, QRSpecification);
                    COMMIT;
                    CLEAR(QRPrint);
                    QRPrint.SetReprintQR;
                    QRPrint.SetQRSpecification(QRSpecification);
                    QRPrint.RUN;
                end;
            }
            action("Split Quantity")
            {
                Image = Split;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemLedgEntries: Record "32";
                    QRMgt: Codeunit "50006";
                    NoOfStickerRequired: Integer;
                    PerStickerQty: Decimal;
                begin
                    CLEAR(ItemLedgEntries);
                    CurrPage.SETSELECTIONFILTER(ItemLedgEntries);

                    CLEAR(QRMgt);
                    QRMgt.SplitQuantityFromItemLedger(ItemLedgEntries);
                end;
            }
        }
    }

    var
        [InDataSet]
        ISVisible: Boolean;
        UserSetup: Record "91";
        "--Agile_Vr_QR": Integer;
        [InDataSet]
        ShowSN: Boolean;
        SN: Integer;


    //Unsupported feature: Code Insertion on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //begin
    /*

    UserSetup.GET(USERID);
    IF UserSetup."Can See Cost" THEN
      ISVisible :=TRUE
    ELSE
      ISVisible := FALSE;
    */
    //end;

    local procedure "--Agile_Fn_QR"()
    begin
    end;

    procedure SetShowSN()
    begin
        ShowSN := TRUE;
    end;
}

