page 25006407 "Warranty Document Subform"
{
    AutoSplitKey = true;
    Caption = 'Warranty Document Line';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table25006406;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Service Order No."; "Service Order No.")
                {
                }
                field("Service Order Line No."; "Service Order Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Standard Time"; "Standard Time")
                {
                }
                field("Symptom Code"; "Symptom Code")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

