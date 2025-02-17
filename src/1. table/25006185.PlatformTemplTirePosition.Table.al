table 25006185 "Platform Templ. Tire Position"
{
    Caption = 'Platform Templ. Tire Position';
    LookupPageID = 25006274;

    fields
    {
        field(10; "Template Code"; Code[10])
        {
            Caption = 'Template Code';
            TableRelation = "Platform Template";
        }
        field(20; "Template Axle Code"; Code[10])
        {
            Caption = 'Template Axle Code';
            TableRelation = "Platform Template Axle".Code WHERE(Template Code=FIELD(Template Code));
        }
        field(30;"Code";Code[20])
        {
            Caption = 'Code';
        }
        field(40;Description;Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1;"Template Code","Template Axle Code","Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

