page 25006086 "Deal Application Entries"
{
    Caption = 'Deal Application Entries';
    Editable = false;
    PageType = List;
    SourceTable = Table25006053;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Type; Type)
                {
                }
                field("Det. Cust. Ledg. Entry EDMS"; "Det. Cust. Ledg. Entry EDMS")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Doc. Line No."; "Doc. Line No.")
                {
                }
                field("Applies-to Entry No."; "Applies-to Entry No.")
                {
                }
                field(Application; Application)
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

