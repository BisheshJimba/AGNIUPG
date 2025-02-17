table 25006870 "TCard Container"
{

    fields
    {
        field(10; "No."; Integer)
        {
        }
        field(12; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(15; Type; Option)
        {
            OptionMembers = Booking,"Order";
        }
        field(17; Subtype; Option)
        {
            OptionCaption = 'Standard,Initial,In Progress,Finished';
            OptionMembers = Standard,Initial,"In Progress",Finished;
        }
        field(20; Name; Text[250])
        {
        }
        field(30; Enabled; Boolean)
        {
        }
        field(40; "Configured Size"; Integer)
        {
        }
        field(60; PositionX; Integer)
        {
        }
        field(70; PositionY; Integer)
        {
        }
        field(80; "Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(90; "Service Advisor"; Code[10])
        {
            Caption = 'Service Advisor';
            TableRelation = Salesperson/Purchaser;
        }
        field(100;"Container Color";Option)
        {
            OptionMembers = Blue,Green,Orange,Gray;
        }
        field(120;"Container Size";Option)
        {
            OptionMembers = Small,Medium,Large,Custom;

            trigger OnValidate()
            begin
                IF "Container Size" <> "Container Size"::Custom THEN BEGIN
                  "Configured Size" := 0;
                  MODIFY;
                END ELSE BEGIN
                  IF "Configured Size" < 110  THEN
                  "Configured Size" := 110;
                  MODIFY;
                END;
            end;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Location Code")
        {
        }
    }

    fieldgroups
    {
    }
}

