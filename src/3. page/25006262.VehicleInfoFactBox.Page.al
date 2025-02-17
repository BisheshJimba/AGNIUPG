page 25006262 "Vehicle Info FactBox"
{
    // 14.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve
    // 
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added Contracts and Warranties controls

    Caption = 'Vehicle Information';
    PageType = CardPart;
    SourceTable = Table25006005;

    layout
    {
        area(content)
        {
            field(LastVFRun1; LastVFRun1)
            {
                CaptionClass = '7,25006145,25006180';
                Lookup = true;
                Visible = IsVFRun1Visible_fBox;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastSLEntry("Serial No.");
                end;
            }
            field(LastVFRun2; LastVFRun2)
            {
                CaptionClass = '7,25006145,25006255';
                Visible = IsVFRun2Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastSLEntry("Serial No.");
                end;
            }
            field(LastVFRun3; LastVFRun3)
            {
                CaptionClass = '7,25006145,25006260';
                Visible = IsVFRun3Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastSLEntry("Serial No.");
                end;
            }
            field("Sales Date"; "Sales Date")
            {
                Caption = 'Sales Date';
                Lookup = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicle("Serial No.");
                end;
            }
            field(FORMAT(ServInfoPaneMgt.GetVehicleContractsCount(Rec)); FORMAT(ServInfoPaneMgt.GetVehicleContractsCount(Rec)))
            {
                Caption = 'Contracts';

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleContracts(Rec);
                end;
            }
            field(FORMAT(ServInfoPaneMgt.GetVehicleWarrantyCount(Rec)); FORMAT(ServInfoPaneMgt.GetVehicleWarrantyCount(Rec)))
            {
                Caption = 'Warranties';

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleWarranties(Rec);
                end;
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
        LastVFRun1: Decimal;
        LastVFRun2: Decimal;
        LastVFRun3: Decimal;

    [Scope('Internal')]
    procedure CalcVF(VehSerialNo: Code[20])
    begin
        //the code is copied from codeunit "Service Info-Pane Mgt. EDMS" function CalcLastVFRun1
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETFILTER("Entry Type", '%1|%2', ServiceLedgerEntry."Entry Type"::Usage, ServiceLedgerEntry."Entry Type"::Info);
        IF ServiceLedgerEntry.FINDLAST THEN BEGIN
            LastVFRun1 := ServiceLedgerEntry.Kilometrage;
            LastVFRun2 := ServiceLedgerEntry."Variable Field Run 2";
            LastVFRun3 := ServiceLedgerEntry."Variable Field Run 3";
        END ELSE BEGIN
            LastVFRun1 := 0;
            LastVFRun2 := 0;
            LastVFRun3 := 0;
        END;

        EXIT;
    end;
}

