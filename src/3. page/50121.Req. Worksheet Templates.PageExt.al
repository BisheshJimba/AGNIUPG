pageextension 50121 pageextension50121 extends "Req. Worksheet Templates"
{
    layout
    {
        addafter("Control 13")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                Visible = false;
            }
        }
    }
}

