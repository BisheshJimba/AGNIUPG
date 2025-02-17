table 25006132 "Vehicle Service Plan Stage"
{
    // 22.03.2013 EDMS P8
    //   * Added option to Status field: Skipped
    // 
    // 2012.07.31 EDMS, P8
    //   * changed type of field 36 - now it is decimal
    //   * added fields: VF Initial Run 1,...

    Caption = 'Vehicle Service Plan Stage';
    LookupPageID = 25006181;

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Plan No."; Code[10])
        {
            Caption = 'Plan No.';
            TableRelation = "Vehicle Service Plan".No. WHERE(Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25; Recurrence; Integer)
        {
            Caption = 'Recurrence';
        }
        field(30; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(36; Kilometrage; Integer)
        {
            CaptionClass = '7,25006132,36';

            trigger OnValidate()
            begin
                DoChangeInitValue := FALSE;
                IF Kilometrage > 0 THEN
                    IF "VF Initial Run 1" = 0 THEN
                        "VF Initial Run 1" := Kilometrage
                    ELSE
                        IF CONFIRM(STRSUBSTNO(Text001, ApplicationManagement.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006132,270')), FALSE) THEN BEGIN
                            "VF Initial Run 1" := Kilometrage;
                            DoChangeInitValue := TRUE;
                        END;

                IF VehicleServicePlan.GET("Vehicle Serial No.", "Plan No.") THEN
                    IF VehicleServicePlan.Adjust THEN
                        IF CONFIRM(STRSUBSTNO(Text002, ApplicationManagement.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006132,36')), TRUE) THEN
                            ServJnlPostLine.AdjustServPlanStageRuns("Vehicle Serial No.", "Plan No.", Recurrence, Code, Kilometrage,
                              0, 0, FALSE, DoChangeInitValue);
            end;
        }
        field(50; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,Serviced,In Process,Skipped';
            OptionMembers = Pending,Serviced,"In Process",Skipped;

            trigger OnValidate()
            var
                VehicleServicePlanStage: Record "25006132" temporary;
            begin
            end;
        }
        field(90; "Expected Service Date"; Date)
        {
            Caption = 'Expected Service Date';
        }
        field(100; "Service Date"; Date)
        {
            Caption = 'Service Date';
        }
        field(200; "Maintain Stage"; Boolean)
        {
            Caption = 'Maintain Stage';

            trigger OnValidate()
            begin
                TESTFIELD(Group, FALSE);
                TESTFIELD(Status, Status::Pending);
            end;
        }
        field(210; Group; Boolean)
        {
            Caption = 'Group';
        }
        field(220; "Applies-to Code"; Code[10])
        {
            Caption = 'Applies-to Code';
        }
        field(230; "Service Interval"; DateFormula)
        {
            Caption = 'Service Interval';
            Description = 'how to estimate current record starting previous stage';
        }
        field(240; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            TableRelation = "Service Package";

            trigger OnValidate()
            var
                ServicePackage: Record "25006134";
            begin
            end;
        }
        field(250; "Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006132,250';

            trigger OnValidate()
            begin
                DoChangeInitValue := FALSE;
                IF "Variable Field Run 2" > 0 THEN
                    IF "VF Initial Run 2" = 0 THEN
                        "VF Initial Run 2" := "Variable Field Run 2"
                    ELSE
                        IF CONFIRM(STRSUBSTNO(Text001, ApplicationManagement.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006132,280')), FALSE) THEN BEGIN
                            "VF Initial Run 2" := "Variable Field Run 2";
                            DoChangeInitValue := TRUE;
                        END;

                IF VehicleServicePlan.GET("Vehicle Serial No.", "Plan No.") THEN
                    IF VehicleServicePlan.Adjust THEN
                        IF CONFIRM(STRSUBSTNO(Text002, ApplicationManagement.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006132,250')), TRUE) THEN
                            ServJnlPostLine.AdjustServPlanStageRuns("Vehicle Serial No.", "Plan No.", Recurrence, Code, 0, "Variable Field Run 2",
                              0, FALSE, DoChangeInitValue);
            end;
        }
        field(260; "Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006132,260';

            trigger OnValidate()
            begin
                DoChangeInitValue := FALSE;
                IF "Variable Field Run 3" > 0 THEN
                    IF "VF Initial Run 3" = 0 THEN
                        "VF Initial Run 3" := "Variable Field Run 3"
                    ELSE
                        IF CONFIRM(STRSUBSTNO(Text001, ApplicationManagement.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006132,290')), FALSE) THEN BEGIN
                            "VF Initial Run 3" := "Variable Field Run 3";
                            DoChangeInitValue := TRUE;
                        END;

                IF VehicleServicePlan.GET("Vehicle Serial No.", "Plan No.") THEN
                    IF VehicleServicePlan.Adjust THEN
                        IF CONFIRM(STRSUBSTNO(Text002, ApplicationManagement.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006132,260')), TRUE) THEN
                            ServJnlPostLine.AdjustServPlanStageRuns("Vehicle Serial No.", "Plan No.", Recurrence, Code, 0, 0,
                              "Variable Field Run 3", FALSE, DoChangeInitValue);
            end;
        }
        field(270; "VF Initial Run 1"; Decimal)
        {
            CaptionClass = '7,25006132,270';
            Description = 'Variable Field Initial Run 1';
            Editable = false;
        }
        field(280; "VF Initial Run 2"; Decimal)
        {
            CaptionClass = '7,25006132,280';
            Description = 'Variable Field Initial Run 2';
            Editable = false;
        }
        field(290; "VF Initial Run 3"; Decimal)
        {
            CaptionClass = '7,25006132,290';
            Description = 'Variable Field Initial Run 3';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Plan No.", Recurrence, "Code")
        {
            Clustered = true;
        }
        key(Key2; Status, "Expected Service Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ServPlanDocLink: Record "25006157";
        ServPlanComment: Record "25006173";
    begin
        ServPlanDocLink.RESET;
        ServPlanDocLink.SETRANGE("Serv. Plan No.", "Plan No.");
        ServPlanDocLink.SETRANGE("Plan Stage Recurrence", Recurrence);
        ServPlanDocLink.SETRANGE("Serv. Plan Stage Code", Code);
        ServPlanDocLink.DELETEALL;

        ServPlanComment.RESET;
        ServPlanComment.SETRANGE(Type, ServPlanComment.Type::"Plan Stage");
        ServPlanComment.SETRANGE("Plan No.", "Plan No.");
        ServPlanComment.SETRANGE("Plan Stage Recurrence", Recurrence);
        ServPlanComment.SETRANGE("Stage Code", Code);
        ServPlanComment.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        ServPlanComment.DELETEALL;
    end;

    var
        Text001: Label 'Would you like to change %1 as well?';
        ApplicationManagement: Codeunit "1";
        ServJnlPostLine: Codeunit "25006107";
        Text002: Label 'Would you like to recalculate %1 in other stages?';
        ServicePlanMgt: Codeunit "25006103";
        VehicleServicePlan: Record "25006126";
        DoChangeInitValue: Boolean;

    [Scope('Internal')]
    procedure ProceedMaintainStageCheck(var VehicleServicePlanStage: Record "25006132" temporary)
    var
        VehServPlanStageCurr: Record "25006132";
    begin
        IF "Maintain Stage" THEN BEGIN

            // THIS code is working for trigger onValidate control
            VehServPlanStageCurr := VehicleServicePlanStage;
            IF VehicleServicePlanStage.COUNT > 1 THEN BEGIN
                VehicleServicePlanStage.FINDFIRST;
                REPEAT
                    IF NOT ((VehicleServicePlanStage."Plan No." = VehServPlanStageCurr."Plan No.") AND
                      (VehicleServicePlanStage.Recurrence = VehServPlanStageCurr.Recurrence) AND
                      (VehicleServicePlanStage.Code = VehServPlanStageCurr.Code)) THEN BEGIN
                        VehicleServicePlanStage."Maintain Stage" := FALSE;
                        VehicleServicePlanStage.MODIFY;
                    END ELSE BEGIN
                        VehicleServicePlanStage."Maintain Stage" := TRUE;
                        VehicleServicePlanStage.MODIFY;
                    END;
                UNTIL VehicleServicePlanStage.NEXT = 0;
                VehicleServicePlanStage.GET(VehServPlanStageCurr."Vehicle Serial No.", VehServPlanStageCurr."Plan No.",
                  VehServPlanStageCurr.Recurrence, VehServPlanStageCurr.Code);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ValidateMaintainStageCheck()
    var
        VehServPlanStageCurr: Record "25006132";
    begin
        IF "Maintain Stage" THEN BEGIN
            // it supposed to be redone by use local table rec for changes
            VehServPlanStageCurr := Rec;
            SETRANGE("Maintain Stage", TRUE);
            IF COUNT > 1 THEN BEGIN
                FINDFIRST;
                REPEAT
                    IF NOT (("Plan No." = VehServPlanStageCurr."Plan No.") AND
                        (Recurrence = VehServPlanStageCurr.Recurrence) AND
                        (Code = VehServPlanStageCurr.Code)) THEN BEGIN
                        "Maintain Stage" := FALSE;
                        MODIFY;
                    END;
                UNTIL NEXT = 0;
                GET(VehServPlanStageCurr."Vehicle Serial No.", VehServPlanStageCurr."Plan No.",
                  VehServPlanStageCurr.Recurrence, VehServPlanStageCurr.Code);
            END;
            SETRANGE("Maintain Stage");
        END;
    end;
}

