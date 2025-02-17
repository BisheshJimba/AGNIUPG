table 33020150 "Trade In Details"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            TableRelation = "Sales Progress Details".Field1;
        }
        field(3; Make; Code[20])
        {
            Description = 'Not TATA';
        }
        field(4; Model; Code[20])
        {
        }
        field(5; Derivative; Text[30])
        {
        }
        field(6; Year; Integer)
        {
        }
        field(7; "ODO Reading"; Integer)
        {
        }
        field(8; Doors; Integer)
        {
        }
        field(9; "Body Style"; Option)
        {
            OptionCaption = ' ,Hatch,Sedan,MPV,SUV,Ute,Van,Wagon';
            OptionMembers = " ",Hatch,Sedan,MPV,SUV,Ute,Van,Wagon;
        }
        field(10; "Engine Size"; Decimal)
        {
        }
        field(11; "Fuel Type"; Code[10])
        {
            TableRelation = "CRM Master Template".Code WHERE(Master Options=CONST(FuelPreference));
        }
        field(12; Drive; Option)
        {
            OptionCaption = ' ,2WD,4WD,AWD';
            OptionMembers = " ","2WD","4WD",AWD;
        }
        field(13; Transmission; Option)
        {
            OptionCaption = ' ,Auto,Manual';
            OptionMembers = " ",Auto,Manual;
        }
        field(14; Color; Code[20])
        {
        }
        field(15; "Price Offered (LCY)"; Decimal)
        {

            trigger OnValidate()
            begin
                //Calculating Additional currency amount.
                gblGLSetup.GET;

                gblCurrExchRate.RESET;
                gblCurrExchRate.SETRANGE("Currency Code", gblGLSetup."Additional Reporting Currency");
                gblCurrExchRate.SETFILTER("Starting Date", '%1..%2', 0D, TODAY);
                IF gblCurrExchRate.FIND('-') THEN BEGIN
                    IF (gblCurrExchRate."Relational Exch. Rate Amount" <> 0) THEN BEGIN
                        "Add. Curr. Pricce Offered" := "Price Offered (LCY)" / gblCurrExchRate."Relational Exch. Rate Amount";
                        MODIFY;
                    END;
                END;
            end;
        }
        field(16; "Add. Curr. Pricce Offered"; Decimal)
        {
            Editable = false;
        }
        field(17; "Estimated Recon"; Option)
        {
            OptionCaption = ' ,Minor,Moderate,Major';
            OptionMembers = " ",Minor,Moderate,Major;
        }
        field(18; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(19; "Trade In Own"; Boolean)
        {
        }
        field(20; "Sales Progress Code"; Code[10])
        {
            TableRelation = "Sales Progress Details".Field2;
        }
    }

    keys
    {
        key(Key1; "Prospect No.", "Sales Progress Code", Make, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        gblGLSetup: Record "98";
        gblCurrExchRate: Record "330";
}

