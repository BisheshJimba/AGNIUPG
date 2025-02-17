page 50002 "General Gatepass"
{
    PageType = Card;
    Permissions = TableData "Gatepass Line" = rm;
    SourceTable = "Gatepass Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document Profile"; Rec."Document Type")
                {
                    Caption = 'Document Profile';
                }
                field("Document No"; Rec."Document No")
                {
                }
                field(Location; Rec.Location)
                {
                }
                field("Issued Date"; Rec."Issued Date")
                {
                }
                field("Issued Date (BS)"; Rec."Issued Date (BS)")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Visible = false;
                }
                field("Issued By"; Rec."Issued By")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No. of Print"; Rec."No. of Print")
                {
                }
                field("Ship Address"; Rec."Ship Address")
                {
                }
                field(Kilometer; Rec.Kilometer)
                {
                }
            }
            group(Details)
            {
                field(Person; Rec.Person)
                {
                    Editable = true;
                }
                field(Destination; Rec.Destination)
                {
                }
                field(Owner; Rec.Owner)
                {
                    Editable = true;
                }
                field("Driver Name"; Rec."Driver Name")
                {
                }
                field("External Document Type"; Rec."External Document Type")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Vehicle Registration No."; Rec."Vehicle Registration No.")
                {
                }
                field(VIN; Rec.VIN)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Remarks; Rec.Remarks)
                {
                    MultiLine = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
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
                    GatePass: Record "Gatepass Header";
                    SalesInvHdr: Record "Sales Invoice Header";
                    ServiceOrdEDMS: Record "Service Header EDMS";
                    GatepassLine: Record "Gatepass Line";
                begin
                    IF (Rec."Document Type" = Rec."Document Type"::Admin) OR (Rec."External Document Type" = Rec."External Document Type"::"Closed Job") THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(50027, TRUE, FALSE, GatePass);
                    END;

                    IF (Rec."Document Type" = Rec."Document Type"::"Vehicle Service") AND (Rec."External Document Type" = Rec."External Document Type"::Repair) THEN BEGIN
                        ServiceOrdEDMS.RESET;
                        ServiceOrdEDMS.SETRANGE("No.", Rec."External Document No.");
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
                    IF (Rec."Document Type" = Rec."Document Type"::"Vehicle Service") AND (Rec."External Document Type" = Rec."External Document Type"::"Trail/Demo") THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(50027, TRUE, FALSE, GatePass);
                    END;

                    IF Rec."External Document Type" = Rec."External Document Type"::"Transfer Order" THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(33020799, TRUE, FALSE, GatePass);
                    END;
                    IF Rec."External Document Type" = Rec."External Document Type"::PDI THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(33020799, TRUE, FALSE, GatePass);
                    END;

                    // SalesInvHdr.RESET;
                    // SalesInvHdr.SETRANGE("No.","External Document No.");
                    // IF SalesInvHdr.FINDFIRST THEN BEGIN
                    //  REPORT.RUNMODAL(3010750,TRUE,FALSE,SalesInvHdr);
                    // END;

                    SalesInvHdr.RESET;
                    SalesInvHdr.SETRANGE("No.", Rec."External Document No.");
                    //Agni Incorporate UPG
                    IF SalesInvHdr.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(3010750, TRUE, FALSE, SalesInvHdr);
                    END;
                    //Agni Incorporate UPG
                    IF ((Rec."External Document Type" = Rec."External Document Type"::"General CheckUp") AND (Rec."External Document No." = '') OR
                      (Rec."Document Type" = Rec."Document Type"::"Vehicle GatePass") AND (Rec."External Document Type" = Rec."External Document Type"::"General CheckUp") OR
                      (Rec."Document Type" = Rec."Document Type"::"Vehicle GatePass") AND (Rec."External Document Type" = Rec."External Document Type"::"For Quotation") AND (Rec."External Document No." <> '')) THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(50027, TRUE, FALSE, GatePass);
                    END ELSE
                        IF ((SalesInvHdr.FINDFIRST) OR
                 (Rec."Document Type" = Rec."Document Type"::"Vehicle GatePass") AND (Rec."External Document Type" = Rec."External Document Type"::"For Quotation") AND (Rec."External Document No." = '')) THEN BEGIN
                            REPORT.RUNMODAL(3010750, TRUE, FALSE, SalesInvHdr);
                        END;

                    IF (Rec."Document Type" = Rec."Document Type"::"Vehicle Trade") AND (Rec."External Document Type" = Rec."External Document Type"::"Vehicle Trial") THEN BEGIN
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
        GatePass: Page "General Gatepass";
        Update: Boolean;
        GatepassReport: Report "3010750";
}

