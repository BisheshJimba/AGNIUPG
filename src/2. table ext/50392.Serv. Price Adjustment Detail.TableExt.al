tableextension 50392 tableextension50392 extends "Serv. Price Adjustment Detail"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST(Resource Group)) "Resource Group"
                            ELSE IF (Type=CONST(Service Cost)) "Service Cost"
                            ELSE IF (Type=CONST(G/L Account)) "G/L Account";
        }
    }
}

