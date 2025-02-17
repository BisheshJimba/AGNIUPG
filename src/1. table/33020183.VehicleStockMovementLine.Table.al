table 33020183 "Vehicle Stock Movement Line"
{

    fields
    {
        field(1; VIN; Code[20])
        {
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo";
        }
        field(3; "Document No"; Code[20])
        {
        }
        field(10; "Opening Qty"; Decimal)
        {
        }
        field(11; "Opening Amount"; Decimal)
        {
        }
        field(12; "Purchase Qty"; Decimal)
        {
        }
        field(13; "Purchase Amount"; Decimal)
        {
        }
        field(14; "Sales Qty"; Decimal)
        {
        }
        field(15; "Sales Cost Amount"; Decimal)
        {
        }
        field(16; "Adjustment Qty"; Decimal)
        {
        }
        field(17; "Adjustment Amount"; Decimal)
        {
        }
        field(18; "Opening NonInventory"; Decimal)
        {
        }
        field(19; "Purchase NonInventory"; Decimal)
        {
        }
        field(20; "Purchase IPG Inventoriable"; Code[250])
        {
        }
        field(21; "Sales IPG Inventoriable"; Code[250])
        {
        }
        field(22; "Purchase IPG Non-Inventoriable"; Code[250])
        {
        }
        field(23; "Sales IPG Non-Inventoriable"; Code[250])
        {
        }
        field(24; "Posting Date"; Date)
        {
        }
        field(25; "Dim 1"; Code[20])
        {
        }
        field(26; "Dim 2"; Code[20])
        {
        }
        field(27; "Sales Amount"; Decimal)
        {
        }
        field(28; "Customer No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; VIN, "Document Type", "Document No")
        {
            Clustered = true;
        }
        key(Key2; VIN, "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

