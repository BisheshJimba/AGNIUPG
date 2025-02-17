table 25006162 "Recall Campaign"
{
    Caption = 'Recall Campaign';
    LookupPageID = 25006246;

    fields
    {
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF ("Search Description" = COPYSTR(UPPERCASE(xRec.Description), 1, 30)) OR ("Search Description" = '') THEN
                    "Search Description" := COPYSTR(Description, 1, 30);
            end;
        }
        field(36; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(40; "Search Description"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(56; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(80; Comment; Boolean)
        {
            CalcFormula = Exist("Service Comment Line EDMS" WHERE(Type = CONST(Recall Campaign),
                                                                   No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(81;"External No.";Code[20])
        {
            Caption = 'External No.';
        }
        field(100;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" > 0D) THEN
                  ERROR(Text000,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));
            end;
        }
        field(110;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                IF ("Ending Date" < "Starting Date") AND ("Ending Date" > 0D) THEN
                  ERROR(Text001,FIELDCAPTION("Ending Date"),FIELDCAPTION("Starting Date"));
            end;
        }
        field(140;Active;Boolean)
        {
            Caption = 'Active';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Search Description")
        {
        }
        key(Key3;Active)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //VINs to be deleted
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN
         BEGIN
          ServSetup.GET;
          ServSetup.TESTFIELD("Recall Campaign Nos.");
          NoSeriesMgt.InitSeries(ServSetup."Recall Campaign Nos.",ServSetup."Recall Campaign Nos.",0D,"No.",
              ServSetup."Recall Campaign Nos.");
         END;
    end;

    var
        ServSetup: Record "25006120";
        NoSeriesMgt: Codeunit "396";
        Recall: Record "25006162";
        Text000: Label '%1 must be before %2.';
        Text001: Label '%1 must be after %2.';

    [Scope('Internal')]
    procedure AssistEdit(OldRecall: Record "25006162"): Boolean
    begin
        WITH Recall DO BEGIN
          Recall := Rec;
          ServSetup.GET;
          ServSetup.TESTFIELD("Recall Campaign Nos.");
          IF NoSeriesMgt.SelectSeries(ServSetup."Recall Campaign Nos.",OldRecall."No. Series","No. Series") THEN BEGIN
            ServSetup.GET;
            ServSetup.TESTFIELD("Recall Campaign Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Recall;
            EXIT(TRUE);
          END;
        END;
    end;
}

