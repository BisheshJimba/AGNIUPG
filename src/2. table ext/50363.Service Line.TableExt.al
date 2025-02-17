tableextension 50363 tableextension50363 extends "Service Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item WHERE (Type=CONST(Inventory))
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST(Cost)) "Service Cost";
        }
        modify("Attached to Line No.")
        {
            TableRelation = "Service Line"."Line No." WHERE(Document Type=FIELD(Document Type),
                                                             Document No.=FIELD(Document No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 95)".

        modify("Time Sheet Date")
        {
            TableRelation = "Time Sheet Detail".Date WHERE (Time Sheet No.=FIELD(Time Sheet No.),
                                                            Time Sheet Line No.=FIELD(Time Sheet Line No.));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        modify("Bin Code")
        {
            TableRelation = IF (Document Type=FILTER(Order|Invoice),
                                Location Code=FILTER(<>''),
                                Type=CONST(Item)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                  Item No.=FIELD(No.),
                                                                                  Variant Code=FIELD(Variant Code))
                                                                                  ELSE IF (Document Type=FILTER(Credit Memo),
                                                                                           Location Code=FILTER(<>''),
                                                                                           Type=CONST(Item)) Bin.Code WHERE (Location Code=FIELD(Location Code));
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 5495)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Substitution Available"(Field 5702)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Whse. Outstanding Qty. (Base)"(Field 5750)".

        modify("Service Item Line No.")
        {
            TableRelation = "Service Item Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                  Document No.=FIELD(Document No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Service Item Line Description"(Field 5906)".

        modify("Fault Code")
        {
            TableRelation = "Fault Code".Code WHERE (Fault Area Code=FIELD(Fault Area Code),
                                                     Symptom Code=FIELD(Symptom Code));
        }
        modify("Replaced Item No.")
        {
            TableRelation = IF (Replaced Item Type=CONST(Item)) Item
                            ELSE IF (Replaced Item Type=CONST(Service Item)) "Service Item";
        }
    }

    //Unsupported feature: Property Modification (Length) on "ReplaceServItem(PROCEDURE 8).VariantCode(Variable 1002)".

}

