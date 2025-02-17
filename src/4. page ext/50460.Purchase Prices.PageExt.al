pageextension 50460 pageextension50460 extends "Purchase Prices"
{
    // 17.06.2014 Elva Baltic P8 #F0006 EDMS7.10
    //   * ADDED FIELDS:
    //     "Ordering Price Type Code"
    layout
    {
        addafter("Control 14")
        {
            field("Ordering Price Type Code"; Rec."Ordering Price Type Code")
            {
                Visible = false;
            }
        }
    }
}

