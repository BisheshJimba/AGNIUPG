page 25006266 "PDI create from Assem. Confirm"
{
    Caption = 'PDI create from Assem. Confirm';
    PageType = Card;
    SourceTable = Table25006145;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            field(ServiceHeaderTmp."Document Type";
                ServiceHeaderTmp."Document Type")
            {
            }
            field(ServiceHeaderTmp."No.";
                ServiceHeaderTmp."No.")
            {
            }
            field(BilllToCustomer; BilllToCustomer)
            {
                Caption = 'Billl-to Customer No.';
                TableRelation = Customer WHERE(Internal = CONST(Yes));
            }
            field(OrderDate; OrderDate)
            {
                Caption = 'Order Date';
            }
            field(PlannedDate; PlannedDate)
            {
                Caption = 'Planned Service Date';
            }
            field(AssemblyTotalAmount; AssemblyTotalAmount)
            {
                Caption = 'Assembly total amount';
                Enabled = false;
            }
            field(VehicleAssembly.COUNT;
                VehicleAssembly.COUNT)
            {
                Caption = 'Assembly lines count';
                Enabled = false;
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        ServiceHeaderTmp."Bill-to Customer No." := BilllToCustomer;
        ServiceHeaderTmp."Planned Service Date" := PlannedDate;
        ServiceHeaderTmp."Order Date" := OrderDate;
    end;

    trigger OnOpenPage()
    begin
        AssemblyTotalAmount := 0;
        VehicleAssembly.FINDFIRST;
        REPEAT
            AssemblyTotalAmount += VehicleAssembly.Amount;
        UNTIL VehicleAssembly.NEXT = 0;
        BilllToCustomer := ServiceHeaderTmp."Bill-to Customer No.";
        PlannedDate := ServiceHeaderTmp."Planned Service Date";
        OrderDate := ServiceHeaderTmp."Order Date";
    end;

    var
        AssemblyTotalAmount: Decimal;
        ServiceHeaderTmp: Record "25006145" temporary;
        VehicleAssembly: Record "25006380";
        BilllToCustomer: Code[20];
        OrderDate: Date;
        PlannedDate: Date;

    [Scope('Internal')]
    procedure SetVehicleAssembly(var VehicleAssemblyPar: Record "25006380")
    begin
        VehicleAssembly := VehicleAssemblyPar;
        VehicleAssembly.COPYFILTERS(VehicleAssemblyPar);
    end;

    [Scope('Internal')]
    procedure SetServiceHeaderTmp(var ServiceHeaderPar: Record "25006145" temporary)
    begin
        ServiceHeaderTmp := ServiceHeaderPar;
    end;

    [Scope('Internal')]
    procedure GetServiceHeaderTmp(var ServiceHeaderPar: Record "25006145" temporary)
    begin
        ServiceHeaderPar := ServiceHeaderTmp;
    end;
}

