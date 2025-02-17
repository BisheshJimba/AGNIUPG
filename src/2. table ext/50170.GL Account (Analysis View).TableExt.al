tableextension 50170 tableextension50170 extends "G/L Account (Analysis View)"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Account Source=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Account Source=CONST(Cash Flow Account)) "Cash Flow Account";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 12)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance at Date"(Field 31)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Change"(Field 32)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted Amount"(Field 33)".

        modify(Totaling)
        {
            TableRelation = IF (Account Source=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Account Source=CONST(Cash Flow Account)) "Cash Flow Account";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Balance(Field 36)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted at Date"(Field 37)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount"(Field 47)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount"(Field 48)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted Debit Amount"(Field 52)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted Credit Amount"(Field 53)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Additional-Currency Net Change"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Add.-Currency Balance at Date"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Additional-Currency Balance"(Field 62)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Add.-Currency Debit Amount"(Field 64)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Add.-Currency Credit Amount"(Field 65)".

    }
}

