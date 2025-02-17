tableextension 50314 tableextension50314 extends "FA Posting Group"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Acquisition Cost %"(Field 31)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Depreciation %"(Field 32)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Write-Down %"(Field 33)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Appreciation %"(Field 34)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Custom 1 %"(Field 35)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Custom 2 %"(Field 36)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Sales Price %"(Field 37)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Maintenance %"(Field 38)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Gain %"(Field 39)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Loss %"(Field 40)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Book Value % (Gain)"(Field 41)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Book Value % (Loss)"(Field 42)".

        field(50000; "Default Depreciation Method"; Option)
        {
            OptionMembers = "Straight Line";
        }
        field(50001; "Default Depreciation Rate"; Decimal)
        {
        }
        field(50002; "Default Depreciation Year"; Decimal)
        {
        }
        field(60000; "Description for VAT Book"; Text[50])
        {
        }
    }
}

