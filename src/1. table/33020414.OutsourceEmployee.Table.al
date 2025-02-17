table 33020414 "Outsource Employee"
{

    fields
    {
        field(1; "Outsource Employee No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Outsource Employee No." <> xRec."Outsource Employee No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Outsource Employee No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Full Name"; Text[100])
        {
        }
        field(3; Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "Department Name" := DimensionRec.Description;
                END;
                IF DimensionRec.COUNT = 0 THEN
                    "Department Name" := '';
            end;
        }
        field(4; Branch; Text[50])
        {
            TableRelation = "Dimension Value".Code WHERE(Dimension Code=CONST(BRANCH));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, Branch);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "Branch Name" := DimensionRec.Description;
                END;
                IF DimensionRec.COUNT = 0 THEN
                    "Branch Name" := '';
            end;
        }
        field(5; Service; Text[30])
        {
            TableRelation = "Outsource Service-Company".Description WHERE(Type = CONST(Service));
        }
        field(6; Company; Text[30])
        {
            TableRelation = "Outsource Service-Company".Description WHERE(Type = CONST(Company));
        }
        field(7; "Joined Date"; Date)
        {
        }
        field(8; "Left Date"; Date)
        {
        }
        field(9; "No. Series"; Code[20])
        {
        }
        field(10; "Department Name"; Text[50])
        {
        }
        field(11; "Branch Name"; Text[50])
        {
        }
        field(12; Address; Text[80])
        {
        }
        field(13; "Phone No."; Text[30])
        {
        }
        field(14; Qualification; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Outsource Employee No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Outsource Employee No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Outsource Employee No.");
            NoSeriesMngt.InitSeries(HRSetup."Outsource Employee No.", xRec."No. Series", 0D, "Outsource Employee No.", "No. Series");
        END;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        OutsourceEmpRec: Record "33020414";
        DimensionRec: Record "33020337";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        OutsourceEmpRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Outsource Employee No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Outsource Employee No.", xRec."No. Series", OutsourceEmpRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Outsource Employee No.");
            NoSeriesMngt.SetSeries(OutsourceEmpRec."Outsource Employee No.");
            Rec := OutsourceEmpRec;
            EXIT(TRUE);
        END;
    end;
}

