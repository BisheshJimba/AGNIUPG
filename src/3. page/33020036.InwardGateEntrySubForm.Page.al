page 33020036 "Inward Gate Entry SubForm"
{
    AutoSplitKey = true;
    Caption = 'Inward Gate Entry SubForm';
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
                    OptionCaption = ' ,,Sales Return Order,Purchase Order,,Transfer Receipt';
                    ValuesAllowed = " ";
                    Sales Return Order;
                    Purchase Order;
                    Transfer Receipt;
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

