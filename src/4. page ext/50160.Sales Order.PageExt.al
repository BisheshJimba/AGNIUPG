pageextension 50160 pageextension50160 extends "Sales Order"
{
    // 11.07.2016 EB.P30 #T089
    //   Added fields:
    //     "Make Code"
    //     "Model Code"
    // 
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 08.09.2014 Elva Baltic P8 #S0004 EDMS
    //   * Deal Type field is moved into General tab.
    // 
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed order and set Visible TRUE for:
    //     Sales Order Contracts FactBox
    // 
    // 17.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Contract No."
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Fixed "Sales Order Contracts FactBox" link
    // 
    // 22.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   *"Deal Type" field moved to the general tab
    // 
    // 21.03.2014 Elva Baltic P18 #RX012 MMG7.00
    //   Removed FactBox "Customer Contracts FactBox"
    //   Added FactBox "Sales Order Contracts FactBox"
    // 
    // 17.07.2013 EDMS P8
    //   * Added function Split
    Editable = false;
    Editable = false;
    Editable = PaymentMethodEditable;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    PromotedActionCategories = 'New,Process,Reports,Vehicle Module';
    layout
    {
        modify(SalesLines)
        {
            Visible = NOT VehicleTradeDocument;
        }


        //Unsupported feature: Code Modification on "Control 6.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF GETFILTER("Sell-to Customer No.") = xRec."Sell-to Customer No." THEN
          IF "Sell-to Customer No." <> xRec."Sell-to Customer No." THEN
            SETRANGE("Sell-to Customer No.");

        IF ApplicationAreaSetup.IsFoundationEnabled THEN
          SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

        CurrPage.UPDATE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..7
        ShipToOptions := ShipToOptions::"Custom Address";

        CurrPage.UPDATE;
        */
        //end;


        //Unsupported feature: Code Modification on "Control 105.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        UpdatePaymentService;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        UpdatePaymentService;
        ////MIN for add the condition for Uneditable the field LC code.
        IF "Payment Method Code" <> '' THEN BEGIN
          PaymentMethodEditable := FALSE;
          "Sys. LC No." := '';
          END
          ELSE
          PaymentMethodEditable := TRUE;
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on "Control 18.OnValidate".

        //trigger (Variable: ShipAdd)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on "Control 18.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF GETFILTER("Bill-to Customer No.") = xRec."Bill-to Customer No." THEN
          IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
            SETRANGE("Bill-to Customer No.");

        IF ApplicationAreaSetup.IsFoundationEnabled THEN
          SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

        CurrPage.UPDATE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..7
        {ShipCount := 0;
        IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN BEGIN
          ShipAdd.RESET;
          ShipAdd.SETRANGE("Customer No.","Bill-to Customer No.");
          IF ShipAdd.FINDSET THEN REPEAT
            ShipCount += 1;
            UNTIL ShipAdd.NEXT = 0;
            IF ShipCount > 1 THEN BEGIN
              CLEAR(ShipAddPage);
              ShipAddPage.LOOKUPMODE(TRUE);
              IF ShipAddPage.RUNMODAL = ACTION::LookupOK THEN
                SETRANGE("Bill-to Customer No.");
                 END;
          END;
          }
        CurrPage.UPDATE;
        */
        //end;

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 94".

        addafter("Control 6")
        {
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
            }
            field("Deal Type Code"; "Deal Type Code")
            {
            }
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                Importance = Promoted;
                ShowMandatory = true;

                trigger OnValidate()
                begin
                    IF Rec.GETFILTER("Sell-to Customer No.") = xRec."Sell-to Customer No." THEN
                        IF Rec."Sell-to Customer No." <> xRec."Sell-to Customer No." THEN
                            Rec.SETRANGE("Sell-to Customer No.");

                    IF ApplicationAreaSetup.IsFoundationEnabled THEN
                        SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0, Rec);

                    CurrPage.UPDATE;
                end;
            }
        }
        addafter("Control 243")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                Editable = false;
            }
            field("Picker ID"; "Picker ID")
            {
            }
            field("Total CBM"; "Total CBM")
            {
                Editable = false;
            }
            field(Trip; Trip)
            {
            }
            field("Trip Start Date"; "Trip Start Date")
            {
            }
            field("Trip Start Time"; "Trip Start Time")
            {
            }
            field("Trip End Date"; "Trip End Date")
            {
            }
            field("Trip End Time"; "Trip End Time")
            {
            }
        }
        addafter("Control 245")
        {
            field("Accountability Center"; "Accountability Center")
            {
            }
        }
        addafter("Control 124")
        {
            field("Forward Accountability Center"; "Forward Accountability Center")
            {
            }
            field("Forward Location Code"; "Forward Location Code")
            {
            }
        }
        addafter("Control 9")
        {
            field("Contract No."; "Contract No.")
            {
            }
        }
        addafter("Control 129")
        {
            field("Scheme Type"; "Scheme Type")
            {
            }
            field("Financed By No."; "Financed By No.")
            {
                Visible = false;
            }
            field(FinanceByName; FinanceByName)
            {
                Caption = 'Finance By Name';
                Editable = false;
                Visible = false;
            }
            field("Re-Financed By"; "Re-Financed By")
            {
                Visible = false;
            }
            field("Financed Amount"; "Financed Amount")
            {
                Visible = false;
            }
            field("Make Code"; "Make Code")
            {
            }
            field("Model Code"; "Model Code")
            {
            }
            field("Direct Sales"; "Direct Sales")
            {
            }
            field("Booked Date"; "Booked Date")
            {
            }
            field("Tender Sales"; "Tender Sales")
            {
            }
            field("Direct Sales Commission No."; "Direct Sales Commission No.")
            {
            }
            field("Latest Flipped Date"; "Latest Flipped Date")
            {
                Editable = false;
            }
            field("Invertor Serial No."; "Invertor Serial No.")
            {
            }
            field("Dealer VIN"; "Dealer VIN")
            {
            }
            field("Fleet No."; "Fleet No.")
            {
            }
            group("Letter of Credit/Delivery Order")
            {
                Caption = 'Letter of Credit/Delivery Order';
                Visible = "Veh&SpareTrade";
                field("Sys. LC No."; "Sys. LC No.")
                {
                    Caption = 'LC / DO No.';
                    Editable = PaymentMethodEditable;

                    trigger OnValidate()
                    begin
                        //MIN for add the condition for Uneditable the field payment method code.
                        IF "Sys. LC No." <> '' THEN BEGIN
                            PaymentMethodEditable := FALSE;
                            Rec."Payment Method Code" := '';
                        END
                        ELSE
                            PaymentMethodEditable := TRUE;
                    end;
                }
                field("LC Amend No."; "LC Amend No.")
                {
                }
            }
        }
        addafter("Control 98")
        {
            field("Phone No."; "Phone No.")
            {
                Importance = Additional;
            }
            field("Mobile Phone No."; "Mobile Phone No.")
            {
                Importance = Additional;
            }
        }
        addafter(SalesLines)
        {
            part(SalesLinesVehicle; 25006469)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 105")
        {
            field("Advance Payment"; "Advance Payment")
            {
            }
            field("Booking Amount"; "Booking Amount")
            {
            }
        }
        addafter("Control 27")
        {
            field(Correction; Rec.Correction)
            {
            }
        }
        addafter("Control 145")
        {
            field("Province No."; "Province No.")
            {
            }
        }
        addafter("Control 1907468901")
        {
            group("Booking Advance")
            {
                Caption = 'Booking Advance';
                field("Advance Payment Mode"; "Advance Payment Mode")
                {
                }
                field("Advance Payment Account"; "Advance Payment Account")
                {
                }
                field("Advance Cheque No"; "Advance Cheque No")
                {
                }
                field("Advance Amount"; "Advance Amount")
                {
                }
                field("Advance Received"; "Advance Received")
                {
                }
            }
            group(Vehicle)
            {
                Caption = 'Vehicle';
                Visible = SparePartDocument;
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Make Code2"; "Make Code")
                {
                }
                field("Model Code2"; "Model Code")
                {
                }
            }
            group("Battery Reference")
            {
                Caption = 'Battery Reference';
                field("Warranty Claim No."; "Warranty Claim No.")
                {
                }
            }
        }
        addfirst("Control 1900000007")
        {
            part("Scan QR"; 50021)
            {
                Caption = 'Scan QR';
                SubPageLink = No.=FIELD(No.);
            }
        }
        addafter("Control 1906127307")
        {
            part(; 50056)
            {
                ApplicationArea = Suite;
                Provider = "58";
                SubPageLink = Memo No.=FIELD(Document Type), Document Date=FIELD(Document No.), Status=FIELD(Line No.);
            }
            part("Vechile Factbox";50055)
            {
                Provider = "58";
                SubPageLink = VIN=FIELD(VIN);
            }
        }
        moveafter("Control 111";"Control 221")
    }
    actions
    {
        modify(CalculateInvoiceDiscount)
        {
            Visible = false;
        }


        //Unsupported feature: Code Insertion (VariableCollection) on "Post(Action 75).OnAction".

        //trigger (Variable: PurchaseHeader)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on "Post(Action 75).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"Posted Document");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*

            {IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN BEGIN
              TESTFIELD("Make Code");
              TESTFIELD("Model Code");
            END;
            }

            //***SM 07-08-2013 to check the vehicle discount limit of SalesPerson
            SalesLine.RESET;
            SalesLine.SETRANGE("Document No.","No.");
            IF SalesLine.FINDFIRST THEN BEGIN
              IF SalesLine."Line Discount %" <> 0 THEN //sandeep
                SalesLine.VehMaxSalesDiscCheck ;
            END;

            //*** SM 14-06-2013 to check the commission no. in case of direct sales.
            IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN BEGIN
                IF "Direct Sales" THEN
                   TESTFIELD("Direct Sales Commission No.");
            END;



            //*** SM 14-06-2013 VAT Registration No. mandatory
            {Customer.RESET;
            Customer.SETRANGE("No.","Bill-to Customer No.");
            IF Customer.FINDFIRST THEN BEGIN
               Customer.TESTFIELD("VAT Registration No.");
            END;}

            {
            //*** SM 26-06-2013 to check the valid period of the created insurance memo for the specific vehicles
            IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN BEGIN
                SalesLine.RESET;
                SalesLine.SETRANGE("Document No.","No.");
                IF SalesLine.FINDFIRST THEN BEGIN
                    Vehicle.RESET;
                    Vehicle.SETRANGE("Serial No.",SalesLine."Vehicle Serial No.");
                    IF Vehicle.FINDFIRST THEN BEGIN
                        Vehicle.CALCFIELDS("Insurance Memo No.");
                        Vehicle.CALCFIELDS("Insurance Policy No.");
                        Vehicle.TESTFIELD("Insurance Memo No.");
                        Vehicle.TESTFIELD("Insurance Policy No.");
                        InsMemoLine.RESET;
                        InsMemoLine.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
                        IF InsMemoLine.FINDLAST THEN BEGIN
                           RefNo := InsMemoLine."Reference No.";
                           InsMemoHdr.RESET;
                           InsMemoHdr.SETRANGE("Reference No.",RefNo);
                           IF InsMemoHdr.FINDLAST THEN BEGIN
                              CheckDate := CALCDATE('+' +FORMAT(InsMemoHdr."Valid Period"),InsMemoHdr."Memo Date");
                              MESSAGE(FORMAT(CheckDate));
                              IF WORKDATE > CheckDate THEN
                                 ERROR(ExpiredInsMemo);
                           END;
                        END;
                    END;
                END;
            END; //commented by chandra 05.07.2013 to ease the shipment of vehiles in early period of implement..
            //*** SM 26-06-2013 to check the valid period of the created insurance memo for the specific vehicles
            }


            recsalesHrd.COPY(Rec);
            Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"Posted Document"); //standard code commented pram


            //***RNM 29-08-13 for temporary fix of the sales order archive**********
            ArchiveManagement.ArchiveSalesDocument(Rec);
            CurrPage.UPDATE(FALSE);
            //**********************************************************************
            */
        //end;
        addafter("Action 62")
        {
            action("<Action63>")
            {
                Caption = 'Terms & Conditions';
                Image = ViewComments;
                RunObject = Page 67;
                                RunPageLink = Document Type=FIELD(Document Type), No.=FIELD(No.), Document Line No.=CONST(0);
            }
        }
        addafter("Action 17")
        {
            group("&Vehicle")
            {
                Caption = '&Vehicle';
                action("Process Checklists")
                {
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    RunObject = Page 25006010;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.);
                }
            }
        }
        addafter(CalculateInvoiceDiscount)
        {
            action("<Action1000000018>")
            {
                Caption = 'Get Dealer Discount';
                Image = CalculateInvoiceDiscount;

                trigger OnAction()
                begin
                    ShowDiscounts
                end;
            }
        }
        addafter("Action 204")
        {
            action("Post Booking Amount")
            {
                Caption = 'Post Booking Amount';

                trigger OnAction()
                var
                    lGenJnlPostLine: Codeunit "12";
                    lGenJnlLine: Record "81";
                    "lResp.Center": Record "5714";
                    lTempJnlLineDim: Record "480" temporary;
                    lNoSeriesMngt: Codeunit "396";
                    lGenLineBatch: Record "232";
                begin

                    TESTFIELD("Advance Received",FALSE);
                    // Post Advance Booking Amount
                    lGenJnlLine.INIT;
                    IF UserMgt.DefaultResponsibility THEN BEGIN
                      "lResp.Center".GET("Responsibility Center");
                      lGenLineBatch.GET("lResp.Center"."Advance Booking Template","lResp.Center"."Advance Booking Batch");
                      lGenJnlLine.VALIDATE("Journal Template Name","lResp.Center"."Advance Booking Template");
                      lGenJnlLine.VALIDATE("Journal Batch Name","lResp.Center"."Advance Booking Batch");
                    END
                    ELSE BEGIN
                      AccCenter.GET("Accountability Center");
                      lGenLineBatch.GET(AccCenter."Advance Booking Template",AccCenter."Advance Booking Batch");
                      lGenJnlLine.VALIDATE("Journal Template Name",AccCenter."Advance Booking Template");
                      lGenJnlLine.VALIDATE("Journal Batch Name",AccCenter."Advance Booking Batch");
                    END;

                    lGenJnlLine."Line No.":=10000;
                    lGenJnlLine."Document No.":=lNoSeriesMngt.GetNextNo(lGenLineBatch."No. Series",WORKDATE,TRUE);
                    lGenJnlLine."Posting Date":=WORKDATE;

                    IF "Advance Payment Mode"="Advance Payment Mode"::Bank THEN BEGIN
                      lGenJnlLine."Account Type":=lGenJnlLine."Account Type"::"Bank Account";
                      lGenJnlLine."Cheque No.":="Advance Cheque No";
                      END
                      ELSE
                      lGenJnlLine."Account Type":=lGenJnlLine."Account Type"::"G/L Account";
                    lGenJnlLine.VALIDATE("Account No.","Advance Payment Account");
                    lGenJnlLine.VALIDATE(Amount,"Advance Amount");
                    lGenJnlLine."Bal. Account Type":=lGenJnlLine."Bal. Account Type"::Customer;
                    lGenJnlLine.VALIDATE("Bal. Account No.","Sell-to Customer No.");
                    lGenJnlLine.Description:='Booking Advance-Sales Order No-'+"No.";
                    lGenJnlLine.VALIDATE("Sales Order No.","No.");
                    lGenJnlLine.INSERT;
                    //lGenJnlPostLine.RunWithoutCheck(lGenJnlLine,lTempJnlLineDim);
                    "Advance Received":=TRUE;
                    MODIFY;

                    MESSAGE('Booking Amount Successfully Posted');
                end;
            }
            action("Reverse Booking Amount")
            {
                Caption = 'Reverse Booking Amount';

                trigger OnAction()
                var
                    lGenJnlPostLine: Codeunit "12";
                    lGenJnlLine: Record "81";
                    "lResp.Center": Record "5714";
                    lTempJnlLineDim: Record "480" temporary;
                    lNoSeriesMngt: Codeunit "396";
                    lGenLineBatch: Record "232";
                begin
                    TESTFIELD("Advance Reversed",FALSE);

                    // Post Advance Booking Amount
                    lGenJnlLine.INIT;
                    IF UserMgt.DefaultResponsibility THEN BEGIN
                      "lResp.Center".GET("Responsibility Center");
                      lGenLineBatch.GET("lResp.Center"."Advance Booking Template","lResp.Center"."Advance Booking Batch");
                      lGenJnlLine.VALIDATE("Journal Template Name","lResp.Center"."Advance Booking Template");
                      lGenJnlLine.VALIDATE("Journal Batch Name","lResp.Center"."Advance Booking Batch");
                    END
                    ELSE BEGIN
                      AccCenter.GET("Accountability Center");
                      lGenLineBatch.GET(AccCenter."Advance Booking Template",AccCenter."Advance Booking Batch");
                      lGenJnlLine.VALIDATE("Journal Template Name",AccCenter."Advance Booking Template");
                      lGenJnlLine.VALIDATE("Journal Batch Name",AccCenter."Advance Booking Batch");
                    END;
                    lGenJnlLine."Line No.":=10000;

                    lGenJnlLine."Document No.":=lNoSeriesMngt.GetNextNo(lGenLineBatch."No. Series",WORKDATE,TRUE);
                    lGenJnlLine."Posting Date":=WORKDATE;

                    lGenJnlLine."Account Type":=lGenJnlLine."Account Type"::Customer;
                    lGenJnlLine.VALIDATE("Account No.","Sell-to Customer No.");
                    lGenJnlLine.VALIDATE(Amount,"Advance Amount");
                    IF "Advance Payment Mode"="Advance Payment Mode"::Bank THEN BEGIN
                      lGenJnlLine."Account Type":=lGenJnlLine."Account Type"::"Bank Account";
                      lGenJnlLine."Cheque No.":="Advance Cheque No";
                      END
                      ELSE
                      lGenJnlLine."Bal. Account Type":=lGenJnlLine."Bal. Account Type"::"G/L Account";
                    lGenJnlLine.VALIDATE(lGenJnlLine."Bal. Account No.","Advance Payment Account");
                    lGenJnlLine.Description:='Rev. Booking Advance-Sales Order No-'+"No.";
                    lGenJnlLine.INSERT;
                    //lGenJnlPostLine.RunWithoutCheck(lGenJnlLine,lTempJnlLineDim);
                    "Advance Reversed":=TRUE;
                    MODIFY;
                    MESSAGE('Booking Amount Reversed Successfully');
                end;
            }
            separator()
            {
            }
            action("<Action1000000009>")
            {
                Caption = 'Customer Allocation';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 33020097;
                                Visible = VehicleTradeDocument;

    trigger OnAction()
    begin
        //***SM 25-06-2013 to create lines in customer allocation table
        AllocateCustomer
    end;
            }
            action("<Action1000000011>")
            {
                Caption = 'Allocation Entries';
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = VehicleTradeDocument;

                trigger OnAction()
                begin
                    //***SM 25-06-2013 to run the allocation entry page
                    SalesLine.RESET;
                    SalesLine.SETRANGE("Document No.","No.");
                    IF SalesLine.FINDFIRST THEN BEGIN
                       CustAllocation.RESET;
                       CustAllocation.SETRANGE("Model Version No.",SalesLine."Model Version No.");
                       CustAllocation.SETRANGE("Booked Date","Booked Date");
                       PAGE.RUNMODAL(33020097,CustAllocation);
                    END;
                end;
            }
            action("Customer Flip")
            {
                Caption = 'Customer Flip';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = VehicleTradeDocument;

                trigger OnAction()
                begin
                    //***SM 26-06-2013 to swap the customers in two sales orders

                    TempSalesNoCustAllocation := "No.";
                    TempCustomerNo := "Sell-to Customer No.";
                    TempQuoteNo := "Quote No.";

                    //to get the applied customer no. from the customer allocation entry
                    CustAllocation.RESET;
                    CustAllocation.SETRANGE(Applied,TRUE);
                    IF CustAllocation.FINDFIRST THEN BEGIN
                       VALIDATE("Sell-to Customer No.",CustAllocation."Customer No.");
                       "Quote No." := CustAllocation."Quote No.";
                       VALIDATE("Latest Flipped Date",TODAY);
                       MODIFY;
                       TempSalesOrderNo := CustAllocation."Sales Order No.";
                       //MESSAGE(TempSalesOrderNo);
                       CustAllocation."Sales Order No." := "No.";
                       //MESSAGE(CustAllocation."Sales Order No.");
                       CustAllocation.MODIFY;
                       CustAllocation1.RESET;
                       CustAllocation1.SETRANGE("Sales Order No.","No.");
                       CustAllocation1.SETRANGE(Applied,FALSE);
                       IF CustAllocation1.FINDFIRST THEN BEGIN
                          CustAllocation1."Sales Order No." := TempSalesOrderNo;
                          CustAllocation1."Quote No." := TempQuoteNo;
                          CustAllocation1.MODIFY;
                       END;
                       CustAllocation.Applied := FALSE;
                       CustAllocation.MODIFY;
                    END ELSE
                        ERROR(NoAppliedEntries);


                    IF TempSalesOrderNo <> '' THEN BEGIN
                       SalesHeader.RESET;
                       SalesHeader.SETRANGE("No.",TempSalesOrderNo);
                       IF SalesHeader.FINDFIRST THEN BEGIN
                          SalesHeader.VALIDATE("Sell-to Customer No.",TempCustomerNo);
                          SalesHeader."Quote No." := TempQuoteNo;
                          SalesHeader.VALIDATE("Latest Flipped Date",TODAY);
                          SalesHeader.MODIFY;
                       END;
                    END;
                end;
            }
            action("Get Scheme Discount")
            {
                Caption = 'Get Scheme Discount';
                Image = Trace;

                trigger OnAction()
                begin
                    //***SM 10-08-2013 to get schemewise discount
                    GetSchemeDiscount(Rec)
                end;
            }
        }
        addafter(IncomingDocument)
        {
            action("<Action1101904040>")
            {
                Caption = 'Split Document';
                Ellipsis = true;
                Image = Splitlines;

                trigger OnAction()
                begin
                    SalesSplittingLine.OpenFormForDoc(Rec);
                end;
            }
        }
        addfirst("Action 25")
        {
            separator()
            {
            }
            action("Apply Vehicle Marginal VAT")
            {
                Caption = 'Apply Vehicle Marginal VAT';
                Image = VATEntries;

                trigger OnAction()
                begin
                    ApplyVehMarginalVAT
                end;
            }
            action("Prepayment-Change Bill-to Cust.")
            {
                Caption = 'Prepayment-Change Bill-to Cust.';
                Image = Prepayment;

                trigger OnAction()
                var
                    SalesPostPrepayment: Codeunit "442";
                begin
                    CLEAR(SalesPostPrepayment);
                    SalesPostPrepayment.ChangeBillToCustomer(Rec);
                end;
            }
        }
        addafter(Post)
        {
            action("Post and &Print")
            {
                Caption = 'Post and &Print';
                Ellipsis = true;
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F9';

                trigger OnAction()
                var
                    PurchaseHeader: Record "38";
                    Vehi: Record "33019823";
                begin
                    SalesLine.RESET;
                    SalesLine.SETRANGE("Document No.","No.");
                    IF SalesLine."Document Profile" = SalesLine."Document Profile"::"Vehicles Trade" THEN BEGIN
                        IF SalesLine.FINDFIRST THEN BEGIN
                           /*Vehicle.RESET;
                           Vehicle.SETRANGE("Serial No.",SalesLine."Vehicle Serial No.");
                                IF Vehicle.FINDFIRST THEN BEGIN
                                    Vehicle.CALCFIELDS("Insurance Policy No.");
                                    Vehicle.TESTFIELD("Insurance Policy No.");
                                 END;
                                 */
                                 IF Vehi.GET(SalesLine."Vehicle Serial No.") THEN BEGIN
                                   Vehi.CALCFIELDS("Insurance Policy No.");
                                   Vehi.TESTFIELD("Insurance Policy No.");
                                 END;
                        END;
                    END;
                    
                    IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN BEGIN
                      TESTFIELD("Make Code");
                      TESTFIELD("Model Code");
                    END;

                end;
            }
        }
        addfirst("Action 223")
        {
            action("Order Confirmation")
            {
                Caption = 'Order Confirmation';
                Ellipsis = true;
                Image = Print;
                Visible = false;

                trigger OnAction()
                begin
                    DocPrint.PrintSalesOrder(Rec,Usage::"Order Confirmation");
                end;
            }
        }
        addafter("Action 225")
        {
            action("Vehicle Delivery Order")
            {
                Caption = 'Vehicle Delivery Order';
                Image = Print;
                Promoted = false;

                trigger OnAction()
                begin
                     //REPORT.RUNMODAL(33020199,TRUE,FALSE,SalesShipmentheader);
                    //CurrPage.SETSELECTIONFILTER(SalesShipmentheader);
                    //CurrPage.SETSELECTIONFILTER(SalesShipmentheader);
                    REPORT.RUNMODAL(33020199,TRUE,FALSE);
                    //Sipradi - YS Begin
                    /*
                    SalesShipmentheader.FIND('-');
                    IF SalesShipmentheader."Document Profile" = "Document Profile"::Service THEN BEGIN
                      WITH SalesShipmentheader DO BEGIN
                        REPORT.RUNMODAL(33020199,TRUE,FALSE,SalesShipmentheader)
                      END;
                    END
                    ELSE
                      SalesShipmentheader.PrintRecords(TRUE);
                      */

                end;
            }
            action("<Action1102159021>")
            {
                Caption = 'Allotment Letter';

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(SalesHeader);
                    REPORT.RUNMODAL(50022,TRUE,TRUE,SalesHeader);
                end;
            }
        }
        addafter("Action 5")
        {
            action(Print)
            {
                Caption = 'Print';
                Image = ServiceAgreement;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesLine: Record "37";
                    DocMgt: Codeunit "25006000";
                    DocReport: Record "25006011";
                begin
                    SalesLine.RESET;
                    DocMgt.PrintCurrentDoc("Document Profile", 1, 1, DocReport);
                    DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine,FALSE);
                end;
            }
            action(Email)
            {
                Caption = 'Email';
                Image = Email;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesLine: Record "37";
                    DocMgt: Codeunit "25006000";
                    DocReport: Record "25006011";
                begin
                    SalesLine.RESET;
                    DocMgt.PrintCurrentDoc("Document Profile", 1, 1, DocReport);
                    DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine,TRUE);
                end;
            }
        }
        addafter("Action 224")
        {
            action("Generate QR")
            {
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //QRPrintMgt.CreateSalesQRCode(Rec);
                end;
            }
            action("Forward Sales Order")
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ForwardSalesOrder(Rec);
                end;
            }
        }
    }

    var
        PurchaseHeader: Record "38";
        recsalesHrd: Record "36";

    var
        ShipAdd: Record "222";
        ShipCount: Integer;
        ShipAddPage: Page "301";

    var
        SalesSplittingLine: Record "25006042";

    var
        SalesInvHeader: Record "36";

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        LostSaleMgt: Codeunit "25006504";
        Contact: Record "5050";
        PipelineHistory1: Record "33020198";
        PipelineHistory2: Record "33020198";
        SalesShipmentheader: Record "110";
        SalesHeader: Record "36";
        UserSetup: Record "91";
        FinanceByName: Text[250];
        ISVisible: Boolean;
        AccCenter: Record "33019846";
        SalesLine: Record "37";
        CustAllocation: Record "33019860";
        InsMemoLine: Record "33020166";
        InsMemoHdr: Record "33020165";
        RefNo: Code[20];
        CheckDate: Date;
        Vehicle: Record "25006005";
        TempSalesOrderNo: Code[20];
        TempCustomerNo: Code[20];
        TempSalesNoCustAllocation: Code[20];
        CustAllocation1: Record "33019860";
        Customer: Record "18";
        SalesPriceCalcMgt: Codeunit "7000";
        SalesLine2: Record "37";
        [InDataSet]
        "Veh&SpareTrade": Boolean;
        TempQuoteNo: Code[20];
        NoAppliedEntries: Label 'There are no applied entries to swap the customers. Please choose the customer from customer alloctaion entries.';
        [InDataSet]
        PaymentMethodEditable: Boolean;
        QRPrintMgt: Codeunit "50007";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetControlVisibility;
    UpdateShipToBillToGroupVisibility;
    WorkDescription := GetWorkDescription;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
      SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
    //EDMS >>
    #1..3

    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
      "Veh&SpareTrade" := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
                       ("Document Profile" = "Document Profile"::"Spare Parts Trade");
    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****

    {
    IF Contact.GET("Financed By No.") THEN
      "Financed By" := Contact.Name + ', ' + Contact.Address
    ELSE
      "Financed By" := '';
    }

    //ShipToOptions := ShipToOptions::"Custom Address";
    //BillToOptions := BillToOptions::"Default (Customer)";
    */
    //end;


    //Unsupported feature: Code Modification on "OnDeleteRecord".

    //trigger OnDeleteRecord(): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CurrPage.SAVERECORD;
    EXIT(ConfirmDeletion);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    LostSaleMgt.OnSalesHeaderDelete(Rec); //EDMS
    CurrPage.SAVERECORD;
    EXIT(ConfirmDeletion);
    */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
    /*
    xRec.INIT;
    "Responsibility Center" := UserMgt.GetSalesFilter;
    IF (NOT DocNoVisible) AND ("No." = '') THEN
      SetSellToCustomerFromFilter;

    SetDefaultPaymentServices;
    UpdateShipToBillToGroupVisibility;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..7
    //EDMS >>
      CASE DocumentProfileFilter OF
        FORMAT("Document Profile"::"Vehicles Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Vehicles Trade";
          VehicleTradeDocument := TRUE;
          "Veh&SpareTrade" := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
        END;
        FORMAT("Document Profile"::"Spare Parts Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Spare Parts Trade";
          SparePartDocument := TRUE;
          "Veh&SpareTrade" := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
        END;
      END;
    //EDMS >>
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF UserMgt.GetSalesFilter <> '' THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
      FILTERGROUP(0);
    END;

    SETRANGE("Date Filter",0D,WORKDATE - 1);

    SetDocNoVisible;
    #10..12

    IF "Quote No." <> '' THEN
      ShowQuoteNo := TRUE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //FilterOnRecord;
    {
    #1..5
    }
    #7..15
    //EDMS >>
      FILTERGROUP(3);
      DocumentProfileFilter := GETFILTER("Document Profile");
      FILTERGROUP(0);
    //EDMS <<

     UserSetup.GET(USERID);
     IF UserSetup."Batt-Lube User" = TRUE THEN BEGIN
        "Battery Document" := TRUE;
     END;
     PaymentMethodEditable := TRUE;
    */
    //end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        IF ("Document Profile" = "Document Profile"::"Vehicles Trade") THEN
            IF UserSetup."Allow View all Veh. Invoice" THEN
                SkipFilter := TRUE;
        IF NOT SkipFilter THEN BEGIN
            RespCenterFilter := UserMgt.GetSalesFilter();
            IF RespCenterFilter <> '' THEN BEGIN
                FILTERGROUP(2);
                IF UserMgt.DefaultResponsibility THEN
                    SETRANGE("Responsibility Center", RespCenterFilter)
                ELSE
                    SETRANGE("Accountability Center", RespCenterFilter);
                FILTERGROUP(0);
            END;
        END;
    end;

    procedure ShowDiscounts()
    var
        SalesLine: Record "37";
        Customer: Record "18";
    begin
        IF Customer.GET("Sell-to Customer No.") THEN BEGIN
            IF Customer."Is Dealer" THEN BEGIN
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", "Document Type");
                SalesLine.SETRANGE("Document No.", "No.");
                SalesLine.SETRANGE("Line Type", SalesLine."Line Type"::Vehicle);
                IF SalesLine.FINDSET THEN BEGIN
                    SalesLine.TESTFIELD("Model Version No.");
                    SalesLine.TESTFIELD("Unit Price");
                    CLEAR(SalesPriceCalcMgt);
                    SalesPriceCalcMgt.GetInvoiceDiscount(Rec, SalesLine);
                END;
            END;
        END;
    end;
}

