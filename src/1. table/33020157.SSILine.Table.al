table 33020157 "SSI Line"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            TableRelation = "SSI Header"."Prospect No.";
        }
        field(3; "Prospect Line No."; Integer)
        {
        }
        field(5; "SSI Code"; Code[10])
        {
            TableRelation = "CRM Master Template".Code WHERE(Master Options=CONST(SSI));

            trigger OnValidate()
            begin
                IF CRMMaster_G.GET(CRMMaster_G."Master Options"::SSI, "SSI Code") THEN
                    Description := CRMMaster_G.Description;
            end;
        }
        field(8; Description; Text[150])
        {
        }
        field(10; Marks; Option)
        {
            OptionCaption = '1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "1","2","3","4","5","6","7","8","9","10";
        }
        field(12; Remarks; Text[120])
        {
        }
        field(13; Positive; Text[30])
        {
        }
        field(14; Negative; Text[30])
        {
        }
        field(15; Improvements; Text[120])
        {
        }
    }

    keys
    {
        key(Key1; "Prospect No.", "Prospect Line No.", "SSI Code")
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

