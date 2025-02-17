tableextension 50437 tableextension50437 extends "Whse. Pick Request"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = IF (Document Type=CONST(Shipment)) "Warehouse Shipment Header".No.
                            ELSE IF (Document Type=CONST(Internal Pick)) "Whse. Internal Pick Header".No.
                            ELSE IF (Document Type=CONST(Production)) "Production Order".No. WHERE (Status=FIELD(Document Subtype))
                            ELSE IF (Document Type=CONST(Assembly)) "Assembly Header".No. WHERE (Document Type=FIELD(Document Subtype));
        }
        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }
    }
}

