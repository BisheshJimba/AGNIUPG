tableextension 50050 tableextension50050 extends "Workflow Step Instance"
{
    fields
    {
        modify("Function Name")
        {
            TableRelation = IF (Type = CONST(Event)) "Workflow Event"
            ELSE
            IF (Type = CONST(Response)) "Workflow Response";
        }
    }
}

