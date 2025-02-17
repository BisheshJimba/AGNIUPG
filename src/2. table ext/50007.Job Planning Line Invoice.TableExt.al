tableextension 50007 tableextension50007 extends "Job Planning Line Invoice"
{
    fields
    {
        modify("Job Planning Line No.")
        {
            TableRelation = "Job Planning Line"."Line No." WHERE("Job No." = FIELD("Job No."),
                                                                  "Job Task No." = FIELD("Job Task No."));
        }
    }
}

