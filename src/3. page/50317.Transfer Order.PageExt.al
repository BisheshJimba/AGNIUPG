pageextension 50317 pageextension50317 extends "Transfer Order"
{
    // 11.07.2016 EB.P30 #T090
    //   Modified trigger OnNewRecord
    // 
    // 26.02.2015 EDMS P21
    //   Deleted RunObject property and added code to trigger OnAction for:
    //     Post
    //     Post and Print
    // 
    // 21.05.2014 Elva Baltic P21 #F012 MMG7.00
    //   Added page action:
    //     ReceiptDimensions
    // 
    // 25.04.2014 Elva Baltic P8 #F019 MMG7.00
    //   * Added New group LV Invoice
    // 
    // 27.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified trigger:
    //     CreateOrderPromising - OnAction()
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Promoted action "Create Order Promising"
    // 
    // 17.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Combined Order
    // 
    // 07.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added Global Variables:
    //     CapabletoPromise
    //     ServiceTransferMgt
    //   Added Page Actions:
    //     CreateReqWorksheet
    //     CreateOrderPromising
    Editable = true;
    Editable = false;
    layout
    {
        modify(TransferLines)
        {

            //Unsupported feature: Property Modification (SubPageLink) on "TransferLines(Control 55)".

            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 8")
        {
            field("Picker ID"; "Picker ID")
            {
            }
        }
        addafter("Control 6")
        {
            field("Courier Pod. No."; "Courier Pod. No.")
            {
                Visible = SparePartDocument;
            }
            field("Courier Date"; "Courier Date")
            {
                Visible = SparePartDocument;
            }
            field(Weight; Weight)
            {
                Visible = SparePartDocument;
            }
            field("Combined Order"; "Combined Order")
            {
                Editable = false;
            }
            field(Remarks; Remarks)
            {
            }
            field(Tender; Tender)
            {
            }
            field("Document Date"; "Document Date")
            {
                Editable = false;
            }
            field("Total CBM"; "Total CBM")
            {
            }
        }
        addafter(TransferLines)
        {
            part(TransferLinesVehicle; 25006468)
            {
                SubPageLink = Document No.=FIELD(No.),
                              Derived From Line No.=CONST(0);
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 1907468901")
        {
            group(Service)
            {
                field("Document Profile";"Document Profile")
                {
                }
                field("Source Type";"Source Type")
                {
                }
                field("Source Subtype";"Source Subtype")
                {
                }
                field("Source No.";"Source No.")
                {
                }
            }
        }
        addfirst("Control 1900000007")
        {
            part("Scan QR";50034)
            {
                Caption = 'Scan QR';
                SubPageLink = No.=FIELD(No.);
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 28".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 98".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 97".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 85".


        //Unsupported feature: Property Modification (Image) on "Action 69".



        //Unsupported feature: Code Modification on "Action 69.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            DocPrint.PrintTransferHeader(Rec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //DocPrint.PrintTransferHeader(Rec);
            DocPrint.PrintTransferHeader2(Rec);  //AGNI2017CU8
            */
        //end;


        //Unsupported feature: Code Modification on "Post(Action 66).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post (Yes/No)",Rec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post (Yes/No)",Rec);
            //Calling codeunit 33020163::Vehicle Transfer Management.
            IF VehicleTradeDocument THEN BEGIN
              ProCheckList.RESET;
              ProCheckList.SETRANGE("Source ID",TransferLine."Document No.");
            IF ProCheckList.FINDFIRST THEN BEGIN
            END;
            //GblVehTransMngt.checkCCnPPNoTransLine(Rec);
            //GblGatepassMngt.createVehTransGatepass(Rec);
            END;
            */
        //end;


        //Unsupported feature: Code Modification on "PostAndPrint(Action 67).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post + Print",Rec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post + Print",Rec);
            //Calling codeunit 33020163::Vehicle Transfer Management.
            IF VehicleTradeDocument THEN BEGIN
            //GblVehTransMngt.checkCCnPPNoTransLine(Rec);
            //GblGatepassMngt.createVehTransGatepass(Rec);
            END;
            */
        //end;
        addfirst("Action 57")
        {
            action("Generate QR")
            {
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //QRPrintMgt.CreateTransferQRCode(Rec);
                end;
            }
        }
        addafter(Dimensions)
        {
            action(ReceiptDimensions)
            {
                Caption = 'Receipt Dimensions';
                Image = Dimensions;

                trigger OnAction()
                begin
                    ShowDocReceiptDim;
                    CurrPage.SAVERECORD;
                end;
            }
        }
        addafter("Action 95")
        {
            action(AutoReserveQtyOutbnd)
            {
                Caption = 'Auto Reserve Quantity Outbnd.';
                Image = Reserve;

                trigger OnAction()
                begin
                    ServiceTransferMgt.ReserveTransfOrderQtyOutbnd(Rec);                         // 07.03.2014 Elva Baltic P21
                end;
            }
            action(CreateOrderPromising)
            {
                Caption = 'Create Order Promising';
                Image = CreateInventoryPickup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CapabletoPromise.CreateReqLinesFromTransfer(Rec, TRUE, 0);                   // 27.03.2014 Elva Baltic P21
                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        ServiceDocument: Boolean;
        DocumentProfileFilter: Text[250];
        CapabletoPromise: Codeunit "99000886";
        ServiceTransferMgt: Codeunit "25006010";
        GblVehTransMngt: Codeunit "33020163";
        GblGatepassMngt: Codeunit "50001";
        ProCheckList: Record "25006025";
        TransferLine: Record "5741";
        Text001: Label 'The Vehicle Purchase has not been Completely Invioce. Vehicle cannot be transferred!';
        QRPrintMgt: Codeunit "50007";
        BlockReceipt: Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
        /*
        //EDMS >>
          VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
          SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
          ServiceDocument := "Document Profile" = "Document Profile"::Service;
        //EDMS >>

        SetControlforTranstoCode;
        */
    //end;


    //Unsupported feature: Code Insertion on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //begin
        /*
        //EDMS >>
          CASE DocumentProfileFilter OF
            FORMAT("Document Profile"::"Vehicles Trade"): BEGIN
              "Document Profile" := "Document Profile"::"Vehicles Trade";
              VehicleTradeDocument := TRUE;
            END;
            FORMAT("Document Profile"::"Spare Parts Trade"): BEGIN
              "Document Profile" := "Document Profile"::"Spare Parts Trade";
              SparePartDocument := TRUE;
            END;
            FORMAT("Document Profile"::Service): BEGIN
              "Document Profile" := "Document Profile"::Service;
              ServiceDocument := TRUE;
            END;
        // 11.07.2016 EB.P30 >>
            FORMAT("Document Profile"::"Spare Parts Trade") + '|' + FORMAT("Document Profile"::Service): BEGIN
              "Document Profile" := "Document Profile"::"Spare Parts Trade";
              SparePartDocument := TRUE;
            END;
        // 11.07.2016 EB.P30 <<
          END;
        //EDMS >>
        */
    //end;


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
        /*
        //EDMS >>
          FILTERGROUP(3);
          DocumentProfileFilter := GETFILTER("Document Profile");
          FILTERGROUP(0);
        //EDMS <<
        IF ("Document Profile" IN ["Document Profile"::"Spare Parts Trade"]) THEN
          SparePartDocument := TRUE;

        SetControlforTranstoCode;
        */
    //end;

    local procedure SetControlforTranstoCode()
    begin
        IF "Document Profile" IN ["Document Profile"::"Spare Parts Trade"] THEN
           IF Status IN [Status::Released] THEN
              BlockReceipt := TRUE;
    end;
}

