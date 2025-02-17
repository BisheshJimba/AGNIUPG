page 25006079 "Item Line Factbox"
{
    // 08.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Inventory
    // 
    // 02.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added Page and some fields CaptionML property

    Caption = 'Item Details - Requisition';
    PageType = CardPart;
    SourceTable = Table27;

    layout
    {
        area(content)
        {
            field("Reorder Point"; "Reorder Point")
            {
            }
            field("Maximum Inventory"; "Maximum Inventory")
            {
            }
            field(Inventory; Inventory)
            {
            }
            field("Reserved Qty. on Inventory"; "Reserved Qty. on Inventory")
            {
                Caption = 'Reserved Qty. on Inventory';
            }
            field("Qty. on Purch. Order"; "Qty. on Purch. Order")
            {
                Caption = 'Qty. on Purch. Order';
            }
            field(GetSalesQty(-6); GetSalesQty(-6))
            {
                Caption = 'Sales Quantity (-6M)';
            }
            field(GetSalesQty(-3); GetSalesQty(-3))
            {
                Caption = 'Sales Quantity (-3M)';
            }
            field(GetSalesQty(-2); GetSalesQty(-2))
            {
                Caption = 'Sales Quantity (-2M)';
            }
            field(GetSalesQty(-1); GetSalesQty(-1))
            {
                Caption = 'Sales Quantity (-1M)';
            }
            field(GetSalesQty(0); GetSalesQty(0))
            {
                Caption = 'Sales Quantity (current month)';
            }
        }
    }

    actions
    {
    }
}

