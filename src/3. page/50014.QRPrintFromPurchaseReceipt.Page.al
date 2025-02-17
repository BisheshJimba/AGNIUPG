page 50014 "QR Print From Purchase Receipt"
{
    // lookup of partno
    // CLEAR(QRPackageList);
    // QRPackageList.SETTABLEVIEW(QRSpecification);
    // QRPackageList.InitItem(PurchReceiptNo,PkgNo);
    // QRPackageList.DisplayItem;
    // QRPackageList.EDITABLE(FALSE);
    // QRPackageList.LOOKUPMODE(TRUE);
    // IF QRPackageList.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //   QRPackageList.GETRECORD(QRSpecification);
    //   PartNo := COPYSTR(QRSpecification."Code 1",1,20);
    //   IF PurchReceiptNo = OpeningReceipts THEN
    //   HideOldPrint := FALSE
    //   ELSE
    //     HideOldPrint := TRUE;
    //   GetBatchPrintForm;
    // END;

    DeleteAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Print';
    SaveValues = false;
    ShowFilter = false;
    SourceTable = Table33019974;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group()
            {
                Editable = true;
                grid()
                {
                    Editable = true;
                    GridLayout = Rows;
                    group(Filters)
                    {
                        Editable = true;
                        field(PurchReceiptNo; PurchReceiptNo)
                        {
                            Caption = 'Document No.';
                            Editable = true;
                            Lookup = true;
                            TableRelation = "Purch. Rcpt. Header".No.;

                            trigger OnValidate()
                            begin
                                PkgNo := '';
                                PartNo := '';
                                IF PurchReceiptNo = OpeningReceipts THEN
                                    HideOldPrint := FALSE
                                ELSE
                                    HideOldPrint := TRUE;
                                GetBatchPrintForm;
                            end;
                        }
                        field("Item No"; PartNo)
                        {
                            Caption = 'Item No.';
                            Lookup = true;
                            TableRelation = Item.No.;

                            trigger OnValidate()
                            begin
                                IF PurchReceiptNo = OpeningReceipts THEN
                                    HideOldPrint := FALSE
                                ELSE
                                    HideOldPrint := TRUE;
                                GetBatchPrintForm;
                            end;
                        }
                    }
                }
            }
            group()
            {
                Editable = true;
                repeater(Group)
                {
                    field("Purchase Receipt No."; "Purchase Receipt No.")
                    {
                        Editable = false;
                    }
                    field("Parent Lot No."; "Parent Lot No.")
                    {
                        Editable = false;
                    }
                    field("Package No."; "Package No.")
                    {
                        Editable = false;
                    }
                    field("Supplier Code"; "Supplier Code")
                    {
                        Editable = false;
                    }
                    field("Location Code"; "Location Code")
                    {
                        Editable = false;
                    }
                    field("Item No."; "Item No.")
                    {
                        Editable = false;
                    }
                    field("Item Name"; "Item Name")
                    {
                    }
                    field("Purchase Quantity"; "Purchase Quantity")
                    {
                        Editable = false;
                    }
                    field("Remaining Stock Qty"; "Remaining Stock Qty")
                    {
                        Caption = 'Remaining Print';
                        Editable = false;
                    }
                    field("No. of Stickers Printed"; "No. of Stickers Printed")
                    {
                    }
                    field("Add Item"; "Add Item")
                    {

                        trigger OnValidate()
                        begin
                            MODIFY;
                            CurrPage.QRBatchGenerationGrid.PAGE.QueueQR(Rec, "Add Item");
                        end;
                    }
                    field(ShowAvailableStock; ShowAvailableStock)
                    {
                        AssistEdit = true;
                        Caption = 'Drill Available Stock';
                        DrillDown = true;
                        Editable = false;
                        Lookup = true;

                        trigger OnAssistEdit()
                        begin
                            CLEAR(QRMgt);
                            QRMgt.GenerateBatchPrintDatasetFromItemRecord("Item No.");
                        end;

                        trigger OnDrillDown()
                        begin
                            CLEAR(QRMgt);
                            QRMgt.GenerateBatchPrintDatasetFromItemRecord("Item No.");
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            CLEAR(QRMgt);
                            QRMgt.GenerateBatchPrintDatasetFromItemRecord("Item No.");
                        end;
                    }
                }
            }
            part(QRBatchGenerationGrid; 50016)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(Print)
                {
                    Caption = '&Print';
                    Image = BarCode;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        BatchGenerationGrid: Record "33019974" temporary;
                        QRPrint: Report "50074";
                        PrintQRSpecification: Record "33019974" temporary;
                    begin
                        CurrPage.QRBatchGenerationGrid.PAGE.FillItemsSelected(BatchGenerationGrid);
                        CLEAR(QRMgt);
                        QRMgt.PostPrintItemReclassification(BatchGenerationGrid, PrintQRSpecification);
                        COMMIT;

                        CLEAR(QRPrint);
                        QRPrint.SetPrintUsingItemLedgerEntryNo;
                        QRPrint.SetQRSpecification(PrintQRSpecification);
                        QRPrint.RUN;

                        CurrPage.QRBatchGenerationGrid.PAGE.DeleteQueue;
                        GetBatchPrintForm;
                    end;
                }
                action("Print from Old Lot")
                {
                    Caption = 'Print from Old Lot';
                    Image = BarChart;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        QRPrint: Report "50074";
                    begin
                        CLEAR(QRPrint);
                        QRPrint.SetQRSpecification(Rec);
                        QRPrint.RUN;
                        GetBatchPrintForm;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowAvailableStock := 'View';
    end;

    var
        QRSpecificationFilter: Record "33019974";
        QRMgt: Codeunit "50006";
        NoOfPrints: Integer;
        PerStickerQty: Decimal;
        [InDataSet]
        HideOldPrint: Boolean;
        OpeningReceipts: Label 'OPENING';
        PurchReceiptNo: Code[20];
        PkgNo: Code[20];
        PartNo: Code[20];
        SupplierCode: Code[10];
        ShowAvailableStock: Code[10];
        Text1000: Label 'You cannot lookup Package No. if Purchase Receipt No. is blank.';

    local procedure GetBatchPrintForm()
    var
        QRSpecification: Record "33019974" temporary;
        BatchGenerationGrid: Record "33019974" temporary;
    begin
        CurrPage.QRBatchGenerationGrid.PAGE.FillItemsSelected(BatchGenerationGrid);

        QRMgt.GenerateBatchPrintDatasetFromPurchaseReceipt(SupplierCode, PartNo, PurchReceiptNo, PkgNo, BatchGenerationGrid, Rec);
        RESET;
        IF FINDFIRST THEN;
        CurrPage.UPDATE(FALSE);
    end;
}

