table 25006153 "External Serv. Tracking No."
{
    // 15.07.2008. EDMS P2
    //   * Added fields "Purchase Amount", "Sale Amount"

    Caption = 'External Serv. Tracking No.';
    LookupPageID = 25006228;

    fields
    {
        field(1; "External Service No."; Code[20])
        {
            Caption = 'External Service No.';
            NotBlank = true;
            TableRelation = "External Service";
        }
        field(2; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';

            trigger OnValidate()
            begin
                IF "External Serv. Tracking No." <> xRec."External Serv. Tracking No." THEN BEGIN
                    ExtService.GET("External Service No.");
                    NoSeriesMgt.TestManual(ExtService."Tracking Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(10; "Purchase Amount"; Decimal)
        {
            CalcFormula = Sum("External Serv. Ledger Entry".Amount WHERE(External Serv. No.=FIELD(External Service No.),
                                                                          External Serv. Tracking No.=FIELD(External Serv. Tracking No.),
                                                                          Entry Type=CONST(Purchase)));
            Caption = 'Purchase Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Sales Amount";Decimal)
        {
            CalcFormula = Sum("External Serv. Ledger Entry".Amount WHERE (External Serv. No.=FIELD(External Service No.),
                                                                          External Serv. Tracking No.=FIELD(External Serv. Tracking No.),
                                                                          Entry Type=CONST(Sale)));
            Caption = 'Sales Amount';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"External Service No.","External Serv. Tracking No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        ExtService.GET("External Service No.");
        Description := ExtService.Description;

        IF "External Serv. Tracking No." = '' THEN BEGIN
          ExtService.TESTFIELD("Tracking Nos.");
          NoSeriesMgt.InitSeries(ExtService."Tracking Nos.",xRec."No. Series",0D,"External Serv. Tracking No.","No. Series");
        END;
    end;

    var
        ExtService: Record "25006133";
        NoSeriesMgt: Codeunit "396";
}

