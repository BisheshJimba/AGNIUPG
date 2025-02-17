pageextension 50120 pageextension50120 extends "Req. Worksheet Template List"
{
    layout
    {
        addafter("Control 12")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                Visible = false;
            }
        }
    }
}

