tableextension 50327 tableextension50327 extends "Substitution Condition"
{
    fields
    {
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 2)".

            TableRelation = "Item Substitution"."Variant Code" WHERE(No.=FIELD(No.),
                                                                      Variant Code=FIELD(Variant Code));
        }
        modify("Substitute No.")
        {
            TableRelation = "Item Substitution"."Substitute No." WHERE (No.=FIELD(No.),
                                                                        Variant Code=FIELD(Variant Code),
                                                                        Substitute No.=FIELD(Substitute No.));
        }
        modify("Substitute Variant Code")
        {
            TableRelation = "Item Substitution"."Substitute Variant Code" WHERE (No.=FIELD(No.),
                                                                                 Variant Code=FIELD(Variant Code),
                                                                                 Substitute No.=FIELD(Substitute No.),
                                                                                 Substitute Variant Code=FIELD(Substitute Variant Code));
        }
    }
}

