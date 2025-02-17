page 50030 "Sales Order Subform (App)"
{
    Caption = 'AppSalesOrderLine';
    PageType = List;
    SourceTable = Table37;
    SourceTableView = WHERE(Document Type=CONST(Order),
                            Outstanding Quantity=FILTER(>0),
                            Type=CONST(Item));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type";"Document Type")
                {
                }
                field(SalesKey;"Document No." + ' '+FORMAT("Line No."))
                {
                }
                field("Document No.";"Document No.")
                {
                }
                field("Line No.";"Line No.")
                {
                }
                field(Item;"No.")
                {
                    Caption = 'Item';
                }
                field(Description;Description)
                {
                }
                field("Required Qty";OutstandingQty)
                {
                    Caption = 'Required Qty';
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
        OutstandingQty := Quantity - QRMgt.CheckHowManyQtyIsFullfilled(DATABASE::"Sales Line","Document Type",
                "Document No.","Line No.");
    end;

    var
        QRMgt: Codeunit "50006";
        OutstandingQty: Decimal;
}

