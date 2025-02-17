page 25006087 "Get Vehicle to Charge"
{
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Added LVI captions
    // 
    // 16.01.2014 EDMS P15
    //   * Initial edition

    Caption = 'Get Vehicle to Charge';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(VehicleSerialNo; VehicleSerialNo)
            {
                Caption = 'Vehicle Serial No.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    Vehicle.RESET;
                    IF LookUpMgt.LookUpVehicleAMT(Vehicle, VehicleSerialNo) THEN BEGIN
                        Text := Vehicle."Serial No.";
                        EXIT(TRUE)
                    END;
                end;

                trigger OnValidate()
                begin
                    VehicleAccCycleNo := '';
                    IF VehicleSerialNo <> '' THEN
                        IF Vehicle.GET(VehicleSerialNo) THEN BEGIN
                            Vehicle.CALCFIELDS("Default Vehicle Acc. Cycle No.");
                            VehicleAccCycleNo := Vehicle."Default Vehicle Acc. Cycle No.";
                        END;
                    CurrPage.UPDATE;
                end;
            }
            field(VehAccCycleNo; VehicleAccCycleNo)
            {
                Caption = 'Vehicle Accounting Cycle No.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    recVehAccCycle.RESET;
                    IF LookUpMgt.LookUpVehicleAccCycle(recVehAccCycle, VehicleSerialNo, '') THEN BEGIN
                        Text := recVehAccCycle."No.";
                        EXIT(TRUE);
                    END;
                end;
            }
            field(Positive; Positive)
            {
                Caption = 'Positive';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Positive := TRUE;
    end;

    var
        VehicleSerialNo: Code[20];
        VehicleAccCycleNo: Code[20];
        LookUpMgt: Codeunit "25006003";
        Vehicle: Record "25006005";
        recVehAccCycle: Record "25006024";
        Positive: Boolean;

    [Scope('Internal')]
    procedure GetVehicleParams(var VehSerNo: Code[20]; var VehAccCycleNo: Code[20]; var VehOperationPositive: Boolean)
    begin
        VehSerNo := VehicleSerialNo;
        VehAccCycleNo := VehicleAccCycleNo;
        VehOperationPositive := Positive;
    end;
}

