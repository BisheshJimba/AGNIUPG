table 33020147 "Sales Progress Details"
{

    fields
    {
        field(3; "Sales Progress"; Code[10])
        {
            TableRelation = "CRM Master Template".Code WHERE(Master Options=CONST(SalesProgress));

            trigger OnValidate()
            begin
                IF CRMMaster_G.GET(CRMMaster_G."Master Options"::SalesProgress, "Sales Progress") THEN
                    "Sales Progress Description" := CRMMaster_G.Description;
            end;
        }
        field(4; "Sales Progress Description"; Text[150])
        {
        }
        field(5; "Code"; Code[10])
        {
        }
        field(8; Description; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Sales Progress", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        CRMMaster_G: Record "33020143";
}

