tableextension 50049 tableextension50049 extends "Workflow Step"
{
    fields
    {
        modify("Function Name")
        {
            TableRelation = IF (Type = CONST(Event)) "Workflow Event"
            ELSE
            IF (Type = CONST(Response)) "Workflow Response"
            ELSE
            IF (Type = CONST("Sub-Workflow")) Workflow;
        }
    }
}

