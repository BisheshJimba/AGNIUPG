tableextension 50260 tableextension50260 extends "Interaction Template Setup"
{
    // 11.02.2016 EB.P7 Added field SMS
    fields
    {
        field(25006000; SMS; Code[10])
        {
            TableRelation = "Interaction Template" WHERE(Attachment No.=CONST(0));
        }
    }
}

