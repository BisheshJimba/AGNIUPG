table 33020035 "Gate Entry Header"
{
    Caption = 'Gate Entry Header';

    fields
    {
        field(1; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Inward,Outward';
            OptionMembers = Inward,Outward;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                "Posting Date" := "Document Date";
            end;
        }
        field(5; "Document Time"; Time)
        {
            Caption = 'Document Time';

            trigger OnValidate()
            begin
                "Posting Time" := "Document Time";
            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            begin
                CASE "Entry Type" OF
                    "Entry Type"::Inward:
                        IF GateEntryLocSetup.GET("Entry Type", "Location Code") THEN
                            IF ("No. Series" <> '') AND (InventSetup."Inward Gate Entry Nos." = GateEntryLocSetup."Posting No. Series") THEN
                                "Posting No. Series" := "No. Series"
                            ELSE
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", GateEntryLocSetup."Posting No. Series");
                    "Entry Type"::Outward:
                        IF GateEntryLocSetup.GET("Entry Type", "Location Code") THEN
                            IF ("No. Series" <> '') AND (InventSetup."Inward Gate Entry Nos." = GateEntryLocSetup."Posting No. Series") THEN
                                "Posting No. Series" := "No. Series"
                            ELSE
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", GateEntryLocSetup."Posting No. Series");
                END;
            end;
        }
        field(8; Description; Text[120])
        {
            Caption = 'Description';
        }
        field(9; "Item Description"; Text[120])
        {
            Caption = 'Item Description';
        }
        field(10; "LR/RR No."; Code[20])
        {
            Caption = 'LR/RR No.';
        }
        field(11; "LR/RR Date"; Date)
        {
            Caption = 'LR/RR Date';
        }
        field(12; "Vehicle No."; Code[20])
        {
            Caption = 'Vehicle No.';
        }
        field(13; "Station From/To"; Code[20])
        {
            Caption = 'Station From/To';
        }
        field(15; Comment; Boolean)
        {
            CalcFormula = Exist("Gate Entry Comment Line" WHERE(Gate Entry Type=FIELD(Entry Type),
                                                                 No.=FIELD(No.)));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(16;"Posting No. Series";Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(17;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(18;"Posting Time";Time)
        {
            Caption = 'Posting Time';
        }
        field(19;"Posting No.";Code[20])
        {
            Caption = 'Posting No.';
        }
        field(20;"User ID";Code[50])
        {
            Caption = 'User ID';
            TableRelation = Table2000000002;
        }
    }

    keys
    {
        key(Key1;"Entry Type","No.")
        {
            Clustered = true;
        }
        key(Key2;"Location Code","Posting Date","No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        GateEntryLine.RESET;
        GateEntryLine.SETRANGE("Entry Type","Entry Type");
        GateEntryLine.SETRANGE("Gate Entry No.","No.");
        GateEntryLine.DELETEALL;

        GateEntryCommentLine.SETRANGE("Gate Entry Type","Entry Type");
        GateEntryCommentLine.SETRANGE("No.","No.");
        GateEntryCommentLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        "Document Date" := WORKDATE;
        "Document Time" := TIME;
        "Posting Date" := WORKDATE;
        "Posting Time" := TIME;
        "User ID" := USERID;
        InventSetup.GET;

        CASE "Entry Type" OF
          "Entry Type"::Inward:
            IF "No." = '' THEN BEGIN
              InventSetup.TESTFIELD(InventSetup."Inward Gate Entry Nos.");
              NoSeriesMgt.InitSeries(InventSetup."Inward Gate Entry Nos.",xRec."No. Series","Posting Date","No.","No. Series");
            END;
          "Entry Type"::Outward:
            IF "No." = '' THEN BEGIN
              InventSetup.TESTFIELD(InventSetup."Outward Gate Entry Nos.");
              NoSeriesMgt.InitSeries(InventSetup."Outward Gate Entry Nos.",xRec."No. Series","Posting Date","No.","No. Series");
            END;
        END;
    end;

    var
        GateEntryLine: Record "33020036";
        InventSetup: Record "313";
        GateEntryLocSetup: Record "33020037";
        GateEntryCommentLine: Record "33020042";
        NoSeriesMgt: Codeunit "396";

    [Scope('Internal')]
    procedure AssistEdit(OldGateEntryHeader: Record "33020035"): Boolean
    begin
        InventSetup.GET;
        CASE "Entry Type" OF
          "Entry Type"::Inward:
            BEGIN
              InventSetup.TESTFIELD("Inward Gate Entry Nos.");
              IF NoSeriesMgt.SelectSeries(InventSetup."Inward Gate Entry Nos.",OldGateEntryHeader."No. Series","No. Series") THEN BEGIN
                InventSetup.GET;
                InventSetup.TESTFIELD("Inward Gate Entry Nos.");
                NoSeriesMgt.SetSeries("No.");
                EXIT(TRUE);
              END;
            END;
          "Entry Type"::Outward:
            BEGIN
              InventSetup.TESTFIELD("Outward Gate Entry Nos.");
              IF NoSeriesMgt.SelectSeries(InventSetup."Outward Gate Entry Nos.",OldGateEntryHeader."No. Series","No. Series") THEN BEGIN
                InventSetup.GET;
                InventSetup.TESTFIELD("Outward Gate Entry Nos.");
                NoSeriesMgt.SetSeries("No.");
                EXIT(TRUE);
              END;
            END;
        END;
    end;
}

