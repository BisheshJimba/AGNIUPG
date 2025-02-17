pageextension 50132 pageextension50132 extends "VAT Entries"
{
    layout
    {
        addafter("Control 60")
        {
            field("External Document No."; Rec."External Document No.")
            {
            }
            field("Exempt Purchase No."; "Exempt Purchase No.")
            {
            }
        }
        addafter("Control 62")
        {
            field("PP No. (Exempt Purchase)"; "PP No. (Exempt Purchase)")
            {
            }
        }
    }
}

