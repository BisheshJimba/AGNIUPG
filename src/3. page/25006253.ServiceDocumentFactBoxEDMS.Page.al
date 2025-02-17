page 25006253 "Service Document FactBox EDMS"
{
    // 17.12.2014 EDMS P12
    //   * Code from all triggers OnLookup moved to triggers OnDrillDown
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added fields:
    //     ServiceQuotes
    //     ServiceOrders

    Caption = 'Vehicle Service Info.';
    PageType = CardPart;
    SourceTable = Table25006145;

    layout
    {
        area(content)
        {
            field(FORMAT(ServInfoPaneMgt.CalcLastVisitDate("Vehicle Serial No.")); FORMAT(ServInfoPaneMgt.CalcLastVisitDate("Vehicle Serial No.")))
            {
                Caption = 'Last Visit Date';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder("Vehicle Serial No.");
                end;
            }
            field(ServInfoPaneMgt.CalcLastVisitVFRun1("Vehicle Serial No.");
                ServInfoPaneMgt.CalcLastVisitVFRun1("Vehicle Serial No."))
            {
                Caption = 'Kilometrage';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder("Vehicle Serial No.");
                end;
            }
            field(ServInfoPaneMgt.CalcLastVisitVFRun2("Vehicle Serial No.");
                ServInfoPaneMgt.CalcLastVisitVFRun2("Vehicle Serial No."))
            {
                CaptionClass = '7,25006145,25006255';
                Visible = IsVFRun2Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder("Vehicle Serial No.");
                end;
            }
            field(ServInfoPaneMgt.CalcLastVisitVFRun3("Vehicle Serial No.");
                ServInfoPaneMgt.CalcLastVisitVFRun3("Vehicle Serial No."))
            {
                CaptionClass = '7,25006145,25006260';
                Visible = IsVFRun3Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder("Vehicle Serial No.");
                end;
            }
            field(ServInfoPaneMgt.CalcLastVisitHour("Vehicle Serial No.");
                ServInfoPaneMgt.CalcLastVisitHour("Vehicle Serial No."))
            {
                Caption = 'Last Visit Hours';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder("Vehicle Serial No.");
                end;
            }
            field(ServInfoPaneMgt.GetSanjivaniInfo(VIN);
                ServInfoPaneMgt.GetSanjivaniInfo(VIN))
            {
                Caption = 'Sanjivani Registered';
                Lookup = true;
                Visible = false;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    ServInfoPaneMgt.LookupLastSanjivaniReg(VIN);
                end;
            }
            field(FORMAT(ServInfoPaneMgt.CalcVehSalesDate("Vehicle Serial No.")); FORMAT(ServInfoPaneMgt.CalcVehSalesDate("Vehicle Serial No.")))
            {
                Caption = 'Sales Date';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicle("Vehicle Serial No.");
                end;
            }
            field(ServInfoPaneMgt.GetServicePlanCount(Rec);
                ServInfoPaneMgt.GetServicePlanCount(Rec))
            {
                Caption = 'Service Plans';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupServicePlans(Rec)
                end;
            }
            field(ServInfoPaneMgt.GetWarrantyInfo(Rec);
                ServInfoPaneMgt.GetWarrantyInfo(Rec))
            {
                Caption = 'Warranties';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehWarranties(Rec)
                end;
            }
            field(ServInfoPaneMgt.GetActiveRecallCount(Rec);
                ServInfoPaneMgt.GetActiveRecallCount(Rec))
            {
                Caption = 'Recall Campaigns';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupActiveRecalls(Rec)
                end;
            }
            field(ServInfoPaneMgt.GetComponentServicePlansCount(Rec);
                ServInfoPaneMgt.GetComponentServicePlansCount(Rec))
            {
                Caption = 'Component''s Service Plans';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleComponentsPlans(Rec);
                end;
            }
            field(ServInfoPaneMgt.GetInsuranceCount(Rec);
                ServInfoPaneMgt.GetInsuranceCount(Rec))
            {
                Caption = 'Insurance';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleInsurancesPlans(Rec);
                end;
            }
            field(ServiceQuotes; ServInfoPaneMgt.GetVehicleDocCount(Rec, DocType::Quote))
            {
                Caption = 'Service Quotes';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleDoc(Rec, DocType::Quote);
                end;
            }
            field(ServiceOrders; ServInfoPaneMgt.GetVehicleDocCount(Rec, DocType::Order))
            {
                Caption = 'Service Orders';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleDoc(Rec, DocType::Order);
                end;
            }
            field("Scheme Status"; "Scheme Status")
            {
            }
            field(FORMAT(ServInfoPaneMgt.CalcNextServiceDate("Vehicle Serial No.")); FORMAT(ServInfoPaneMgt.CalcNextServiceDate("Vehicle Serial No.")))
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
        //MESSAGE('IsVFRun1Visible_fBox='+FORMAT(IsVFRun1Visible_fBox)+', No='+"No.");
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        EXIT(FIND(Which));
    end;

    trigger OnInit()
    begin
        IsVFRun1Visible_fBox := IsVFActive(FIELDNO(Kilometrage));
        //IsVFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2")); <<Bishesh Jimba 2/4/25
        //IsVFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));   Bishesh Jimba>>
    end;

    var
        ServInfoPaneMgt: Codeunit "25006104";
        [InDataSet]
        IsVFRun1Visible_fBox: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        DocType: Option Quote,"Order","Return Order";

    [Scope('Internal')]
    procedure ShowDetails()
    begin
        PAGE.RUN(PAGE::"Vehicle Card", Rec);
    end;

    [Scope('Internal')]
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;
}

