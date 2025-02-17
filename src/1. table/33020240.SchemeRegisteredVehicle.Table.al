table 33020240 "Scheme Registered Vehicle"
{
    Permissions = TableData 25006005 = rm;

    fields
    {
        field(1; "VIN Code"; Code[20])
        {
        }
        field(2; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                "Valid Until" := CALCDATE(Period, "Start Date");
            end;
        }
        field(3; Period; DateFormula)
        {

            trigger OnValidate()
            begin
                "Valid Until" := CALCDATE(Period, "Start Date");
            end;
        }
        field(4; "Valid Until"; Date)
        {
            Editable = false;
        }
        field(5; "Scheme Type"; Option)
        {
            OptionCaption = 'AMC,SANJIVANI';
            OptionMembers = AMC,SANJIVANI;
        }
        field(6; "Registered By"; Code[50])
        {
            Editable = false;
        }
        field(50000; "Reference No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "VIN Code", "Scheme Type", "Start Date", "Valid Until")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TESTFIELD("Start Date");
        //TESTFIELD("Valid Until");
        //TESTFIELD(Period);
        Vehicle.RESET;
        Vehicle.SETCURRENTKEY(VIN);
        Vehicle.SETRANGE(VIN, "VIN Code");
        IF Vehicle.FINDFIRST THEN BEGIN
            Vehicle."AMC Registered" := TRUE;
            Vehicle.MODIFY(TRUE);
        END;
        "Registered By" := USERID;
        IF "Reference No." = '' THEN
            ERROR('You must specify WMS Job No.');
    end;

    var
        Vehicle: Record "25006005";
}

