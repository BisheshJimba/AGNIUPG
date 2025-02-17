page 33019998 "Vehicle Fuel Issue List Part"
{
    Caption = 'Vehicle Fuel Issue History';
    PageType = ListPart;
    SourceTable = Table33019963;

    layout
    {
        area(content)
        {
            field(FORMAT(ROUND(AdminUIMngt.getLastVisitKmVeh("VIN (Chasis No.)"), 0.1, '=')); FORMAT(ROUND(AdminUIMngt.getLastVisitKmVeh("VIN (Chasis No.)"),0.1,'=')))
            {
                Caption = 'Last Visit KM';
            }
            field(FORMAT(ROUND(AdminUIMngt.getLastFilledFuelLitreVeh("VIN (Chasis No.)"), 0.1, '=')); FORMAT(ROUND(AdminUIMngt.getLastFilledFuelLitreVeh("VIN (Chasis No.)"),0.1,'=')))
            {
                Caption = 'Last Visit - Issue';
            }
            field(FORMAT(AdminUIMngt.getPetrolPump("VIN (Chasis No.)")); FORMAT(AdminUIMngt.getPetrolPump("VIN (Chasis No.)")))
            {
                Caption = 'Petrol Pump';
            }
        }
    }

    actions
    {
    }

    var
        AdminUIMngt: Codeunit "33019962";
}

