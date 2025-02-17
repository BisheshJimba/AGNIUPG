page 33019999 "Staff Fuel Issue List Part"
{
    Caption = 'Staff Fuel Issue History';
    PageType = ListPart;
    SourceTable = Table33019963;

    layout
    {
        area(content)
        {
            field(FORMAT(ROUND(AdminUIMngt.getLastFilledFuelLitreStaff("Staff No."), 0.1, '=')); FORMAT(ROUND(AdminUIMngt.getLastFilledFuelLitreStaff("Staff No."),0.1,'=')))
            {
                Caption = 'Last Visit - Issue';
            }
            field(FORMAT(AdminUIMngt.getPetrolPump("Staff No.")); FORMAT(AdminUIMngt.getPetrolPump("Staff No.")))
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

