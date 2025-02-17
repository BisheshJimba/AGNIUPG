page 50010 "QR Batch Print Form"
{
    DeleteAllowed = false;
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
                        field(Supplier; Supplier)
                        {
                            Editable = true;
                            Lookup = true;
                            LookupPageID = Suppliers;
                            TableRelation = Table70000;

                            trigger OnValidate()
                            begin
                                "Part No." := '';
                                "Purchase Receipt No." := '';
                            end;
                        }
                        field("Part No."; "Part No.")
                        {
                            Editable = true;
                            Lookup = true;

                            trigger OnValidate()
                            var
                                PartNo: Code[20];
                                SupplierNo: Code[20];
                            begin
                                "Purchase Receipt No." := '';
                            end;
                        }
                        field("Purchase Receipt No"; "Purchase Receipt No.")
                        {
                            Editable = true;
                            Lookup = true;

                            trigger OnValidate()
                            begin
                                IF "Purchase Receipt No." = OpeningReceipts THEN
                                    HideOldPrint := FALSE
                                ELSE
                                    HideOldPrint := TRUE;
                                CurrPage.UPDATE;
                                IF "Purchase Receipt No." = OpeningReceipts THEN
                                    GetBatchPrintForm;
                            end;
                        }
                    }
                }
            }
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                    Editable = false;
                }
                field("Lot No"; "Parent Lot No.")
                {
                    Editable = false;
                }
                field("Purchase Receipt No."; "Purchase Receipt No.")
                {
                    Editable = false;
                }
                field("No. of Stickers"; "No. of Stickers")
                {
                    Editable = false;
                }
                field("Per Sticker Qty"; "Per Sticker Qty")
                {
                    Editable = false;
                }
                field("Remaining Stock Qty"; "Remaining Stock Qty")
                {
                    Editable = false;
                }
                field("No. Of Sticker Available"; "No. Of Sticker Available")
                {
                    Editable = false;
                }
                field("No. of Sticker Required"; "No. of Sticker Required")
                {
                }
                field("Issue From Old Lot"; "Issue From Old Lot")
                {
                    Visible = NOT HideOldPrint;
                }
                field("Per Sticker Qty for Old Lot"; "Per Sticker Qty for Old Lot")
                {
                    Visible = NOT HideOldPrint;
                }
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
                        QRPrint: Report "50074";
                    begin
                        CLEAR(QRPrint);
                        QRPrint.SetQRSpecification(Rec);
                        QRPrint.RUN;
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
                    Visible = NOT HideOldPrint;

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

    var
        QRSpecificationFilter: Record "33019974";
        QRMgt: Codeunit "50006";
        NoOfPrints: Integer;
        PerStickerQty: Decimal;
        [InDataSet]
        HideOldPrint: Boolean;
        OpeningReceipts: Label 'OPENING';

    local procedure GetBatchPrintForm()
    var
        QRSpecification: Record "33019974" temporary;
    begin
        QRMgt.GenerateBatchPrintDataset(Supplier, "Part No.", "Purchase Receipt No.", Rec);
        RESET;
        IF FINDFIRST THEN;
    end;
}

