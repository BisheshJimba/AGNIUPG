page 33020269 "Vehicle Transfer Orders"
{
    Editable = false;
    PageType = List;
    SourceTable = Table5741;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Document No."; "Document No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Status; Status)
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("In-Transit Code"; "In-Transit Code")
                {
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        TransHdr: Record "5740";
        TransLine: Record "5741";
}

