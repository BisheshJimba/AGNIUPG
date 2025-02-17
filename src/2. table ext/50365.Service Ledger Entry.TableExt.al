tableextension 50365 tableextension50365 extends "Service Ledger Entry"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Service Contract)) "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract))
                            ELSE IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST(Service Cost)) "Service Cost"
                            ELSE IF (Type=CONST(G/L Account)) "G/L Account";
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 48)".

    }
}

