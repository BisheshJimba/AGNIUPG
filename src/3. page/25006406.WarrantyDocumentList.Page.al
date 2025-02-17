page 25006406 "Warranty Document List"
{
    Caption = 'Warranty Document List';
    CardPageID = "Warranty Document Card";
    Editable = false;
    PageType = List;
    SourceTable = Table25006405;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Service Order No."; "Service Order No.")
                {
                }
                field("Service Order Sequence No."; "Service Order Sequence No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
                {
                }
                field("Vehicle Status Code"; "Vehicle Status Code")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Model Commercial Name"; "Model Commercial Name")
                {
                }
                field("Variable Field Run 1"; "Variable Field Run 1")
                {
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                }
                field("Claim Job Type"; "Claim Job Type")
                {
                }
                field("Symptom Code"; "Symptom Code")
                {
                }
                field("Recal Campaign Code"; "Recal Campaign Code")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Currency Factor"; "Currency Factor")
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

