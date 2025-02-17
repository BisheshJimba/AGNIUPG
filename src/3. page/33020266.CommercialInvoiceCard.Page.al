page 33020266 "Commercial Invoice Card"
{
    PageType = Card;
    SourceTable = Table33020185;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; No)
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Date; Date)
                {
                }
                field("Buyer Order No"; "Buyer Order No")
                {
                }
                field("Buyer Order Date"; "Buyer Order Date")
                {
                }
                field("Pre-Carriage By"; "Pre-Carriage By")
                {
                }
                field("Place of Recpt By Pre-Carrier"; "Place of Recpt By Pre-Carrier")
                {
                }
                field("Port of Loading"; "Port of Loading")
                {
                }
                field("Final Destination"; "Final Destination")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Consignment No"; "Consignment No")
                {
                }
                field(Incoterms; Incoterms)
                {
                }
                field("Incoterms Address"; "Incoterms Address")
                {
                    Visible = IncotermsAddress;
                }
                field(Narration; Narration)
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Sys. LC No."; "Sys. LC No.")
                {
                }
                field("Bank LC No."; "Bank LC No.")
                {
                }
                field("LC Value"; "LC Value")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field("Bank Address"; "Bank Address")
                {
                }
                field("Payment Bank No"; "Payment Bank No")
                {
                }
                field("Payment Bank Name"; "Payment Bank Name")
                {
                    Editable = false;
                }
                field(Posted; Posted)
                {
                    Editable = false;
                }
                field("Document Negotiation No."; "Document Negotiation No.")
                {
                }
                field("Domestic LC Margin No."; "Domestic LC Margin No.")
                {
                }
                field("Loan Payment Amount"; "Loan Payment Amount")
                {
                }
                field("Freight Amount"; "Freight Amount")
                {
                }
            }
            part(SalesInvLinesVehicle; 33020268)
            {
                Caption = 'Commercial SubForm';
                SubPageLink = Document No.=FIELD(No);
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Posted Sales Invoice")
            {
                Caption = 'Posted Sales Invoice';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvHeader: Record "112";
                begin
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE("Sys. LC No.", "Sys. LC No.");
                    PostedSalesInvoice.SetCommercialNo(No);
                    PostedSalesInvoice.SETTABLEVIEW(SalesInvHeader);
                    PostedSalesInvoice.RUN;
                end;
            }
            action("<Action1000000023>")
            {
                Caption = 'Post';
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Posted := TRUE;
                    MODIFY;
                end;
            }
            action(Annexure)
            {
                Caption = 'Annexure';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF Posted THEN BEGIN
                        CommercialInvHdr.RESET;
                        CommercialInvLine.RESET;
                        SalesInvHdr.RESET;
                        CommercialInvHdr.SETRANGE(No, No);
                        IF CommercialInvHdr.FINDFIRST THEN BEGIN
                            CommercialInvLine.SETRANGE("Document No.", CommercialInvHdr.No);
                            IF CommercialInvLine.FINDSET THEN
                                REPEAT
                                    SalesInvHdr.SETRANGE(SalesInvHdr."No.", CommercialInvLine."Sales Invoice No.");
                                    IF SalesInvHdr.FINDFIRST THEN
                                        REPORT.RUNMODAL(33020049, TRUE, TRUE, SalesInvHdr);
                                UNTIL CommercialInvLine.NEXT = 0;
                        END;
                    END;
                end;
            }
            group()
            {
                action("Draft Drawn Report")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF Posted THEN BEGIN
                            CommercialInvHdr.RESET;
                            CommercialInvHdr.SETRANGE(No, No);
                            IF CommercialInvHdr.FINDFIRST THEN BEGIN
                                REPORT.RUNMODAL(33020207, TRUE, TRUE, CommercialInvHdr);
                            END
                        END ELSE
                            ERROR(Text001);
                    end;
                }
                action("Good Received Note")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF Posted THEN BEGIN
                            CommercialInvHdr.RESET;
                            CommercialInvHdr.SETRANGE(No, No);
                            IF CommercialInvHdr.FINDFIRST THEN BEGIN
                                REPORT.RUNMODAL(33020208, TRUE, TRUE, CommercialInvHdr);
                            END
                        END ELSE
                            ERROR(Text001);
                    end;
                }
                action("Certificate Of Origin")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF Posted THEN BEGIN
                            CommercialInvHdr.RESET;
                            CommercialInvHdr.SETRANGE(No, No);
                            IF CommercialInvHdr.FINDFIRST THEN BEGIN
                                REPORT.RUNMODAL(33020209, TRUE, TRUE, CommercialInvHdr);
                            END
                        END ELSE
                            ERROR(Text001);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CompanyInformation.GET;
        IF CompanyInformation."Balaju Auto Works" THEN
            IncotermsAddress := TRUE;
    end;

    var
        PostedSalesInvoice: Page "33020267";
        CommercialInvHdr: Record "33020185";
        CommercialInvLine: Record "33020186";
        SalesInvHdr: Record "112";
        Text001: Label 'This Commercial Invoice is not Posted. Please post it before printing the invoice.';
        IncotermsAddress: Boolean;
        CompanyInformation: Record "79";
}

