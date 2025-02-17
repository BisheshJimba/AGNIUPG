page 33020294 "Vehicle Insurance FactBox"
{
    PageType = CardPart;
    SourceTable = Table25006005;

    layout
    {
        area(content)
        {
            group("Vehicle Insurance")
            {
                field("LineNo."; VehicleInsNewPolicy."Line No.")
                {
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"New Policy");
                    end;
                }
                field("Serial No."; VehicleInsNewPolicy."Vehicle Serial No.")
                {
                    Editable = false;
                }
                field("VIN No."; VehicleInsNewPolicy.VIN)
                {
                }
                field("Registration No."; "Registration No.")
                {
                    Caption = 'VRN';
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Policy No."; VehicleInsNewPolicy."Insurance Policy No.")
                {

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"New Policy");
                    end;
                }
                field("Insured Value"; VehicleInsNewPolicy."Insured Value")
                {

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"New Policy");
                    end;
                }
                field("Ins. Prem. Value (With VAT)"; VehicleInsNewPolicy."Ins. Prem Value (with VAT)")
                {

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"New Policy");
                    end;
                }
                field("Ins. Company Name"; VehicleInsNewPolicy."Ins. Company Name")
                {
                }
                field("Start Date"; VehicleInsNewPolicy."Starting Date")
                {
                }
                field("End Date"; VehicleInsNewPolicy."Ending Date")
                {
                }
                field("Expiring Days"; ExpiringDays)
                {

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"New Policy");
                    end;
                }
            }
            group("Body Addition")
            {
                field(InsurancePolicyNoB; VehicleInsBodyAddition."Insurance Policy No.")
                {
                    Caption = 'InsurancePolicyNo';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Body Addition");
                    end;
                }
                field(StartingDateB; VehicleInsBodyAddition."Starting Date")
                {
                    Caption = 'StartingDate';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Body Addition");
                    end;
                }
                field(EndingDateB; VehicleInsBodyAddition."Ending Date")
                {
                    Caption = 'EndingDate';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Body Addition");
                    end;
                }
                field(InsuredValueB; VehicleInsBodyAddition."Insured Value")
                {
                    Caption = 'InsuredValue';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Body Addition");
                    end;
                }
                field("InsPremValue(with VAT)B"; VehicleInsBodyAddition."Ins. Prem Value (with VAT)")
                {
                    Caption = 'InsPremValue(with VAT)';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Body Addition");
                    end;
                }
            }
            group("Value Addition")
            {
                field(InsurancePolicyNoV; VehicleInsValueAddition."Insurance Policy No.")
                {
                    Caption = 'InsurancePolicyNo';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Value Addition");
                    end;
                }
                field(StartingDateV; VehicleInsValueAddition."Starting Date")
                {
                    Caption = 'StartingDateV';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Value Addition");
                    end;
                }
                field(EndingDateV; VehicleInsValueAddition."Ending Date")
                {
                    Caption = 'EndingDate';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Value Addition");
                    end;
                }
                field(InsuredValueV; VehicleInsValueAddition."Insured Value")
                {
                    Caption = 'InsuredValue';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Value Addition");
                    end;
                }
                field("InsPremValue(with VAT)V"; VehicleInsValueAddition."Ins. Prem Value (with VAT)")
                {
                    Caption = 'InsPremValue(with VAT)';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::"Value Addition");
                    end;
                }
            }
            group(Passanger)
            {
                field(InsurancePolicyNoP; VehicleInsPassanger."Insurance Policy No.")
                {
                    Caption = 'InsurancePolicyNo';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::Passenger);
                    end;
                }
                field(StartingDateP; VehicleInsPassanger."Starting Date")
                {
                    Caption = 'StartingDate';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::Passenger);
                    end;
                }
                field(EndingDateP; VehicleInsPassanger."Ending Date")
                {
                    Caption = 'EndingDate';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::Passenger);
                    end;
                }
                field(InsuredValueP; VehicleInsPassanger."Insured Value")
                {
                    Caption = 'InsuredValue';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::Passenger);
                    end;
                }
                field("InsPremValue(with VAT)P"; VehicleInsPassanger."Ins. Prem Value (with VAT)")
                {
                    Caption = 'InsPremValue(with VAT)';

                    trigger OnDrillDown()
                    begin
                        STPLMgt.LookupVehicleInsurance("Serial No.", InsuranceActivity::Passenger);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ExpiringDays := 0;
        ExpiringDaysB := 0;
        ExpiringDaysV := 0;
        ExpiringDaysP := 0;
        CLEAR(VehicleInsNewPolicy);
        IF STPLMgt.GetVehicleInsuranceDetails("Serial No.", InsuranceActivity::"New Policy", VehicleInsNewPolicy) THEN BEGIN
            VehicleInsNewPolicy.CALCFIELDS(VIN, "Ins. Company Name", "Insured Value");

            ExpiringDays := VehicleInsNewPolicy."Ending Date" - TODAY;
        END;

        CLEAR(VehicleInsBodyAddition);
        IF STPLMgt.GetVehicleInsuranceDetails("Serial No.", InsuranceActivity::"Body Addition", VehicleInsBodyAddition) THEN BEGIN
            VehicleInsBodyAddition.CALCFIELDS(VIN, "Ins. Company Name", "Insured Value");
            ExpiringDaysB := VehicleInsBodyAddition."Ending Date" - TODAY;
        END;

        CLEAR(VehicleInsValueAddition);
        IF STPLMgt.GetVehicleInsuranceDetails("Serial No.", InsuranceActivity::"Value Addition", VehicleInsValueAddition) THEN BEGIN
            VehicleInsValueAddition.CALCFIELDS(VIN, "Ins. Company Name", "Insured Value");
            ExpiringDaysV := VehicleInsValueAddition."Ending Date" - TODAY;
        END;

        CLEAR(VehicleInsPassanger);
        IF STPLMgt.GetVehicleInsuranceDetails("Serial No.", InsuranceActivity::Passenger, VehicleInsPassanger) THEN BEGIN
            VehicleInsPassanger.CALCFIELDS(VIN, "Ins. Company Name", "Insured Value");
            ExpiringDaysP := VehicleInsPassanger."Ending Date" - TODAY;
        END;
    end;

    var
        VehicleInsNewPolicy: Record "25006033";
        STPLMgt: Codeunit "50000";
        ExpiringDays: Integer;
        InsuranceActivity: Option "New Policy","Body Addition","Value Addition",Renewal,Cancellation,Passenger;
        VehicleInsBodyAddition: Record "25006033";
        VehicleInsValueAddition: Record "25006033";
        VehicleInsPassanger: Record "25006033";
        ExpiringDaysB: Integer;
        ExpiringDaysV: Integer;
        ExpiringDaysP: Integer;
}

