page 50013 "QR Scan Subform"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Table37;
    SourceTableTemporary = true;
    SourceTableView = SORTING(Document Type, Type, No., Variant Code, Drop Shipment, Location Code, Shipment Date);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    StyleExpr = LineStatus;
                }
                field(Description; Description)
                {
                    StyleExpr = LineStatus;
                }
                field(Quantity; Quantity)
                {
                    StyleExpr = LineStatus;
                }
                field("Qty. to Ship"; "Qty. to Ship")
                {
                    Caption = 'Qty Allocated';
                    StyleExpr = LineStatus;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CLEAR(LineStatus);
        IF "Qty. to Ship" = Quantity THEN
            LineStatus := FullyAllocated
        ELSE
            IF "Qty. to Ship" > 0 THEN
                LineStatus := PartiallyAllocated
            ELSE
                LineStatus := NotAllocated;
    end;

    trigger OnOpenPage()
    begin
        IF PageCaption <> '' THEN BEGIN
            CurrPage.CAPTION(PageCaption);
        END;
    end;

    var
        FullyAllocated: Label 'Standard';
        PartiallyAllocated: Label 'Attention';
        NotAllocated: Label 'Unfavorable';
        LineStatus: Text;
        PageCaption: Text;
        CurrentlyScanningDocType: Option;
        CurrentlyScanningDocNo: Code[20];
        CurrentlyScanningLineNo: Integer;
        CurrentlyScanningItemNo: Code[20];

    [Scope('Internal')]
    procedure InsertSalesLine(var SalesHeader: Record "36"; _CurrentlyScanningItemNo: Code[20])
    var
        SalesLine: Record "37";
        QRMgt: Codeunit "50006";
    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SETFILTER("No.", '<>%1', '');
        SalesLine.SETFILTER("Qty. to Ship", '>%1', 0);
        IF SalesLine.FINDFIRST THEN
            REPEAT

                CLEAR(Rec);
                INIT;
                "Document Type" := SalesLine."Document Type";
                "Document No." := SalesLine."Document No.";
                "Line No." := SalesLine."Line No.";
                Type := Type::Item;
                "No." := SalesLine."No.";
                Description := SalesLine.Description;
                Quantity := SalesLine."Qty. to Ship";
                "Qty. to Ship" := QRMgt.CheckHowManyQtyIsFullfilled(DATABASE::"Sales Line", SalesLine."Document Type",
                      SalesLine."Document No.", SalesLine."Line No.");

                INSERT(TRUE);
                IF "No." = _CurrentlyScanningItemNo THEN BEGIN
                    CurrentlyScanningDocType := "Document Type";
                    CurrentlyScanningDocNo := "Document No.";
                    CurrentlyScanningLineNo := "Line No.";
                END;
            UNTIL SalesLine.NEXT = 0;
        CurrentlyScanningItemNo := _CurrentlyScanningItemNo;
    end;

    [Scope('Internal')]
    procedure DeleteSalesLine()
    begin
        RESET;
        DELETEALL;
    end;

    [Scope('Internal')]
    procedure SetPageCaption(NewPageCaption: Text)
    begin
        PageCaption := NewPageCaption;
    end;

    [Scope('Internal')]
    procedure InsertTransferLine(var TransferHeader: Record "5740"; _CurrentlyScanningItemNo: Code[20])
    var
        TransferLine: Record "5741";
        QRMgt: Codeunit "50006";
    begin

        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", TransferHeader."No.");
        TransferLine.SETFILTER("Item No.", '<>%1', '');
        TransferLine.SETFILTER("Qty. to Ship", '>%1', 0);
        IF TransferLine.FINDFIRST THEN
            REPEAT

                CLEAR(Rec);
                INIT;
                //"Document Type" := SalesLine."Document Type";
                "Document No." := TransferLine."Document No.";
                "Line No." := TransferLine."Line No.";
                "No." := TransferLine."Item No.";
                Description := TransferLine.Description;
                Quantity := TransferLine."Qty. to Ship";
                "Qty. to Ship" := QRMgt.CheckHowManyQtyIsFullfilled(DATABASE::"Transfer Line", 0,
                      TransferLine."Document No.", TransferLine."Line No.");

                INSERT;
                IF "No." = _CurrentlyScanningItemNo THEN BEGIN
                    CurrentlyScanningDocType := "Document Type";
                    CurrentlyScanningDocNo := "Document No.";
                    CurrentlyScanningLineNo := "Line No.";
                END;
            UNTIL TransferLine.NEXT = 0;
        CurrentlyScanningItemNo := _CurrentlyScanningItemNo;
    end;

    [Scope('Internal')]
    procedure DeleteTransferLine()
    begin
        RESET;
        DELETEALL;
    end;

    [Scope('Internal')]
    procedure SetCurrentlyScanningRecord()
    begin
        Rec.GET(CurrentlyScanningDocType, CurrentlyScanningDocNo, CurrentlyScanningLineNo);
        CurrPage.SETRECORD(Rec);
    end;

    [Scope('Internal')]
    procedure GetCurrentlyScanningRecord(var _CurrentlyScanningDocType: Option; var _CurrentlyScanningDocNo: Code[20]; var _CurrentlyScanningLineNo: Integer)
    begin
        _CurrentlyScanningDocType := CurrentlyScanningDocType;
        _CurrentlyScanningDocNo := CurrentlyScanningDocNo;
        _CurrentlyScanningLineNo := CurrentlyScanningLineNo;
    end;
}

