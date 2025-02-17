tableextension 50062 tableextension50062 extends "Workflow User Group"
{
    fields
    {
        field(50000; Type; Option)
        {
            OptionCaption = ' ,Vehicle Repair Tracker,Purchase Header,Blanket PO,Service Header,Expense Memo,Procurement';
            OptionMembers = " ","Vehicle Repair Tracker","Purchase Header","Blanket PO","Service Header","Expense Memo",Procurement;
        }
        field(50001; Active; Boolean)
        {
        }
        field(50002; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(50003; "Amount Limit Lower"; Decimal)
        {
            Description = 'For custom purchase';
        }
        field(50004; "Amount Limit Upper"; Decimal)
        {
        }
    }
}

