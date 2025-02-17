tableextension 50249 tableextension50249 extends "Segment Wizard Filter"
{
    fields
    {
        modify("Territory Code Filter")
        {
            TableRelation = "Dealer Segment Type";
        }
        modify("Profile Questn. Line Filter")
        {
            TableRelation = "Profile Questionnaire Line"."Line No." WHERE(Profile Questionnaire Code=FIELD(Profile Questn. Code Filter),
                                                                           Type=CONST(Answer));
        }
    }
}

