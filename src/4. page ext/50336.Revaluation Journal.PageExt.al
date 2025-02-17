pageextension 50336 pageextension50336 extends "Revaluation Journal"
{
    // 19.03.2014 Elva Baltic P7 #S0038 MMG7.00
    //   * Fields added - VIN, Vehicle Serial No., Vehicle Acc. Cycle No.
    Editable = true;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

        addafter("Control 85")
        {
            field("Serial No."; Rec."Serial No.")
            {
            }
        }
        addafter("Control 310")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Visible = false;
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field(VIN; VIN)
            {
            }
        }
    }
}

