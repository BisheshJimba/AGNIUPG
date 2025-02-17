tableextension 50053 tableextension50053 extends "Workflow Step Buffer"
{
    fields
    {
        modify("Event Step ID")
        {
            TableRelation = "Workflow Step".ID WHERE("Workflow Code" = FIELD("Workflow Code"),
                                                      Type = CONST(Event));
        }
        modify("Response Step ID")
        {
            TableRelation = "Workflow Step".ID WHERE("Workflow Code" = FIELD("Workflow Code"),
                                                      Type = CONST(Response));
        }
        modify("Parent Event Step ID")
        {
            TableRelation = "Workflow Step".ID WHERE("Workflow Code" = FIELD("Workflow Code"),
                                                      Type = CONST(Event));
        }
    }
}

