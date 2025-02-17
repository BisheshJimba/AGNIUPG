page 33020191 "Vehicle Dispatch Subform"
{
    PageType = ListPart;
    SourceTable = Table33020172;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sales Invoice No."; "Sales Invoice No.")
                {

                    trigger OnValidate()
                    begin
                        CALCFIELDS(VIN);
                    end;
                }
                field(VIN; VIN)
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Driver's Name"; "Driver's Name")
                {
                }
                field("Fuel Qty."; "Fuel Qty.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

