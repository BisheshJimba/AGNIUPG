page 33019807 "Vehicle with Flowfields"
{
    PageType = List;
    SourceTable = Table33019823;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Serial No."; "Serial No.")
                {
                }
                field(VIN; VIN)
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
                field("Custom Clearance Memo No."; "Custom Clearance Memo No.")
                {
                }
                field("Insurance Memo No."; "Insurance Memo No.")
                {
                }
                field("Insurance Policy No."; "Insurance Policy No.")
                {
                }
                field("Item Charges Applied"; "Item Charges Applied")
                {
                }
                field("Sales Invoice No."; "Sales Invoice No.")
                {
                }
                field("Purchase Order Date"; "Purchase Order Date")
                {
                }
                field("Ins. Payment Memo No."; "Ins. Payment Memo No.")
                {
                }
                field("Purchase Invoice"; "Purchase Invoice")
                {
                }
                field("Purchase Invoice Date"; "Purchase Invoice Date")
                {
                }
                field("Purchase Invoice Date (Real)"; "Purchase Invoice Date (Real)")
                {
                }
                field("Default Vehicle Acc. Cycle No."; "Default Vehicle Acc. Cycle No.")
                {
                }
                field("Total Commission Paid"; "Total Commission Paid")
                {
                }
                field("Scheme Code"; "Scheme Code")
                {
                }
                field("Scheme Type"; "Scheme Type")
                {
                }
                field("PDI Status"; "PDI Status")
                {
                }
                field("PDI Type"; "PDI Type")
                {
                }
                field("Next Service Date"; "Next Service Date")
                {
                }
                field("Kilometrage SR"; "Kilometrage SR")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        CompwiseMakeSetup.RESET;
        CompwiseMakeSetup.SETRANGE("Company Name", COMPANYNAME);
        IF CompwiseMakeSetup.FINDFIRST THEN BEGIN
            SETFILTER("Make Code", CompwiseMakeSetup."Make Code Filter");
        END;

        FILTERGROUP(0);
    end;

    var
        CompwiseMakeSetup: Record "33019876";
}

