pageextension 50275 pageextension50275 extends "Purchase Order Subform"
{
    // 06.10.2016 EB.P7 #PAR28
    //   Modified Quantity OnValidate Trigger.
    // 
    // 30.05.2016 EB.P7 #PAR28
    //   Added field:
    //     25006998Has Replacement
    //   Action added Apply Replacement
    // 
    // 20.05.2016 EB.P30 EDMS
    //   Added field:
    //     " Shipment Package No."
    // 
    // 08.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed ReservedFor SourceExpr:
    //     CreateForText to CreateForText2
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added fields:
    //     ReservedFor
    //     ReservationCustomerNo
    //     ReservationCustomerName
    //     ReservationVIN
    //     ReservationDealType
    //     ReservationOrderingPriceType
    //   Added code to:
    //     OnAfterGetRecord
    // 
    // 27.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     No. - OnAssistEdit()
    // 
    // 19.03.2014 P18
    //   Modified Code for page Action  "TransferLines"
    // 
    // 03.02.2014 Elva Baltic P7 #F018 MMG7.00
    //   * New fields added - VIN, "Vehicle Serial No.", "Vehicle Accounting Cycle No."
    // 
    // 24.10.2013 EDMS P8
    //   * NEW action TransferLines
    Caption = ' Reason Code';
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 14".


        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".



        //Unsupported feature: Code Insertion on "Control 4".

        //trigger OnAssistEdit()
        //begin
        /*
        NoAssistEdit;                                                                         // 27.03.2014 Elva Baltic P21
        */
        //end;


        //Unsupported feature: Code Modification on "Control 14.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        RedistributeTotalsOnAfterValidate;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        IF "Document Profile" = "Document Profile"::Service THEN
          ERROR('You cannot Delete Lines for the document that has been linked to Service Order.');
        */
        //end;


        //Unsupported feature: Code Modification on "Control 8.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        RedistributeTotalsOnAfterValidate;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        RedistributeTotalsOnAfterValidate;
        CurrPage.UPDATE;
        */
        //end;
        addafter("Control 4")
        {
            field("Account Name"; "Account Name")
            {
            }
            field("Has Replacement"; "Has Replacement")
            {
            }
        }
        addafter("Control 6")
        {
            field("Description 2"; Rec."Description 2")
            {
            }
        }
        addafter("Control 9")
        {
            field(ABC; ABC)
            {
            }
        }
        addafter("Control 30")
        {
            field("Ordering Price Type Code"; "Ordering Price Type Code")
            {
                Visible = false;
            }
        }
        addafter("Control 60")
        {
            field("TDS Base Amount"; "TDS Base Amount")
            {
            }
            field("TDS Group"; "TDS Group")
            {
            }
            field("TDS%"; "TDS%")
            {
            }
            field("TDS Type"; "TDS Type")
            {
            }
            field("TDS Amount"; "TDS Amount")
            {
            }
        }
        addafter("Control 27")
        {
            field("Shipment Package No."; "Shipment Package No.")
            {
                Visible = false;
            }
            field("Vendor Order No."; "Vendor Order No.")
            {
            }
            field("Vendor Invoice No."; "Vendor Invoice No.")
            {
            }
            field("Depreciation Book Code"; Rec."Depreciation Book Code")
            {
            }
            field("FA Posting Type"; Rec."FA Posting Type")
            {
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                Visible = false;
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                Visible = false;

                trigger OnValidate()
                begin
                    RedistributeTotalsOnAfterValidate;
                end;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                Visible = false;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                Visible = false;
            }
            field("Requistion No."; "Requistion No.")
            {
                Caption = 'Req. No.';
                Visible = false;
            }
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
            }
            field("VIN - COGS"; "VIN - COGS")
            {
            }
        }
        addafter("Control 14")
        {
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
            }
            field("COGS Type"; "COGS Type")
            {
                Visible = false;
            }
            field("Tax Purchase Type"; "Tax Purchase Type")
            {
            }
            field("Cost Type"; "Cost Type")
            {
            }
        }
        addafter("Control 19")
        {
            field(VIN; VIN)
            {
                Visible = false;
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field(ReservedFor; ReservEngineMgt.CreateForText2(ReservationEntry))
            {
                Caption = 'Reserved For';
                Visible = false;
            }
            field(ReservationCustomerNo; GetReservForInfo(ReturnValue::CustomerNo))
            {
                Caption = 'Reservation Customer No.';
                TableRelation = Customer;
                Visible = false;
            }
            field(ReservationCustomerName; GetReservForInfo(ReturnValue::CustomerName))
            {
                Caption = 'Reservation Customer Name';
                Visible = false;
            }
            field(ReservationVIN; GetReservForInfo(ReturnValue::VIN))
            {
                Caption = 'Reservation VIN';
                TableRelation = Vehicle.VIN;
                Visible = false;
            }
            field(ReservationDealType; GetReservForInfo(ReturnValue::DealType))
            {
                Caption = 'Reservation Deal Type Code';
                TableRelation = "Deal Type";
                Visible = false;
            }
            field(ReservationOrderingPriceType; GetReservForInfo(ReturnValue::OrderingPriceType))
            {
                Caption = 'Reservation Ordering Price Type Code';
                TableRelation = "Ordering Price Type";
                Visible = false;
            }
        }
        moveafter("Control 82"; "Control 6")
    }
    actions
    {
        addafter(OrderTracking)
        {
            separator()
            {
            }
            action(DataExchangeAction)
            {
                Caption = 'Data Exchange';
                Ellipsis = true;
                Image = Change;

                trigger OnAction()
                var
                    DocMgt: Codeunit "25006000";
                    DataExchSelect: Record "25006051";
                    PurchLine: Record "39";
                    PurchaseHeader: Record "38";
                begin
                    DataExchangeAct;
                end;
            }
            action(TransferLines)
            {
                Caption = 'Transfer Lines';
                Ellipsis = true;
                Image = Change;

                trigger OnAction()
                var
                    PurchaseLineLoc: Record "39";
                    RepTransferLines: Report "25006529";
                begin
                    //24.10.2013 EDMS P8
                    CurrPage.SETSELECTIONFILTER(PurchaseLineLoc);
                    IF CONFIRM(Text002, FALSE, PurchaseLineLoc.COUNT) THEN BEGIN
                        // 19.03.2014 P18 >>
                        RepTransferLines.SETTABLEVIEW(PurchaseLineLoc);
                        RepTransferLines.SetParams(PurchaseLineLoc);
                        RepTransferLines.RUN;
                    END;
                    //REPORT.RUNMODAL(REPORT::"Purch. Order-Transfer Line",TRUE,FALSE, PurchaseLineLoc);
                    // 19.03.2014 P18 <<
                end;
            }
        }
        addafter(BlanketOrder)
        {
            action("Service &Order")
            {
                Caption = 'Service &Order';
                Image = Document;

                trigger OnAction()
                begin
                    OpenSpecOrderServiceOrderForm;
                end;
            }
            action("Apply Replacement")
            {
                Caption = 'Apply Replacement';
                Image = ItemSubstitution;

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "25006513";
                begin
                    //10.05.2016 EB.P7 #PAR_28 >>
                    ItemSubstSync.ReplacePurchaseLineItemNo(Rec);
                    //10.05.2016 EB.P7 #PAR_28 <<
                    CurrPage.UPDATE;
                end;
            }
            action("QR Specifications")
            {
                Image = SpecialOrder;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+Q';

                trigger OnAction()
                begin
                    OpenQRSpecificationLines;
                end;
            }
        }
    }

    var
        Text002: Label 'You have selected %1 record lines.';
        ReservEngineMgt: Codeunit "99000831";
        ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType;
        ReservationEntry: Record "337";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    TypeChosen := HasTypeToFillMandatotyFields;
    CLEAR(DocumentTotals);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    // 28.03.2014 Elva Baltic P21 >>
    CLEAR(ReservationEntry);
    IF ReservationEntry.GET(ReservEngineMgt.GetReservForEntryNo("Document No.", "Line No.", DATABASE::"Purchase Line", "Document Type", 0, ''), FALSE) THEN;
    // 28.03.2014 Elva Baltic P21 <<
    */
    //end;


    //Unsupported feature: Code Modification on "OnDeleteRecord".

    //trigger OnDeleteRecord(): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
      COMMIT;
      IF NOT ReservePurchLine.DeleteLineConfirm(Rec) THEN
        EXIT(FALSE);
      ReservePurchLine.DeleteLine(Rec);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF "Document Profile" = "Document Profile"::Service THEN
      ERROR('You cannot Delete Lines for the document that has been linked to Service Order.');
    #1..6
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsertRecord".

    //trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF ApplicationAreaSetup.IsFoundationEnabled THEN
      Type := Type::Item;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    IF "Document Profile" = "Document Profile"::Service THEN
      ERROR('You cannot Insert Lines for the document that has been linked to Service Order.');

    IF ApplicationAreaSetup.IsFoundationEnabled THEN
      Type := Type::Item;
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModifyRecord".

    //trigger OnModifyRecord(): Boolean
    //begin
    /*

    IF "Document Profile" = "Document Profile"::Service THEN BEGIN
      IF (xRec.Type <> Rec.Type) OR
         (xRec."No." <> Rec."No.") OR
         (xRec."External Serv. Tracking No." <> Rec."External Serv. Tracking No.") OR
         (xRec.Quantity <> Rec.Quantity) THEN
         ERROR('You cannot Modify the document that has been linked to Service Order.');
    END;
    */
    //end;

    procedure OpenSpecOrderServiceOrderForm()
    var
        ServiceHeader: Record "25006145";
        ServiceOrder: Page "25006183";
    begin
        Rec.TESTFIELD("Special Order Service No.");
        ServiceHeader.SETRANGE("No.", "Special Order Service No.");
        ServiceOrder.SETTABLEVIEW(ServiceHeader);
        ServiceOrder.EDITABLE := FALSE;
        ServiceOrder.RUN;
    end;

    procedure ReturnLines(var PurchLine: Record "39")
    var
        PurchLine2: Record "39";
    begin
        PurchLine.RESET;
        PurchLine.COPYFILTERS(Rec);
        PurchLine2 := Rec;
        CurrPage.SETSELECTIONFILTER(PurchLine);
        Rec := PurchLine2;
    end;

    procedure DataExchangeAct()
    var
        DocMgt: Codeunit "25006000";
        DataExchSelect: Record "25006051";
        PurchLine: Record "39";
        PurchaseHeader: Record "38";
    begin
        PurchLine.RESET;
        DocMgt.ChooseExcelReport("Document Profile", 1, 1, DataExchSelect);
        ReturnLines(PurchLine);
        //MESSAGE('There are selected:'+FORMAT(PurchLine.COUNT));
        PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
        DocMgt.SelectImportPurchHdr(DataExchSelect, PurchaseHeader, PurchLine);
    end;
}

