table 33019831 "Spare Req. Header Archive"
{
    Caption = 'Spare Req. Header Archive';

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PurchNPaySetup.GET;
                    NoSeriesMngt.TestManual(PurchNPaySetup."Requisition No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Worksheet Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            Editable = false;
        }
        field(3; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            Editable = false;
        }
        field(5; "Time Archived"; Time)
        {
            Caption = 'Time Archived';
            Editable = false;
        }
        field(6; "Date Archived"; Date)
        {
            Caption = 'Date Archived';
            Editable = false;
        }
        field(7; "Archived By"; Code[50])
        {
            Caption = 'Archived By';
            Editable = false;
        }
        field(8; "Version No."; Integer)
        {
            Caption = 'Version No.';
            Editable = false;
        }
        field(9; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
            Editable = false;
        }
        field(11; "Responsibility Center"; Code[10])
        {
            Editable = false;
        }
        field(12; Location; Code[10])
        {
            Editable = false;
        }
        field(13; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(14; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Close';
            OptionMembers = Open,Close;
        }
    }

    keys
    {
        key(Key1; "Worksheet Template Name", "Journal Batch Name", "Doc. No. Occurrence", "Version No.", "No.")
        {
            Clustered = true;
        }
        key(Key2; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            PurchNPaySetup.GET;
            PurchNPaySetup.TESTFIELD("Spare Req. No.");
            NoSeriesMngt.InitSeries(PurchNPaySetup."Spare Req. No.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        UserSetup.GET(USERID);
        "Responsibility Center" := UserSetup."Default Responsibility Center";
        Location := UserSetup."Default Location";
    end;

    var
        NoSeriesMngt: Codeunit "396";
        PurchNPaySetup: Record "312";
        UserSetup: Record "91";
}

