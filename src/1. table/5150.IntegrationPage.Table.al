table 5150 "Integration Page"
{
    Caption = 'Integration Page';
    DataPerCompany = false;

    fields
    {
        field(1; "Service Name"; Text[240])
        {
            Caption = 'Service Name';
            // TableRelation = "Web Service"."Service Name" WHERE("Object Type"=CONST(Page)); //internal scope issue
        }
        field(2; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Web Service"."Object ID" WHERE("Object Type" = CONST(Page), "Service Name" = FIELD("Service Name"))); //internal scope issue

        }
        field(3; "Source Table ID"; Integer)
        {
            Caption = 'Source Table ID';
        }
        field(4; Published; Boolean)
        {
            Caption = 'Published';
            // FieldClass = FlowField;
            // CalcFormula = Exist("Web Service" WHERE(Service Name=FIELD(Service Name),Published=CONST(Yes))); //internal scope issue

        }
    }

    keys
    {
        key(Key1; "Service Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

