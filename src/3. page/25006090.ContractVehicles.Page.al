page 25006090 "Contract Vehicles"
{
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Set Visible FALSE to fields:
    //     "Contract Type"
    //     "Contract No."
    // 
    // 07.04.2014 Elva Baltic P15 # MMG7.00
    //   * initial creation

    Caption = 'Contract Vehicles';
    SourceTable = Table25006059;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Contract Type"; "Contract Type")
                {
                    Visible = false;
                }
                field("Contract No."; "Contract No.")
                {
                    Visible = false;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Veh. Make Code"; "Veh. Make Code")
                {
                }
                field("Veh. Model Code"; "Veh. Model Code")
                {
                }
                field("Veh. Model Version No."; "Veh. Model Version No.")
                {
                    Visible = false;
                }
                field(VIN; VIN)
                {
                }
            }
        }
    }

    actions
    {
    }
}

