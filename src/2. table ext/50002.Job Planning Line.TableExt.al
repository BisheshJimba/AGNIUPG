tableextension 50002 tableextension50002 extends "Job Planning Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST(Text)) "Standard Text";
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE IF (Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Invoiced Amount (LCY)"(Field 1035)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Invoiced Cost Amount (LCY)"(Field 1036)".

        modify("Ledger Entry No.")
        {
            TableRelation = IF ("Ledger Entry Type" = CONST(Resource)) "Res. Ledger Entry"
            ELSE IF ("Ledger Entry Type" = CONST(Item)) "Item Ledger Entry"
            ELSE IF ("Ledger Entry Type" = CONST("G/L Account")) "G/L Entry";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. Transferred to Invoice"(Field 1080)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. Invoiced"(Field 1090)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 1100)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 1101)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

    }
}

