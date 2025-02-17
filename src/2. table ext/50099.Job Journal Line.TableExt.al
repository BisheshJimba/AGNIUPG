tableextension 50099 tableextension50099 extends "Job Journal Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account";
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE IF (Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }
        modify("Time Sheet Date")
        {
            TableRelation = "Time Sheet Detail".Date WHERE("Time Sheet No." = FIELD("Time Sheet No."),
                                                            "Time Sheet Line No." = FIELD("Time Sheet Line No."));
        }
        modify("Ledger Entry No.")
        {
            TableRelation = IF ("Ledger Entry Type" = CONST(Resource)) "Res. Ledger Entry"
            ELSE IF ("Ledger Entry Type" = CONST(Item)) "Item Ledger Entry"
            ELSE IF ("Ledger Entry Type" = CONST("G/L Account")) "G/L Entry";
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 5468)".

    }
}

