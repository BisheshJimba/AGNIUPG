page 25006251 "Choose Service Plan Stages"
{
    Caption = 'Choose Service Plan Stages';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = Table25006132;
    SourceTableTemporary = true;
    SourceTableView = SORTING(Status);

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = VehicleSerialNoVisible;
                }
                field("Plan No."; "Plan No.")
                {
                }
                field(Code; Code)
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field(Kilometrage; Kilometrage)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = false;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = false;
                }
                field("VF Initial Run 1"; "VF Initial Run 1")
                {
                    Visible = false;
                }
                field("VF Initial Run 2"; "VF Initial Run 2")
                {
                    Visible = false;
                }
                field("VF Initial Run 3"; "VF Initial Run 3")
                {
                    Visible = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Service Date"; "Service Date")
                {
                    Editable = false;
                }
                field("Expected Service Date"; "Expected Service Date")
                {
                }
                field(MaintainStageFld; "Maintain Stage")
                {

                    trigger OnValidate()
                    begin
                        ProceedMaintainStageCheck(Rec);
                    end;
                }
                field("Package No."; "Package No.")
                {
                }
                field("Service Interval"; "Service Interval")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SetColumnVisability;
    end;

    var
        TempVehServPlanStage: Record "25006132";
        VehServPlanStage: Record "25006132";
        EmptyGroup: Label '''''';
        Text001: Label 'PENDING';
        Text002: Label 'SERVICED';
        [InDataSet]
        VehicleSerialNoVisible: Boolean;
        ComponentsView: Boolean;

    local procedure IsFirstLine(VehSerialNo: Code[20]; PlanNo: Code[20]; "Code": Code[20]): Boolean
    var
        SalesShptLine: Record "111";
    begin
        TempVehServPlanStage.RESET;
        TempVehServPlanStage.COPYFILTERS(Rec);
        TempVehServPlanStage.SETRANGE("Vehicle Serial No.", VehSerialNo);
        TempVehServPlanStage.SETRANGE("Plan No.", PlanNo);
        IF TempVehServPlanStage.ISEMPTY THEN BEGIN
            VehServPlanStage.COPYFILTERS(Rec);
            VehServPlanStage.SETRANGE("Vehicle Serial No.", VehSerialNo);
            VehServPlanStage.SETRANGE("Plan No.", PlanNo);
            VehServPlanStage.FINDFIRST;
            TempVehServPlanStage := VehServPlanStage;
            TempVehServPlanStage.INSERT;
        END;
        IF TempVehServPlanStage.Code = Code THEN
            EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure GroupingSymbol() Symbol: Integer
    begin
        IF Group THEN BEGIN
            IF IsGroupExpanded THEN
                Symbol := 0
            ELSE
                Symbol := 1
        END ELSE
            Symbol := 2;
    end;

    [Scope('Internal')]
    procedure IsGroupExpanded(): Boolean
    var
        "--ETREE1.00--": Integer;
        GroupFilter: Text[1024];
        FullFilter: Text[1024];
        SubStrPosition: Integer;
    begin
        FullFilter := GETFILTER("Applies-to Code");

        IF FullFilter = '' THEN
            EXIT(TRUE);

        IF FullFilter = EmptyGroup THEN
            EXIT(FALSE);

        GroupFilter := STRSUBSTNO('|%1', Code);
        IF STRPOS(FullFilter, GroupFilter + '|') > 0 THEN
            EXIT(TRUE);

        IF STRLEN(FullFilter) < STRLEN(GroupFilter) THEN
            EXIT(FALSE);

        FullFilter := DELSTR(FullFilter, 1, STRLEN(FullFilter) - STRLEN(GroupFilter));
        EXIT(GroupFilter = FullFilter);
    end;

    [Scope('Internal')]
    procedure ResetGrouping()
    begin
        SETFILTER("Applies-to Code", '');
    end;

    local procedure GroupingSymbolOnPush()
    var
        FullGrpFilter: Text[250];
        GrpFilter: Text[250];
        SubStringPos: Integer;
    begin
        IF NOT Group THEN
            EXIT;

        FullGrpFilter := GETFILTER("Applies-to Code");

        // If group filtering is not set then create fully expanded filter
        IF FullGrpFilter = '' THEN
            FullGrpFilter := EmptyGroup + '|' + Text001 + '|' + Text002;

        SETRANGE(Group);
        GrpFilter := STRSUBSTNO('|%1', Rec.Code);

        IF IsGroupExpanded THEN BEGIN
            SubStringPos := STRPOS(FullGrpFilter, GrpFilter + '|');

            IF SubStringPos = 0 THEN
                SubStringPos := STRPOS(FullGrpFilter, GrpFilter);
            FullGrpFilter := DELSTR(FullGrpFilter, SubStringPos, STRLEN(GrpFilter))
        END ELSE
            FullGrpFilter += GrpFilter;

        SETFILTER("Applies-to Code", FullGrpFilter);
    end;

    [Scope('Internal')]
    procedure SetColumnVisability()
    var
        LastVehNo: Code[20];
        VehNoVisible: Boolean;
    begin
        IF GET('', '', 0, 'COMPONENTS') THEN BEGIN
            SetComponentsView;
            DELETE;
        END;
        VehicleSerialNoVisible := ComponentsView;
    end;

    [Scope('Internal')]
    procedure SetComponentsView()
    begin
        ComponentsView := TRUE;
    end;
}

