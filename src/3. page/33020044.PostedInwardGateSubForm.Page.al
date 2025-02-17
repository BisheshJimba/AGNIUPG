page 33020044 "Posted Inward Gate SubForm"
{
    Caption = 'Posted Inward Gate SubForm';
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
                    OptionCaption = ' ,,Sales Return Order,Purchase Order,,Transfer Receipt';
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
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

