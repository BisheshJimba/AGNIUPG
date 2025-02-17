tableextension 50486 tableextension50486 extends "Config. Package Table"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Table Name"(Field 3)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Package Records"(Field 4)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Package Errors"(Field 5)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Table Caption"(Field 12)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Fields Included"(Field 17)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Fields Available"(Field 18)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Fields to Validate"(Field 19)".


        //Unsupported feature: Property Modification (CalcFormula) on "Filtered(Field 25)".


        //Unsupported feature: Property Insertion (Enabled) on ""Delete Recs Before Processing"(Field 27)".


        //Unsupported feature: Property Insertion (Editable) on ""Delete Recs Before Processing"(Field 27)".

        modify("Parent Table ID")
        {
            TableRelation = "Config. Package Table"."Table ID" WHERE(Package Code=FIELD(Package Code),
                                                                      Parent Table ID=CONST(0));
        }

        //Unsupported feature: Property Deletion (CaptionML) on ""Delete Recs Before Processing"(Field 27)".

    }
}

