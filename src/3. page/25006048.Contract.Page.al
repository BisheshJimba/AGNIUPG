page 25006048 Contract
{
    // 23.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Accepted Amount"
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Contract Location"
    //   Set Visible FALSE to:
    //     Field:
    //       "No. of Archived Versions"
    //     Page action:
    //       <Page Contract Sales Prices>
    //       <Action1190012>  Archive Document
    // 
    // 07.04.2014 Elva Baltic P15 # MMG7.00
    //   * Added Page Action: Vehicles
    // 
    // 21.03.2014 Elva Baltic P18 MMG7.00 #RX012
    //   Added fields
    //     "Payment Terms Code"
    //     "Fin. Charge Terms Code"
    // 
    // 05.10.2007. EDMS P2
    //   * Changed property Menu Item Contract -> Signers

    Caption = 'Contract';
    PageType = Card;
    SourceTable = Table25006016;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field("Bill-to Address"; "Bill-to Address")
                {
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Caption = 'Post Code/City';
                }
                field("Bill-to City"; "Bill-to City")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Expiration Date"; "Expiration Date")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field(Status; Status)
                {
                }
                field(Suspended; Suspended)
                {
                }
                field("No. of Archived Versions"; "No. of Archived Versions")
                {
                    Visible = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                }
                field("Fin. Charge Terms Code"; "Fin. Charge Terms Code")
                {
                }
                field("Accepted Amount"; "Accepted Amount")
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
            group("&Contract")
            {
                Caption = '&Contract';
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
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = SalesPrices;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006056;
                                    RunPageLink = Contract No.=FIELD(Contract No.);
                    Visible = false;
                }
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
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocMgt: Codeunit "25006000";
                    RepSelect: Record "25006011";
                begin
                    DocMgt.PrintCurrentDoc(0, 0, 13, RepSelect);
                    DocMgt.SelectContractDocReport(RepSelect, Rec);
                end;
            }
            group("<Action1101904000>")
            {
                Caption = 'F&unctions';
                action("<Action1101907101>")
                {
                    Caption = '&Activate';
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE;
                        ActivateContract.ActivateContract(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                action("<Action1101907102>")
                {
                    Caption = '&Inactivate';
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE;
                        ActivateContract.InactivateContract(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                action("<Action1190012>")
                {
                    Caption = 'Archi&ve Document';
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchiveContract(Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
        }
    }

    var
        ActivateContract: Codeunit "25006005";
        ArchiveManagement: Codeunit "5063";
}

