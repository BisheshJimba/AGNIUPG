table 33020359 "Training Requests Header"
{

    fields
    {
        field(10; "Tr. Req. No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Tr. Req. No." <> xRec."Tr. Req. No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Training Request No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(20; Department; Code[10])
        {
            FieldClass = Normal;
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));
        }
        field(25; "Department Name"; Text[80])
        {
            CalcFormula = Lookup("Location Master".Description WHERE(Code = FIELD(Department)));
            FieldClass = FlowField;
        }
        field(30; "Training Code"; Code[20])
        {
            TableRelation = "Training List"."Training Code";
        }
        field(40; "Training Topic"; Text[30])
        {
            TableRelation = "Training List"."Training Topic";
        }
        field(45; "Training Objective"; Text[30])
        {
        }
        field(46; "Duration (days)"; Integer)
        {
        }
        field(47; ODT; Boolean)
        {
        }
        field(48; "From Date"; Date)
        {
        }
        field(49; "To Date"; Date)
        {

            trigger OnValidate()
            begin
                "Duration (days)" := ("To Date" - "From Date") + 1;
            end;
        }
        field(50; "Requested By"; Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                //sm to get emp name
                Employee.RESET;
                Employee.SETRANGE("User ID", "Requested By");
                IF Employee.FIND('-') THEN BEGIN
                    "Requested Name" := Employee."Full Name";
                END;
            end;
        }
        field(51; "Requested Name"; Text[50])
        {
        }
        field(52; Institute; Text[50])
        {
        }
        field(53; Venue; Text[50])
        {
        }
        field(60; "Requested Date"; Date)
        {
        }
        field(70; Approved; Boolean)
        {
        }
        field(75; "Approved By"; Code[50])
        {
        }
        field(80; "Approved Date"; Date)
        {
        }
        field(90; Rejected; Boolean)
        {
        }
        field(95; "Rejected By"; Code[50])
        {
        }
        field(100; "Rejected Date"; Date)
        {
        }
        field(110; Completed; Boolean)
        {

            trigger OnValidate()
            begin
                TrainingRequestsLineRec.RESET;
                TrainingRequestsLineRec.SETRANGE("Tr. Req. No.", "Tr. Req. No.");
                IF TrainingRequestsLineRec.FINDFIRST THEN BEGIN

                END;
            end;
        }
        field(120; "Completed Date"; Date)
        {
        }
        field(125; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(126; Cost; Decimal)
        {
        }
        field(127; "Very Good (%)"; Decimal)
        {
        }
        field(128; "Good (%)"; Decimal)
        {
        }
        field(129; "Not Good (%)"; Decimal)
        {
        }
        field(130; "Very Useful (%)"; Decimal)
        {
        }
        field(131; "Useful (%)"; Decimal)
        {
        }
        field(132; "Not Useful (%)"; Decimal)
        {
        }
        field(150; "Sent for Approval"; Boolean)
        {
        }
        field(151; Canceled; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Tr. Req. No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Approved THEN
            ERROR('Cannot delete the approved document');
        IF Rejected THEN
            ERROR('Cannot delete the rejected document');
    end;

    trigger OnInsert()
    var
        EMp: Record "5200";
    begin
        EMp.RESET;
        EMp.SETRANGE("User ID", USERID);
        EMp.FINDFIRST;
        IF EMp."Manager ID" = '' THEN
            ERROR('Only managers can send the trainning request.');

        IF "Tr. Req. No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Training Request No.");
            NoSeriesMngt.InitSeries(HRSetup."Training Request No.", xRec."No. Series", 0D, "Tr. Req. No.", "No. Series");
        END;

        "Requested Date" := TODAY;
        VALIDATE("Requested By", USERID);
    end;

    var
        NoSeriesMngt: Codeunit "396";
        HRSetup: Record "5218";
        TrainingRequest: Record "33020359";
        Employee: Record "5200";
        TrainingRequestsLineRec: Record "33020360";
        months: Decimal;

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        TrainingRequest := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Training Request No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Training Request No.", xRec."No. Series", TrainingRequest."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Training Request No.");
            NoSeriesMngt.SetSeries(TrainingRequest."Tr. Req. No.");
            Rec := TrainingRequest;
            EXIT(TRUE);
        END;
    end;
}

