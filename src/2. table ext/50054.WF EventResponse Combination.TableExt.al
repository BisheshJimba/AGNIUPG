tableextension 50054 tableextension50054 extends "WF Event/Response Combination"
{
    fields
    {
        modify("Function Name")
        {
            TableRelation = IF (Type = CONST(Event)) "Workflow Event"
            ELSE
            IF (Type = CONST(Response)) "Workflow Response";
        }
        modify("Predecessor Function Name")
        {
            TableRelation = IF ("Predecessor Type" = CONST(Event)) "Workflow Event"
            ELSE IF ("Predecessor Type" = CONST(Response)) "Workflow Response";
        }
    }
}

