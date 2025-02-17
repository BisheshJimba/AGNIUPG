tableextension 50472 tableextension50472 extends "Item Journal Template"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Test Report Caption"(Field 15)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Page Caption"(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Posting Report Caption"(Field 17)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Whse. Register Report Caption"(Field 22)".

        field(50000; "User ID"; Code[50])
        {
            TableRelation = "User Setup";
        }
    }
}

