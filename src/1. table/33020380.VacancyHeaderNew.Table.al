table 33020380 "Vacancy Header New"
{

    fields
    {
        field(1; "Vacancy No"; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Vacancy No" <> xRec."Vacancy No" THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Vacancy Nos. New");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Posted Date"; Date)
        {
        }
        field(3; "Fiscal Year"; Text[30])
        {
        }
        field(4; "No. Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(5; "Posted By"; Text[30])
        {
        }
        field(6; "Vacancy Type"; Option)
        {
            OptionMembers = Internal,External;
        }
    }

    keys
    {
        key(Key1; "Vacancy No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Vacancy No" = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Vacancy Nos. New");
            NoSeriesMngt.InitSeries(HRSetup."Vacancy Nos. New", xRec."No. Series", 0D, "Vacancy No", "No. Series");
        END;

        "Posted By" := USERID;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        VacancyHeaderNew: Record "33020380";
        UserSetup: Record "91";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        VacancyHeaderNew := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Vacancy Nos. New");
        IF NoSeriesMngt.SelectSeries(HRSetup."Vacancy Nos. New", xRec."No. Series", VacancyHeaderNew."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Vacancy Nos. New");
            NoSeriesMngt.SetSeries(VacancyHeaderNew."Vacancy No");
            Rec := VacancyHeaderNew;
            EXIT(TRUE);
        END;
    end;
}

