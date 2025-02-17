page 25006493 "Create Vehicle-Interactive"
{
    Caption = 'Create Vehicle-Interactive';
    PageType = Card;

    layout
    {
        area(content)
        {
            field(MakeCode; MakeCode)
            {
                Caption = 'Make Code';
                Editable = false;
            }
            field(ModelCode; ModelCode)
            {
                Caption = 'Model Code';
                Editable = false;
            }
            field(ModelVersionNo; ModelVersionNo)
            {
                Caption = 'Model Version No.';
                Editable = false;
            }
            field(SerialNo; SerialNo)
            {
                Caption = 'Vehicle Serial No.';
                Editable = false;
            }
            field(NewVIN; NewVIN)
            {
                Caption = 'VIN';
            }
            field(NewEngineNo; NewEngineNo)
            {
                Caption = 'Engine No.';
            }
            field("<Production Years>"; ProductionYears)
            {
                Caption = 'Production Years';
            }
            field("<Commercia Invoice No.>"; CommercialInvoiceNo)
            {
                Caption = 'Commercia Invoice No.';
            }
        }
    }

    actions
    {
    }

    var
        NewVIN: Code[20];
        MakeCode: Code[20];
        ModelCode: Code[20];
        ModelVersionNo: Code[20];
        SerialNo: Code[20];
        BodyColorCode: Code[10];
        InteriorCode: Code[10];
        NewEngineNo: Code[20];
        ProductionYears: Code[4];
        CommercialInvoiceNo: Code[20];

    [Scope('Internal')]
    procedure fGetNewVin(): Code[20]
    begin
        EXIT(NewVIN);
    end;

    [Scope('Internal')]
    procedure fSetData(MakeCode1: Code[20]; ModelCode1: Code[20]; ModelVersionNo1: Code[20]; SerialNo1: Code[20]; BodyColorCode1: Code[10]; InteriorCode1: Code[10])
    begin
        MakeCode := MakeCode1;
        ModelCode := ModelCode1;
        ModelVersionNo := ModelVersionNo1;
        SerialNo := SerialNo1;
        BodyColorCode := BodyColorCode1;
        InteriorCode := InteriorCode1;
    end;

    [Scope('Internal')]
    procedure fGetNewEngineNo(): Code[20]
    begin
        EXIT(NewEngineNo);
    end;

    [Scope('Internal')]
    procedure fGetNewProductionYear(): Code[4]
    begin
        EXIT(ProductionYears);
    end;

    [Scope('Internal')]
    procedure fGetNewCommercialInvoiceNo(): Code[20]
    begin
        EXIT(CommercialInvoiceNo);
    end;
}

