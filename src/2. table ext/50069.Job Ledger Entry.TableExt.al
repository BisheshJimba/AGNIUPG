tableextension 50069 tableextension50069 extends "Job Ledger Entry"
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
            ELSE IF (Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."));
        }
        modify("Ledger Entry No.")
        {
            TableRelation = IF ("Ledger Entry Type" = CONST(Resource)) "Res. Ledger Entry"
            ELSE IF ("Ledger Entry Type" = CONST(Item)) "Item Ledger Entry"
            ELSE IF ("Ledger Entry Type" = CONST("G/L Account")) "G/L Entry";
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

    }
}

