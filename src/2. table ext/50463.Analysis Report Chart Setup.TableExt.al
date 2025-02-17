tableextension 50463 tableextension50463 extends "Analysis Report Chart Setup"
{
    fields
    {
        modify("Analysis Line Template Name")
        {
            TableRelation = "Analysis Report Name"."Analysis Line Template Name" WHERE(Analysis Area=FIELD(Analysis Area),
                                                                                        Name=FIELD(Analysis Report Name));
        }
        modify("Analysis Column Template Name")
        {
            TableRelation = "Analysis Report Name"."Analysis Column Template Name" WHERE (Analysis Area=FIELD(Analysis Area),
                                                                                          Name=FIELD(Analysis Report Name));
        }
    }
}

