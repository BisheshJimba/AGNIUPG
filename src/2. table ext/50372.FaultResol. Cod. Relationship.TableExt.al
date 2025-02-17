tableextension 50372 tableextension50372 extends "Fault/Resol. Cod. Relationship"
{
    fields
    {
        modify("Fault Code")
        {
            TableRelation = "Fault Code".Code WHERE(Fault Area Code=FIELD(Fault Area Code),
                                                     Symptom Code=FIELD(Symptom Code));
        }
    }
}

