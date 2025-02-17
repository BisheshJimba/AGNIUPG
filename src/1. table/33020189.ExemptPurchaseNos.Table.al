table 33020189 "Exempt Purchase Nos."
{

    fields
    {
        field(1; "Exempt No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Exempt No." <> xRec."Exempt No." THEN BEGIN
                    PurchSetup.GET;
                    NoSeriesMgmt.TestManual(PurchSetup."Purch. VAT No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Exempt No.")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Exempt No." = '' THEN BEGIN
            PurchSetup.GET;
            PurchSetup.TESTFIELD("Purch. VAT No.");
            NoSeriesMgmt.InitSeries(PurchSetup."Purch. VAT No.", xRec."No. Series", 0D, "Exempt No.", "No. Series");
        END;
    end;

    var
        PurchSetup: Record "312";
        NoSeriesMgmt: Codeunit "396";

    [Scope('Internal')]
    procedure AssistEdit(OldExempt: Record "33020189"): Boolean
    var
        Exempt: Record "33020189";
    begin
        PurchSetup.GET;
        IF NoSeriesMgmt.SelectSeries(PurchSetup."Purch. VAT No.", OldExempt."No. Series", "No. Series") THEN BEGIN
            NoSeriesMgmt.SetSeries("Exempt No.");
            EXIT(TRUE);
        END;
    end;
}

