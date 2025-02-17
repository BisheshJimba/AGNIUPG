tableextension 50456 tableextension50456 extends Bin
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Adjustment Bin"(Field 5)".

        modify("Variant Filter")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Filter"(Field 33)".

            TableRelation = "Stockkeeping Unit"."Variant Code" WHERE(Location Code=FIELD(Location Code),
                                                                      Item No.=FIELD(Item Filter));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Default(Field 34)".

    }
}

