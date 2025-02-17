tableextension 50259 tableextension50259 extends Rating
{
    fields
    {
        modify("Profile Questionnaire Line No.")
        {
            TableRelation = "Profile Questionnaire Line"."Line No." WHERE(Profile Questionnaire Code=FIELD(Profile Questionnaire Code),
                                                                           Type=CONST(Question),
                                                                           Contact Class. Field=CONST(Rating));
        }
        modify("Rating Profile Quest. Line No.")
        {
            TableRelation = "Profile Questionnaire Line"."Line No." WHERE (Profile Questionnaire Code =FIELD(Rating Profile Quest. Code),
                                                                           Type=CONST(Answer));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Profile Question Description"(Field 6)".

    }
}

