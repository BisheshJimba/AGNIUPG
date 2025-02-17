pageextension 50245 pageextension50245 extends "Purchase Order Archive Subform"
{
    layout
    {
        modify("Control 76")
        {
            Visible = false;
        }
        modify("Control 78")
        {
            Visible = false;
        }
        modify("Control 82")
        {
            Visible = false;
        }
        modify("Control 84")
        {
            Visible = false;
        }
        modify("Control 86")
        {
            Visible = false;
        }
        addafter("Control 74")
        {
            field("Planning Flexibility"; Rec."Planning Flexibility")
            {
                Visible = false;
            }
            field("Prod. Order Line No."; Rec."Prod. Order Line No.")
            {
                Visible = false;
            }
        }
        addafter("Control 80")
        {
            field("Operation No."; Rec."Operation No.")
            {
                Visible = false;
            }
            field("Work Center No."; Rec."Work Center No.")
            {
                Visible = false;
            }
            field(Finished; Rec.Finished)
            {
                Visible = false;
            }
        }
    }
}

