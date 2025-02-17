page 33020046 "Posted Outward Gate SubForm"
{
    AutoSplitKey = true;
    Caption = 'Posted Outward Gate SubForm';
    Editable = false;
    PageType = ListPart;
    SourceTable = Table33020039;

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
                    OptionCaption = ' ,Sales Shipment,,,Purchase Return Shipment,,Transfer Shipment';
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

