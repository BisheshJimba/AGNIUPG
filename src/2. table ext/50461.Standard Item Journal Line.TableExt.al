tableextension 50461 tableextension50461 extends "Standard Item Journal Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        modify("Bin Code")
        {
            TableRelation = IF (Entry Type=FILTER(Purchase|Positive Adjmt.|Output),
                                Quantity=FILTER(>=0)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                      Item Filter=FIELD(Item No.),
                                                                      Variant Filter=FIELD(Variant Code))
                                                                      ELSE IF (Entry Type=FILTER(Purchase|Positive Adjmt.|Output),
                                                                               Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                    Item No.=FIELD(Item No.),
                                                                                                                                    Variant Code=FIELD(Variant Code))
                                                                                                                                    ELSE IF (Entry Type=FILTER(Sale|Negative Adjmt.|Transfer|Consumption),
                                                                                                                                             Quantity=FILTER(>0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                  Item No.=FIELD(Item No.),
                                                                                                                                                                                                  Variant Code=FIELD(Variant Code))
                                                                                                                                                                                                  ELSE IF (Entry Type=FILTER(Sale|Negative Adjmt.|Transfer|Consumption),
                                                                                                                                                                                                           Quantity=FILTER(<=0)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                                                                 Item Filter=FIELD(Item No.),
                                                                                                                                                                                                                                                 Variant Filter=FIELD(Variant Code));
        }
    }
}

