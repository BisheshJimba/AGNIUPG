page 25006063 "Contract Archive"
{
    Caption = 'Contract Archive';
    Editable = false;
    PageType = List;
    SourceTable = Table25006045;

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
                field("Document Profille"; "Document Profille")
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
            }
            group(Version)
            {
                Caption = 'Version';
                field("Version No."; "Version No.")
                {
                }
                field("Archived By"; "Archived By")
                {
                }
                field("Date Archived"; "Date Archived")
                {
                }
                field("Time Archived"; "Time Archived")
                {
                }
                field("Interaction Exist"; "Interaction Exist")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Version")
            {
                Caption = '&Version';
                action(Signers)
                {
                    Caption = 'Signers';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006066;
                    RunPageLink = Contract Type=CONST(Contract),
                                  Contract No.=FIELD(Contract No.),
                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                  Version No.=FIELD(Version No.);
                }
            }
            group(Sale)
            {
                Caption = 'Sale';
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = SalesPrice;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006065;
                                    RunPageLink = Contract No.=FIELD(Contract No.),
                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                  Version No.=FIELD(Version No.);
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006064;
                                    RunPageLink = Contract No.=FIELD(Contract No.),
                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                  Version No.=FIELD(Version No.);
                }
            }
        }
        area(processing)
        {
            action("&Restore")
            {
                Caption = '&Restore';
                Ellipsis = true;
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ArchiveManagement: Codeunit "5063";
                begin
                    ArchiveManagement.RestoreContract(Rec);
                end;
            }
        }
    }
}

