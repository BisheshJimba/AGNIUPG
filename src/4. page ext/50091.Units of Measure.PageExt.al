pageextension 50091 pageextension50091 extends "Units of Measure"
{
    // 28.03.2013 EDMS P1
    //   *Added field "Minutes Per UoM"
    layout
    {
        addafter("Control 3")
        {
            field("Minutes Per UoM"; Rec."Minutes Per UoM")
            {
                Visible = false;
            }
        }
    }
}

