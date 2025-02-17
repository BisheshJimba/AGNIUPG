page 25006046 "Contract List EDMS"
{
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added fields:
    //     "Document Profile"
    //     "Contract Location"
    //   Added Page Actions:
    //     <Page Contract Signers>
    //     <Page Contract Sales Line Discount>
    // 
    // 07.04.2014 Elva Baltic P15 # MMG7.00
    //   * Added Page Action: Vehicles

    Caption = 'Contract List';
    CardPageID = Contract;
    Editable = false;
    PageType = List;
    SourceTable = Table25006016;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Contract No."; "Contract No.")
                {
                }
                field("Document Profile"; "Document Profile")
                {
                }
                field(Description; Description)
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                }
                field(Status; Status)
                {
                }
                field("Contract Location"; "Contract Location")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Contract)
            {
                Caption = 'Contract';
                action(Signers)
                {
                    Caption = 'Signers';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006060;
                    RunPageLink = Contract Type=CONST(Contract),
                                  Contract No.=FIELD(Contract No.);
                }
                action(Vehicles)
                {
                    Caption = 'Vehicles';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006090;
                                    RunPageLink = Contract Type=FIELD(Contract Type),
                                  Contract No.=FIELD(Contract No.);
                }
            }
            group(Sale)
            {
                Caption = 'Sale';
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006049;
                                    RunPageLink = Contract No.=FIELD(Contract No.);
                }
            }
        }
    }
}

