page 50002 "General Gatepass"
{
    PageType = Card;
    Permissions = TableData 50005 = rm;
    SourceTable = "Gatepass Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document Profile"; "Document Type")
                {
                    Caption = 'Document Profile';
                }
                field("Document No"; "Document No")
                {
                }
                field(Location; Location)
                {
                }
                field("Issued Date"; "Issued Date")
                {
                }
                field("Issued Date (BS)"; "Issued Date (BS)")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Visible = false;
                }
                field("Issued By"; "Issued By")
                {
                }
                field(Type; Type)
                {
                }
                field("No. of Print"; "No. of Print")
                {
                }
                field("Ship Address"; "Ship Address")
                {
                }
                field(Kilometer; Kilometer)
                {
                }
            }
            group(Details)
            {
                field(Person; Person)
                {
                    Editable = true;
                }
                field(Destination; Destination)
                {
                }
                field(Owner; Owner)
                {
                    Editable = true;
                }
                field("Driver Name"; "Driver Name")
                {
                }
                field("External Document Type"; "External Document Type")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field(Description; Description)
                {
                }
                field(Remarks; Remarks)
                {
                    MultiLine = true;
                }
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
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    GatePass: Record "50004";
                    SalesInvHdr: Record "112";
                    ServiceOrdEDMS: Record "25006145";
                    GatepassLine: Record "50005";
                begin
                    IF ("Document Type" = "Document Type"::Admin) OR ("External Document Type" = "External Document Type"::"Closed Job") THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(50027, TRUE, FALSE, GatePass);
                    END;

                    IF ("Document Type" = "Document Type"::"Vehicle Service") AND ("External Document Type" = "External Document Type"::Repair) THEN BEGIN
                        ServiceOrdEDMS.RESET;
                        ServiceOrdEDMS.SETRANGE("No.", "External Document No.");
                        IF ServiceOrdEDMS.FINDFIRST THEN BEGIN
                            CurrPage.SETSELECTIONFILTER(GatePass);
                            REPORT.RUNMODAL(33020798, TRUE, FALSE, GatePass);
                            GatepassLine.RESET;
                            GatepassLine.SETRANGE("Service Line Print", TRUE);
                            IF GatepassLine.FINDSET THEN
                                REPEAT
                                    GatepassLine."Service Line Print" := FALSE;
                                    GatepassLine.MODIFY;
                                UNTIL GatepassLine.NEXT = 0;
                        END
                    END;
                    IF ("Document Type" = "Document Type"::"Vehicle Service") AND ("External Document Type" = "External Document Type"::"Trail/Demo") THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(50027, TRUE, FALSE, GatePass);
                    END;

                    IF "External Document Type" = "External Document Type"::"Transfer Order" THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(33020799, TRUE, FALSE, GatePass);
                    END;
                    IF "External Document Type" = "External Document Type"::PDI THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(33020799, TRUE, FALSE, GatePass);
                    END;

                    // SalesInvHdr.RESET;
                    // SalesInvHdr.SETRANGE("No.","External Document No.");
                    // IF SalesInvHdr.FINDFIRST THEN BEGIN
                    //  REPORT.RUNMODAL(3010750,TRUE,FALSE,SalesInvHdr);
                    // END;

                    SalesInvHdr.RESET;
                    SalesInvHdr.SETRANGE("No.", "External Document No.");
                    //Agni Incorporate UPG
                    IF SalesInvHdr.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(3010750, TRUE, FALSE, SalesInvHdr);
                    END;
                    //Agni Incorporate UPG
                    IF (("External Document Type" = "External Document Type"::"General CheckUp") AND ("External Document No." = '') OR
                      ("Document Type" = "Document Type"::"Vehicle GatePass") AND ("External Document Type" = "External Document Type"::"General CheckUp") OR
                      ("Document Type" = "Document Type"::"Vehicle GatePass") AND ("External Document Type" = "External Document Type"::"For Quotation") AND ("External Document No." <> '')) THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(50027, TRUE, FALSE, GatePass);
                    END ELSE
                        IF ((SalesInvHdr.FINDFIRST) OR
                 ("Document Type" = "Document Type"::"Vehicle GatePass") AND ("External Document Type" = "External Document Type"::"For Quotation") AND ("External Document No." = '')) THEN BEGIN
                            REPORT.RUNMODAL(3010750, TRUE, FALSE, SalesInvHdr);
                        END;

                    IF ("Document Type" = "Document Type"::"Vehicle Trade") AND ("External Document Type" = "External Document Type"::"Vehicle Trial") THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(50027, TRUE, FALSE, GatePass);
                    END;

                    /*Bishesh Jimba Aug 22 2024*/
                    // IF ("Document Type" = "Document Type"::"Vehicle GatePass") AND ("External Document Type" = "External Document Type"::"General CheckUp") THEN BEGIN
                    //  CurrPage.SETSELECTIONFILTER(GatePass);
                    //  REPORT.RUNMODAL(50027,TRUE,FALSE,GatePass);
                    // END;

                    // IF ("Document Type" = "Document Type"::"Vehicle GatePass") AND ("External Document Type" = "External Document Type"::"For Quotation") THEN BEGIN
                    //  CurrPage.SETSELECTIONFILTER(GatePass);
                    //  REPORT.RUNMODAL(50027,TRUE,FALSE,GatePass);
                    // END;

                end;
            }
        }
    }

    var
        VisisbleAdmin: Boolean;
        VisibleVehicleTrade: Boolean;
        VisibleService: Boolean;
        VisibleSPTrade: Boolean;
        GatePass: Page "50002";
        Update: Boolean;
        GatepassReport: Report "3010750";
}

