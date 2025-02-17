pageextension 50059 pageextension50059 extends "Location List"
{
    // 21.05.2014 Elva Baltic P21 #F012 MMG7.00
    //   Added page action:
    //     <Page Default Dimensions>
    layout
    {
        addafter("Control 4")
        {
            field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
            {
            }
            field("Location Type"; "Location Type")
            {
            }
            field(WareHouse; WareHouse)
            {
            }
        }
    }
    actions
    {
        addafter("Action 11")
        {
            action(Dimensions)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page 540;
                RunPageLink = Table ID=CONST(14),
                              No.=FIELD(Code);
                ShortCutKey = 'Shift+Ctrl+D';
            }
        }
    }
}

