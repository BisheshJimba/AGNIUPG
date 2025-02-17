pageextension 50063 pageextension50063 extends "Workflow User Group"
{
    layout
    {
        addafter("Control 4")
        {
            field(Active; Rec.Active)
            {
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
            }
            field("Amount Limit Lower"; Rec."Amount Limit Lower")
            {
            }
            field("Amount Limit Upper"; Rec."Amount Limit Upper")
            {
            }
            field(Type; Rec.Type)
            {
                OptionCaption = ' ,Vehicle Repair Tracker,Purchase Header,Blanket PO,Service Header,Expense Memo,Procurement';
            }
        }
    }
}

