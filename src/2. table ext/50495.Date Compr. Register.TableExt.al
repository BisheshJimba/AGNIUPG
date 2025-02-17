tableextension 50495 tableextension50495 extends "Date Compr. Register"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Table Caption"(Field 3)".

        modify("Register No.")
        {
            TableRelation = IF (Table ID=CONST(17)) "G/L Register"
                            ELSE IF (Table ID=CONST(21)) "G/L Register"
                            ELSE IF (Table ID=CONST(25)) "G/L Register"
                            ELSE IF (Table ID=CONST(254)) "G/L Register"
                            ELSE IF (Table ID=CONST(32)) "Item Register"
                            ELSE IF (Table ID=CONST(203)) "Resource Register"
                            ELSE IF (Table ID=CONST(169)) "Job Register"
                            ELSE IF (Table ID=CONST(5601)) "FA Register"
                            ELSE IF (Table ID=CONST(5629)) "Insurance Register"
                            ELSE IF (Table ID=CONST(5625)) "FA Register"
                            ELSE IF (Table ID=CONST(7312)) "Warehouse Register";
        }
    }
}

