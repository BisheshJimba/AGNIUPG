page 33020193 "Vehicle Dispatch List"
{
    CardPageID = "Vehicle Dispatch Card";
    PageType = List;
    SourceTable = Table33020171;
    SourceTableView = WHERE(Received = FILTER(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Dispatched By"; "Dispatched By")
                {
                }
                field(Dispatched; Dispatched)
                {
                }
                field(Received; Received)
                {
                }
                field("Dispatched Date"; "Dispatched Date")
                {
                }
                field("Received Date"; "Received Date")
                {
                }
                field(VIN; VIN)
                {
                    Caption = 'VIN';
                }
                field(Driver; Driver)
                {
                    Caption = 'Driver';
                }
                field(FuelQty; FuelQty)
                {
                    Caption = 'Fuel Qty.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CLEAR(VIN);
        CLEAR(Driver);
        VehDispatchLine.RESET;
        VehDispatchLine.SETRANGE("Document No", "No.");
        IF VehDispatchLine.FINDFIRST THEN BEGIN
            VIN := VehDispatchLine.VIN;
            Driver := VehDispatchLine."Driver's Name";
            FuelQty := VehDispatchLine."Fuel Qty.";
        END;
    end;

    var
        VIN: Code[20];
        Driver: Text[50];
        VehDispatchLine: Record "33020172";
        FuelQty: Decimal;
}

