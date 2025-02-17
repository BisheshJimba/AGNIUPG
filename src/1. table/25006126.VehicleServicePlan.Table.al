table 25006126 "Vehicle Service Plan"
{
    Caption = 'Vehicle Service Plan';
    LookupPageID = 25006180;

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "No."; Code[10])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    ServiceSetup.GET;
                    NoSeriesMgt.TestManual(ServiceSetup."Service Plan Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(50; "Service Plan Type"; Code[10])
        {
            Caption = 'Service Plan Type';
            TableRelation = "Service Plan Type";
        }
        field(70; Active; Boolean)
        {
            CalcFormula = Exist("Vehicle Service Plan Stage" WHERE(Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                    Plan No.=FIELD(No.),
                                                                    Status=CONST(Pending)));
            Caption = 'Active';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Template Code";Code[10])
        {
            Caption = 'Template Code';
            Editable = false;
            TableRelation = "Service Plan Template";
        }
        field(140;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(150;"Start Date";Date)
        {
            Caption = 'Start Date';
            Description = 'date of plan to begin';
        }
        field(160;"Creation Date";Date)
        {
            Caption = 'Creation Date';
            Description = 'date of record has been created';
        }
        field(161;"Start Variable Field Run 1";Decimal)
        {
            CaptionClass = '7,25006126,161';
        }
        field(170;"Start Variable Field Run 2";Decimal)
        {
            CaptionClass = '7,25006126,170';
        }
        field(180;"Start Variable Field Run 3";Decimal)
        {
            CaptionClass = '7,25006126,180';
        }
        field(190;Adjust;Boolean)
        {
            Caption = 'Adjust';
        }
        field(200;Recurring;Boolean)
        {
            Caption = 'Recurring';
            Description = 'Auto Assign Tewplate';
        }
        field(210;"Auto Order By Exp. Date";Boolean)
        {
            Caption = 'Auto Order By Exp. Date';
        }
    }

    keys
    {
        key(Key1;"Vehicle Serial No.","No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        VehServPlanStage: Record "25006132";
        ServPlanComment: Record "25006173";
    begin
        VehServPlanStage.RESET;
        VehServPlanStage.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        VehServPlanStage.SETRANGE("Plan No.", "No.");
        VehServPlanStage.DELETEALL(TRUE);

        ServPlanComment.RESET;
        ServPlanComment.SETRANGE(Type, ServPlanComment.Type::Plan);
        ServPlanComment.SETRANGE("Plan No.", "No.");
        ServPlanComment.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        ServPlanComment.DELETEALL;
    end;

    trigger OnInsert()
    var
        Vehicle: Record "25006005";
    begin
        IF NOT Vehicle.GET("Vehicle Serial No.") THEN
          ERROR(STRSUBSTNO(Text001, "Vehicle Serial No."));

        IF "No." = '' THEN BEGIN
          ServiceSetup.GET;
          ServiceSetup.TESTFIELD("Service Plan Nos.");
          NoSeriesMgt.InitSeries(ServiceSetup."Service Plan Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
        VALIDATE("Creation Date", WORKDATE);
        IF "Start Date" = 0D THEN
          VALIDATE("Start Date", WORKDATE);
    end;

    var
        ServiceSetup: Record "25006120";
        NoSeriesMgt: Codeunit "396";
        ServicePlan: Record "25006126";
        Text001: Label 'Vehicle with serial No. %1 does not exist.';

    [Scope('Internal')]
    procedure AssistEdit(OldPlan: Record "25006126"): Boolean
    begin
        WITH ServicePlan DO BEGIN
          ServicePlan := Rec;
          ServiceSetup.GET;
          ServiceSetup.TESTFIELD("Service Plan Nos.");
          IF NoSeriesMgt.SelectSeries(ServiceSetup."Service Plan Nos.",OldPlan."No. Series","No. Series") THEN BEGIN
            ServiceSetup.GET;
            ServiceSetup.TESTFIELD("Service Plan Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := ServicePlan;
            EXIT(TRUE);
          END;
        END;
    end;
}

