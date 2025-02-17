page 50033 "Transfer Order Subform (App)"
{
    Caption = 'TransferLineDetails';
    PageType = List;
    SourceTable = Table5741;
    SourceTableView = WHERE(Outstanding Quantity=FILTER(>0));

    layout
    {
        area(content)
        {
            repeater()
            {
                field(TransferKey;"Document No." +' '+FORMAT("Line No."))
                {
                }
                field("Document No.";"Document No.")
                {
                }
                field("Line No.";"Line No.")
                {
                }
                field("Item No.";"Item No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Required Qty";OutstandingQty)
                {
                }
                field("Scanned Qty";"Qty. to Ship")
                {
                    Caption = 'Scanned Qty';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OutstandingQty := Quantity - QRMgt.CheckHowManyQtyIsFullfilled(DATABASE::"Transfer Line",0,
                "Document No.","Line No.");
    end;

    var
        QRMgt: Codeunit "50006";
        OutstandingQty: Decimal;
}

