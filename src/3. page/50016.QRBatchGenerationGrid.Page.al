page 50016 "QR Batch Generation Grid"
{
    Caption = 'Batch Generation Grid';
    InsertAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = Table33019974;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Purchase Receipt No."; "Purchase Receipt No.")
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
                field("Parent Lot No."; "Parent Lot No.")
                {
                    Editable = false;
                }
                field("No. of Print"; "No. of Sticker Required")
                {

                    trigger OnValidate()
                    begin
                        QRMgt.TestNoOfPrint(Rec);
                    end;
                }
                field(PerStickerQty; "Per Sticker Qty")
                {

                    trigger OnValidate()
                    begin
                        QRMgt.TestNoOfPrint(Rec);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        QRMgt: Codeunit "50006";

    [Scope('Internal')]
    procedure QueueQR(var FromQRSpecification: Record "33019974" temporary; Add: Boolean)
    var
        QRMgt: Codeunit "50006";
    begin
        CLEAR(QRMgt);
        QRMgt.QueueQR(FromQRSpecification, Rec, Add);
        RESET;
        IF FINDFIRST THEN;
        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure FillItemsSelected(var QRSpecification: Record "33019974" temporary)
    begin
        RESET;
        IF FINDFIRST THEN
            REPEAT
                QRSpecification.INIT;
                QRSpecification."Line No." := "Line No.";
                QRSpecification.TRANSFERFIELDS(Rec);
                QRSpecification.INSERT;
            UNTIL NEXT = 0;

        RESET;
        IF FINDFIRST THEN;
        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure DeleteQueue()
    begin
        RESET;
        DELETEALL;
        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure FillItemsFromItemLedgerEntry(var QRSpecification: Record "33019974" temporary; ItemLedgEntry: Record "32")
    begin
        QRSpecification.INIT;
        QRSpecification.INSERT;
    end;
}

