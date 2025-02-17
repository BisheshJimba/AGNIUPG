table 50022 "Sales Line Buffer"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Model Version No."; Code[20])
        {

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                IF Item.GET("Model Version No.") THEN BEGIN
                    // "Make Code" := Item."Make Code";
                    // "Model Code" := Item."Model Code";//need to add fields
                END;
            end;
        }
        field(4; Quantity; Decimal)
        {
        }
        field(5; "Make Code"; Code[20])
        {
        }
        field(6; "Model Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

