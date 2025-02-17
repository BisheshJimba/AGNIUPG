page 25006758 "SIE Assignment List"
{
    Caption = 'SIE Assignment List';
    Editable = false;
    PageType = List;
    SourceTable = Table25006706;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field(Type; Type)
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Qty. to Assign"; "Qty. to Assign")
                {
                }
                field("Qty. Assigned Det."; "Qty. Assigned Det.")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Amount to Assign"; "Amount to Assign")
                {
                }
                field("Applies-to Type"; "Applies-to Type")
                {
                }
                field("Applies-to Doc. Type"; "Applies-to Doc. Type")
                {
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                }
                field("Applies-to Doc. Line No."; "Applies-to Doc. Line No.")
                {
                }
                field("Applies-to Doc. Line Amount"; "Applies-to Doc. Line Amount")
                {
                }
                field(Corrected; Corrected)
                {
                }
            }
        }
    }

    actions
    {
    }
}

