page 33020265 "Commercial Invoices List"
{
    CardPageID = "Commercial Invoice Card";
    PageType = List;
    SourceTable = Table33020185;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field(No; No)
                {
                }
                field(Date; Date)
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
                field("Payment Bank Name"; "Payment Bank Name")
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
                field("No. Series"; "No. Series")
                {
                }
                field("Customer name"; "Customer name")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field(Amount; Amount)
                {
                    Caption = 'Commercial Amount';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Commercial Invoice")
            {
                Caption = 'Commercial Invoice';
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
                            CompanyInfo.GET;
                            IF CompanyInfo."Balaju Auto Works" THEN BEGIN
                                REPORT.RUNMODAL(25006111, TRUE, TRUE, CommercialInvHdr);
                                REPORT.RUNMODAL(25006112, TRUE, TRUE, CommercialInvHdr);
                                REPORT.RUNMODAL(25006113, TRUE, TRUE, CommercialInvHdr);
                            END ELSE BEGIN
                                REPORT.RUNMODAL(33020041, TRUE, TRUE, CommercialInvHdr);
                                REPORT.RUNMODAL(33020043, TRUE, TRUE, CommercialInvHdr);
                                REPORT.RUNMODAL(33020044, TRUE, TRUE, CommercialInvHdr);
                            END;
                        END
                    END ELSE
                        ERROR('This Commercial Invoice is not Posted. Please post it before printing the invoice.');
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
                            IF CommercialInvLine.FINDSET THEN BEGIN
                                SalesInvHdr.SETRANGE(SalesInvHdr."No.", CommercialInvLine."Sales Invoice No.");
                                IF SalesInvHdr.FINDFIRST THEN
                                    REPORT.RUNMODAL(33020049, TRUE, TRUE, SalesInvHdr);
                            END;
                            //UNTIL CommercialInvLine.NEXT = 0;
                        END;
                    END;
                end;
            }
        }
    }

    var
        CommercialInvHdr: Record "33020185";
        CommercialInvHdr1: Record "33020185";
        CommercialInvHdr2: Record "33020185";
        CommercialInvLine: Record "33020186";
        SalesInvHdr: Record "112";
        CompanyInfo: Record "79";
}

