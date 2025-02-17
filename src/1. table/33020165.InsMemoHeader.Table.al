table 33020165 "Ins. Memo Header"
{
    Caption = 'Insurance Memo Header';
    DrillDownPageID = 33020183;
    LookupPageID = 33020183;

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
        field(3; "Memo Date"; Date)
        {

            trigger OnValidate()
            begin
                "Memo Date (BS)" := GblSTPLSysMngt.getNepaliDate("Memo Date");
            end;
        }
        field(4; "Memo Date (BS)"; Code[10])
        {

            trigger OnValidate()
            begin
                "Memo Date" := GblSTPLSysMngt.getEngDate("Memo Date (BS)");
            end;
        }
        field(5; "Ins. Company Code"; Code[20])
        {
            TableRelation = Vendor.No.;

            trigger OnValidate()
            begin
                CALCFIELDS("Ins. Company Name");
            end;
        }
        field(6; "Ins. Company Name"; Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE(No.=FIELD(Ins. Company Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"User ID";Code[50])
        {
        }
        field(8;"Responsibility Center";Code[20])
        {
        }
        field(9;Posted;Boolean)
        {
        }
        field(10;"No. Series";Code[20])
        {
        }
        field(11;Type;Option)
        {
            OptionCaption = 'Individual,Stock';
            OptionMembers = Individual,Stock;
        }
        field(12;Remarks;Text[50])
        {
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(33019962;"Sales Sys LC No.";Code[20])
        {
            TableRelation = "LC Details" WHERE (Transaction Type=FILTER(Sale));

            trigger OnValidate()
            begin
                CALCFIELDS("Sales Bank LC No.");
            end;
        }
        field(33019963;"Sales Bank LC No.";Code[50])
        {
            CalcFormula = Lookup("LC Details"."LC\DO No." WHERE (No.=FIELD(Sales Sys LC No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019964;"Version No.";Code[10])
        {
            CalcFormula = Max("LC Amend. Details"."Version No." WHERE (No.=FIELD(Sales Sys LC No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019965;"Valid Period";DateFormula)
        {
        }
    }

    keys
    {
        key(Key1;"Reference No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DrillDown;"Reference No.","Vehicle Division","Memo Date")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Reference No." = '' THEN BEGIN
          GblVehModSetup.GET;
          TestNoSeries;
          GblNoSeriesMngt.InitSeries(GetNoSeries,xRec."No. Series",0D,"Reference No.","No. Series");
        END;

        GblUserSetup.GET(USERID);
        "Responsibility Center" := GblUserSetup."Default Responsibility Center";
        "Accountability Center" := GblUserSetup."Default Accountability Center";
        "User ID" := USERID;
    end;

    var
        GblSTPLSysMngt: Codeunit "50000";
        GblNoSeriesMngt: Codeunit "396";
        GblVehModSetup: Record "33020011";
        GblUserSetup: Record "91";

    [Scope('Internal')]
    procedure AssistEdit(xInsHdr: Record "33020165"): Boolean
    begin
        GblVehModSetup.GET;
        TestNoSeries;
        IF GblNoSeriesMngt.SelectSeries(GetNoSeries,xRec."No. Series","No. Series") THEN BEGIN
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
          //"Vehicle Division"::CVD:
            GblVehModSetup.TESTFIELD("Ins. Nos.");
          //"Vehicle Division"::PCD:
            //GblVehModSetup.TESTFIELD("Ins. PCD Nos.");
        //END;
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        //CASE "Vehicle Division" OF
          //"Vehicle Division"::CVD:
            EXIT(GblVehModSetup."Ins. Nos.");
          //"Vehicle Division"::PCD:
            //EXIT(GblVehModSetup."Ins. PCD Nos.");
        //END;
    end;
}

