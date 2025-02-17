page 33020293 "Vehicle Insurance HP FactBox"
{
    PageType = CardPart;
    SourceTable = Table33020062;

    layout
    {
        area(content)
        {
            field("LineNo."; VehicleInsuranceHP."Line No.")
            {
                Editable = false;

                trigger OnDrillDown()
                begin
                    VehicleInsMgtHP.LookupVehicleInsuranceHP("Loan No.");
                end;
            }
            field("Insurance. Type"; VehicleInsuranceHP."Insurance Type")
            {
                Editable = false;

                trigger OnDrillDown()
                begin
                    VehicleInsMgtHP.LookupVehicleInsuranceHP("Loan No.");
                end;
            }
            field("Serial No."; VehicleInsuranceHP."Vehicle Serial No.")
            {
                Editable = false;
            }
            field("VIN No."; VehicleInsuranceHP."VIN No.")
            {
            }
            field("Registration No."; VehicleInsuranceHP."Vehicle Reg. No.")
            {
            }
            field("Policy No."; VehicleInsuranceHP."Policy No.")
            {

                trigger OnDrillDown()
                begin
                    VehicleInsMgtHP.LookupVehicleInsuranceHP("Loan No.");
                end;
            }
            field("Insured Value"; VehicleInsuranceHP."Insured Value")
            {

                trigger OnDrillDown()
                begin
                    VehicleInsMgtHP.LookupVehicleInsuranceHP("Loan No.");
                end;
            }
            field("Ins. Prem. Value (With VAT)"; VehicleInsuranceHP."Ins. Prem Value (with VAT)")
            {

                trigger OnDrillDown()
                begin
                    VehicleInsMgtHP.LookupVehicleInsuranceHP("Loan No.");
                end;
            }
            field("Ins. Compay Code"; VehicleInsuranceHP."Insurance Company Code")
            {
            }
            field("Ins. Company Name"; VehicleInsuranceHP."Insurance Company Name")
            {
            }
            field("Start Date"; VehicleInsuranceHP."Start Date")
            {
            }
            field("End Date"; VehicleInsuranceHP."End Date")
            {
            }
            field("Expiring Days"; ExpiringDays)
            {

                trigger OnDrillDown()
                begin
                    VehicleInsMgtHP.LookupVehicleInsuranceHP("Loan No.");
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ExpiringDays := 0;
        CLEAR(VehicleInsuranceHP);
        /*IF VehicleInsMgtHP.GetVehicleInsuranceHP("Loan No.",VehicleInsuranceHP) THEN BEGIN
          ExpiringDays := VehicleInsuranceHP."End Date" - TODAY;
        END;
        */
        IF VehicleInsMgtHP2.GetVehicleInsuranceHP("Loan No.", VehicleInsuranceHP) THEN BEGIN
            ExpiringDays := VehicleInsuranceHP."End Date" - TODAY;
        END;

    end;

    var
        VehicleInsuranceHP: Record "33020085";
        VehicleInsMgtHP: Codeunit "25006200";
        VehicleInsMgtHP2: Codeunit "25006200";
        ExpiringDays: Integer;
}

