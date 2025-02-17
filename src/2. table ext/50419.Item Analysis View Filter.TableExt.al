tableextension 50419 tableextension50419 extends "Item Analysis View Filter"
{
    fields
    {
        modify("Analysis View Code")
        {
            TableRelation = "Item Analysis View".Code WHERE(Analysis Area=FIELD(Analysis Area),
                                                             Code=FIELD(Analysis View Code));
        }
    }
}

