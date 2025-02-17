table 33020510 "Salary Header"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    DrillDownPageID = 50003;
    LookupPageID = 50003;

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "From Date"; Date)
        {

            trigger OnValidate()
            begin
                IF LineExists THEN
                    ERROR(Text002);
                IF ("To Date" <> 0D) AND ("From Date" <> 0D) THEN
                    IF "From Date" >= "To Date" THEN
                        ERROR(Text000, FIELDCAPTION("From Date"), FIELDCAPTION("To Date"), 'greater');
                IF "From Date" <> 0D THEN
                    Month := DATE2DMY("From Date", 2);
                //MESSAGE(FORMAT(DATE2DMY("From Date",2)));
                "Assigned User ID" := USERID;
            end;
        }
        field(3; "To Date"; Date)
        {

            trigger OnValidate()
            begin
                IF LineExists THEN
                    ERROR(Text002);
                IF ("To Date" <> 0D) AND ("From Date" <> 0D) THEN
                    IF "From Date" >= "To Date" THEN
                        ERROR(Text000, FIELDCAPTION("To Date"), FIELDCAPTION("From Date"), 'lesser');
                "Assigned User ID" := USERID;
            end;
        }
        field(4; Month; Option)
        {
            Editable = true;
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(5; Remarks; Text[50])
        {
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(10; "Accountability Center"; Code[10])
        {
            Description = 'Accountability Center 02August2013';
            TableRelation = "Accountability Center";
        }
        field(11; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(12; "Document Date"; Date)
        {
        }
        field(13; "Posting Date"; Date)
        {
        }
        field(14; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(20; "Salary in Hand"; Decimal)
        {
            CalcFormula = Sum("Salary Line"."Net Pay" WHERE(Document No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Posting No.";Code[20])
        {
        }
        field(22;"Posting No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(23;"Posting Description";Text[50])
        {
        }
        field(24;"Assigned User ID";Code[50])
        {
            TableRelation = "User Setup";
        }
        field(25;"Journal Template Name";Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(26;"Journal Batch Name";Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
        }
        field(27;"Irregular Process";Boolean)
        {

            trigger OnValidate()
            begin
                IF LineExists THEN
                  ERROR(Text002);
            end;
        }
        field(28;"From Date (B.S)";Code[10])
        {
        }
        field(29;"To Date (B.S)";Code[10])
        {
        }
        field(30;"Nepali Month";Option)
        {
            OptionCaption = ' ,Baisakh,Jestha,Asar,Shrawan,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra';
            OptionMembers = " ",Baisakh,Jestha,Asar,Shrawan,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PRSetup.GET;
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMngt.InitSeries(GetNoSeries,xRec."No. Series",0D,"No.","No. Series");
        END;
        InitRecord;
    end;

    var
        NoSeriesMngt: Codeunit "396";
        PRSetup: Record "33020507";
        Text000: Label '"%1" cannot be %3 than "%2".';
        Text001: Label 'Salary Plan';
        UserMgt: Codeunit "5700";
        Text002: Label 'Please delete the existing lines before changing the value in Salary Header.';
        StplMgt: Codeunit "50000";
        TempMonth: Code[15];
        NepEngCalender: Record "33020302";

    [Scope('Internal')]
    procedure AssistEdit(xEmpSalaryHeader: Record "33020510"): Boolean
    begin
        PRSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries,xEmpSalaryHeader."No. Series","No. Series") THEN BEGIN
          PRSetup.GET;
          TestNoSeries;
          NoSeriesMngt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        PRSetup.TESTFIELD("Salary Plan No. Series");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        EXIT(PRSetup."Salary Plan No. Series");
    end;

    [Scope('Internal')]
    procedure InitRecord()
    begin
        NoSeriesMngt.SetDefaultSeries("Posting No. Series",PRSetup."Salary Plan Posting No. Series");
        "Posting Description" := FORMAT(Text001) + ' ' + "No.";
        "Document Date" := TODAY;
        "Posting Date" := TODAY;
        "Accountability Center" := UserMgt.GetRespCenter(0,"Accountability Center");
        "Assigned User ID" := USERID;
    end;

    [Scope('Internal')]
    procedure LineExists(): Boolean
    var
        SalaryLine: Record "33020511";
    begin
        SalaryLine.RESET;
        SalaryLine.SETRANGE("Document No.","No.");
        IF SalaryLine.FINDFIRST THEN
          EXIT(TRUE)
        ELSE
          EXIT(FALSE);
    end;
}

