pageextension 50248 pageextension50248 extends "Interaction Template Setup"
{
    // 11.02.2016 EB.P7 Added SMS field
    layout
    {
        addafter("Control 41")
        {
            field(SMS; Rec.SMS)
            {
            }
        }
    }
}

