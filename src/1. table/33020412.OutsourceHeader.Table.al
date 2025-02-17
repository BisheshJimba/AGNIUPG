table 33020412 "Outsource Header"
{

    fields
    {
        field(1; "Outsource No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Outsource No." <> xRec."Outsource No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."EmpLoyee Outsource Billing No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Date; Date)
        {
        }
        field(3; "Fiscal Year"; Code[10])
        {
        }
        field(4; Posted; Boolean)
        {
        }
        field(5; "Posted By"; Code[20])
        {
        }
        field(6; "Posted Date"; Date)
        {
        }
        field(7; "No. Series"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Outsource No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Outsource No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."EmpLoyee Outsource Billing No.");
            NoSeriesMngt.InitSeries(HRSetup."EmpLoyee Outsource Billing No.", xRec."No. Series", 0D, "Outsource No.", "No. Series");
        END;
    end;

    var
        OutsourceHeaderRec: Record "33020412";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        OutsourceHeaderRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."EmpLoyee Outsource Billing No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."EmpLoyee Outsource Billing No.", xRec."No. Series", OutsourceHeaderRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."EmpLoyee Outsource Billing No.");
            NoSeriesMngt.SetSeries(OutsourceHeaderRec."Outsource No.");
            Rec := OutsourceHeaderRec;
            EXIT(TRUE);
        END;
    end;
}

