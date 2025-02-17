table 33020404 "OutSource Staffs"
{

    fields
    {
        field(1; "Outsource No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Outsource No." <> xRec."Outsource No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Outsource No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Name; Text[50])
        {
        }
        field(3; Company; Text[30])
        {
        }
        field(4; Service; Text[30])
        {
            TableRelation = "Outsource Service-Company".Code WHERE(Type = CONST(Company));
        }
        field(5; "Contract ID"; Code[10])
        {
        }
        field(6; "AMN No."; Text[30])
        {
        }
        field(7; "Effective Date"; Date)
        {
        }
        field(8; Premises; Text[30])
        {
            TableRelation = "Dimension Value".Name WHERE(Dimension Code=CONST(BRANCH));
        }
        field(9; "No."; Integer)
        {
        }
        field(10; Type; Text[30])
        {
        }
        field(11; Deployment; Text[30])
        {
        }
        field(12; Category; Text[30])
        {
        }
        field(13; "Rate / Month"; Decimal)
        {
        }
        field(14; Posted; Boolean)
        {
        }
        field(15; "Posted Date"; Date)
        {
        }
        field(16; "No. Series"; Code[20])
        {
        }
        field(17; "Posted By"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Outsource No.")
        {
            Clustered = true;
        }
        key(Key2; Premises, "Outsource No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Outsource No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Outsource No.");
            NoSeriesMngt.InitSeries(HRSetup."Outsource No.", xRec."No. Series", 0D, "Outsource No.", "No. Series");
        END;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        OutsourceRec: Record "33020404";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        OutsourceRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Outsource No.", OutsourceRec."Outsource No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Outsource No.", xRec."No. Series", OutsourceRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Outsource No.");
            NoSeriesMngt.SetSeries(OutsourceRec."Outsource No.");
            Rec := OutsourceRec;
            EXIT(TRUE);
        END;
    end;
}

