table 33019897 "Battery From Store"
{

    fields
    {
        field(1; "No."; Code[10])
        {

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    SerMgtSetup.GET;
                    NoSeriesMgmt.TestManual(SerMgtSetup.Number);
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Remarks; Text[250])
        {
        }
        field(3; "No. Series"; Code[10])
        {
        }
        field(4; "Responsibility Center"; Code[20])
        {
        }
        field(5; "Location Code"; Code[20])
        {
        }
        field(6; "Dimension 1"; Code[20])
        {
        }
        field(7; "Dimension 2"; Code[20])
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            SerMgtSetup.GET;
            SerMgtSetup.TESTFIELD(SerMgtSetup.Number);
            // NoSeriesMgmt.InitSeries(GetNoSeriesCode2,xRec."No. Series",0D,"Job Card No.","No. Series");
            NoSeriesMgmt.InitSeries(SerMgtSetup.Number, xRec."No. Series", 0D, "No.", "No. Series");

        END;

        UserSetup.GET(USERID);
        "Responsibility Center" := UserSetup."Default Responsibility Center";
        "Accountability Center" := UserSetup."Default Accountability Center";
        "Location Code" := UserSetup."Default Location";
        "Dimension 1" := UserSetup."Shortcut Dimension 1 Code";
        "Dimension 2" := UserSetup."Shortcut Dimension 2 Code";
    end;

    var
        SerMgtSetup: Record "5911";
        NoSeriesMgmt: Codeunit "396";
        UserSetup: Record "91";
}

