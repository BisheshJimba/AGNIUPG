tableextension 50465 tableextension50465 extends "Analysis Report Chart Line"
{
    fields
    {
        modify("User ID")
        {
            TableRelation = "Analysis Report Chart Setup"."User ID" WHERE(Name = FIELD(Name),
                                                                           Analysis Area=FIELD(Analysis Area));
        }
        modify(Name)
        {
            TableRelation = "Analysis Report Chart Setup".Name WHERE (User ID=FIELD(User ID),
                                                                      Analysis Area=FIELD(Analysis Area));
        }
        modify("Analysis Line Line No.")
        {
            TableRelation = "Analysis Line"."Line No." WHERE (Analysis Area=FIELD(Analysis Area),
                                                              Analysis Line Template Name=FIELD(Analysis Line Template Name));
        }
        modify("Analysis Column Line No.")
        {
            TableRelation = "Analysis Column"."Line No." WHERE (Analysis Area=FIELD(Analysis Area),
                                                                Analysis Column Template=FIELD(Analysis Column Template Name));
        }
        modify("Analysis Area")
        {
            TableRelation = "Analysis Report Chart Setup"."Analysis Area" WHERE (User ID=FIELD(User ID),
                                                                                 Name=FIELD(Name));
        }
        modify("Analysis Line Template Name")
        {
            TableRelation = "Analysis Report Chart Setup"."Analysis Line Template Name" WHERE (User ID=FIELD(User ID),
                                                                                               Analysis Area=FIELD(Analysis Area),
                                                                                               Name=FIELD(Name));
        }
        modify("Analysis Column Template Name")
        {
            TableRelation = "Analysis Report Chart Setup"."Analysis Column Template Name" WHERE (User ID=FIELD(User ID),
                                                                                                 Analysis Area=FIELD(Analysis Area),
                                                                                                 Name=FIELD(Name));
        }
    }
}

