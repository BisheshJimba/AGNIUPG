table 33020332 "Vehicle Safety Stock Setup"
{

    fields
    {
        field(1; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(2; "Make Code"; Code[20])
        {
            TableRelation = Make;
        }
        field(3; "Model Code"; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(10;"Model Version";Code[30])
        {

            trigger OnLookup()
            begin
                recItem.RESET;
                IF LookUpMgt.LookUpModelVersion(recItem,'',"Make Code","Model Code") THEN
                  VALIDATE("Model Version",recItem."No.");
            end;
        }
        field(13;Quantity;Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Location Code","Make Code","Model Code","Model Version")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recItem: Record "27";
        LookUpMgt: Codeunit "25006003";
}

