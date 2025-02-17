tableextension 50308 tableextension50308 extends "Unplanned Demand"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 14)".

        modify("Bin Code")
        {
            TableRelation = Bin.Code WHERE(Location Code=FIELD(Location Code),
                                            Item Filter=FIELD(Item No.),
                                            Variant Filter=FIELD(Variant Code));
        }
    }
}

