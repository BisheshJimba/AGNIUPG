page 33020038 "Outward Gate Entry SubForm"
{
    AutoSplitKey = true;
    Caption = 'Outward Gate Entry SubForm';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = Table33020036;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Challan No."; "Challan No.")
                {
                }
                field("Challan Date"; "Challan Date")
                {
                }
                field("Source Type"; "Source Type")
                {
                    OptionCaption = ' ,Sales Shipment,,,Purchase Return Shipment,,Transfer Shipment,Service';
                    ValuesAllowed = " ";
                    Sales Shipment;
                    Purchase Return Shipment;
                    Transfer Shipment;
                    Service;
                }
                field("Source No."; "Source No.")
                {
                }
                field("Source Name"; "Source Name")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

