tableextension 50064 tableextension50064 extends "Office Job Journal"
{
    fields
    {
        modify("Job Journal Template Name")
        {
            TableRelation = "Job Journal Template".Name WHERE("Page ID" = CONST(201),
                                                               Recurring = CONST(false));
        }
    }
}

