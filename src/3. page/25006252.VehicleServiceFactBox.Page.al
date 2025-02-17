page 25006252 "Vehicle Service FactBox"
{
    // 14.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve

    Caption = 'Last Service Data';
    PageType = CardPart;
    SourceTable = Table25006005;

    layout
    {
        area(content)
        {
            field(FORMAT(LastVisitDate); FORMAT(LastVisitDate))
            {
                Caption = 'Last Visit Date';

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder("Serial No.");
                end;
            }
            field(LastVFRun1; LastVFRun1)
            {
                CaptionClass = '7,25006145,25006180';
                Lookup = true;
                Visible = IsVFRun1Visible_fBox;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder("Serial No.");
                end;
            }
            field(LastVFRun2; LastVFRun2)
            {
                CaptionClass = '7,25006145,25006255';
                Visible = IsVFRun2Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder("Serial No.");
                end;
            }
            field(LastVFRun3; LastVFRun3)
            {
                CaptionClass = '7,25006145,25006260';
                Visible = IsVFRun3Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder("Serial No.");
                end;
            }
            field(ServInfoPaneMgt.VehicleGetInsuranceCount(Rec);
                ServInfoPaneMgt.VehicleGetInsuranceCount(Rec))
            {
                Caption = 'Insurance';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.VehicleLookupVehicleInsurancesPlans(Rec);
                end;
            }
            field(ServInfoPaneMgt.GetVehicleInfoContractsCount(Rec);
                ServInfoPaneMgt.GetVehicleInfoContractsCount(Rec))
            {
                Caption = 'Contracts';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleInfoContracts(Rec);
                end;
            }
            field(ServInfoPaneMgt.VehicleGetActiveRecallCount(Rec);
                ServInfoPaneMgt.VehicleGetActiveRecallCount(Rec))
            {
                Caption = 'Recall campaigns';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.VehicleLookupActiveRecalls(Rec);
                end;
            }
            field(ServiceLedgerEntry."Next Service Date";
                ServiceLedgerEntry."Next Service Date")
            {
                Caption = 'Next Service Date';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcVF("Serial No.");
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        EXIT(FIND(Which));
    end;

    trigger OnInit()
    begin
        IsVFRun1Visible_fBox := IsVFActive(FIELDNO(Kilometrage));
        IsVFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        IsVFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;

    var
        ServiceLedgerEntry: Record "25006167";
        ServInfoPaneMgt: Codeunit "25006104";
        [InDataSet]
        IsVFRun1Visible_fBox: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        LastVFRun1: Integer;
        LastVFRun2: Decimal;
        LastVFRun3: Decimal;
        LastVisitDate: Date;

    [Scope('Internal')]
    procedure ShowDetails()
    begin
        PAGE.RUN(PAGE::"Vehicle Card", Rec);
    end;

    [Scope('Internal')]
    procedure CalcVF(VehSerialNo: Code[20])
    begin
        //the code is copied from codeunit "Service Info-Pane Mgt. EDMS" function CalcLastVFRun1
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN BEGIN
            LastVFRun1 := ServiceLedgerEntry.Kilometrage;
            LastVFRun2 := ServiceLedgerEntry."Variable Field Run 2";
            LastVFRun3 := ServiceLedgerEntry."Variable Field Run 3";
            LastVisitDate := ServiceLedgerEntry."Posting Date";
        END ELSE BEGIN
            LastVFRun1 := 0;
            LastVFRun2 := 0;
            LastVFRun3 := 0;
            LastVisitDate := 0D;
        END;

        EXIT;
    end;
}

