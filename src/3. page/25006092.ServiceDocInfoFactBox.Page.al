page 25006092 "Service Doc Info FactBox"
{
    // 17.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Remove field:
    //     "Contract No."
    //   Modified function:
    //     GetActiveContractQty
    //   Modified triggers:
    //     ActiveContractQty - OnDrillDown()
    //     SuspendedContractQty - OnDrillDown()

    Caption = 'Service Doc Info';
    PageType = CardPart;
    SourceTable = Table25006145;

    layout
    {
        area(content)
        {
            group(Contracts)
            {
                Caption = 'Contracts';
                field(ActiveContractQty; GetActiveContractQty(ContractStatusPar::Active, FALSE, DocumentProfile::Service))
                {
                    Caption = 'Active Contracts';

                    trigger OnDrillDown()
                    begin
                        IF "Bill-to Customer No." <> '' THEN
                            Customer.GET("Bill-to Customer No.");

                        Customer.ShowActiveContracts(ContractStatusPar::Active, FALSE, DocumentProfile::Service, "Order Date", "Vehicle Serial No.");         //Suspend = FALSE
                    end;
                }
                field(SuspendedContractQty; GetActiveContractQty(ContractStatusPar::Active, TRUE, DocumentProfile::Service))
                {
                    Caption = 'Suspended Contracts';

                    trigger OnDrillDown()
                    begin
                        IF "Bill-to Customer No." <> '' THEN
                            Customer.GET("Bill-to Customer No.");

                        Customer.ShowActiveContracts(ContractStatusPar::Active, TRUE, DocumentProfile::Service, "Order Date", "Vehicle Serial No.");          //Suspend = TRUE
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        Text000: Label 'Overdue Amounts (LCY) as of %1';
        Customer: Record "18";
        Contract: Record "25006016";
        ContractList: Page "25006046";
        ContractStatusPar: Option Inactive,Active;
        DocumentProfile: Option " ","Spare Parts Trade",,Service;
        ContractVehicle: Record "25006059";

    [Scope('Internal')]
    procedure ShowDetails()
    begin
        PAGE.RUN(PAGE::"Customer Card", Rec);
    end;

    [Scope('Internal')]
    procedure GetActiveContractQty(StatusPar: Option Inactive,Active; SuspendedPar: Boolean; DocProfile: Option " ","Spare Parts Trade",,Service) RetVal: Integer
    begin
        IF "Bill-to Customer No." <> '' THEN
            Customer.GET("Bill-to Customer No.");
        EXIT(Customer.GetActiveContractQty(StatusPar, SuspendedPar, DocProfile, "Order Date", "Vehicle Serial No."));
    end;
}

