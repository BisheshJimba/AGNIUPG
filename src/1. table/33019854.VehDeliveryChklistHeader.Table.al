table 33019854 "Veh. Delivery Chklist Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    ProcessChecklistSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                END;
            end;
        }
        field(2; "Vendor No."; Code[20])
        {
            TableRelation = Vendor.No.;
        }
        field(3; Name; Text[50])
        {
            Editable = false;
        }
        field(4; "Name 2"; Text[50])
        {
            Editable = false;
        }
        field(5; Model; Code[20])
        {
            Editable = false;
        }
        field(6; VIN; Code[20])
        {
            Editable = false;
            TableRelation = Vehicle;
        }
        field(7; Kilometrage; Decimal)
        {
        }
        field(8; "Engine No."; Code[20])
        {
            Editable = false;
        }
        field(9; "Delivery Date"; Date)
        {
        }
        field(10; "No. Series"; Code[20])
        {
            Editable = false;
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
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    var
        NoSeriesMgt: Codeunit "396";
        ProcessChecklistSetup: Record "25006009";
        ChkListHdr: Record "33019854";
        Text051: Label 'Process checkilst %1 already exists.';
        Text010: Label 'You cannot change %1 while lines exist.';

    [Scope('Internal')]
    procedure AssistEdit(OldChklistHdr: Record "33019854"): Boolean
    var
        VehChklistHdr2: Record "33019854";
    begin
        ChkListHdr.COPY(Rec);
        ProcessChecklistSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(ProcessChecklistSetup."Veh. Delivery Chklist Nos.",
           OldChklistHdr."No. Series", ChkListHdr."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(ChkListHdr."No.");
            IF VehChklistHdr2.GET(ChkListHdr."No.") THEN
                ERROR(Text051, ChkListHdr."No.");
            Rec := ChkListHdr;
            EXIT(TRUE);
        END;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        ProcessChecklistSetup.GET;
        ProcessChecklistSetup.TESTFIELD("Veh. Delivery Chklist Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        EXIT(ProcessChecklistSetup."Veh. Delivery Chklist Nos.");
    end;
}

