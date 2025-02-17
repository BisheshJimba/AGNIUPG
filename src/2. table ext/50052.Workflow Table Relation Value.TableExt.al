tableextension 50052 tableextension50052 extends "Workflow Table Relation Value"
{
    fields
    {
        modify("Workflow Step ID")
        {
            TableRelation = "Workflow Step Instance"."Workflow Step ID" WHERE(ID = FIELD("Workflow Step Instance ID"),
                                                                               "Workflow Code" = FIELD("Workflow Code"));
        }
    }
}

