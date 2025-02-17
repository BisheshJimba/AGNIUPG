tableextension 50371 tableextension50371 extends Loaner
{
    fields
    {
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Item No.=CONST(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 8)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Document No."(Field 12)".


        //Unsupported feature: Property Modification (CalcFormula) on "Lent(Field 13)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Document Type"(Field 15)".

    }
}

