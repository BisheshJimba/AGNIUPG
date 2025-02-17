tableextension 50296 tableextension50296 extends "Production Order"
{
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Item)) Item WHERE (Type=CONST(Inventory))
                            ELSE IF (Source Type=CONST(Family)) Family
                            ELSE IF (Status=CONST(Simulated),
                                     Source Type=CONST(Sales Header)) "Sales Header".No. WHERE (Document Type=CONST(Quote))
                                     ELSE IF (Status=FILTER(Planned..),
                                              Source Type=CONST(Sales Header)) "Sales Header".No. WHERE (Document Type=CONST(Order));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 19)".

        modify("Bin Code")
        {
            TableRelation = IF (Source Type=CONST(Item)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                         Item Filter=FIELD(Source No.))
                                                                         ELSE IF (Source Type=FILTER(<>Item)) Bin.Code WHERE (Location Code=FIELD(Location Code));
        }
        modify("Capacity No. Filter")
        {
            TableRelation = IF (Capacity Type Filter=CONST(Work Center)) "Machine Center"
                            ELSE IF (Capacity Type Filter=CONST(Machine Center)) "Work Center";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Expected Operation Cost Amt."(Field 51)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Expected Component Cost Amt."(Field 52)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Actual Time Used"(Field 55)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Capacity Need"(Field 56)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Expected Capacity Need"(Field 57)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Expected Material Ovhd. Cost"(Field 92)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Expected Capacity Ovhd. Cost"(Field 94)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Picked"(Field 7300)".

    }
}

