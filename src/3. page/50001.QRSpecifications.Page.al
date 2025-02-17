page 50001 "QR Specifications"
{
    AutoSplitKey = true;
    LinksAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = "QR Specification";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                }
                field("Supplier Code"; Rec."Supplier Code")
                {
                }
                field("No. of Stickers"; Rec."No. of Stickers")
                {
                    BlankZero = true;
                }
                field("Per Sticker Qty"; Rec."Per Sticker Qty")
                {
                    BlankZero = true;
                }
                field("Qty. Consumed"; Rec."Qty. Consumed")
                {
                }
            }
            group(Control11)
            {
                fixed(Control10)
                {
                    group("Total Quantity")
                    {
                        Caption = 'Total Quantity';
                        field(TotalQty; TotalQty)
                        {
                            Editable = false;
                        }
                    }
                    group("Consumed Quantity")
                    {
                        Caption = 'Consumed Quantity';
                        Visible = false;
                        field(ConsumedQty; ConsumedQty)
                        {
                            Editable = false;
                        }
                    }
                    group("Remaining Quantity")
                    {
                        Caption = 'Remaining Quantity';
                        Visible = false;
                        field(RemainingQty; RemainingQty)
                        {
                            Editable = false;
                        }
                    }
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
                action("Generate Item Tracking Lines")
                {
                    Caption = '&Generate Item Tracking Lines';
                    Image = AdjustVATExemption;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        QRMgt: Codeunit "QR Mgt.";
                    begin
                        QRMgt.GenerateItemTrackingLines(Rec);
                        MESSAGE('Lot No. allocated.');
                        CurrPage.CLOSE;
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InitQRSpecification;
    end;

    var
        TempQRSpecification: Record "QR Specification" temporary;
        QRMgt: Codeunit "QR Mgt.";
        SourceType: Integer;
        SourceSubType: Option;
        SourceID: Code[20];
        SourceRefNo: Integer;
        ItemNo: Code[20];
        UnitOfMeasure: Code[10];
        QtyPerUOM: Decimal;
        LocationCode: Code[10];
        Date: Date;
        LotNo: Code[20];
        RemainingQty: Decimal;
        ConsumedQty: Decimal;
        TotalQty: Decimal;

    [Scope('Internal')]
    procedure SetSource(_SourceType: Integer; _SourceSubType: Option; _SourceID: Code[20]; _SourceRefNo: Integer; _ItemNo: Code[20]; _UnitOfMeasure: Code[10]; _QtyPerUOM: Decimal; _LocationCode: Code[10]; _Date: Date; _LotNo: Code[20])
    begin
        SourceType := _SourceType;
        SourceSubType := _SourceSubType;
        SourceID := _SourceID;
        SourceRefNo := _SourceRefNo;
        ItemNo := _ItemNo;
        UnitOfMeasure := _UnitOfMeasure;
        QtyPerUOM := _QtyPerUOM;
        LocationCode := _LocationCode;
        Date := _Date;
        LotNo := _LotNo;
    end;

    local procedure InitQRSpecification()
    begin
        QRMgt.BuildQRSpecifications(SourceType, SourceSubType, SourceID, SourceRefNo, ItemNo,
          UnitOfMeasure, QtyPerUOM, LocationCode, Date, LotNo, Rec);
    end;

    [Scope('Internal')]
    procedure SetTotalQuantity(_PurchaseQty: Decimal)
    begin
        TotalQty := _PurchaseQty;
    end;

    local procedure CalcBalance(Deleted: Boolean)
    begin

        /*TempQRSpecification.RESET;
        TempQRSpecification.SETRANGE("Line No.","Line No.");
        IF NOT TempQRSpecification.FINDFIRST THEN BEGIN
          TempQRSpecification.INIT;
          TempQRSpecification.TRANSFERFIELDS(Rec);
          TempQRSpecification.INSERT;
        END
        ELSE BEGIN
          IF Deleted THEN BEGIN
            TempQRSpecification."Qty. Consumed" := 0;
          END
          ELSE
            TempQRSpecification."Qty. Consumed" := "Qty. Consumed";
          TempQRSpecification.MODIFY;
        END;
        ConsumedQty := 0;
        TempQRSpecification.RESET;
        IF TempQRSpecification.FINDFIRST THEN REPEAT
          ConsumedQty += TempQRSpecification."Qty. Consumed";
        UNTIL TempQRSpecification.NEXT = 0;
        CurrPage.UPDATE(TRUE);
        */

    end;
}

