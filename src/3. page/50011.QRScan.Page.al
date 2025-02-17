page 50011 "QR Scan"
{
    AutoSplitKey = true;
    PageType = Worksheet;
    SourceTable = "QR Specification";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Settings)
            {
                field("Auto Insert Items"; AutoInsertItems)
                {
                    QuickEntry = false;
                    Visible = false;
                }
                field("Add Qty. on Lines"; AddQtyInOrder)
                {
                    QuickEntry = false;
                    Visible = false;
                }
                field(CurrentlyScanningQRText; CurrentlyScanningQRText)
                {
                    Caption = 'Currently Scanning';
                    Editable = false;
                }
                field(PageCaption; PageCaption)
                {
                    Editable = false;
                    Enabled = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(DefaultQuantity; SetDefaultQtyOne)
                {
                    Caption = 'Default Quantity 1 for Old Lot';
                    QuickEntry = false;
                }
            }
            group(Scan)
            {
                repeater(Group)
                {
                    field("QR Scan"; "QR Text")
                    {
                        QuickEntry = true;

                        trigger OnValidate()
                        begin
                            CurrentlyScanningQRText := "QR Text";
                            Settings[1] := AutoInsertItems;
                            Settings[2] := AddQtyInOrder;
                            CASE TableID OF
                                DATABASE::"Sales Header":
                                    BEGIN
                                        IF NOT QRMgt.PartsFromOldLot("QR Text") THEN BEGIN
                                            CurrentlyScanningItemNo := QRMgt.AssignLotNoToSalesLine(SalesHeader, "QR Text", Settings, "Qty. On Packet");
                                            Rec.DELETEALL;
                                        END
                                        ELSE BEGIN
                                            IF SetDefaultQtyOne THEN BEGIN
                                                "Qty. On Packet" := 1;
                                                CurrentlyScanningItemNo := QRMgt.AssignLotNoToSalesLine(SalesHeader, "QR Text", Settings, "Qty. On Packet");
                                                Rec.DELETEALL;
                                                UpdateSubform;
                                            END;
                                        END;
                                    END;
                                DATABASE::"Service Header EDMS":
                                    BEGIN
                                        IF NOT QRMgt.PartsFromOldLot("QR Text") THEN BEGIN
                                            QRMgt.AssignLotNoToServiceLine(ServiceHeader, "QR Text", Settings, ServItemLineNo);
                                            Rec.DELETEALL;
                                        END;
                                    END;
                                DATABASE::"Transfer Header":
                                    BEGIN
                                        IF NOT QRMgt.PartsFromOldLot("QR Text") THEN BEGIN
                                            CurrentlyScanningItemNo := QRMgt.AssignLotNoToTransferLine(TransferHeader, "QR Text", Settings, "Qty. On Packet");
                                            Rec.DELETEALL;
                                        END ELSE BEGIN
                                            IF SetDefaultQtyOne THEN BEGIN
                                                "Qty. On Packet" := 1;
                                                CurrentlyScanningItemNo := QRMgt.AssignLotNoToTransferLine(TransferHeader, "QR Text", Settings, "Qty. On Packet");
                                                Rec.DELETEALL;
                                                UpdateSubform;
                                            END;
                                        END;
                                    END;
                            END;
                            IF NOT QRMgt.PartsFromOldLot("QR Text") THEN BEGIN
                                UpdateSubform;
                            END;
                        end;
                    }
                }
                part(QRScanSubform; 50013)
                {
                    Caption = 'Items';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        IF PageCaption <> '' THEN BEGIN
            CurrPage.CAPTION(PageCaption);
        END;
    end;

    var
        QRMgt: Codeunit "QR Mgt.";
        SalesHeader: Record 36;
        ServiceHeader: Record "25006145";
        TransferHeader: Record "5740";
        AutoInsertItems: Boolean;
        AddQtyInOrder: Boolean;
        Settings: array[50] of Boolean;
        TableID: Integer;
        ServItemLineNo: Integer;
        PageCaption: Text;
        CurrentlyScanningQRText: Text;
        CurrentlyScanningItemNo: Code[20];
        SetDefaultQtyOne: Boolean;

    [Scope('Internal')]
    procedure SetSalesHeader(NewSalesHeader: Record "36")
    begin
        SalesHeader := NewSalesHeader;
        TableID := DATABASE::"Sales Header";
        CurrPage.QRScanSubform.PAGE.InsertSalesLine(SalesHeader, CurrentlyScanningItemNo);
    end;

    [Scope('Internal')]
    procedure SetServiceHeader(NewServiceHeader: Record "25006145"; _ServItemLineNo: Integer)
    begin
        ServiceHeader := NewServiceHeader;
        TableID := DATABASE::"Service Header EDMS";
        ServItemLineNo := _ServItemLineNo;
    end;

    [Scope('Internal')]
    procedure SetTransferHeader(NewTransferHeader: Record "5740")
    begin
        TransferHeader := NewTransferHeader;
        TableID := DATABASE::"Transfer Header";
        CurrPage.QRScanSubform.PAGE.InsertTransferLine(TransferHeader, CurrentlyScanningItemNo);
    end;

    local procedure UpdateSubform()
    var
        DocType: Option;
        DocNo: Code[20];
        LineNo: Integer;
        SalesLine: Record "37";
    begin
        CASE TableID OF
            DATABASE::"Sales Header":
                BEGIN
                    CurrPage.QRScanSubform.PAGE.SetPageCaption(PageCaption);
                    CurrPage.QRScanSubform.PAGE.DeleteSalesLine;
                    CurrPage.QRScanSubform.PAGE.InsertSalesLine(SalesHeader, CurrentlyScanningItemNo);
                    CurrPage.UPDATE(FALSE);
                END;
            DATABASE::"Transfer Header":
                BEGIN
                    CurrPage.QRScanSubform.PAGE.SetPageCaption(PageCaption);
                    CurrPage.QRScanSubform.PAGE.DeleteTransferLine;
                    CurrPage.QRScanSubform.PAGE.InsertTransferLine(TransferHeader, CurrentlyScanningItemNo);
                    CurrPage.UPDATE(FALSE);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure SetPageCaption(NewPageCaption: Text)
    begin
        PageCaption := NewPageCaption;
    end;
}

