pageextension 50291 pageextension50291 extends "Fixed Asset Setup"
{
    layout
    {
        addafter("Control 1904569201")
        {
            group("FA Mail Setup")
            {
                Caption = 'FA Mail Setup';
                field("Employee No."; Rec."Employee No.")
                {
                }
                field(Days; Rec.Days)
                {
                }
            }
        }
    }
}

