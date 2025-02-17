table 25006156 "Service Plan Template Usage"
{
    Caption = 'Service Plan Template Usage';

    fields
    {
        field(10; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            TableRelation = "Service Plan Template";
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(30; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(40;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version));

            trigger OnLookup()
            begin
                IF LookUpMgt.LookUpModelVersion(Item, "Model Version No.", "Make Code", "Model Code") THEN
                  VALIDATE("Model Version No.", Item."No.");
            end;
        }
        field(50;"Vehicle Status";Code[20])
        {
            Caption = 'Vehicle Status';
            TableRelation = "Vehicle Status";
        }
    }

    keys
    {
        key(Key1;"Template Code","Make Code","Model Code","Model Version No.","Vehicle Status")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record "27";
        LookUpMgt: Codeunit "25006003";
}

