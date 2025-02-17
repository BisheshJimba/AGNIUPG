table 33020163 "CC Memo Header"
{
    Caption = 'CC Memo Header';

    fields
    {
        field(1; "Vehicle Division"; Option)
        {
            OptionCaption = ' ,CVD,PCD';
            OptionMembers = " ",CVD,PCD;
        }
        field(2; "Reference No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Reference No." <> xRec."Reference No." THEN BEGIN
                    GblVehModSetup.GET;
                    GblNoSeriesMngt.TestManual(GetNoSeries);
                    "No. Series" := '';
                END;
            end;
        }
        field(3; "From Dept. Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                CALCFIELDS("From Dept. Name");
            end;
        }
        field(4; "From Dept. Name"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE(Code = FIELD(From Dept. Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "To Dept. Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                CALCFIELDS("To Dept. Name");
            end;
        }
        field(6; "To Dept. Name"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE(Code = FIELD(To Dept. Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Memo Date"; Date)
        {

            trigger OnValidate()
            begin
                "Memo Date (BS)" := GblSTPLSysMngt.getNepaliDate("Memo Date");
            end;
        }
        field(8; "Memo Date (BS)"; Code[10])
        {

            trigger OnValidate()
            begin
                "Memo Date" := GblSTPLSysMngt.getEngDate("Memo Date (BS)");
            end;
        }
        field(9; "User ID"; Code[50])
        {
        }
        field(10; "Responsibility Center"; Code[20])
        {
        }
        field(11; Posted; Boolean)
        {
        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "Reference No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Reference No." = '' THEN BEGIN
            GblVehModSetup.GET;
            TestNoSeries;
            GblNoSeriesMngt.InitSeries(GetNoSeries, xRec."No. Series", 0D, "Reference No.", "No. Series");
        END;

        GblUserSetup.GET(USERID);
        "Responsibility Center" := GblUserSetup."Default Responsibility Center";
        "Accountability Center" := GblUserSetup."Default Accountability Center";
        "User ID" := USERID;
    end;

    var
        GblSTPLSysMngt: Codeunit "50000";
        GblVehModSetup: Record "33020011";
        GblNoSeriesMngt: Codeunit "396";
        GblUserSetup: Record "91";

    [Scope('Internal')]
    procedure AssistEdit(xCCHdr: Record "33020163"): Boolean
    begin
        GblVehModSetup.GET;
        TestNoSeries;
        IF GblNoSeriesMngt.SelectSeries(GetNoSeries, xRec."No. Series", "No. Series") THEN BEGIN
            GblVehModSetup.GET;
            TestNoSeries;
            GblNoSeriesMngt.SetSeries("Reference No.");
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        //CASE "Vehicle Division" OF
        //"Vehicle Division"::" ":
        GblVehModSetup.TESTFIELD("CC Nos.");
        //"Vehicle Division"::CVD:
        //GblVehModSetup.TESTFIELD("CC PCD Nos.");
        //END;
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        //CASE "Vehicle Division" OF
        //"Vehicle Division"::" ":
        EXIT(GblVehModSetup."CC Nos.");
        //"Vehicle Division"::CVD:
        //EXIT(GblVehModSetup."CC PCD Nos.");
        //END;
    end;
}

