pageextension 50324 pageextension50324 extends "Transfer Route Specification"
{
    // 29.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Added fields:
    //     "Default Vehicle Status-to"
    //     from
    //     to
    layout
    {
        addfirst("Control 1")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
            }
        }
        addafter("Control 11")
        {
            field("Default Vehicle Status-to"; Rec."Default Vehicle Status-to")
            {
            }
        }
    }
}

