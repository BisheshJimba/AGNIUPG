pageextension 50112 pageextension50112 extends "Source Code Setup"
{
    layout
    {
        addafter("Control 105")
        {
            field("Service Management EDMS"; Rec."Service Management EDMS")
            {
            }
        }
        addafter("Control 1907509201")
        {
            group(STPL)
            {
                Caption = 'STPL';
                field("Fuel Issue Entry"; Rec."Fuel Issue Entry")
                {
                }
                field("Fuel Journal Line"; Rec."Fuel Journal Line")
                {
                }
                field("Courier Tracking"; Rec."Courier Tracking")
                {
                }
            }
        }
    }
}

