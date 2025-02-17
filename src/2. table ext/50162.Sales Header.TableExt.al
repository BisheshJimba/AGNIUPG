tableextension 50162 tableextension50162 extends "Sales Header"
{
    // 02.05.2017 EB.P7
    //   Added fields:
    //     "Customer Signature Image"
    //     "Customer Signature Text"
    //     "Employee Signature Image"
    //     "Employee Signature Text"
    // 
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    //   Modified "Sell-to Contact No." OnValidate trigger
    //   Modified "Sell-to Customer No." OnValidate trigger
    // 
    // 05.05.2016 EB.P7 #T084
    //   Modified Location Code OnValidate trigger. Removed CreateDim function. (bug changing customer.)
    //   Modified CreateSalesLine
    // 
    // 02.05.2016 EB.P7 #WSH_23
    //   Modified FindContVehilce function.
    // 
    // 16.03 2016 EB.P7 Branch Setup
    //   Modified SetUserDefaultValues, Usert Profile Setup to Branch Profile Setup
    // 
    // 16.04.2015 EB.P7 #Merge
    //   CreateDimSetForPrepmtAccDefaultDim() Modified to Call CreateDim with suficient params.
    //   CreateSalesLine function modified. EDMS functionality moved to function.
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 09.06.2014 Elva Baltic P8 #F0002 EDMS7.10
    //   * VIN became to Normal type.
    // 
    // 07.05.2014 Elva Baltic P8 #S0083 MMG7.00
    //   * Default values should be set at SellToCustomer. Default values must be taken only if empty!
    // 
    // 28.04.2014 Elva Baltic P8 #S0075 MMG7.00
    //   * Fix in ApplyVehMarginalVAT need not to TESTFIELD of setup.
    // 
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified trigger:
    //     OnDelete()
    //   Added procedure:
    //     SetDontFindContract
    // 
    // 17.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     RecreateSalesLines
    //   Added code to:
    //     Contract No. - OnValidate()
    //     Contract No. - OnLookup()
    //     Bill-to Customer No. - OnValidate()
    //   Delete commented code in:
    //     Sell-to Customer No. - OnValidate()
    //   Added procedure:
    //     FindContract
    // 
    // 16.04.2014 Elva Baltic P7 #RX MMG7.00
    //   * TradeIn Function added
    // 
    // 08.04.2014 Elva Baltic P7 #RX MMG7.00
    //   * Field "Bill-to Bank Acc. No." added
    // 
    // 27.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *"Deal Type Code" added to CreateDim
    // 
    // 26.03.2014 Elva Baltic P18 #F011 MMG7.00
    //   Added Code to "Vehicle Serial No. - OnValidate()"
    // 
    // 26.03.2014 Elva Baltic P18 #RX027 MMG7.00
    //   Modified Function
    //     CreateDim() - Added dimension for "Payment Method Code"
    // 
    // 26.03.2014 Elva Baltic P7 #Marginal VAT MMG7.00
    //   Modified function "ApplyVehMarginalVAT"
    // 
    // 21.03.2014 Elva Baltic P18 #RX012 MMG7.00
    //   Added field 50200 "Contract No."
    //   Added Code to
    //     Sell-to Customer No. - OnValidate()
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of Vehicle default dimension
    // 11.06.2013 EDMS P8
    //   Merged with NAV2009
    // 
    // 28.02.2013 EDMS P8
    //   * FIX calculation of vehicle marginal VAT process
    // 
    // 23.01.2013 EDMS P8
    //   * small fix to update VIN in lines
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3
    //   * renamed field Kilometrage to 'Variable Field Run 1'
    // 
    // 09.05.2008. EDMS P2
    //   * Added code OnInsert
    // 
    // 24.09.2007. EDMS P2
    //   * Added field Kilometrage
    // 
    // 10.09.2007 EDMS P3
    //   * Added 2 functions related to PutInTakeOut functionality:TransferPutIn and TransferTakeOut
    DrillDownPageID = 45;
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Bill-to Name"(Field 5)".


        //Unsupported feature: Property Modification (Data type) on ""Bill-to Name 2"(Field 6)".

        modify("Bill-to City")
        {
            TableRelation = IF (Bill-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name"(Field 13)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name 2"(Field 14)".

        modify("Ship-to City")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Recalculate Invoice Disc."(Field 56)".


        //Unsupported feature: Property Modification (CalcFormula) on "Amount(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amount Including VAT"(Field 61)".


        //Unsupported feature: Property Modification (Data type) on ""Sell-to Customer Name"(Field 79)".


        //Unsupported feature: Property Modification (Data type) on ""Sell-to Customer Name 2"(Field 80)".

        modify("Sell-to City")
        {
            TableRelation = IF (Sell-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Sell-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Sell-to Country/Region Code));
        }
        modify("Sell-to Post Code")
        {
            TableRelation = IF (Sell-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Sell-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Sell-to Country/Region Code));
        }
        modify("Ship-to Post Code")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }

        //Unsupported feature: Property Insertion (Editable) on ""Document Date"(Field 99)".


        //Unsupported feature: Property Insertion (Editable) on ""Shipping Agent Code"(Field 105)".

        modify("Quote No.")
        {
            TableRelation = "Sales Header".No. WHERE (Document Type=FILTER(Quote),
                                                      Sell-to Customer No.=FIELD(Sell-to Customer No.));
        }
        modify("Direct Debit Mandate ID")
        {
            TableRelation = "SEPA Direct Debit Mandate" WHERE (Customer No.=FIELD(Bill-to Customer No.),
                                                               Closed=CONST(No),
                                                               Blocked=CONST(No));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Invoice Discount Amount"(Field 1305)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Archived Versions"(Field 5043)".

        modify("Opportunity No.")
        {
            TableRelation = IF (Document Type=FILTER(<>Order)) Opportunity.No. WHERE (Contact No.=FIELD(Sell-to Contact No.),
                                                                                      Closed=CONST(No))
                                                                                      ELSE IF (Document Type=CONST(Order)) Opportunity.No. WHERE (Contact No.=FIELD(Sell-to Contact No.),
                                                                                                                                                  Sales Document No.=FIELD(No.),
                                                                                                                                                  Sales Document Type=CONST(Order));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Shipped Not Invoiced"(Field 5751)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Shipped"(Field 5752)".


        //Unsupported feature: Property Modification (CalcFormula) on "Shipped(Field 5755)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Late Order Shipping"(Field 5795)".

        modify("Assigned User ID")
        {

            //Unsupported feature: Property Modification (Data type) on ""Assigned User ID"(Field 9000)".

            Description = 'Reduced';

            //Unsupported feature: Property Insertion (Editable) on ""Assigned User ID"(Field 9000)".

        }


        //Unsupported feature: Code Insertion (VariableCollection) on ""Sell-to Customer No."(Field 2).OnValidate".

        //trigger (Variable: Cont)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Sell-to Customer No."(Field 2).OnValidate".

        //trigger "(Field 2)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CheckCreditLimitIfLineNotInsertedYet;
            TESTFIELD(Status,Status::Open);
            IF ("Sell-to Customer No." <> xRec."Sell-to Customer No.") AND
               (xRec."Sell-to Customer No." <> '')
            THEN BEGIN
            #6..24
                  INIT;
                  SalesSetup.GET;
                  "No. Series" := xRec."No. Series";
                  InitRecord;
                  InitNoSeries;
                  EXIT;
                END;
            #32..70
            "VAT Registration No." := Cust."VAT Registration No.";
            "VAT Country/Region Code" := Cust."Country/Region Code";
            "Shipping Advice" := Cust."Shipping Advice";
            "Responsibility Center" := UserSetupMgt.GetRespCenter(0,Cust."Responsibility Center");
            VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center"));

            IF "Sell-to Customer No." = xRec."Sell-to Customer No." THEN
              IF ShippedSalesLinesExist OR ReturnReceiptExist THEN BEGIN
                TESTFIELD("VAT Bus. Posting Group",xRec."VAT Bus. Posting Group");
                TESTFIELD("Gen. Bus. Posting Group",xRec."Gen. Bus. Posting Group");
              END;

            "Sell-to IC Partner Code" := Cust."IC Partner Code";
            "Send IC Document" := ("Sell-to IC Partner Code" <> '') AND ("IC Direction" = "IC Direction"::Outgoing);

            #86..103

            IF NOT SkipSellToContact THEN
              UpdateSellToCont("Sell-to Customer No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            CheckCreditLimitIfLineNotInsertedYet;
            TESTFIELD(Status,Status::Open);
            //SP
            {IF "Sell-to Customer No." <> xRec."Sell-to Customer No." THEN BEGIN
              ShipAdd.RESET;
              ShipAdd.SETRANGE("Customer No.","Sell-to Customer No.");
              IF ShipAdd.COUNT > 1 THEN BEGIN
                  CLEAR(ShipAddPage);
                  ShipAddPage.LOOKUPMODE(TRUE);
                  ShipAddPage.SETTABLEVIEW(ShipAdd);
                  IF ShipAddPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ShipAddPage.GETRECORD(ShipAdd);
                      VALIDATE("Bill-to Address",ShipAdd.Address);
                      VALIDATE("Bill-to Address 2",ShipAdd."Address 2");
                      VALIDATE("Bill-to City",ShipAdd.City);
                      VALIDATE("Bill-to Post Code",ShipAdd."Post Code");
                      VALIDATE("Bill-to County",ShipAdd.County);
                      VALIDATE("Bill-to Country/Region Code",ShipAdd."Country/Region Code");
                      VALIDATE("Ship Add Name 2",ShipAdd."Name 2"); //new field
                END;
               END;
            END;
            }
            LCClearIfSellToCustomerUsed;
            #3..27
                  InitRecord2;
            #29..73
            //"Responsibility Center" := UserSetupMgt.GetRespCenter(0,Cust."Responsibility Center");
            //VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center"));

            GLSetup.GET;
            IF UserSetupMgt.DefaultResponsibility THEN BEGIN
              "Responsibility Center" := UserSetupMgt.GetRespCenter(0,Cust."Responsibility Center");
              //make debit note default for sales document --- lookup responsibility cetner ------>>
              RespCenter2.GET(UserSetupMgt.GetRespCenter(0,Cust."Responsibility Center"));
              IF RespCenter2."Default Debit Note for Sales" THEN
                "Debit Note" := TRUE;
              //--by Surya -- 20 August 2012 --------------------------------------<<
              VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center"));
            END
            ELSE BEGIN
              "Accountability Center" := UserSetupMgt.GetRespCenter(0,Cust."Accountability Center");
              //make debit note default for sales document --- lookup responsibility cetner ------>>
              AccCenter2.GET(UserSetupMgt.GetRespCenter(0,Cust."Accountability Center"));
              IF AccCenter2."Default Debit Note for Sales" THEN
                "Debit Note" := TRUE;
              //--by Surya -- 20 August 2012 --------------------------------------<<
              VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Accountability Center"));
            END;
            #76..82

            IF Cust."Location Code for Dealer" <> '' THEN
              "Location Code" := Cust."Location Code for Dealer"; //AGNI_DEALER

            #83..106

            //20.03.2013 EDMS >>
            IF ("Vehicle Serial No." = xRec."Vehicle Serial No.") AND (NOT FindCustomer) THEN
              FindContVehicle;
            //20.03.2013 EDMS >>

            // 27.05.2016 EB.P30 >>
            IF Cont.GET("Sell-to Contact No.") THEN BEGIN
              VALIDATE("Mobile Phone No.", Cont."Mobile Phone No.");
              VALIDATE("Phone No.", Cont."Phone No.");
            END;
            // 27.05.2016 EB.P30 <<
            */
        //end;


        //Unsupported feature: Code Modification on ""No."(Field 3).OnValidate".

        //trigger "(Field 3)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "No." <> xRec."No." THEN BEGIN
              SalesSetup.GET;
              NoSeriesMgt.TestManual(GetNoSeriesCode);
              "No. Series" := '';
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF "No." <> xRec."No." THEN BEGIN
              SalesSetup.GET;
              NoSeriesMgt.TestManual(GetNoSeriesCode2);
              "No. Series" := '';
            END;
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Bill-to Customer No."(Field 4).OnValidate".

        //trigger (Variable: UserSetup)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Bill-to Customer No."(Field 4).OnValidate".

        //trigger "(Field 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);
            BilltoCustomerNoChanged := xRec."Bill-to Customer No." <> "Bill-to Customer No.";
            IF BilltoCustomerNoChanged THEN
              IF xRec."Bill-to Customer No." = '' THEN
                InitRecord
              ELSE BEGIN
                IF HideValidationDialog OR NOT GUIALLOWED THEN
                  Confirmed := TRUE
                ELSE
                  Confirmed := CONFIRM(ConfirmChangeQst,FALSE,BillToCustomerTxt);
                IF Confirmed THEN BEGIN
                  SalesLine.SETRANGE("Document Type","Document Type");
                  SalesLine.SETRANGE("Document No.","No.");
            #14..23
            GetCust("Bill-to Customer No.");
            Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,FALSE);
            Cust.TESTFIELD("Customer Posting Group");
            CheckCrLimit;
            "Bill-to Customer Template Code" := '';
            "Bill-to Name" := Cust.Name;
            "Bill-to Name 2" := Cust."Name 2";
            CopyBillToCustomerAddressFieldsFromCustomer(Cust);
            IF NOT SkipBillToContact THEN
              "Bill-to Contact" := Cust.Contact;
            "Payment Terms Code" := Cust."Payment Terms Code";
            #35..56
            "Invoice Disc. Code" := Cust."Invoice Disc. Code";
            "Customer Disc. Group" := Cust."Customer Disc. Group";
            "Language Code" := Cust."Language Code";
            "Salesperson Code" := Cust."Salesperson Code";
            "Combine Shipments" := Cust."Combine Shipments";
            Reserve := Cust.Reserve;
            IF "Document Type" = "Document Type"::Order THEN
            #64..74
              DATABASE::"Salesperson/Purchaser","Salesperson Code",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::"Customer Template","Bill-to Customer Template Code");

            VALIDATE("Payment Terms Code");
            VALIDATE("Prepmt. Payment Terms Code");
            #82..85
            IF (xRec."Sell-to Customer No." = "Sell-to Customer No.") AND
               BilltoCustomerNoChanged
            THEN BEGIN
              RecreateSalesLines(BillToCustomerTxt);
              BilltoCustomerNoChanged := FALSE;
            END;
            IF NOT SkipBillToContact THEN
              UpdateBillToCont("Bill-to Customer No.");

            "Bill-to IC Partner Code" := Cust."IC Partner Code";
            "Send IC Document" := ("Bill-to IC Partner Code" <> '') AND ("IC Direction" = "IC Direction"::Outgoing);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..4
                InitRecord2
            #6..8
                ELSE BEGIN
                  //Confirmed := CONFIRM(ConfirmChangeQst,FALSE,BillToCustomerTxt);
                  Confirmed := TRUE;
                END;
            #11..26

            CustomerPostingGroup.GET(Cust."Customer Posting Group");
            IF NOT CustomerPostingGroup."Skip VAT Reg. No. Check" THEN
              Cust.TESTFIELD("VAT Registration No.");

            #27..30

            //SP
            IF SkipIfService AND (NOT SkipCopy) AND GUIALLOWED THEN BEGIN
              IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN BEGIN
               //   ShipAdd.SETRANGE("Customer No.","Sell-to Customer No.");

                    ShipAdd.SETRANGE("Customer No.","Bill-to Customer No.");
                    ShipAddPage.LOOKUPMODE := TRUE;
                    ShipAddPage.SETTABLEVIEW(ShipAdd);
                    COMMIT;
                    IF ShipAdd.COUNT > 0 THEN BEGIN
                    IF ShipAddPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                      ShipAddPage.GETRECORD(ShipAdd);
                      //VALIDATE("Ship-to Code",ShipAdd.Code);
                        CompanyInfo.GET;
                        IF CompanyInfo."Balaju Auto Works" THEN BEGIN
                          VALIDATE("Bill-to Address",ShipAdd.Address);
                          VALIDATE("Bill-to Address 2",ShipAdd."Address 2");
                          VALIDATE("Bill-to City",ShipAdd.City);
                          VALIDATE("Bill-to Post Code",ShipAdd."Post Code");
                          VALIDATE("Bill-to County",ShipAdd.County);
                          VALIDATE("Bill-to Country/Region Code",ShipAdd."Country/Region Code");
                          "Ship Add Name 2" := ShipAdd."Name 2";
                          //SalesOrder.BillToOptions :=Another Customer;
                          VALIDATE("Sell-to Address", ShipAdd.Address);
                          VALIDATE("Ship-to Address", ShipAdd.Address);
                          VALIDATE("Sell-to Address 2",ShipAdd."Address 2");
                          VALIDATE("Ship-to Address 2",ShipAdd."Address 2");
                          VALIDATE("Sell-to City",ShipAdd.City);
                          VALIDATE("Ship-to City",ShipAdd.City);
                          VALIDATE("Sell-to Post Code",ShipAdd."Post Code");
                          VALIDATE("Ship-to Post Code",ShipAdd."Post Code");
                          VALIDATE("Sell-to County",ShipAdd.County);
                          VALIDATE("Ship-to County",ShipAdd.County);
                          VALIDATE("Sell-to Country/Region Code",ShipAdd."Country/Region Code");
                          VALIDATE("Ship-to Country/Region Code",ShipAdd."Country/Region Code");

                    END;
                   END;
                    END ELSE
                  CopyBillToCustomerAddressFieldsFromCustomer(Cust);
                END;
            END;
            //CopyBillToCustomerAddressFieldsFromCustomer(Cust);

            //3-April
            #32..59

            //**SM 08 Sept 2014 to flow salesperson code from customer only for document other than service
            IF "Document Profile" <> "Document Profile"::Service THEN
               "Salesperson Code" := Cust."Salesperson Code";
            //**SM 08 Sept 2014 to flow salesperson code from customer only for document other than service

            #61..77
              DATABASE::"Customer Template","Bill-to Customer Template Code",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::"Payment Method","Payment Method Code",
              DATABASE::"Deal Type","Deal Type Code", //27.03.2014 Elva Baltic P1 #RX MMG7.00
              DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
              );


            //Sipradi-YS GEN6.1.0 25006145-1 BEGIN >> Get User Branch/Costcenter (Dimension)
            IF "Document Profile" <> "Document Profile"::Service THEN BEGIN
              IF UserSetup.GET(USERID) THEN BEGIN
                IF SalesHeader_G.GET("Document Type","No.") THEN BEGIN                            // CNY.RK
                  VALIDATE("Shortcut Dimension 1 Code",UserSetup."Shortcut Dimension 1 Code");
                  VALIDATE("Shortcut Dimension 2 Code",UserSetup."Shortcut Dimension 2 Code");
                END;
              END;
            END;
            //Sipradi-YS GEN6.1.0 25006145-1 END
            #79..88
              IF NOT SkipIfService THEN //prabesh added
                RecreateSalesLines(BillToCustomerTxt);
            #90..96

            //EDMS 07.01.08
             SetUserDefaultValues;


            IF Location2.GET(UserSetup."Default Location") THEN BEGIN
              IF Location2."Default Price Group" <> '' THEN
               "Customer Price Group" := Location2."Default Price Group";
            END;
            CheckNoVATCustomer;

            //***Chandra 09-04-14 to trace flipped date of the sales order in archive to calculate
            //the no of reserved days of vehicle for particular customer**********
            ArchiveManagement.ArchiveSalesDocument(Rec);
            //**********************************************************************

            IF (xRec."Bill-to Customer No." <> "Bill-to Customer No.") AND NOT DontFindContract THEN                 // 17.04.2014 Elva Baltic P21
              FindContract;                                                                                          // 17.04.2014 Elva Baltic P21
            */
        //end;


        //Unsupported feature: Code Modification on ""Ship-to Code"(Field 12).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF ("Document Type" = "Document Type"::Order) AND
               (xRec."Ship-to Code" <> "Ship-to Code")
            THEN BEGIN
            #4..27
                "Ship-to City" := ShipToAddr.City;
                "Ship-to Post Code" := ShipToAddr."Post Code";
                "Ship-to County" := ShipToAddr.County;
                VALIDATE("Ship-to Country/Region Code",ShipToAddr."Country/Region Code");
                "Ship-to Contact" := ShipToAddr.Contact;
                "Shipment Method Code" := ShipToAddr."Shipment Method Code";
            #34..42
                  GetCust("Sell-to Customer No.");
                  "Ship-to Name" := Cust.Name;
                  "Ship-to Name 2" := Cust."Name 2";
                  CopyShipToCustomerAddressFieldsFromCustomer(Cust);
                  "Ship-to Contact" := Cust.Contact;
                  "Shipment Method Code" := Cust."Shipment Method Code";
                  "Tax Area Code" := Cust."Tax Area Code";
            #50..70
                IF xRec."Tax Liable" <> "Tax Liable" THEN
                  VALIDATE("Tax Liable");
              END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..30
                "Ship Add Name 2" := ShipToAddr."Name 2";//sp

                "Province No." := ShipToAddr."Province No."; //Min
            #31..45
                  //CopyShipToCustomerAddressFieldsFromCustomer(Cust);    //commented by ankur
                  IF "Document Type" = "Document Type"::Quote THEN
                    SetShipToAddressForQuote();
            #47..73
            */
        //end;


        //Unsupported feature: Code Modification on ""Posting Date"(Field 20).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestNoSeriesDate(
              "Posting No.","Posting No. Series",
              FIELDCAPTION("Posting No."),FIELDCAPTION("Posting No. Series"));
            #4..7
              "Prepmt. Cr. Memo No.","Prepmt. Cr. Memo No. Series",
              FIELDCAPTION("Prepmt. Cr. Memo No."),FIELDCAPTION("Prepmt. Cr. Memo No. Series"));

            IF "Incoming Document Entry No." = 0 THEN
              VALIDATE("Document Date","Posting Date");

            IF ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
               NOT ("Posting Date" = xRec."Posting Date")
            #16..25
              IF DeferralHeadersExist THEN
                ConfirmUpdateDeferralDate;
            SynchronizeAsmHeader;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..10
            IF "Incoming Document Entry No." = 0 THEN BEGIN
              VALIDATE("Document Date","Posting Date");
              VALIDATE("Shipment Date","Posting Date");
            END;
            #13..28
            */
        //end;


        //Unsupported feature: Code Modification on ""Prices Including VAT"(Field 35).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);

            IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
            #4..38
                  IF NOT RecalculatePrice THEN BEGIN
                    SalesLine."VAT Difference" := 0;
                    SalesLine.UpdateAmounts;
                  END ELSE
                    IF "Prices Including VAT" THEN BEGIN
                      SalesLine."Unit Price" :=
                        ROUND(
            #46..70
                            Currency."Amount Rounding Precision"));
                      END;
                    END;
                  SalesLine.MODIFY;
                UNTIL SalesLine.NEXT = 0;
              END;
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..41
                    //05.03.2010 EDMS P2 >>
                    LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
                    LicensePermission.SETRANGE("Object Number",CODEUNIT::VehicleSalesPriceDiscountMgt);
                    LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
                    IF NOT LicensePermission.ISEMPTY THEN
                      VehPriceMgt.UpdAssemblyHdrField(Rec,SalesLine,FIELDNO("Prices Including VAT"));   //23.11.2007 EDMS P3
                    //05.03.2010 EDMS P2 <<
                  END ELSE BEGIN
            #43..73
                    //05.03.2010 EDMS P2 >>
                    LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
                    LicensePermission.SETRANGE("Object Number",CODEUNIT::VehicleSalesPriceDiscountMgt);
                    LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
                    IF NOT LicensePermission.ISEMPTY THEN
                      VehPriceMgt.ChkAssemblyHdrSalesLine(SalesLine,FALSE)
                    //05.03.2010 EDMS P2 <<
                    END;
            #74..77
            */
        //end;


        //Unsupported feature: Code Modification on ""Salesperson Code"(Field 43).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ApprovalEntry.SETRANGE("Table ID",DATABASE::"Sales Header");
            ApprovalEntry.SETRANGE("Document Type","Document Type");
            ApprovalEntry.SETRANGE("Document No.","No.");
            ApprovalEntry.SETFILTER(Status,'%1|%2',ApprovalEntry.Status::Created,ApprovalEntry.Status::Open);
            IF NOT ApprovalEntry.ISEMPTY THEN
              ERROR(Text053,FIELDCAPTION("Salesperson Code"));

            CreateDim(
              DATABASE::"Salesperson/Purchaser","Salesperson Code",
              DATABASE::Customer,"Bill-to Customer No.",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::"Customer Template","Bill-to Customer Template Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..8
              DATABASE::Customer,"Bill-to Customer No.",
              DATABASE::"Salesperson/Purchaser","Salesperson Code",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::"Customer Template","Bill-to Customer Template Code",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::"Payment Method","Payment Method Code",
              DATABASE::"Deal Type","Deal Type Code", //27.03.2014 Elva Baltic P1 #RX MMG7.00
              DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
              );
            */
        //end;


        //Unsupported feature: Code Modification on ""Payment Method Code"(Field 104).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            PaymentMethod.INIT;
            IF "Payment Method Code" <> '' THEN
              PaymentMethod.GET("Payment Method Code");
            #4..13
              TESTFIELD("Applies-to ID",'');
              CLEAR("Payment Service Set ID");
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..16

            CreateDim(
              DATABASE::Customer,"Bill-to Customer No.",
              DATABASE::"Salesperson/Purchaser","Salesperson Code",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::"Customer Template","Bill-to Customer Template Code",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::"Payment Method","Payment Method Code",
              DATABASE::"Deal Type","Deal Type Code", //27.03.2014 Elva Baltic P1 #RX MMG7.00
              DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
              );
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Posting No. Series"(Field 108).OnValidate".

        //trigger (Variable: StplSysMgt)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Posting No. Series"(Field 108).OnValidate".

        //trigger  Series"(Field 108)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Posting No. Series" <> '' THEN BEGIN
              SalesSetup.GET;
              TestNoSeries;
              NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
            END;
            TESTFIELD("Posting No.",'');
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..3
              //NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
              NoSeriesMgt.TestSeries("Posting No. Series","Posting No. Series");
            END;
            TESTFIELD("Posting No.",'');
            */
        //end;


        //Unsupported feature: Code Modification on ""Campaign No."(Field 5050).OnValidate".

        //trigger "(Field 5050)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CreateDim(
              DATABASE::Campaign,"Campaign No.",
              DATABASE::Customer,"Bill-to Customer No.",
              DATABASE::"Salesperson/Purchaser","Salesperson Code",
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::"Customer Template","Bill-to Customer Template Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5
              DATABASE::"Customer Template","Bill-to Customer Template Code",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::"Payment Method","Payment Method Code",
              DATABASE::"Deal Type","Deal Type Code", //27.03.2014 Elva Baltic P1 #RX MMG7.00
              DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
              );
            */
        //end;


        //Unsupported feature: Code Modification on ""Sell-to Contact No."(Field 5052).OnValidate".

        //trigger "(Field 5052)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);

            IF ("Sell-to Contact No." <> xRec."Sell-to Contact No.") AND
               (xRec."Sell-to Contact No." <> '')
            #5..43

            UpdateSellToCust("Sell-to Contact No.");
            UpdateSellToCustTemplateCode;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);

            // "Document Profile" := "Document Profile" :: "Vehicles Trade"; // CNY.CRM
            #2..46
            //EDMS1.0.00 >>
             IF "Sell-to Customer No." = '' THEN
              SetUserDefaultValues;
            //EDMS1.0.00 <<

            // 27.05.2016 EB.P30 >>
            IF Cont.GET("Sell-to Contact No.") THEN BEGIN
              VALIDATE("Mobile Phone No.", Cont."Mobile Phone No.");
              VALIDATE("Phone No.", Cont."Phone No.");
            END;
            // 27.05.2016 EB.P30 <<
            */
        //end;


        //Unsupported feature: Code Modification on ""Bill-to Customer Template Code"(Field 5054).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD("Document Type","Document Type"::Quote);
            TESTFIELD(Status,Status::Open);

            #4..35
              DATABASE::"Salesperson/Purchaser","Salesperson Code",
              DATABASE::Customer,"Bill-to Customer No.",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Responsibility Center","Responsibility Center");

            IF NOT InsertMode AND
               (xRec."Sell-to Customer Template Code" = "Sell-to Customer Template Code") AND
               (xRec."Bill-to Customer Template Code" <> "Bill-to Customer Template Code")
            THEN
              RecreateSalesLines(FIELDCAPTION("Bill-to Customer Template Code"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..38
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::"Payment Method","Payment Method Code",
              DATABASE::"Deal Type","Deal Type Code", //27.03.2014 Elva Baltic P1 #RX MMG7.00
              DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
              );
            #40..45
            */
        //end;


        //Unsupported feature: Code Modification on ""Responsibility Center"(Field 5700).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);
            IF NOT UserSetupMgt.CheckRespCenter(0,"Responsibility Center") THEN
              ERROR(
            #4..12
              DATABASE::Customer,"Bill-to Customer No.",
              DATABASE::"Salesperson/Purchaser","Salesperson Code",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Customer Template","Bill-to Customer Template Code");

            IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
              RecreateSalesLines(FIELDCAPTION("Responsibility Center"));
              "Assigned User ID" := '';
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..15
              DATABASE::"Customer Template","Bill-to Customer Template Code",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::"Payment Method","Payment Method Code",
              DATABASE::"Deal Type","Deal Type Code", //27.03.2014 Elva Baltic P1 #RX MMG7.00
              DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
              );
            #17..21
            */
        //end;


        //Unsupported feature: Code Modification on ""Assigned User ID"(Field 9000).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF NOT UserSetupMgt.CheckRespCenter2(0,"Responsibility Center","Assigned User ID") THEN
              ERROR(
                Text061,"Assigned User ID",
                RespCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter2("Assigned User ID"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            {
            #1..4
            }
            GLSetup.GET;
            IF "Dealer PO No." = '' THEN BEGIN
              IF UserSetupMgt.DefaultResponsibility THEN BEGIN
                IF NOT UserSetupMgt.CheckRespCenter2(0,"Responsibility Center","Assigned User ID") THEN
                  ERROR(
                    Text061,"Assigned User ID",
                    RespCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter2("Assigned User ID"))
              END
              ELSE BEGIN
                IF NOT UserSetupMgt.CheckRespCenter2(0,"Accountability Center","Assigned User ID") THEN
                  ERROR(
                    Text061,"Assigned User ID",
                    AccCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter2("Assigned User ID"))
              END;
            END;
            */
        //end;
        field(50000;"Vehicle Regd. No.";Code[30])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            FieldClass = FlowField;
        }
        field(50001;"Battery Document";Boolean)
        {
        }
        field(50002;"Direct Sales";Boolean)
        {
            Description = '//for direct vehicle sales';
        }
        field(50004;"Salesperson Name";Text[50])
        {
            CalcFormula = Lookup(Salesperson/Purchaser.Name WHERE (Code=FIELD(Salesperson Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008;"Direct Sales Commission No.";Code[20])
        {
            Caption = 'Direct Sales Commission No.';
        }
        field(50009;"Prospect Line No.";Integer)
        {
            Description = 'CNY.CRM Populate Pipeline Management Details for the Prospect';
            TableRelation = "Pipeline Management Details"."Line No." WHERE (Prospect No.=FIELD(Sell-to Contact No.),
                                                                            Pipeline Status=CONST(Open));

            trigger OnLookup()
            begin


                // CNY.CRM >>
                PipelineMgtDetails_G.RESET;
                PipelineMgtDetails_G.SETRANGE("Prospect No.","Sell-to Contact No.");
                PipelineMgtDetails_G.SETRANGE("Pipeline Status",PipelineMgtDetails_G."Pipeline Status" :: Open);
                IF PAGE.RUNMODAL(33020138,PipelineMgtDetails_G) = ACTION :: LookupOK THEN BEGIN
                  VALIDATE("Prospect Line No.",PipelineMgtDetails_G."Line No.");
                END;
                // CNY.CRM <<
            end;

            trigger OnValidate()
            begin
                // CNY.CRM >>

                //"Document Profile" := "Document Profile" :: "Vehicles Trade";

                IF xRec."Prospect Line No." <> "Prospect Line No." THEN BEGIN
                  SalesLine_G.RESET;
                  SalesLine_G.SETRANGE("Document Type","Document Type");
                  SalesLine_G.SETRANGE("Document No.","No.");
                  SalesLine_G.SETRANGE("Prospect Line No.",xRec."Prospect Line No.");
                  IF SalesLine_G.FINDFIRST THEN
                    SalesLine_G.DELETEALL;
                END;

                PipelineMgtDetails_G.RESET;
                PipelineMgtDetails_G.SETRANGE("Prospect No.","Sell-to Contact No.");
                PipelineMgtDetails_G.SETRANGE("Line No.","Prospect Line No.");
                IF PipelineMgtDetails_G.FINDFIRST THEN BEGIN
                  "Salesperson Code" := PipelineMgtDetails_G."Salesperson Code";

                  SalesLine_G.RESET;
                  SalesLine_G.SETRANGE("Document Type","Document Type");
                  SalesLine_G.SETRANGE("Document No.","No.");
                  IF SalesLine_G.FINDLAST THEN
                    LineNo := SalesLine_G."Line No."
                  ELSE
                    LineNo := 0;

                  SalesLine_G.INIT;
                  SalesLine_G."Document Type" := "Document Type";
                  SalesLine_G."Document No." := "No.";
                  SalesLine_G."Line No." := LineNo + 10000;
                  SalesLine_G."Prospect Line No." := "Prospect Line No.";
                  SalesLine_G.Type := SalesLine_G.Type :: Item;
                  SalesLine_G."Line Type" := SalesLine_G."Line Type" :: Vehicle;
                  SalesLine_G."Make Code" := PipelineMgtDetails_G."Make Code";
                  SalesLine_G."Model Code" := PipelineMgtDetails_G."Model Code";
                  SalesLine_G.VALIDATE("Model Version No.",PipelineMgtDetails_G."Model Version No.");
                  //SalesHeader_G."Model Version No." := PipelineMgtDetails_G."Model Version No.";
                  SalesLine_G.INSERT;
                END;
                // CNY.CRM <<
            end;
        }
        field(50010;"Converted to C1";Boolean)
        {
            Description = 'CNY.CRM To handle multiple release of quote while updating Pipeline status';
            Editable = false;
        }
        field(50011;"Return Reason";Code[10])
        {
            TableRelation = "Return Reason".Code;
        }
        field(50055;"Invertor Serial No.";Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(50056;"RV RR Code";Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Revisit,Repeat Repair';
            OptionMembers = " ",Revisit,"Repeat Repair";
        }
        field(50057;"Quality Control";Code[20])
        {
            Description = 'PSF';
            TableRelation = Resource;
        }
        field(50059;"Floor Control";Code[20])
        {
            Description = 'PSF';
            TableRelation = Resource;
        }
        field(50060;"Insurance Type";Code[20])
        {
        }
        field(50096;"Booking Amount";Decimal)
        {
        }
        field(60000;"Allotment Date";Date)
        {
        }
        field(60001;"Allotment Time";Time)
        {
        }
        field(60002;"Confirmed Time";Time)
        {
        }
        field(60003;"Confirmed Date";Date)
        {
        }
        field(70000;"Dealer PO No.";Code[20])
        {
            Description = 'For Dealer Portal';
        }
        field(70001;"Dealer Tenant ID";Code[10])
        {
            Description = 'For Dealer Portal';

            trigger OnValidate()
            begin
                DealerInformation.RESET;
                DealerInformation.SETRANGE("Tenant ID","Dealer Tenant ID");
                DealerInformation.FINDFIRST;
                VALIDATE("Sell-to Customer No.",DealerInformation."Customer No.");
            end;
        }
        field(70002;"Dealer Line No.";Integer)
        {
            Description = 'For Dealer Portal';
        }
        field(70003;"Order Type";Option)
        {
            OptionCaption = ' ,Stock order,Rush Order,VOR order,Accidental';
            OptionMembers = " ","Stock order","Rush Order","VOR order",Accidental;
        }
        field(70004;"Swift Code";Text[50])
        {
        }
        field(70005;"Ship Add Name 2";Text[40])
        {
            Description = 'for shipping address';
        }
        field(90000;"Model Version No. (Sales Line)";Code[20])
        {
            CalcFormula = Lookup("Sales Line"."Model Version No." WHERE (Document Type=FIELD(Document Type),
                                                                         Document No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                recSalesLine: Record "37";
                tcDMS001: Label 'Do you want to change lines too?';
            begin
                TESTFIELD(Status,Status::Open);

                recSalesLine.RESET;
                recSalesLine.SETRANGE("Document Type","Document Type");
                recSalesLine.SETRANGE("Document No.","No.");
                IF recSalesLine.FINDSET(TRUE,FALSE) THEN
                 IF CONFIRM(tcDMS001) THEN
                  REPEAT
                   recSalesLine.VALIDATE("Deal Type Code","Deal Type Code");
                   recSalesLine.MODIFY;
                  UNTIL recSalesLine.NEXT = 0;

                //27.03.2014 Elva Baltic P1 #RX MMG7.00 >>
                CreateDim(
                  DATABASE::"Deal Type","Deal Type Code",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                  DATABASE::Campaign,"Campaign No.",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Customer Template","Bill-to Customer Template Code",
                  DATABASE::Vehicle,"Vehicle Serial No.",
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );
                //27.03.2014 Elva Baltic P1 #RX MMG7.00  <<
            end;
        }
        field(25006005;"Prepmt. Bill-to Cust. Changed";Boolean)
        {
            Caption = 'Prepmt. Bill-to Cust. Changed';
        }
        field(25006120;"Service Document No.";Code[20])
        {
            Caption = 'Service Document No.';
        }
        field(25006130;"Service Document";Boolean)
        {
            Caption = 'Service Document';
        }
        field(25006140;"Order Creator";Code[10])
        {
            Caption = 'Order Creator';
            Description = 'Internal';
            TableRelation = Salesperson/Purchaser;
        }
        field(25006150;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Registration No." = '' THEN BEGIN
                  VALIDATE("Vehicle Serial No.",'');
                  EXIT;
                END;

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY("Registration No.");
                Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                  IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                    VALIDATE("Vehicle Serial No.",Vehicle."Serial No.")
                END ELSE
                  MESSAGE(Text131, "Vehicle Registration No.");
            end;
        }
        field(25006276;"Warranty Claim No.";Code[20])
        {
            Caption = 'Warranty Claim No.';
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
            end;
        }
        field(25006371;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
            end;
        }
        field(25006372;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));

            trigger OnLookup()
            var
                recModelVersion: Record "27";
            begin
                TESTFIELD("Make Code");
                TESTFIELD("Model Code");

                recModelVersion.RESET;
                IF LookUpMgt.LookUpModelVersion(recModelVersion,"Model Version No.","Make Code","Model Code") THEN
                 VALIDATE("Model Version No.",recModelVersion."No.")
            end;

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
            end;
        }
        field(25006377;"Quote Applicable To Date";Date)
        {
            Caption = 'Quote Applicable To Date';
        }
        field(25006378;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                Vehi: Record "33019823";
            begin
                //CALCFIELDS(VIN);  //09.06.2014 Elva Baltic P8 #F0002 EDMS7.10

                IF "Vehicle Serial No." = '' THEN BEGIN
                  VIN := '';  //09.06.2014 Elva Baltic P8 #F0002 EDMS7.10
                  "Vehicle Accounting Cycle No." := '';
                  "Vehicle Status Code" := '';
                  "Make Code" := '';
                  "Model Code" := '';
                  "Model Version No." := '';
                  "Vehicle Registration No." := '';
                  VALIDATE("Contract No.", '');                                               // 17.04.2014 Elva Baltic P21
                END ELSE BEGIN
                  Vehicle.GET("Vehicle Serial No.");
                  IF Vehi.GET("Vehicle Serial No.") THEN;  //V2
                  VIN := Vehicle.VIN;  //09.06.2014 Elva Baltic P8 #F0002 EDMS7.10
                  Vehi.CALCFIELDS("Default Vehicle Acc. Cycle No."); //V2
                  "Vehicle Accounting Cycle No." := Vehi."Default Vehicle Acc. Cycle No."; //V2
                  "Vehicle Status Code" := Vehicle."Status Code";
                  "Make Code" := Vehicle."Make Code";
                  "Model Code" := Vehicle."Model Code";
                  "Model Version No." := Vehicle."Model Version No.";
                  "Vehicle Registration No." := Vehicle."Registration No.";
                END;

                IF (Rec."Sell-to Customer No." = xRec."Sell-to Customer No.") AND NOT FindVehicle THEN
                  FindVehicleCont;

                UpdateVehicleContact;
                RecreateSalesLines(FIELDCAPTION("Vehicle Serial No.")); //23.01.2013 EDMS P8

                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 >>
                CreateDim(
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                  DATABASE::Campaign,"Campaign No.",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Customer Template","Bill-to Customer Template Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::"Deal Type","Deal Type Code", //27.03.2014 Elva Baltic P1 #RX MMG7.00
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );
                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 <<
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006390;"Vehicle Item Charge No.";Code[20])
        {
            Caption = 'Vehicle Item Charge No.';
            TableRelation = "Item Charge";
        }
        field(25006391;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
        }
        field(25006392;"Mobile Phone No.";Text[30])
        {
            Caption = 'Mobile Phone No.';
        }
        field(25006393;"Customer Signature Image";BLOB)
        {
            Caption = 'Signature Image';
        }
        field(25006394;"Customer Signature Text";Text[50])
        {
            Caption = 'Signature Text';
        }
        field(25006395;"Employee Signature Image";BLOB)
        {
            Caption = 'Signature Image';
        }
        field(25006396;"Employee Signature Text";Text[30])
        {
            Description = '//reduced';
        }
        field(25006670;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Description = 'Only For Service or Spare Parts Trade';
            FieldClass = FlowField;
            TableRelation = Vehicle;
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                VehicleCard: Page "25006032";
            begin
                //09.06.2014 Elva Baltic P8 #F0002 EDMS7.10
                IF VIN <> '' THEN BEGIN
                  Vehicle.RESET;
                  Vehicle.SETRANGE(VIN, VIN);
                  IF Vehicle.FINDFIRST THEN
                    "Vehicle Serial No." := Vehicle."Serial No."
                  ELSE BEGIN
                    //PROMPT TO CREATE NEW VEH. CARD
                    IF CONFIRM(STRSUBSTNO(TextEDMS100, Vehicle.TABLECAPTION), TRUE) THEN BEGIN
                      Vehicle.RESET;
                      Vehicle.INIT;
                      Vehicle.VIN := VIN;
                      Vehicle.INSERT(TRUE);
                      VehicleCard.SETRECORD(Vehicle);
                      COMMIT;
                      VehicleCard.RUNMODAL;
                      //PAGE.RUN(PAGE::"Vehicle Card", Vehicle);
                      Vehicle.SETRANGE(VIN, VIN);
                      IF Vehicle.FINDFIRST THEN
                        "Vehicle Serial No." := Vehicle."Serial No."
                    END ELSE
                      EXIT;
                  END;
                END ELSE
                  "Vehicle Serial No." := '';
                VALIDATE("Vehicle Serial No.");
            end;
        }
        field(25006680;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";

            trigger OnLookup()
            var
                Customer: Record "18";
                ContractTemp: Record "25006016" temporary;
            begin
                IF Customer.GET("Bill-to Customer No.") THEN;
                Customer.SetContractFilter(ContractTemp, Contract.Status::Active, FALSE, Contract."Document Profile"::"Spare Parts Trade", "Order Date", '');
                IF ContractTemp.GET(ContractTemp."Contract Type"::Contract, "Contract No.") THEN;
                IF PAGE.RUNMODAL(0, ContractTemp) = ACTION::LookupOK THEN
                  VALIDATE("Contract No.",ContractTemp."Contract No.");
            end;

            trigger OnValidate()
            begin
                IF Contract.GET(Contract."Contract Type"::Contract, "Contract No.") AND ("Contract No." <> xRec."Contract No.") THEN
                  VALIDATE("Payment Terms Code", Contract."Payment Terms Code");

                IF xRec."Contract No." <> "Contract No." THEN
                  RecreateSalesLines(FIELDCAPTION("Contract No."));
            end;
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,36,25006800';
            Enabled = false;

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Sales Header",FIELDNO("Variable Field 25006800"),
                  "Make Code","Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,36,25006801';
            Enabled = false;

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Sales Header",FIELDNO("Variable Field 25006801"),
                  "Make Code","Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,36,25006802';
            Enabled = false;

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Sales Header",FIELDNO("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25006995;Kilometrage;Decimal)
        {
        }
        field(25006996;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,36,25006996';
            Enabled = false;
        }
        field(25006997;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,36,25006997';
            Enabled = false;
        }
        field(33019833;"Job Finished Date";Date)
        {
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF NOT UserSetupMgt.CheckRespCenter(0,"Accountability Center") THEN
                  ERROR(
                    Text027,
                    AccCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter);

                "Location Code" := UserSetupMgt.GetLocation(0,'',"Accountability Center");
                IF "Location Code" <> '' THEN BEGIN
                  IF Location.GET("Location Code") THEN
                    "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                END ELSE BEGIN
                  IF InvtSetup.GET THEN
                    "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                END;

                UpdateShipToAddress;

                IF xRec."Accountability Center" <> "Accountability Center" THEN BEGIN
                  RecreateSalesLines(FIELDCAPTION("Accountability Center"));
                  "Assigned User ID" := '';
                END;
            end;
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            Caption = 'LC No.';
            TableRelation = "LC Details".No. WHERE (Transaction Type=CONST(Sale),
                                                    Issued To/Received From=FIELD(Sell-to Customer No.),
                                                    Released=CONST(Yes),
                                                    Closed=CONST(No));

            trigger OnValidate()
            var
                LCDetail: Record "33020012";
                LCAmendDetail: Record "33020013";
                Text33020011: Label 'LC has amendments and amendment is not released.';
                Text33020012: Label 'LC has amendments and  amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
                //Code to check for LC Amendment and insert Bank LC No. and LC Amend No. (LC Version No.) if LC is amended atleast once.
                IF "Sys. LC No." = '' THEN
                  "Bank LC No." := '';
                IF "Sys. LC No." <> '' THEN BEGIN
                  LCAmendDetail.RESET;
                  LCAmendDetail.SETRANGE("No.","Sys. LC No.");
                  IF LCAmendDetail.FIND('+') THEN BEGIN
                    IF NOT LCAmendDetail.Closed THEN BEGIN
                      IF LCAmendDetail.Released THEN BEGIN
                        "Bank LC No." := LCAmendDetail."Bank Amended No.";
                        "LC Amend No." := LCAmendDetail."Version No.";
                        MODIFY;
                      END ELSE
                        ERROR(Text33020011);
                    END ELSE
                      ERROR(Text33020012);
                  END ELSE BEGIN
                    LCDetail.RESET;
                    LCDetail.SETRANGE("No.","Sys. LC No.");
                    IF LCDetail.FIND('-') THEN BEGIN
                      IF NOT LCDetail.Closed THEN BEGIN
                        IF LCDetail.Released THEN BEGIN
                          "Bank LC No." := LCDetail."LC\DO No.";
                          MODIFY;
                        END ELSE
                          ERROR(Text33020013);
                      END ELSE
                        ERROR(Text33020014);
                    END;
                  END;
                  IF ("Document Profile" = "Document Profile"::"Vehicles Trade") AND ("Sys. LC No." <> '') THEN BEGIN
                    "Confirmed Date" := TODAY;
                    "Confirmed Time" := TIME;
                  END ELSE BEGIN
                    "Confirmed Date" := 0D;
                    "Confirmed Time" := 0T;
                  END;

                  SalesLine_Confirmation.RESET;
                  SalesLine_Confirmation.SETRANGE("Document Type","Document Type");
                  SalesLine_Confirmation.SETRANGE("Document No.","No.");
                  IF SalesLine_Confirmation.FINDSET THEN BEGIN
                    SalesLine_Confirmation."Confirmed Date" := "Confirmed Date";
                    SalesLine_Confirmation."Confirmed Time" := "Confirmed Time";
                    SalesLine_Confirmation.MODIFY;
                  END;
                 END;
                //VALIDATE("Sys. LC No.","Bank LC No.");
            end;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
        }
        field(33020013;"LC Amend No.";Code[20])
        {
            Caption = 'Amendment No.';
            TableRelation = "LC Amend. Details"."Version No." WHERE (No.=FIELD(Sys. LC No.));
        }
        field(33020017;"Financed By No.";Code[20])
        {
            Description = 'Financed Bank';
            TableRelation = Contact.No. WHERE (No.=FILTER(FI*));
        }
        field(33020018;"Re-Financed By";Code[20])
        {
            Description = 'To Account';
            TableRelation = Contact.No. WHERE (No.=FILTER(FI*));
        }
        field(33020019;"Financed Amount";Decimal)
        {
        }
        field(33020020;"Financed By";Text[50])
        {
            CalcFormula = Lookup(Contact.Name WHERE (No.=FIELD(Financed By No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020235;"Job Type";Code[20])
        {
            CalcFormula = Lookup("Posted Serv. Order Header"."Job Type" WHERE (Order No.=FIELD(Service Document No.)));
            Editable = true;
            FieldClass = FlowField;
        }
        field(33020236;"Package No.";Code[20])
        {
            Editable = true;
            TableRelation = "Service Package".No.;
        }
        field(33020237;"Advance Payment Mode";Option)
        {
            OptionMembers = Cash,Bank;

            trigger OnValidate()
            begin
                TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020238;"Advance Payment Account";Code[10])
        {
            TableRelation = IF (Advance Payment Mode=FILTER(Cash)) "G/L Account".No.
                            ELSE IF (Advance Payment Mode=FILTER(Bank)) "Bank Account".No.;

            trigger OnValidate()
            begin
                TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020239;"Advance Cheque No";Code[10])
        {

            trigger OnValidate()
            begin
                TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020240;"Advance Cheque Date";Code[10])
        {

            trigger OnValidate()
            begin
                TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020241;"Advance Amount";Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020242;"Advance Received";Boolean)
        {
            Editable = false;

            trigger OnValidate()
            var
                ArchiveManagement: Codeunit "5063";
            begin

                //***Chandra 09-04-14 to trace flipped date of the sales order in archive to calculate
                //the no of reserved days of vehicle for particular customer with prepayment received **********
                ArchiveManagement.ArchiveSalesDocument(Rec);
                //**********************************************************************
            end;
        }
        field(33020243;"Advance Reversed";Boolean)
        {
            Editable = false;
        }
        field(33020244;"Job Type (Before Posting)";Code[20])
        {
        }
        field(33020245;"Debit Note";Boolean)
        {
            Editable = true;
        }
        field(33020246;"VF Loan No";Code[10])
        {
        }
        field(33020247;"Warranty Settlement";Boolean)
        {
        }
        field(33020252;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020267;"Delay Reason Code";Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Additional Job,Parts Not Avilable,Parts Delay,Diagnosis And Troubleshooting,Customer Approval Delay,ERP Issue,Internet Issue';
            OptionMembers = " ","Additional Job","Parts Not Avilable","Parts Delay","Diagnosis And Troubleshooting","Customer Approval Delay","ERP Issue","Internet Issue";
        }
        field(33020272;"Insurance Company Name";Text[30])
        {
        }
        field(33020273;"Insurance Policy Number";Code[20])
        {
        }
        field(33020299;"Warranty Settlement (Battery)";Boolean)
        {
        }
        field(33020500;"Booked Date";Date)
        {
            Description = 'If the booking is for the month of april 2013, choose01/04/2013';

            trigger OnValidate()
            begin
                SalesLine.RESET;
                SalesLine.SETRANGE("Document No.","No.");
                IF SalesLine.FINDFIRST THEN BEGIN
                  SalesLine."Booked Date" := "Booked Date";
                  SalesLine.MODIFY;
                END;
            end;
        }
        field(33020510;"Tender Sales";Boolean)
        {
        }
        field(33020511;"Job Category";Option)
        {
            Editable = false;
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI;
        }
        field(33020512;"Advance Payment";Boolean)
        {

            trigger OnValidate()
            begin
                IF ("Document Profile" = "Document Profile"::"Vehicles Trade") AND ("Advance Payment") THEN BEGIN
                  "Confirmed Date" := TODAY;
                  "Confirmed Time" := TIME;
                END ELSE BEGIN
                  "Confirmed Date" := 0D;
                  "Confirmed Time" := 0T;
                END;

                SalesLine_Confirmation.RESET;
                SalesLine_Confirmation.SETRANGE("Document Type","Document Type");
                SalesLine_Confirmation.SETRANGE("Document No.","No.");
                IF SalesLine_Confirmation.FINDSET THEN BEGIN
                  SalesLine_Confirmation."Confirmed Date" := "Confirmed Date";
                  SalesLine_Confirmation."Confirmed Time" := "Confirmed Time";
                  SalesLine_Confirmation.MODIFY;
                END;
            end;
        }
        field(33020513;"Scheme Type";Code[20])
        {
            TableRelation = "Service Scheme Line";
        }
        field(33020514;"Mobile No.";Code[50])
        {
            CalcFormula = Lookup(Customer."Mobile No." WHERE (No.=FIELD(Sell-to Customer No.)));
            Description = '//reduced';
            FieldClass = FlowField;
        }
        field(33020515;"Latest Flipped Date";Date)
        {
            Editable = false;

            trigger OnValidate()
            var
                ArchiveManagement: Codeunit "5063";
            begin

                   //***Chandra 09-04-14 to trace flipped date of the sales order in archive to calculate
                   //the no of reserved days of vehicle for particular customer**********
                  ArchiveManagement.ArchiveSalesDocument(Rec);
                  //**********************************************************************
            end;
        }
        field(33020516;"Total Line Discount Amount";Decimal)
        {
            CalcFormula = Sum("Sales Line"."Line Discount Amount" WHERE (Document Type=FIELD(Document Type),
                                                                         Document No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020600;"Service Type";Option)
        {
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,6th type service,7th type Service,8th type Service,Bonus,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service","6th type Service","7th type Service"," 8th type Service",Bonus,Other;

            trigger OnValidate()
            var
                NotAllowed: Label 'Job Category must be Under Warranty';
            begin
            end;
        }
        field(33020601;"No. of Line Items";Integer)
        {
            CalcFormula = Count("Sales Line" WHERE (Document Type=FIELD(Document Type),
                                                    Document No.=FIELD(No.),
                                                    Outstanding Quantity=FILTER(>0)));
            Description = 'MOBAPP1.00';
            FieldClass = FlowField;
        }
        field(33020602;"Total Qty. to Scan";Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE (Document Type=FIELD(Document Type),
                                                                         Document No.=FIELD(No.)));
            Description = 'MOBAPP1.00';
            FieldClass = FlowField;
        }
        field(33020603;"QR Image";BLOB)
        {
            Description = 'MOBAPP1.00';
            SubType = Bitmap;
        }
        field(33020604;"Picker ID";Code[35])
        {
            Description = '//reduced';
            TableRelation = "User Setup";
        }
        field(33020605;"Forward Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020606;"Forward Location Code";Code[10])
        {
            TableRelation = Location;
        }
        field(33020607;"Forwarded PI Quotes";Code[20])
        {
        }
        field(33020608;"Province No.";Option)
        {
            OptionCaption = ' ,Province 1, Province 2, Bagmati Province, Gandaki Province, Province 5, Karnali Province, Sudur Pachim Province ';
            OptionMembers = " ","Province 1"," Province 2"," Bagmati Province"," Gandaki Province"," Province 5"," Karnali Province"," Sudur Pachim Province";
        }
        field(33020609;"Dealer VIN";Code[20])
        {
        }
        field(33020610;"Revisit Repair Reason";Code[20])
        {
        }
        field(33020611;"Resource PSF";Code[20])
        {
        }
        field(33020612;"Fleet No.";Code[20])
        {
            TableRelation = "Fixed Asset" WHERE (FA Class Code=CONST(BUS/AUTO),
                                                 Responsible Employee=CONST(''));
        }
        field(33020613;"Total CBM";Decimal)
        {
            CalcFormula = Sum("Sales Line".CBM WHERE (Document No.=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(33020614;Trip;Text[2])
        {
        }
        field(33020615;"Trip Start Date";Date)
        {
        }
        field(33020616;"Trip Start Time";Time)
        {
        }
        field(33020617;"Trip End Date";Date)
        {
        }
        field(33020618;"Trip End Time";Time)
        {
        }
    }
    keys
    {
        key(Key1;"Document Profile")
        {
        }
        key(Key2;"Service Document No.")
        {
        }
        key(Key3;"Vehicle Serial No.")
        {
        }
        key(Key4;"Posting Date")
        {
        }
        key(Key5;"Shortcut Dimension 1 Code","Posting Date")
        {
        }
        key(Key6;"Sell-to Customer Name")
        {
        }
        key(Key7;"Sell-to Customer No.")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF NOT UserSetupMgt.CheckRespCenter(0,"Responsibility Center") THEN
          ERROR(
            Text022,
            RespCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter);

        PostSalesDelete.DeleteHeader(
          Rec,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,
        #8..36
        SalesCommentLine.DELETEALL;

        IF (SalesShptHeader."No." <> '') OR
           (SalesInvHeader."No." <> '') OR
           (SalesCrMemoHeader."No." <> '') OR
           (ReturnRcptHeader."No." <> '') OR
           (SalesInvHeaderPrepmt."No." <> '') OR
           (SalesCrMemoHeaderPrepmt."No." <> '')
        THEN
          MESSAGE(PostedDocsToPrintCreatedMsg);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //IF "Dealer PO No." <> '' THEN
          //ERROR(DealerDelErr);

        IF "Posting No." <> '' THEN
          ERROR('You cannot delete document if posting no. is reserved');

        GLSetup.GET;
        IF NOT GLSetup."Use Accountability Center" THEN
          IF NOT UserSetupMgt.CheckRespCenter(0,"Responsibility Center") THEN
            ERROR(
              Text022,
              RespCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter)
        ELSE
          IF NOT UserSetupMgt.CheckRespCenter(0,"Accountability Center") THEN
            ERROR(
              Text022,
              RespCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter);
        #5..39
          (SalesInvHeader."No." <> '') OR
           (SalesCrMemoHeader."No." <> '') OR
           (ReturnRcptHeader."No." <> '') OR
          (SalesInvHeaderPrepmt."No." <> '') OR
           (SalesCrMemoHeaderPrepmt."No." <> '')
        THEN
         MESSAGE(PostedDocsToPrintCreatedMsg);
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnInsert".

    //trigger (Variable: Vehicle)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        InitInsert;
        InsertMode := TRUE;

        SetSellToCustomerFromFilter;

        IF GetFilterContNo <> '' THEN
          VALIDATE("Sell-to Contact No.",GetFilterContNo);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7
        //09.05.2008. EDMS P2 >>
        IF SalesSetup."Compress Prepayment" THEN
          "Compress Prepayment" := TRUE;
        //09.05.2008. EDMS P2 <<
        */
    //end;


    //Unsupported feature: Code Modification on "InitInsert(PROCEDURE 61)".

    //procedure InitInsert();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeries.GET(GetNoSeriesCode);
          IF (NOT NoSeries."Default Nos.") AND SelectNoSeriesAllowed AND NoSeriesMgt.IsSeriesSelected THEN
            "No." := NoSeriesMgt.GetNextNo(NoSeries.Code,"Posting Date",TRUE)
          ELSE
            NoSeriesMgt.InitSeries(NoSeries.Code,xRec."No. Series","Posting Date","No.","No. Series");
        END;

        InitRecord;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF "No." = '' THEN BEGIN
          //TestNoSeries;
          NoSeries.GET(GetNoSeriesCode2);
        #4..9
        IF "Dealer PO No." <> '' THEN
          InitRecord2ForDocFromDealer
        ELSE
          InitRecord2;
        "Assigned User ID" := USERID;
        */
    //end;


    //Unsupported feature: Code Modification on "InitRecord(PROCEDURE 10)".

    //procedure InitRecord();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesSetup.GET;

        CASE "Document Type" OF
        #4..56

        "Document Date" := WORKDATE;

        VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center"));

        IF IsCreditDocType THEN BEGIN
          GLSetup.GET;
        #64..67

        UpdateOutboundWhseHandlingTime;

        "Responsibility Center" := UserSetupMgt.GetRespCenter(0,"Responsibility Center");
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header","Document Type","No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..59
        // Below Code is commented to get default location from user setup table
        //VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center"));
        // Sipradi-YS GEN6.1.0 * Code to get default location
        VALIDATE("Location Code",UserSetupMgt.GetLocation2);
        // Sipradi-YS END
        #61..70

        GLSetup.GET;
        IF UserSetupMgt.DefaultResponsibility THEN BEGIN
          "Responsibility Center" := UserSetupMgt.GetRespCenter(0,"Responsibility Center");
        END
        ELSE BEGIN
          "Accountability Center" := UserSetupMgt.GetRespCenter(0,"Accountability Center");
        END;

        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header","Document Type","No.");
        */
    //end;


    //Unsupported feature: Code Modification on "AssistEdit(PROCEDURE 1)".

    //procedure AssistEdit();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        WITH SalesHeader DO BEGIN
          COPY(Rec);
          SalesSetup.GET;
          TestNoSeries;
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldSalesHeader."No. Series","No. Series") THEN BEGIN
            IF ("Sell-to Customer No." = '') AND ("Sell-to Contact No." = '') THEN BEGIN
              HideCreditCheckDialogue := FALSE;
              CheckCreditMaxBeforeInsert;
        #9..14
            EXIT(TRUE);
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode2,OldSalesHeader."No. Series","No. Series") THEN BEGIN
        #6..17
        */
    //end;


    //Unsupported feature: Code Modification on "TestNoSeries(PROCEDURE 6)".

    //procedure TestNoSeries();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesSetup.GET;

        CASE "Document Type" OF
          "Document Type"::Quote:
            SalesSetup.TESTFIELD("Quote Nos.");
          "Document Type"::Order:
            SalesSetup.TESTFIELD("Order Nos.");
          "Document Type"::Invoice:
            BEGIN
              SalesSetup.TESTFIELD("Invoice Nos.");
              SalesSetup.TESTFIELD("Posted Invoice Nos.");
            END;
          "Document Type"::"Return Order":
            SalesSetup.TESTFIELD("Return Order Nos.");
          "Document Type"::"Credit Memo":
            BEGIN
              SalesSetup.TESTFIELD("Credit Memo Nos.");
              SalesSetup.TESTFIELD("Posted Credit Memo Nos.");
            END;
          "Document Type"::"Blanket Order":
            SalesSetup.TESTFIELD("Blanket Order Nos.");
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        SalesSetup.GET;
        //08.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        ServiceSetup.GET;
        //08.04.2014 Elva Baltic P1 #RX MMG7.00 <<
        #2..9
        //20.03.2013 EDMS >>
              CASE "Document Profile" OF
                "Document Profile"::Service:
                  BEGIN
                    ServiceSetup.TESTFIELD("Invoice Nos.");
                    ServiceSetup.TESTFIELD("Posted Invoice Nos.");
                  END
                ELSE BEGIN
        //20.03.2013 EDMS <<
              SalesSetup.TESTFIELD("Invoice Nos.");
              SalesSetup.TESTFIELD("Posted Invoice Nos.");
                END;

        //20.03.2013 EDMS >>
              END;
            END;
        //20.03.2013 EDMS <<

        #13..16
        //20.03.2013 EDMS >>
              CASE "Document Profile" OF
                "Document Profile"::Service:
                  BEGIN
                    ServiceSetup.TESTFIELD("Credit Memo Nos.");
                    ServiceSetup.TESTFIELD("Posted Credit Memo Nos.");
                  END
                ELSE BEGIN
        //20.03.2013 EDMS  <<
        #17..19

        //20.03.2013 EDMS >>
        END;
            END;
        //20.03.2013 EDMS <<

        #20..22
        */
    //end;


    //Unsupported feature: Code Modification on "GetNoSeriesCode(PROCEDURE 9)".

    //procedure GetNoSeriesCode();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CASE "Document Type" OF
          "Document Type"::Quote:
            NoSeriesCode := SalesSetup."Quote Nos.";
          "Document Type"::Order:
            NoSeriesCode := SalesSetup."Order Nos.";
          "Document Type"::Invoice:
            NoSeriesCode := SalesSetup."Invoice Nos.";
          "Document Type"::"Return Order":
            NoSeriesCode := SalesSetup."Return Order Nos.";
          "Document Type"::"Credit Memo":
            NoSeriesCode := SalesSetup."Credit Memo Nos.";
          "Document Type"::"Blanket Order":
            NoSeriesCode := SalesSetup."Blanket Order Nos.";
        END;
        EXIT(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode,SelectNoSeriesAllowed,"No. Series"));
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //20.03.2013 EDMS
        IF ServiceSetup.GET THEN;

        #1..6
            BEGIN
        //20.03.2013 EDMS >>
             CASE "Document Profile" OF
               "Document Profile"::Service:
                 EXIT(ServiceSetup."Invoice Nos.");
               ELSE
        //20.03.2013 EDMS <<
            NoSeriesCode := SalesSetup."Invoice Nos.";

        //20.03.2013 EDMS >>
              END;
            END;
        //20.03.2013 EDMS <<

        #8..10
        //20.03.2013 EDMS >>
            BEGIN
             CASE "Document Profile" OF
               "Document Profile"::Service:
                 EXIT(ServiceSetup."Credit Memo Nos.");
               ELSE
        //20.03.2013 EDMS <<
            NoSeriesCode := SalesSetup."Credit Memo Nos.";

        //20.03.2013 EDMS >>
              END;
            END;
        //20.03.2013 EDMS <<
        #12..15
        */
    //end;


    //Unsupported feature: Code Modification on "GetPostingNoSeriesCode(PROCEDURE 8)".

    //procedure GetPostingNoSeriesCode();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF IsCreditDocType THEN
          EXIT(SalesSetup."Posted Credit Memo Nos.");
        EXIT(SalesSetup."Posted Invoice Nos.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF ServiceSetup.GET THEN;//20.03.2013 EDMS

        IF IsCreditDocType THEN
        //20.03.2013 EDMS >>
          BEGIN
          IF "Document Profile" = "Document Profile"::Service THEN
            EXIT(ServiceSetup."Posted Credit Memo Nos.")
          ELSE
        //20.03.2013 EDMS <<
            EXIT(SalesSetup."Posted Credit Memo Nos.");

        //20.03.2013 EDMS >>
        END;

        IF "Document Profile" = "Document Profile"::Service THEN
          EXIT(ServiceSetup."Posted Invoice Nos.")
        ELSE
        //20.03.2013 EDMS <<

        EXIT(SalesSetup."Posted Invoice Nos.");
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: ContractVehicle) (VariableCollection) on "FindContract(PROCEDURE 59)".


    //Unsupported feature: Variable Insertion (Variable: ContractTemp) (VariableCollection) on "FindContract(PROCEDURE 59)".


    //Unsupported feature: Variable Insertion (Variable: Customer) (VariableCollection) on "FindContract(PROCEDURE 59)".


    //Unsupported feature: Property Deletion (Local) on "GetPostingPrepaymentNoSeriesCode(PROCEDURE 59)".


    //Unsupported feature: Property Modification (Name) on "GetPostingPrepaymentNoSeriesCode(PROCEDURE 59)".



    //Unsupported feature: Code Modification on "GetPostingPrepaymentNoSeriesCode(PROCEDURE 59)".

    //procedure GetPostingPrepaymentNoSeriesCode();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF IsCreditDocType THEN
          EXIT(SalesSetup."Posted Prepmt. Cr. Memo Nos.");
        EXIT(SalesSetup."Posted Prepmt. Inv. Nos.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF ("Bill-to Customer No." = '') THEN
          EXIT;

        Customer.GET("Bill-to Customer No.");
        Customer.SetContractFilter(ContractTemp, Contract.Status::Active, FALSE, Contract."Document Profile"::"Spare Parts Trade", "Order Date", '');

        IF ContractTemp.COUNT = 1 THEN BEGIN
          ContractTemp.FINDFIRST;
          IF "Contract No." <> ContractTemp."Contract No." THEN
            VALIDATE("Contract No.", ContractTemp."Contract No.");
        END;

        IF ContractTemp.COUNT > 1 THEN BEGIN
          MESSAGE(Text136, "Bill-to Customer No.", ContractTemp.COUNT);
          IF ("Contract No." <> '') THEN
            VALIDATE("Contract No.", '');
        END;

        IF (ContractTemp.COUNT = 0) AND ("Contract No." <> '') THEN
          VALIDATE("Contract No.", '');
        */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: Type6) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: No6) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: Type7) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: No7) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: Type8) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: No8) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: Type9) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: No9) (ParameterCollection) on "CreateDim(PROCEDURE 16)".



    //Unsupported feature: Code Modification on "CreateDim(PROCEDURE 16)".

    //procedure CreateDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        #4..8
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        #15..18
          MODIFY;
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        // Sipradi-YS GEN6.1.0 - 36.1 * Following Standard Code is commented to Override Retrieving of Dimension
        {
        #1..11
        TableID[6] := Type6;  //25.10.2013 EDMS P8
        No[6] := No6;
        // 26.03.2014 Elva Baltic P18 #RX027 MMG7.00 >>
        TableID[7] := Type7;
        No[7] := No7;
        // 26.03.2014 Elva Baltic P18 #RX027 MMG7.00 <<
        //27.03.2014 Elva Baltic P1 #RX MMG7.00 >>
        TableID[8] := Type8;
        No[8] := No8;
        //27.03.2014 Elva Baltic P1 #RX MMG7.00 <<
        // 10.03.2015 EDMS P21 >>
        TableID[9] := Type9;
        No[9] := No9;
        // 10.03.2015 EDMS P21 <<

        #12..21
        }
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: Cont) (VariableCollection) on "UpdateSellToCont(PROCEDURE 24)".



    //Unsupported feature: Code Modification on "UpdateSellToCont(PROCEDURE 24)".

    //procedure UpdateSellToCont();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF OfficeMgt.GetContact(OfficeContact,CustomerNo) THEN BEGIN
          HideValidationDialog := TRUE;
          UpdateSellToCust(OfficeContact."No.");
        #4..10
              ContBusRel.SETCURRENTKEY("Link to Table","No.");
              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
              ContBusRel.SETRANGE("No.","Sell-to Customer No.");
              IF ContBusRel.FINDFIRST THEN
                "Sell-to Contact No." := ContBusRel."Contact No."
              ELSE
                "Sell-to Contact No." := '';
            END;
            "Sell-to Contact" := Cust.Contact;
          END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..13
              IF ContBusRel.FINDFIRST THEN BEGIN
                "Sell-to Contact No." := ContBusRel."Contact No.";
            //20.03.2013 EDMS >>
              IF ("Vehicle Serial No." = xRec."Vehicle Serial No.") AND (NOT FindCustomer) THEN
                FindContVehicle;
            END ELSE
            //20.03.2013 EDMS  <<
        #17..20
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: Cont) (VariableCollection) on "UpdateBillToCont(PROCEDURE 27)".


    //Unsupported feature: Property Deletion (Local) on "UpdateBillToCont(PROCEDURE 27)".



    //Unsupported feature: Code Modification on "UpdateSellToCust(PROCEDURE 25)".

    //procedure UpdateSellToCust();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF Cont.GET(ContactNo) THEN
          "Sell-to Contact No." := Cont."No."
        ELSE BEGIN
        #4..24
            ContComp.GET(Cont."Company No.");
            "Sell-to Customer Name" := ContComp."Company Name";
            "Sell-to Customer Name 2" := ContComp."Name 2";
            SetShipToAddress(
              ContComp."Company Name",ContComp."Name 2",ContComp.Address,ContComp."Address 2",
              ContComp.City,ContComp."Post Code",ContComp.County,ContComp."Country/Region Code");
            IF ("Sell-to Customer Template Code" = '') AND (NOT CustTemplate.ISEMPTY) THEN
              VALIDATE("Sell-to Customer Template Code",Cont.FindCustomerTemplate);
          END ELSE
        #34..62
           ("Bill-to Customer No." = '')
        THEN
          VALIDATE("Bill-to Contact No.","Sell-to Contact No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..27
            {SetShipToAddress(      //ankur 13th april 2023
              ContComp."Company Name",ContComp."Name 2",ContComp.Address,ContComp."Address 2",
              ContComp.City,ContComp."Post Code",ContComp.County,ContComp."Country/Region Code");}
        #31..65

        IF "Document Type" = "Document Type"::Quote THEN
          SetShipToAddressForQuote();    //ankur 02/08/2023
        */
    //end;


    //Unsupported feature: Code Modification on "UpdateShipToAddress(PROCEDURE 31)".

    //procedure UpdateShipToAddress();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF IsCreditDocType THEN BEGIN
          IF "Location Code" <> '' THEN BEGIN
            Location.GET("Location Code");
            SetShipToAddress(
              Location.Name,Location."Name 2",Location.Address,Location."Address 2",Location.City,
              Location."Post Code",Location.County,Location."Country/Region Code");
            "Ship-to Contact" := Location.Contact;
          END ELSE BEGIN
            CompanyInfo.GET;
            "Ship-to Code" := '';
        #11..14
            "Ship-to Contact" := CompanyInfo."Ship-to Contact";
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
            {SetShipToAddress(
              Location.Name,Location."Name 2",Location.Address,Location."Address 2",Location.City,
              Location."Post Code",Location.County,Location."Country/Region Code");
            "Ship-to Contact" := Location.Contact;}
        #8..17
        */
    //end;


    //Unsupported feature: Code Modification on "SetSecurityFilterOnRespCenter(PROCEDURE 43)".

    //procedure SetSecurityFilterOnRespCenter();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF UserSetupMgt.GetSalesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
          FILTERGROUP(0);
        END;

        SETRANGE("Date Filter",0D,WORKDATE - 1);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        {
        #1..5
        }
        SETRANGE("Date Filter",0D,WORKDATE - 1);
        */
    //end;


    //Unsupported feature: Code Modification on "CreateDimSetForPrepmtAccDefaultDim(PROCEDURE 73)".

    //procedure CreateDimSetForPrepmtAccDefaultDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.SETFILTER("Prepmt. Amt. Inv.",'<>%1',0);
        #4..8
        TempSalesLine.MARKEDONLY(FALSE);
        IF TempSalesLine.FINDSET THEN
          REPEAT
            SalesLine.CreateDim(DATABASE::"G/L Account",TempSalesLine."No.",
              DATABASE::Job,TempSalesLine."Job No.",
              DATABASE::"Responsibility Center",TempSalesLine."Responsibility Center");
          UNTIL TempSalesLine.NEXT = 0;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..11
            //16.04.2015 EB.P7 #Merge >>
            SalesLine.CreateDim(
              DATABASE::"G/L Account",TempSalesLine."No.",
              DATABASE::Job,TempSalesLine."Job No.",
              DATABASE::"Responsibility Center",TempSalesLine."Responsibility Center",
              0,'',
              0,'',
              0,'',
              0,'',
              0,''
            );
            //16.04.2015 EB.P7 #Merge <<
          UNTIL TempSalesLine.NEXT = 0;
        */
    //end;


    //Unsupported feature: Code Modification on "GetCardpageID(PROCEDURE 58)".

    //procedure GetCardpageID();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CASE "Document Type" OF
          "Document Type"::Quote:
            EXIT(PAGE::"Sales Quote");
          "Document Type"::Order:
            EXIT(PAGE::"Sales Order");
          "Document Type"::Invoice:
            EXIT(PAGE::"Sales Invoice");
          "Document Type"::"Credit Memo":
            EXIT(PAGE::"Sales Credit Memo");
          "Document Type"::"Blanket Order":
            EXIT(PAGE::"Blanket Sales Order");
          "Document Type"::"Return Order":
            EXIT(PAGE::"Sales Return Order");
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..8
            EXIT(PAGE::"Credit Note");
        #10..14
        */
    //end;


    //Unsupported feature: Code Modification on "CreateSalesLine(PROCEDURE 78)".

    //procedure CreateSalesLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesLine.INIT;
        SalesLine."Line No." := SalesLine."Line No." + 10000;
        SalesLine.VALIDATE(Type,TempSalesLine.Type);
        IF TempSalesLine."No." = '' THEN BEGIN
          SalesLine.VALIDATE(Description,TempSalesLine.Description);
          SalesLine.VALIDATE("Description 2",TempSalesLine."Description 2");
        END ELSE BEGIN
          SalesLine.VALIDATE("No.",TempSalesLine."No.");
          IF SalesLine.Type <> SalesLine.Type::" " THEN BEGIN
            SalesLine.VALIDATE("Unit of Measure Code",TempSalesLine."Unit of Measure Code");
        #11..18
          END;
          SalesLine.VALIDATE("Shipment Date",TempSalesLine."Shipment Date");
        END;
        SalesLine.INSERT;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7
          SalesLine."Line Type" := TempSalesLine."Line Type"; //05.05.2016 EB.P7 #T084
          SalesLine."Order Line Type No." := TempSalesLine."Order Line Type No.";//AGNI UPG 2009
        #8..21

        //23.11.2007 EDMS P3 >>
        SalesLine."Document Profile" := TempSalesLine."Document Profile";
        SalesLine."Make Code" := TempSalesLine."Make Code";
        SalesLine."Model Code" := TempSalesLine."Model Code";
        SalesLine."Model Version No." := TempSalesLine."Model Version No.";
        SalesLine."Service Order Line No. EDMS" := TempSalesLine."Service Order Line No. EDMS"; //10.08.06 AB
        SalesLine."Order Line Type No." := TempSalesLine."Order Line Type No.";
        //23.01.2013 EDMS P8 >>
        SalesLine."Contract No." := "Contract No.";                                             // 17.04.2014 Elva Baltic P21
        {
        IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN BEGIN
          SalesLine.VALIDATE("Vehicle Serial No.", "Vehicle Serial No.");
        END ELSE BEGIN //AGNI UPG 2009
        }
          SalesLine.VIN := TempSalesLine.VIN;
          SalesLine."Vehicle Serial No." := TempSalesLine."Vehicle Serial No.";
          SalesLine."Vehicle Accounting Cycle No." := TempSalesLine."Vehicle Accounting Cycle No.";
          SalesLine."Vehicle Assembly ID" := TempSalesLine."Vehicle Assembly ID";
          SalesLine."Vehicle Status Code" := TempSalesLine."Vehicle Status Code";
        //END;
        //23.01.2013 EDMS P8 <<
        SalesLine."Variable Field 25006800" := TempSalesLine."Variable Field 25006800";
        SalesLine."Variable Field 25006801" := TempSalesLine."Variable Field 25006801";
        SalesLine."Variable Field 25006802" := TempSalesLine."Variable Field 25006802";
        //23.11.2007 EDMS P3 <<
        SalesLine."External Serv. Tracking No." := TempSalesLine."External Serv. Tracking No."; //SM 25 Feb 2016
        //SM 25 Feb 2016

        SalesLine."Dealer PO No." := TempSalesLine."Dealer PO No.";
        SalesLine."Dealer Tenant ID" := TempSalesLine."Dealer Tenant ID";
        SalesLine."Dealer Line No." := TempSalesLine."Dealer Line No.";

        SalesLine.VALIDATE("Unit Price",TempSalesLine."Unit Price");
        SalesLine.VALIDATE("Unit Cost (LCY)",TempSalesLine."Unit Cost (LCY)");
        SalesLine.INSERT;
        */
    //end;


    //Unsupported feature: Code Modification on "CopyBillToCustomerAddressFieldsFromCustomer(PROCEDURE 93)".

    //procedure CopyBillToCustomerAddressFieldsFromCustomer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF BillToCustomerIsReplaced OR ShouldCopyAddressFromBillToCustomer(BillToCustomer) THEN BEGIN
          "Bill-to Address" := BillToCustomer.Address;
          "Bill-to Address 2" := BillToCustomer."Address 2";
          "Bill-to City" := BillToCustomer.City;
          "Bill-to Post Code" := BillToCustomer."Post Code";
          "Bill-to County" := BillToCustomer.County;
          "Bill-to Country/Region Code" := BillToCustomer."Country/Region Code";
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7
          "Ship-to Address" := BillToCustomer.Address;
          "Ship-to Address 2" := BillToCustomer."Address 2";
          "Ship-to City" := BillToCustomer.City;
          "Ship-to Post Code" := BillToCustomer."Post Code";
          "Ship-to County" := BillToCustomer.County;
          "Ship-to Country/Region Code" := BillToCustomer."Country/Region Code";
        END;
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: ShipAdd) (VariableCollection) on "UpdateShipToAddressFromSellToAddress(PROCEDURE 50)".


    //Unsupported feature: Variable Insertion (Variable: ShipCount) (VariableCollection) on "UpdateShipToAddressFromSellToAddress(PROCEDURE 50)".


    //Unsupported feature: Variable Insertion (Variable: ShipAddPage) (VariableCollection) on "UpdateShipToAddressFromSellToAddress(PROCEDURE 50)".



    //Unsupported feature: Code Modification on "InitFromContact(PROCEDURE 126)".

    //procedure InitFromContact();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        #4..6
          INIT;
          SalesSetup.GET;
          "No. Series" := xRec."No. Series";
          InitRecord;
          InitNoSeries;
          EXIT(TRUE);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..9
          InitRecord2;
        #11..13
        */
    //end;


    //Unsupported feature: Code Modification on "InitFromTemplate(PROCEDURE 118)".

    //procedure InitFromTemplate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        #4..6
          INIT;
          SalesSetup.GET;
          "No. Series" := xRec."No. Series";
          InitRecord;
          InitNoSeries;
          EXIT(TRUE);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..9
          InitRecord2;
        #11..13
        */
    //end;

    local procedure GetPostingPrepaymentNoSeriesCode(): Code[10]
    begin
        IF IsCreditDocType THEN
          EXIT(SalesSetup."Posted Prepmt. Cr. Memo Nos.");
        EXIT(SalesSetup."Posted Prepmt. Inv. Nos.");
    end;

    procedure SetUserDefaultValues()
    var
        UserSetup: Record "91";
        UserProfile: Record "25006067";
        UserProfileMgt: Codeunit "25006002";
        PriofileID: Code[30];
    begin
        //EDMS
        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN
         IF UserSetup."Salespers./Purch. Code" <> '' THEN
          VALIDATE("Salesperson Code",UserSetup."Salespers./Purch. Code");

        PriofileID := UserProfileMgt.CurrProfileID;
        IF PriofileID <> '' THEN
          //07.05.2014 Elva Baltic P8 #S0083 MMG7.00 >>
          IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN BEGIN
           IF "Location Code" = '' THEN
             IF UserProfile."Default Location Code" <> '' THEN
               VALIDATE("Location Code", UserProfile."Default Location Code");
           IF "Deal Type Code" = '' THEN
             IF UserProfile."Default Deal Type Code" <> '' THEN
               VALIDATE("Deal Type Code", UserProfile."Default Deal Type Code");
           IF "Payment Method Code" = '' THEN
             IF UserProfile."Default Payment Method" <> '' THEN
               VALIDATE("Payment Method Code", UserProfile."Default Payment Method");
           IF "Shipping Agent Code" = '' THEN
             IF UserProfile."Default Shipping Agent Code" <> '' THEN
               VALIDATE("Shipping Agent Code",UserProfile."Default Shipping Agent Code");
          END;
          //07.05.2014 Elva Baltic P8 #S0083 MMG7.00 <<
    end;

    procedure ApplyVehMarginalVAT()
    var
        SalesLine: Record "37";
        PurchaseAmount: Decimal;
        SalesAmount: Decimal;
        ItemLedgerEntry: Record "32";
        LineNo: Integer;
        SalesLine2: Record "37";
        GrossProfit: Decimal;
        VATAmount: Decimal;
        CurrExchangeRate: Record "330";
        PurchDate: Date;
        Text101: Label 'Can''t find a positive entry.';
        TextAmounts: Label 'Purchase Amount:%1\Sales Amount:%2';
        SalesSetup: Record "311";
        SalesHeader: Record "36";
        Item: Record "27";
        AssignItemChargeSales: Codeunit "5807";
    begin
        //EDMS
        SalesSetup.GET;
        //SalesSetup.TESTFIELD("Veh. Marginal VAT Account No.");  //28.04.2014 Elva Baltic P8 #S0075 MMG7.00

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.SETRANGE("Line Type",SalesLine."Line Type"::Vehicle);

        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type","Document Type");
        SalesLine2.SETRANGE("Document No.","No.");

        LineNo := 0;
        IF SalesLine2.FINDLAST THEN
         LineNo := SalesLine2."Line No.";


        IF SalesLine.FINDSET THEN
         REPEAT
          SalesLine.TESTFIELD("Make Code");
          SalesLine.TESTFIELD("Model Code");
          SalesLine.TESTFIELD("Model Version No.");
          SalesLine.TESTFIELD("No.");
          SalesLine.TESTFIELD("Line Amount");
          SalesLine.TESTFIELD("Vehicle Serial No.");

          Item.GET(SalesLine."No.");
          IF NOT Item."Cost is Adjusted" THEN
            IF NOT CONFIRM(STRSUBSTNO(Text200,"Model Version No.")) THEN
              EXIT;

          //Getting Sales Amount
          SalesAmount := SalesLine."Line Amount";  //28.02.2013 EDMS P8

          //Getting Purchase Amount
          ItemLedgerEntry.RESET;
          ItemLedgerEntry.SETCURRENTKEY("Serial No.");
          ItemLedgerEntry.SETRANGE("Serial No.",SalesLine."Vehicle Serial No.");
          ItemLedgerEntry.SETRANGE(Open,TRUE);
          IF  ItemLedgerEntry.ISEMPTY THEN
           ERROR(Text101);
        // 26.03.2014 Elva Baltic P7 #Marginal VAT MMG7.00 >>
          ItemLedgerEntry.FINDFIRST;

          ValueEntry.RESET;
          ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgerEntry."Entry No.");
          ValueEntry.SETRANGE("Entry Type",ValueEntry."Entry Type"::"Direct Cost");
          IF ValueEntry.FINDFIRST THEN BEGIN
            REPEAT
              PurchaseAmount += ValueEntry."Cost Amount (Actual)";
            UNTIL ValueEntry.NEXT = 0
          END;

          PurchDate := ItemLedgerEntry."Posting Date";
          IF "Currency Code" <> '' THEN
           BEGIN
            PurchaseAmount := ROUND(CurrExchangeRate.ExchangeAmtLCYToFCY(PurchDate,"Currency Code",
                                 PurchaseAmount,CurrExchangeRate.ExchangeRate(PurchDate,"Currency Code")),0.01);
           END;

          MESSAGE(TextAmounts,FORMAT(PurchaseAmount),FORMAT(SalesAmount));

          IF SalesAmount > PurchaseAmount THEN BEGIN  //01.07.2008. EDMS P2
            GrossProfit := SalesAmount - PurchaseAmount;

             SalesLine2.INIT;
             SalesLine2."Document Profile" := "Document Profile"::"Vehicles Trade";
             SalesLine2."Document Type" := "Document Type";
             SalesLine2."Document No." := "No.";
             LineNo := LineNo + 10000;
             SalesLine2."Line No." := LineNo;
             SalesLine2.VALIDATE("Line Type",SalesLine."Line Type"::"Charge (Item)");
             SalesLine2.VALIDATE("No.",SalesSetup."Veh. Marg. VAT Item Charge");
             SalesLine2.VALIDATE(Quantity,1);
             SalesLine2.VALIDATE("Unit Price", ROUND(GrossProfit));  //28.02.2013 EDMS P8
             SalesLine2.VALIDATE("Make Code",SalesLine."Make Code");
             SalesLine2.VALIDATE("Model Code",SalesLine."Model Code");
             SalesLine2.VALIDATE("Model Version No.",SalesLine."Model Version No.");
             SalesLine2.VALIDATE("Vehicle Serial No.",SalesLine."Vehicle Serial No.");
             SalesLine2.INSERT(TRUE);

             //Add Item Charge Assignment
             ItemChargeAssgntSales.INIT;
             ItemChargeAssgntSales."Document Type" := SalesLine2."Document Type";
             ItemChargeAssgntSales."Document No." := SalesLine2."Document No.";
             ItemChargeAssgntSales."Document Line No." := SalesLine2."Line No.";
             ItemChargeAssgntSales."Item Charge No." := SalesLine2."No.";

             IF "Currency Code" = '' THEN
               Currency.InitRoundingPrecision
             ELSE BEGIN
               TESTFIELD("Currency Factor");
               Currency.GET("Currency Code");
               Currency.TESTFIELD("Amount Rounding Precision");
             END;


             IF (SalesLine2."Inv. Discount Amount" = 0) AND
                (SalesLine2."Line Discount Amount" = 0) AND
                (NOT "Prices Including VAT")
             THEN
               ItemChargeAssgntSales."Unit Cost" := SalesLine2."Unit Price"
             ELSE
               IF "Prices Including VAT" THEN
                 ItemChargeAssgntSales."Unit Cost" :=
                   ROUND(
                     (SalesLine2."Line Amount" - SalesLine2."Inv. Discount Amount") / SalesLine2.Quantity / (1 + SalesLine2."VAT %" / 100),
                     Currency."Unit-Amount Rounding Precision")
               ELSE
                 ItemChargeAssgntSales."Unit Cost" :=
                   ROUND(
                     (SalesLine2."Line Amount" - SalesLine2."Inv. Discount Amount") / SalesLine2.Quantity,
                     Currency."Unit-Amount Rounding Precision");

             IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
               AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales,SalesLine2."Return Receipt No.")
             ELSE
               AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales,SalesLine2."Shipment No.");
             CLEAR(AssignItemChargeSales);

             //Change Quantity to Assign to 1
             ItemChargeAssgntSales.RESET;
             ItemChargeAssgntSales.SETRANGE("Document Type",SalesLine2."Document Type");
             ItemChargeAssgntSales.SETRANGE("Document No.",SalesLine2."Document No.");
             ItemChargeAssgntSales.SETRANGE("Document Line No.",SalesLine2."Line No.");
             IF ItemChargeAssgntSales.FINDFIRST THEN
               REPEAT
                 ItemChargeAssgntSales.VALIDATE("Qty. to Assign",1);
                 ItemChargeAssgntSales.MODIFY;
               UNTIL ItemChargeAssgntSales.NEXT = 0;
          END;

          SalesLine.VALIDATE("Gen. Prod. Posting Group",SalesSetup."Veh. Marg.VAT Gen.Prod.Grp.");
          SalesLine.VALIDATE("Gen. Bus. Posting Group",SalesSetup."Veh. Marg.VAT Gen.Bus.Grp.");
          //28.02.2013 EDMS P8 >>
          IF SalesAmount > PurchaseAmount THEN
            SalesLine.VALIDATE("Unit Price",PurchaseAmount)
          ELSE
            SalesLine.VALIDATE("Unit Price",SalesAmount);
          //28.02.2013 EDMS P8 <<
          SalesLine.MODIFY;
         UNTIL SalesLine.NEXT = 0;
         COMMIT;
         //  26.03.2014 Elva Baltic P7 #Marginal VAT MMG7.00 <<
    end;

    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Sales Header",intFieldNo));
    end;

    procedure FindContVehicle()
    var
        Vehicle: Record "25006005";
        VehCount: Integer;
        Cont: Record "5050";
        VehicleContact: Record "25006013";
    begin
        IF ("Document Profile" <> "Document Profile"::"Spare Parts Trade") THEN
          EXIT;

        IF "Sell-to Contact No." = '' THEN
         EXIT;

        IF NOT Cont.GET("Sell-to Contact No.") THEN
         EXIT;

        FindVehicle := TRUE;

        Vehicle.RESET;

        MarkContVehicles(Vehicle,Cont."No.");
        IF (Cont.Type = Cont.Type::Person)
         AND (Cont."Company No." <> '')  THEN BEGIN
          IF Cont.GET(Cont."Company No.") THEN
            MarkContVehicles(Vehicle,Cont."No.");
        END;
        Vehicle.MARKEDONLY(TRUE);
        VehCount := Vehicle.COUNT;

        CASE VehCount OF
         0:
          BEGIN
           Vehicle.MARKEDONLY(FALSE);
          END;
         1:
          BEGIN
           Vehicle.FINDFIRST;
           IF CONFIRM(VehicleConfirm,TRUE,Vehicle."Make Code",Vehicle."Model Code",
             Vehicle.FIELDCAPTION("Registration No."),Vehicle."Registration No.",
             Vehicle.FIELDCAPTION(VIN),Vehicle.VIN) THEN
           VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
          END;
         ELSE
          BEGIN
            COMMIT;
            IF NOT HideValidationDialog THEN
              IF LookUpMgt.LookUpVehicleAMT(Vehicle,'') THEN
                  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.")
            ELSE BEGIN
              Vehicle.FINDFIRST;
              VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
            END;
          END;
        END;
    end;

    procedure GetLegalStatement(): Text
    begin
        SalesSetup.GET;
        EXIT(SalesSetup.GetLegalStatement);
    end;

    procedure FindVehicleCont()
    var
        Vehicle: Record "25006005";
        CustomerCount: Integer;
        Contact: Record "5050";
        VehicleContact: Record "25006013";
        ContBusRelation: Record "5054";
        Customer: Record "18";
    begin
        IF ("Document Profile" <> "Document Profile"::"Spare Parts Trade") THEN
          EXIT;

        IF "Vehicle Serial No." = '' THEN
          EXIT;

        FindCustomer := TRUE;

        Contact.RESET;
        Customer.RESET;

        MarkVehicleContacts(Contact,"Vehicle Serial No.");
        Contact.MARKEDONLY(TRUE);
        IF Contact.FINDFIRST THEN
          REPEAT
            ContBusRelation.SETRANGE("Contact No.", Contact."No.");
            IF ContBusRelation.FINDFIRST THEN
              REPEAT
                IF Customer.GET(ContBusRelation."No.") THEN
                  Customer.MARK(TRUE);
              UNTIL ContBusRelation.NEXT = 0;
          UNTIL Contact.NEXT = 0;
        Customer.MARKEDONLY(TRUE);

        CustomerCount := Customer.COUNT;

        CASE CustomerCount OF
         0:
          BEGIN
           Customer.MARKEDONLY(FALSE);
          END;
         1:
          BEGIN
           Customer.FINDFIRST;
           IF CONFIRM(ContactConfirm,TRUE,Customer."No.", Customer.Name) THEN
             VALIDATE("Sell-to Customer No.",Customer."No.");
          END;
         ELSE
          BEGIN
            COMMIT;
            IF PAGE.RUNMODAL(PAGE::"Customer List", Customer) = ACTION::LookupOK THEN
              VALIDATE("Sell-to Customer No.",Customer."No.");
          END;
        END;
    end;

    procedure MarkContVehicles(var Vehicle: Record "25006005";ContNo: Code[20])
    var
        VehicleContact: Record "25006013";
    begin
        VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Contact No.");
        VehicleContact.SETRANGE("Contact No.",ContNo);
        IF VehicleContact.FINDFIRST THEN
         REPEAT
          IF Vehicle.GET(VehicleContact."Vehicle Serial No.") THEN
            Vehicle.MARK := TRUE;
         UNTIL VehicleContact.NEXT = 0;
    end;

    procedure MarkVehicleContacts(var Contact: Record "5050";VehSerialNo: Code[20])
    var
        VehicleContact: Record "25006013";
    begin
        VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Vehicle Serial No.");
        VehicleContact.SETRANGE("Vehicle Serial No.",VehSerialNo);
        IF VehicleContact.FINDFIRST THEN
         REPEAT
          IF Contact.GET(VehicleContact."Contact No.") THEN
            Contact.MARK := TRUE;
         UNTIL VehicleContact.NEXT = 0;
    end;

    procedure UpdateVehicleContact()
    var
        VehicleContact: Record "25006013";
    begin
        SalesSetup.GET;
        IF NOT SalesSetup."Offer Link Vehicle and Contact" THEN
          EXIT;

        IF "Sell-to Contact No." = '' THEN
          EXIT;

        VehicleContact.RESET;
        VehicleContact.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        IF VehicleContact.COUNT > 0 THEN
          EXIT;

        IF NOT CONFIRM(STRSUBSTNO(Text125, "Sell-to Contact No.")) THEN
          EXIT;

        VehicleContact.INIT;
        VehicleContact.VALIDATE("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleContact.VALIDATE("Relationship Code", SalesSetup."Link Relationship Code");
        VehicleContact.VALIDATE("Contact No.", "Sell-to Contact No.");
        VehicleContact.INSERT(TRUE);
    end;

    procedure GetPromptProfile(): Boolean
    begin
        EXIT(PromptProfile);
    end;

    procedure SetPromptProfile(BoolValueToSet: Boolean)
    begin
        PromptProfile := BoolValueToSet;
    end;

    procedure DefineProfileRange()
    var
        Selected: Integer;
    begin
        IF GetPromptProfile THEN BEGIN
          Selected := STRMENU(TextDlg001, 1);
          IF Selected > 0 THEN BEGIN
            "Document Profile" := Selected - 1;
            SETRANGE("Document Profile", "Document Profile");
          END;
        END;
    end;

    procedure SetDontFindContract(NewDontFindContract: Boolean)
    begin
        DontFindContract := NewDontFindContract;
    end;

    procedure OnLookupVehicleRegistrationNo()
    var
        Vehicle: Record "25006005";
    begin
        IF "Vehicle Registration No." <> '' THEN BEGIN
          Vehicle.RESET;
          Vehicle.SETCURRENTKEY("Registration No.");
          Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
          IF Vehicle.FINDFIRST THEN;
          Vehicle.SETRANGE("Registration No.");
        END;
    end;

    procedure GetPostingNoSeries()
    begin
         // Sipradi-YS GEN6.1.0 25006145.1 BEGIN >> Getting Posting No. Series based on user Branch,Cost Center and document type.
        /*IF "Document Profile" = "Document Profile"::Service THEN
          VALIDATE("Posting No. Series",StplSysMgt.getPostingNoSeries(2,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"))
        ELSE
          VALIDATE("Posting No. Series",StplSysMgt.getPostingNoSeries(1,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"));
        */
        IF "Posting No. Series" = '' THEN BEGIN
          IF "Document Profile" = "Document Profile"::Service THEN  BEGIN
            ServiceSetup.GET;
            VALIDATE("Posting No. Series",ServiceSetup."Posted Invoice Nos.")
          END
          ELSE BEGIN
            SalesSetup.GET;
            VALIDATE("Posting No. Series",SalesSetup."Posted Invoice Nos.");
          END;
        END;

    end;

    local procedure GetNoSeriesCode2(): Code[10]
    begin
        CASE "Document Type" OF
          "Document Type"::Quote:
            EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::Quote));
          "Document Type"::Order:
            EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::Order));
          "Document Type"::Invoice:
            BEGIN
             CASE "Document Profile" OF
               "Document Profile"::Service:
                 EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,DocumentType::Invoice));
               ELSE
                 EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::Invoice));
              END;
            END;
          "Document Type"::"Return Order":
            EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Return Order"));
          "Document Type"::"Credit Memo":
            BEGIN
             CASE "Document Profile" OF
               "Document Profile"::Service:
                 EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,DocumentType::"Credit Memo"));
               ELSE
                 EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Credit Memo"));
              END;
            END;
          "Document Type"::"Blanket Order":
            EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Blanket Order"));
        END;
    end;

    procedure InitRecord2()
    begin
        SalesSetup.GET;
        CASE "Document Type" OF
          "Document Type"::Quote,"Document Type"::Order:
            BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Invoice"));
              NoSeriesMgt.SetDefaultSeries("Shipping No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Shipment"));

              IF "Document Type" = "Document Type"::Order THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Prepmt. Inv.")
        );
                NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,
                                            DocumentType::"Posted Prepmt. Cr. Memo"));
              END;

            END;
          "Document Type"::Invoice:
            BEGIN
              IF ("No. Series" <> '') AND
                 (StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::Invoice) =
                 StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Invoice"))
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                              StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Invoice"));
              IF SalesSetup."Shipment on Invoice" THEN
                NoSeriesMgt.SetDefaultSeries("Shipping No. Series",
                                              StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Shipment"));
            END;
          "Document Type"::"Return Order":
            BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Credit Memo"))
        ;
              NoSeriesMgt.SetDefaultSeries("Return Receipt No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,
                                            DocumentType::"Posted Return Receipt"));
            END;
          "Document Type"::"Credit Memo":
            BEGIN
              IF ("No. Series" <> '') AND
                 (StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Credit Memo") =
                  StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Credit Memo"))
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                             StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Credit Memo")
        );
              IF SalesSetup."Return Receipt on Credit Memo" THEN
                NoSeriesMgt.SetDefaultSeries("Return Receipt No. Series",
                                              StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,
                                              DocumentType::"Posted Return Receipt"));
            END;
        END;

        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote] THEN
          BEGIN
          "Shipment Date" := WORKDATE;
          "Order Date" := WORKDATE;
        END;
        IF "Document Type" = "Document Type"::"Return Order" THEN
          "Order Date" := WORKDATE;

        IF NOT ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) AND
           ("Posting Date" = 0D)
        THEN
          "Posting Date" := WORKDATE;

        IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" THEN
          "Posting Date" := 0D;

        "Document Date" := WORKDATE;
        // Below Code is commented to get default location from user setup table
        //VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center")); Standard
        // Sipradi-YS GEN6.1.0 * Code to get default location
        VALIDATE("Location Code",UserSetupMgt.GetLocation2);
        // Sipradi-YS END
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          GLSetup.GET;
          Correction := GLSetup."Mark Cr. Memos as Corrections";
        END;

        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

        Reserve := Reserve::Optional;

        IF InvtSetup.GET THEN
          VALIDATE("Outbound Whse. Handling Time",InvtSetup."Outbound Whse. Handling Time");
        IF UserSetupMgt.DefaultResponsibility THEN
          "Responsibility Center" := UserSetupMgt.GetRespCenter(0,"Responsibility Center")
        ELSE
          "Accountability Center" := UserSetupMgt.GetRespCenter(0,"Accountability Center");
    end;

    procedure CheckNoVATCustomer()
    var
        Customer: Record "18";
        VATPostingSetup: Record "325";
    begin
        Customer.RESET;
        IF Customer.GET("Bill-to Customer No.") THEN BEGIN
        //VATPostingSetup.RESET;
        //VATPostingSetup.SETRANGE("VAT Bus. Posting Group",Customer."VAT Bus. Posting Group");
        //IF VATPostingSetup.FINDFIRST THEN BEGIN
          IF Customer."Non-Billable" THEN BEGIN
            VALIDATE("Debit Note",TRUE);
            ChangePostingNoSeries(TRUE);
          END
          ELSE BEGIN
            VALIDATE("Debit Note",FALSE);
            ChangePostingNoSeries(FALSE);
          END;
        END;
    end;

    procedure ChangePostingNoSeries(DebitNote: Boolean)
    begin
        IF DebitNote THEN
          "Posting No. Series" := StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Debit Note")
        ELSE BEGIN
        InitRecord2;
        /*  IF (StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::Invoice) =
             StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Invoice"))
          THEN
            "Posting No. Series" := "No. Series"
          ELSE
            NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                          StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,DocumentType::"Posted Invoice"));
                                          */
        END;

    end;

    procedure CorrectServiceInvoice(var SalesHeader: Record "36")
    var
        PostedServHeader: Record "25006149";
        PostedServLine: Record "25006150";
        ServLedger: Record "25006167";
        SalesLine: Record "37";
        ServMgtSetup: Record "25006120";
        totalcount: Integer;
        ProgressWindow: Dialog;
        Text000: Label ' #1##################################.';
    begin
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1,'Wait Until Process is Completed.......');
        WITH SalesHeader DO BEGIN
          PostedServHeader.RESET;
          PostedServHeader.SETCURRENTKEY("Order No.");
          PostedServHeader.SETRANGE("Order No.","Service Document No.");
          IF PostedServHeader.FINDFIRST THEN BEGIN
            // Correct Posted Serv. Order Header/Line
            PostedServHeader."Sell-to Customer No." := "Sell-to Customer No.";
            PostedServHeader."Bill-to Customer No." := "Bill-to Customer No.";
            PostedServHeader."Bill-to Name" := "Bill-to Name";
            PostedServHeader."Bill-to Name 2" := "Bill-to Name 2";
            PostedServHeader."Bill-to Address" := "Bill-to Address";
            PostedServHeader."Bill-to Address 2" := "Bill-to Address 2";
            PostedServHeader."Bill-to City" := "Bill-to City";
            PostedServHeader."Bill-to Contact" := "Bill-to Contact";
            PostedServHeader."Sell-to Customer Name" := "Sell-to Customer Name";
            PostedServHeader."Sell-to Customer Name 2" := "Sell-to Customer Name 2";
            PostedServHeader."Sell-to Address" := "Sell-to Address";
            PostedServHeader."Sell-to Address 2" := "Sell-to Address 2";
            PostedServHeader."Sell-to City" := "Sell-to City";
            PostedServHeader."Sell-to Contact" := "Sell-to Contact";
            PostedServHeader."Invoice Disc. Code" := "Invoice Disc. Code";
            // Correct Sales Line
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            IF SalesLine.FINDSET THEN REPEAT
              ProgressWindow.UPDATE(1,'Modifying Sales Line.......');
              PostedServLine.RESET;
              PostedServLine.SETRANGE("Document No.",PostedServHeader."No.");
              PostedServLine.SETRANGE("Line No.",SalesLine."Service Order Line No. EDMS");
              IF PostedServLine.FINDFIRST THEN BEGIN
                SalesLine.VALIDATE("Customer Price Group",PostedServLine."Customer Price Group");
                SalesLine.VALIDATE("Job Type",PostedServLine."Job Type");
                SalesLine."Package No." := PostedServLine."Package No.";
                SalesLine."Package Version No." := PostedServLine."Package Version No.";
                SalesLine."Package Version Spec. Line No." := PostedServLine."Package Version Spec. Line No.";
                SalesLine."Line Discount %" := PostedServLine."Line Discount %";
                IF (SalesLine.Type = SalesLine.Type::"G/L Account") OR
                    (SalesLine.Type = SalesLine.Type::"External Service" )THEN BEGIN
                  SalesLine.Description := PostedServLine.Description;
                  SalesLine."Description 2" := PostedServLine."Description 2";
                  SalesLine.VALIDATE("Unit Cost (LCY)",PostedServLine."Unit Cost (LCY)");
                END;
                IF (SalesLine.Type = SalesLine.Type::"G/L Account") THEN
                  SalesLine.VALIDATE("Unit Price",PostedServLine."Unit Price");
                  SalesLine.VALIDATE(Quantity);
                SalesLine.MODIFY;
                ProgressWindow.UPDATE(1,'Modifying Posted Service Line.......');
                PostedServLine."Sell-to Customer No." := SalesLine."Sell-to Customer No.";
                PostedServLine."Bill-to Customer No." := SalesLine."Bill-to Customer No.";
                PostedServLine.MODIFY;

              END;
            UNTIL SalesLine.NEXT = 0;
          PostedServHeader.MODIFY;
          END;
          //Deleting and Reinserting Remaining Sanjivani Amount
          IF ("Package No." <> '') AND ("Job Type (Before Posting)" = 'SANJIVANI')
          AND ("Sell-to Customer No." = "Bill-to Customer No.")
          THEN
            BEGIN
            ServMgtSetup.RESET;
            ServMgtSetup.GET;
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            SalesLine.SETRANGE(Type,SalesLine.Type::"G/L Account");
            SalesLine.SETRANGE("No.",ServMgtSetup."Sanjivani Rem. B/C Account No.");
            IF SalesLine.FINDSET THEN BEGIN
              ProgressWindow.UPDATE(1,'Deleting Existing Remaining Sanjivani Line.......');
              SalesLine.DELETEALL;
            END;
            ProgressWindow.UPDATE(1,'Calculating Remaining Sanjivani Amount.......');
            CalcRemainingSanjivaniAmount(SalesHeader);
          END;

          // Correct Service Ledger Entry EDMS
          ServLedger.RESET;
          ServLedger.SETCURRENTKEY("Service Order No.","Document Type");
          ServLedger.SETRANGE("Service Order No.","Service Document No.");
          IF ServLedger.FINDSET THEN REPEAT
            ProgressWindow.UPDATE(1,'Modifying Service Ledger Entries.......');
            ServLedger."Customer No." := "Sell-to Customer No.";
            ServLedger."Bill-to Customer No." := "Bill-to Customer No.";
            ServLedger.MODIFY;
          UNTIL ServLedger.NEXT = 0;



        END;
    end;

    procedure CalcRemainingSanjivaniAmount(SalesHeader: Record "36")
    var
        TotalIssuedAmount: Decimal;
        ServicePackage: Record "25006134";
        TotalPackageAmount: Decimal;
        InvalidAmount: Label 'Service Package Amount for Sanjivani (%1) cannot be %2.';
        NewLineNo: Integer;
        SalesLine2: Record "37";
        ServMgtSetup: Record "25006120";
        GenBus: Code[20];
        GenProd: Code[20];
        SanjivaniText: Label 'REMAINING SANJIVANI AMOUNT';
    begin
        TotalIssuedAmount := 0;
        NewLineNo := 0;
        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
        IF SalesLine2.FINDLAST THEN
          NewLineNo := SalesLine2."Line No." + 10000;

        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
        SalesLine2.SETFILTER("Job Type",'%1|%2','SANJIVANI','SANIJIVANI WARRANTY');

        ServicePackage.RESET;
        ServicePackage.GET(SalesHeader."Package No.");
        IF ServicePackage."Total Amount (Sanjivani)" <= 0 THEN
          ERROR(InvalidAmount,ServicePackage."No.",ServicePackage."Total Amount (Sanjivani)");
        TotalPackageAmount := ServicePackage."Total Amount (Sanjivani)";
        IF SalesLine2.FINDFIRST THEN
        GenBus := SalesLine2."Gen. Bus. Posting Group";
        GenProd := SalesLine2."Gen. Prod. Posting Group";
        REPEAT
          TotalIssuedAmount += SalesLine2."Line Amount";
        UNTIL SalesLine2.NEXT=0;

        //Insert Sales Line for Remaining Sanjivani Amount
        IF TotalIssuedAmount <> TotalPackageAmount THEN BEGIN
          WITH SalesHeader DO BEGIN
            SalesLine2.INIT;
            SalesLine2."Document Type":="Document Type";
            SalesLine2."Document No.":= "No.";
            SalesLine2."Line No." := NewLineNo;
            SalesLine2.Type := SalesLine2.Type::"G/L Account";

            ServMgtSetup.RESET;
            ServMgtSetup.GET;
            SalesLine2.VALIDATE("No.",ServMgtSetup."Sanjivani Rem. B/C Account No.");
            SalesLine2."Document Profile" := SalesLine2."Document Profile"::Service;
            SalesLine2."Service Order No. EDMS" := "Service Document No.";
            SalesLine2."Package No." := ServicePackage."No.";
            SalesLine2."Responsibility Center" := "Responsibility Center";
            SalesLine2."Accountability Center" := "Accountability Center";
            SalesLine2."Job Type" := 'SANJIVANI';

            SalesLine2.VALIDATE(Quantity,1);
            SalesLine2.VALIDATE("Unit Price",TotalPackageAmount-TotalIssuedAmount);
            SalesLine2."Location Code" := "Location Code";
            SalesLine2.Description := SanjivaniText;
            SalesLine2."Shipment Date" := "Posting Date";
            SalesLine2.INSERT(TRUE);
            SalesLine2.VALIDATE("Shortcut Dimension 1 Code","Shortcut Dimension 1 Code");
            SalesLine2.VALIDATE("Shortcut Dimension 2 Code","Shortcut Dimension 2 Code");

            SalesLine2.VALIDATE("Vehicle Serial No.","Vehicle Serial No.");
            SalesLine2.Kilometrage := Kilometrage;
        //    SalesLine2."Gen. Prod. Posting Group" := ServMgtSetup."Sanjivani Gen. Bus. Posting Gr";
        //    SalesLine2."Gen. Prod. Posting Group" := ServMgtSetup."Sanjivani Gen. Pro. Posting Gr";
            SalesLine2.MODIFY;
           END;


        END;
    end;

    procedure AllocateCustomer()
    var
        CustAllocateSales: Record "33019860";
        SalesLine: Record "37";
    begin
        IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN BEGIN
            CustAllocateSales.INIT;
            CustAllocateSales."Booked Date" := "Booked Date";
            SalesLine.RESET;
            SalesLine.SETRANGE("Document No.","No.");
            IF SalesLine.FINDFIRST THEN BEGIN
               CustAllocateSales."Model Version No." := SalesLine."Model Version No.";
            END;
            CustAllocateSales.INSERT(TRUE);
        END;
    end;

    procedure GetSchemeDiscount(SalesHeader: Record "36")
    var
        SalesLine: Record "37";
        ServScheme: Record "33019862";
        SchemeType: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",,"External Service";
        SchemeDiscount: Decimal;
    begin
        //***SM 10-08-2013 to flow the line discount as per schemes
        TESTFIELD("Scheme Type");
        ServScheme.RESET;
        ServScheme.SETRANGE(Code,"Scheme Type");
        IF ServScheme.FINDFIRST THEN BEGIN
            REPEAT
              SchemeType := ServScheme.Type;
              SchemeDiscount := ServScheme."Discount %";
              SalesLine.RESET;
              SalesLine.SETRANGE("Document No.","No.");
              SalesLine.SETRANGE(Type,SchemeType);
              IF SalesLine.FINDSET THEN BEGIN
                 REPEAT
                   SalesLine.VALIDATE("Line Discount %",SchemeDiscount);
                   SalesLine.MODIFY;
                   IF (SalesLine.Type = SalesLine.Type::"G/L Account") THEN BEGIN
                      SalesLine.VALIDATE("Line Discount %",0);
                      SalesLine.MODIFY;
                   END;
                 UNTIL SalesLine.NEXT = 0;
              END;
            UNTIL ServScheme.NEXT = 0;
        END;
    end;

    procedure ForwardSalesQuote(var SalesHeader: Record "36")
    var
        Salesline: Record "37";
        SalesHeaderRec: Record "36";
        PreviousAccCenter: Code[20];
        PreviousLocatioCode: Code[20];
    begin
        WITH SalesHeader DO BEGIN
          Salesline.RESET;
          Salesline.SETRANGE("Document Type","Document Type");
          Salesline.SETRANGE("Document No.","No.");
          Salesline.SETFILTER("Forward Accountability Center",'<>%1','');
          Salesline.SETFILTER("Forward Location Code",'<>%1','');
          Salesline.SETRANGE("Quote Forwarded",FALSE);
          IF Salesline.FINDFIRST THEN
            REPEAT
              IF NOT Salesline."Quote Forwarded" THEN
                CreateForwardedSalesQuote(Salesline);
            UNTIL Salesline.NEXT = 0;
          END;
    end;

    procedure CreateForwardedSalesQuote(var SalesQuoteLine: Record "37")
    var
        SalesHeader: Record "36";
        SalesLine: Record "37";
        SalesLineRec: Record "37";
        UserSetup: Record "91";
        UserOriginalAccountibilityCenter: Code[20];
        UserOriginalDefaultLocation: Code[10];
        SalesHdrRec: Record "36";
    begin
        //1.check if already forward already exist
        //2. if doesnt exist create
        WITH SalesQuoteLine DO BEGIN
          IF SalesQuoteLine."Quote Forwarded" THEN
            EXIT;

          IF NOT CONFIRM('Do you want to forward the quote to %1',FALSE,"Forward Location Code") THEN
            EXIT;

          UserSetup.GET(USERID);
          UserOriginalAccountibilityCenter := UserSetup."Default Accountability Center";
          UserOriginalDefaultLocation := UserSetup."Default Location";
          UserSetup."Default Accountability Center" := SalesQuoteLine."Forward Accountability Center";
          UserSetup."Default Location" := SalesQuoteLine."Forward Location Code";
          UserSetup.MODIFY;


          SalesHeader.INIT;
          SalesHeader.VALIDATE("Sell-to Customer No.","Sell-to Customer No.");//Min
          SalesHeader."Document Type" := "Document Type";
          SalesHeader."Accountability Center" := "Forward Accountability Center";
          SalesHeader."Location Code" := "Forward Location Code";
          SalesHeader."Posting No." := "Posting No.";
          SalesHeader."Document Profile" := SalesHeader."Document Profile"::"Spare Parts Trade"; //Min
          SalesHdrRec.GET("Document Type","Document No.");
          IF SalesHdrRec."Forwarded PI Quotes" <> '' THEN
            SalesHeader."Forwarded PI Quotes" := SalesHdrRec."Forwarded PI Quotes"
          ELSE
            SalesHeader."Forwarded PI Quotes" := "Document No.";
          IF SalesHdrRec."Dealer PO No." <> '' THEN //Min
            SalesHeader."Dealer PO No." := SalesHdrRec."Dealer PO No.";
          SalesHeader.INSERT(TRUE);

          SalesLine.RESET;
          SalesLine.SETRANGE("Document No.","Document No.");
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Forward Accountability Center","Forward Accountability Center");
          SalesLine.SETRANGE("Forward Location Code","Forward Location Code");
          SalesLine.SETRANGE("Quote Forwarded",FALSE);
          IF SalesLine.FINDFIRST THEN
            REPEAT
              SalesLineRec := SalesLine;
              SalesLineRec."Document No." := SalesHeader."No.";
              SalesLineRec."Accountability Center" := SalesLine."Forward Accountability Center";
              SalesLineRec."Location Code" := SalesLine."Forward Location Code";
              //SalesLineRec."Quote Forwarded" := TRUE;
              SalesLineRec."Forward Accountability Center" := '';
              SalesLineRec."Forward Location Code" := '';
              SalesLineRec.INSERT;

              //SalesLine."Quote Forwarded" := TRUE;
              //SalesLine.MODIFY;
              SalesLine.DELETE;
              UNTIL SalesLine.NEXT = 0;


          UserSetup.GET(USERID);
          UserSetup."Default Accountability Center" := UserOriginalAccountibilityCenter;
          UserSetup."Default Location" := UserOriginalDefaultLocation;
          UserSetup.MODIFY;
          MESSAGE('Sales Quote forwarded Sucessfully! new forwarded sales quote is %1',SalesHeader."No.");
          END;
    end;

    procedure SkipIfService(): Boolean
    begin
        ServiceAddr := TRUE;
        EXIT(ServiceAddr);
    end;

    procedure ForwardSalesOrder(var SalesHeader1: Record "36")
    begin
        WITH SalesHeader1 DO BEGIN
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETFILTER("Forward Accountability Center",'<>%1','');
          SalesLine.SETFILTER("Forward Location Code",'<>%1','');
          SalesLine.SETRANGE("Quote Forwarded",FALSE);
          IF SalesLine.FINDFIRST THEN
            REPEAT
              IF NOT SalesLine."Quote Forwarded" THEN
                CreateSalesOrder(SalesLine);
              UNTIL SalesLine.NEXT = 0;
        END;
    end;

    procedure CreateSalesOrder(var SalesLine1: Record "37")
    var
        UserSetup1: Record "91";
        UserOriginalAccCenter: Code[20];
        UserorgDefLocCenter: Code[20];
        SalesHeader1: Record "36";
        SalesHeader2: Record "36";
        SalesLine01: Record "37";
        SalesLine01Rec: Record "37";
    begin
        WITH SalesLine1 DO BEGIN
          IF SalesLine1."Quote Forwarded" THEN
            EXIT;
          IF NOT CONFIRM('do you want to forward the location to %1',FALSE,"Forward Location Code") THEN
            EXIT;
          UserSetup1.GET(USERID);
          UserorgDefLocCenter := UserSetup1."Default Location";
          UserOriginalAccCenter := UserSetup1."Default Accountability Center";
          UserSetup1."Default Accountability Center" := SalesLine1."Forward Accountability Center";
          UserSetup1."Default Location" := SalesLine1."Forward Location Code";
          UserSetup1.MODIFY;

          SalesHeader1.INIT;
          SalesHeader1.VALIDATE("Document Type",SalesHeader1."Document Type"::Order);
          SalesHeader1.VALIDATE("Sell-to Customer No.","Sell-to Customer No.");

          SalesHeader1.VALIDATE("Accountability Center","Forward Accountability Center");
          SalesHeader1.VALIDATE("Location Code","Forward Location Code");
          SalesHeader1.VALIDATE("Posting No.","Posting No.");
          SalesHeader1."Document Profile" := SalesHeader1."Document Profile"::"Spare Parts Trade";

          SalesHeader2.GET("Document Type","Document No.");
          IF SalesHeader2."Forwarded PI Quotes" <> '' THEN
            SalesHeader1."Forwarded PI Quotes" := SalesHeader2."Forwarded PI Quotes"
          ELSE
            SalesHeader1."Forwarded PI Quotes" := "Document No.";
          IF SalesHeader2."Dealer PO No." <> '' THEN
            SalesHeader1."Dealer PO No." := SalesHeader2."Dealer PO No.";
          SalesHeader1.INSERT(TRUE);

          SalesLine01.RESET;
          SalesLine01.SETRANGE("Document No.","Document No.");
          SalesLine01.SETRANGE("Document Type","Document Type");
          SalesLine01.SETRANGE("Forward Accountability Center","Forward Accountability Center");
          SalesLine01.SETRANGE("Forward Location Code","Forward Location Code");
          SalesLine01.SETRANGE("Quote Forwarded",FALSE);
          IF SalesLine01.FINDFIRST THEN
            REPEAT
              SalesLine01Rec := SalesLine01;
              SalesLine01Rec."Document No." := SalesHeader1."No.";
              SalesLine01Rec."Accountability Center" := SalesLine01."Forward Accountability Center";
              SalesLine01Rec."Location Code" := SalesLine01."Forward Location Code";
              SalesLine01Rec."Forward Accountability Center" := '';
              SalesLine01Rec."Forward Location Code" := '';
              SalesLine01Rec.INSERT;

              SalesLine01.DELETE;
              UNTIL SalesLine01.NEXT = 0;

        UserSetup1.GET(USERID);
        UserSetup1."Default Accountability Center" := UserOriginalAccCenter;
        UserSetup1."Default Location" := UserorgDefLocCenter;
        UserSetup1.MODIFY;
        MESSAGE('Sales Order has been forwared sucessfully. New sales order is %1',SalesHeader."No.");

          END;
    end;

    procedure SkipWhileCopyDoc()
    begin
        SkipCopy := TRUE;
    end;

    local procedure SetShipToAddressForQuote()
    begin
        "Ship-to Name" := "Sell-to Customer Name";
        "Ship-to Name 2" := "Sell-to Customer Name 2";
        "Ship-to Address" := "Sell-to Address";
        "Ship-to Address 2" := "Sell-to Address 2";
        "Ship-to City" := "Sell-to City";
        "Ship-to Post Code" := "Sell-to Post Code";
        "Ship-to County" := "Sell-to County";
        "Ship-to Country/Region Code" := "Sell-to Country/Region Code";

        "Bill-to Name" := "Sell-to Customer Name";
        "Bill-to Name 2" := "Sell-to Customer Name 2";
        "Bill-to Address" := "Sell-to Address";
        "Bill-to Address 2" := "Sell-to Address 2";
        "Bill-to City" := "Sell-to City";
        "Bill-to Post Code" := "Sell-to Post Code";
        "Bill-to County" := "Sell-to County";
        "Bill-to Country/Region Code" := "Sell-to Country/Region Code";
    end;

    local procedure LCClearIfSellToCustomerUsed()
    begin
        IF "Sys. LC No." = '' THEN
          EXIT;
        IF "Sell-to Customer No." = '' THEN
          EXIT;
        IF NOT CONFIRM('LC No. will be cleared if you change the customer.Do you want to continue?',FALSE) THEN
          ERROR('');
        "Sys. LC No." := '';
    end;

    procedure InitRecord2ForDocFromDealer()
    begin
        SalesSetup.GET;
        CASE "Document Type" OF
          "Document Type"::Quote,"Document Type"::Order:
            BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                            StplSysMgt.getLocWiseNoSeriesForDocFromDealer(DocumentProfile::Sales,DocumentType::"Posted Invoice","Location Code"));
              NoSeriesMgt.SetDefaultSeries("Shipping No. Series",
                                            StplSysMgt.getLocWiseNoSeriesForDocFromDealer(DocumentProfile::Sales,DocumentType::"Posted Shipment","Location Code"));

              IF "Document Type" = "Document Type"::Order THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",
                                            StplSysMgt.getLocWiseNoSeriesForDocFromDealer(DocumentProfile::Sales,DocumentType::"Posted Prepmt. Inv.","Location Code")
        );
                NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",
                                            StplSysMgt.getLocWiseNoSeriesForDocFromDealer(DocumentProfile::Sales,
                                            DocumentType::"Posted Prepmt. Cr. Memo","Location Code"));
              END;

            END;
        END;
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote] THEN
          BEGIN
          "Shipment Date" := WORKDATE;
          "Order Date" := WORKDATE;
        END;
        IF "Document Type" = "Document Type"::"Return Order" THEN
          "Order Date" := WORKDATE;

        IF NOT ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) AND
           ("Posting Date" = 0D)
        THEN
          "Posting Date" := WORKDATE;

        IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" THEN
          "Posting Date" := 0D;

        "Document Date" := WORKDATE;
        // Below Code is commented to get default location from user setup table
        //VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center")); Standard
        // Sipradi-YS GEN6.1.0 * Code to get default location
        VALIDATE("Location Code",UserSetupMgt.GetLocation2);
        // Sipradi-YS END
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          GLSetup.GET;
          Correction := GLSetup."Mark Cr. Memos as Corrections";
        END;

        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

        Reserve := Reserve::Optional;

        IF InvtSetup.GET THEN
          VALIDATE("Outbound Whse. Handling Time",InvtSetup."Outbound Whse. Handling Time");
        IF UserSetupMgt.DefaultResponsibility THEN
          "Responsibility Center" := UserSetupMgt.GetRespCenter(0,"Responsibility Center")
        ELSE
          "Accountability Center" := UserSetupMgt.GetRespCenter(0,"Accountability Center");
    end;

    //Unsupported feature: Insertion (FieldGroupCollection) on "(FieldGroup: DropDown)".


    var
        Cont: Record "5050";
        ShipAdd: Record "222";
        ShipAddPage: Page "301";

    var
        UserSetup: Record "91";
        Location2: Record "14";
        ArchiveManagement: Codeunit "5063";
        CustomerPostingGroup: Record "92";
        ShipAdd: Record "222";
        ShipCount: Integer;
        ShipAddPage: Page "301";
        SalesOrder: Page "42";

    var
        CompanyInfo: Record "79";

    var
        LicensePermission: Record "2000000043";

    var
        StplSysMgt: Codeunit "50000";

    var
        Vehicle: Record "25006005";


    //Unsupported feature: Property Modification (Id) on "SynchronizingMsg(Variable 1026)".

    //var
    //>>>> ORIGINAL VALUE:
    //SynchronizingMsg : 1026;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SynchronizingMsg : 1001026;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PostedDocsToPrintCreatedMsg(Variable 1084)".

    //var
    //>>>> ORIGINAL VALUE:
    //PostedDocsToPrintCreatedMsg : 1084;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PostedDocsToPrintCreatedMsg : 10841;
    //Variable type has not been exported.

    var
        Contract: Record "25006016";
        ServiceSetup: Record "25006120";

    var
        VFMgt: Codeunit "25006004";

    var
        Text12800: Label 'This field can be used only for documents with type %1 or %2';
        Text125: Label 'Do You want to link this vehice to contact No. %1?';
        VehPriceMgt: Codeunit "25006301";
        Text200: Label 'Model version No. %1 cost is not adjusted. Do you want to continue?';
        FindVehicle: Boolean;
        FindCustomer: Boolean;
        VehicleConfirm: Label 'There is a vehicle linked to this contact.\%1 %2\%3 %4\%5 %6\Do you want to apply this vehicle?';
        ContactConfirm: Label 'There is a customer linked to this vehicle.\%1 %2\Do you want to apply this customer?';
        LookUpMgt: Codeunit "25006003";
        Text131: Label 'There is no vehicle with Registration No. %1';
        PromptProfile: Boolean;
        TextDlg001: Label 'Default,Spare Parts Trade,Vehicles Trade';
        ValueEntry: Record "5802";
        ItemChargeAssgntSales: Record "5809";
        Currency: Record "4";
        Text136: Label 'Cutomer No. %1 have %2 active contracts!';
        DontFindContract: Boolean;
        TextEDMS100: Label 'Do you want to print prepayment invoice %1?';

    var
        LCAmendDetail: Record "33020013";
        StplSysMgt: Codeunit "50000";
        DocumentProfile: Option Purchase,Sales,Service,Transfer;
        DocumentType: Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order","Posted Debit Note";
        RespCenter2: Record "5714";
        "---CNY.CRM-------------": Integer;
        PipelineMgtDetails_G: Record "33020141";
        SalesLine_G: Record "37";
        LineNo: Integer;
        SalesHeader_G: Record "36";
        AccCenter: Record "33019846";
        AccCenter2: Record "33019846";
        SalesLine_Confirmation: Record "37";
        DealerDelErr: Label 'You cannot delete the Sales Order created from Dealer Portal.';
        DealerInformation: Record "33020428";
        QRPrintMgt: Codeunit "50007";
        ServiceAddr: Boolean;
        SkipCopy: Boolean;
        VehicleInsurance: Record "25006033";
}

