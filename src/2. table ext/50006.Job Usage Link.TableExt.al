tableextension 50006 tableextension50006 extends "Job Usage Link"
{
    fields
    {
        modify("Line No.")
        {
            TableRelation = "Job Planning Line"."Line No." WHERE("Job No." = FIELD("Job No."),
                                                                  "Job Task No." = FIELD("Job Task No."));
        }
    }
}

