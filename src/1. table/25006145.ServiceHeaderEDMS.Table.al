table 25006145 "Service Header EDMS"
{
    // 02.05.2017 EB.P7
    //   Added fields:
    //     "Customer Signature Image"
    //     "Customer Signature Text"
    //     "Employee Signature Image"
    //     "Employee Signature Text"
    // 
    // 30.08.2016 EB.P7 WSH16
    //   Field added:
    //     25007405"Finished Travel Qty (Hours)"
    //   Modified flow field formula Finished Quantity (Hours)
    // 
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified GetUserSetup(), Usert Profile Setup to Branch Profile Setup
    // 
    // 12.02.2016 EB.P7
    //   Added field Mobile Phone No.
    // 
    // 23.04.2015 EDMS P21
    //   Added function:
    //     OnLookupVIN
    //   Modified functions:
    //     RecreateDmsServLines
    //   Modified triggers:
    //     VIN - OnLookup
    //     Vehicle Serial No. - OnValidate
    //     Deal Type - OnValidate
    // 
    // 16.04.2015 EB.P7 #S0150 MMG7.00
    //   Fixed rename record problem. Posting No. copies only in init procedure.
    // 
    // 16.03.2015 EDMS P21
    //   Modified triggers:
    //     Make Code - OnValidate
    //     Vehicle Serial No. - OnValidate
    //   Modified functions:
    //     CheckVehicleCreated
    //     RecreateDmsServLines
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 09.03.2015 EB.P7 #Serv. Sched. Setup
    //   New message added Text138, when Schedule Setup Entry does not exist.
    // 
    // 20.02.2015 EDMS P21
    //   Set Editable property to Yes for field:
    //     "Model Version No."
    //   Modified triggers:
    //     Model Version No. - OnLookup
    //     VIN - OnValidate
    //     Vehicle Registration No. - OnValidate
    //     Vehicle Serial No. - OnValidate
    // 
    // 19.02.2015 EDMS P21
    //   Modified trigger:
    //     Sell-to Contact No. - OnValidate
    //   Modified function:
    //     UpdateSellToCont
    // 
    // 27.01.2015 EB.P7 #E0062 MMG7.00
    //   Updated vehicle search after customer choose
    // 
    // 27.10.2014 EB.P8 #S0218 MMG7.00
    //   Removed error when change sell to customer system went in loop.
    // 
    // 19.05.2014 Elva Baltic P21 #S0108 MMG7.00
    //   Added function:
    //     CalcAmountIncVAT
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified OptionString for field:
    //     "Applies-to Doc. Type"
    //   Modified triggers:
    //     Applies-to Doc. No. - OnValidate()
    //   Deleted code in trigger:
    //     Applies-to Doc. No. - OnLookup()
    // 
    // 08.05.2014 Elva Baltic P8 #S0084 MMG7.00
    //   * Do not allow to set blocked vehicle
    // 
    // 17.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Modified OnDelete trigger
    // 
    // 16.04.2014 Elva Baltic P7 # MMG7.00
    //   * Field "Shipping Agent Code" added
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     RecreateDmsServLines
    //   Added field:
    //     Contract No.
    // 
    // 04.04.2014 Elva Baltic P8 E0011 MMG7.00
    //   * Fix in bahavior of vehicle change
    //   * Modified Vehicle Status Code-OnValidate
    // 
    //   Added code to:
    //     Bill-to Customer No. - OnValidate()
    // 
    //   Added Code to trigger
    //     OnDelete()
    // 
    // 29.05.2013 Elva Baltic P15
    //   * Show Vehicle Contact table instead of Customer
    // 
    // 08.05.2013 EDMS P8
    //   * Implement use of T25006126."Auto Order By Exp. Date"
    // 14.03.2013 EDMS P8
    //   * Added fields: "Prepayment Share Sell-To %"
    // 25.02.2013 EDMS P8
    //   * Implement new dimensions
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3
    //   * added functions: TestVFRun2, TestVFRun3
    //   * new variable VehicleServicePlanStageTmp_CS - temporarely stores current/last selected plan stage
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management

    Caption = 'Service Document';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    DrillDownPageID = 25006185;
    LookupPageID = 25006254;
    Permissions = TableData 25006036 = rim;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                DocumentMgt: Codeunit "25006000";
                codVin: Code[20];
                recVeh: Record "25006005";
                ShipAdd: Record "222";
                ShipCount: Integer;
                ShipAddPage: Page "301";
            begin
                IF ("Sell-to Customer No." <> xRec."Sell-to Customer No.") AND (xRec."Sell-to Customer No." <> '') THEN BEGIN
                    Confirmed := ConfirmLoc(STRSUBSTNO(Text004, FIELDCAPTION("Sell-to Customer No.")), FALSE, '');
                    IF Confirmed THEN BEGIN
                        ServLine.SETRANGE("Document Type", "Document Type");
                        ServLine.SETRANGE("Document No.", "No.");
                        IF "Sell-to Customer No." = '' THEN BEGIN
                            IF ServLine.FINDFIRST THEN
                                ERROR(Text005, FIELDCAPTION("Sell-to Customer No."));
                            INIT;
                            ServiceSetup.GET;
                            InitRecord2;
                            "No. Series" := xRec."No. Series";
                            IF xRec."Posting No." <> '' THEN BEGIN
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            END;
                            //08-05-2007 EDMS P3 PREPMT >>
                            IF xRec."Prepayment No." <> '' THEN BEGIN
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            END;
                            IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            END;
                            //08-05-2007 EDMS P3 PREPMT <<
                            EXIT;
                        END;
                        //08-05-2007 EDMS P3 PREPMT >>
                        IF "Document Type" = "Document Type"::Order THEN BEGIN
                            ServLine.SETFILTER("Prepmt. Amt. Inv.", '<>0');
                            IF ServLine.FINDFIRST THEN
                                ServLine.TESTFIELD("Prepmt. Amt. Inv.", 0);
                            ServLine.SETRANGE("Prepmt. Amt. Inv.");
                        END;
                        //08-05-2007 EDMS P3 PREPMT <<
                        ServLine.RESET
                    END
                    ELSE BEGIN
                        Rec := xRec;
                        EXIT;
                    END;
                END;

                IF ("Document Type" = "Document Type"::Order) AND (xRec."Sell-to Customer No." <> "Sell-to Customer No.") THEN BEGIN
                    ServLine.SETRANGE("Document Type", ServLine."Document Type"::Order);
                    ServLine.SETRANGE("Document No.", "No.");
                    ServLine.SETFILTER("Purch. Order Line No.", '<>0');
                    IF ServLine.FINDFIRST THEN
                        ERROR(Text006, FIELDCAPTION("Sell-to Customer No."));
                    ServLine.RESET;
                END;

                GetCust("Sell-to Customer No.");
                Cust.CheckBlockedCustOnDocs(Cust, "Document Type", FALSE, FALSE);
                Cust.TESTFIELD("Gen. Bus. Posting Group");


                "Sell-to Customer Template Code" := '';
                "Sell-to Customer Name" := COPYSTR(Cust.Name, 1, MAXSTRLEN("Sell-to Customer Name"));
                "Sell-to Customer Name 2" := COPYSTR(Cust."Name 2", 1, MAXSTRLEN("Sell-to Customer Name 2"));
                ;
                "Sell-to Address" := COPYSTR(Cust.Address, 1, MAXSTRLEN("Sell-to Address"));
                ;
                "Sell-to Address 2" := COPYSTR(Cust."Address 2", 1, MAXSTRLEN("Sell-to Address 2"));
                ;
                "Sell-to City" := Cust.City;
                "Sell-to Post Code" := Cust."Post Code";
                "Sell-to County" := Cust.County;
                "Sell-to Country/Region Code" := Cust."Country/Region Code";
                //"Prices Including VAT" :=  Cust."Prices Including VAT";
                IF NOT SkipSellToContact THEN
                    "Sell-to Contact" := Cust.Contact;
                "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                "VAT Registration No." := Cust."VAT Registration No.";

                GLSetup.GET;
                IF NOT GLSetup."Use Accountability Center" THEN
                    "Responsibility Center" := UserMgt.GetRespCenter(3, Cust."Responsibility Center")
                ELSE
                    "Accountability Center" := UserMgt.GetRespCenter(3, Cust."Accountability Center");
                //VALIDATE("Location Code",UserMgt.GetLocation(3,Cust."Location Code","Responsibility Center"));

                VALIDATE("Vehicle Item Charge No.", Cust."Default Service Item Charge");


                IF Cust."Bill-to Customer No." <> '' THEN
                    VALIDATE("Bill-to Customer No.", Cust."Bill-to Customer No.")
                ELSE BEGIN
                    IF "Bill-to Customer No." = "Sell-to Customer No." THEN
                        SkipBillToContact := TRUE;
                    VALIDATE("Bill-to Customer No.", "Sell-to Customer No.");
                    SkipBillToContact := FALSE;
                END;

                IF NOT SkipSellToContact THEN BEGIN  //27.10.2014 EB.P8 #S0218 MMG7.00
                    SkipSellToContact := TRUE;
                    UpdateSellToCont("Sell-to Customer No.");
                    SkipSellToContact := FALSE;
                END;

                //GetUserSetup; moved to No. Onvalidate //Sipradi-Yuran


                IF (xRec."Sell-to Customer No." <> "Sell-to Customer No.") OR
                   (xRec."Currency Code" <> "Currency Code") OR
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") OR
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group") THEN
                    RecreateDmsServLines(FIELDCAPTION("Sell-to Customer No."));

                IF (xRec."Sell-to Customer No." <> "Sell-to Customer No.") AND ("Sell-to Customer No." <> '') THEN
                    DocumentMgt.ShowCustomerComments("Sell-to Customer No.");

                //sp
                IF "Sell-to Customer No." <> xRec."Sell-to Customer No." THEN BEGIN
                    ShipAdd.SETRANGE("Customer No.", "Sell-to Customer No.");
                    ShipAddPage.LOOKUPMODE := TRUE;
                    ShipAddPage.SETTABLEVIEW(ShipAdd);
                    COMMIT;
                    IF ShipAddPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        ShipAddPage.GETRECORD(ShipAdd);
                        //VALIDATE("Ship-to Code",ShipAdd.Code);
                        CompanyInfo.GET;
                        IF CompanyInfo."Balaju Auto Works" THEN BEGIN
                            //prabesh
                            VALIDATE("Bill-to Address", ShipAdd.Address);
                            VALIDATE("Bill-to Address 2", ShipAdd."Address 2");
                            //VALIDATE("Bill-to City",ShipAdd.City);
                            //VALIDATE("Bill-to Post Code",ShipAdd."Post Code");
                            //VALIDATE("Bill-to County",ShipAdd.County);
                            //VALIDATE("Bill-to Country/Region Code",ShipAdd."Country/Region Code");

                            VALIDATE("Service Address Code", ShipAdd.Code);
                            VALIDATE("Sell-to Address", ShipAdd.Address);
                            VALIDATE("Sell-to Address 2", ShipAdd."Address 2");
                            VALIDATE("Sell-to City", ShipAdd.City);
                            // VALIDATE("Sell-to Post Code",ShipAdd."Post Code");
                            VALIDATE("Sell-to County", ShipAdd.County);
                            VALIDATE("Sell-to Country/Region Code", ShipAdd."Country/Region Code");
                            VALIDATE("Ship Add Name 2", ShipAdd."Name 2");
                        END;
                    END;
                END;
                //sp
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    ServiceSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode2);
                    "No. Series" := '';
                END;

                //16.04.2015 EB.P7 #S0150 MMG7.00 >>
                //IF ServiceSetup."Use Order No. as Posting No." THEN
                //  CASE "Document Type" OF
                //    "Document Type"::Order:
                //      "Posting No." := "No.";
                //    "Document Type"::"Return Order":
                //      "Pst. Return Order No." := "No."
                //  END
                //16.04.2015 EB.P7 #S0150 MMG7.00 <<
            end;
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                ContBusRel: Record "5054";
                Cont: Record "5050";
                recServContract: Record "25006016";
                UserSetup: Record "91";
                Location1: Record "14";
                Location2: Record "14";
                ShipAdd: Record "222";
                ShipCount: Integer;
                ShipAddPage: Page "301";
            begin
                IF (xRec."Bill-to Customer No." <> "Bill-to Customer No.") AND (xRec."Bill-to Customer No." <> '') THEN BEGIN
                    Confirmed := ConfirmLoc(STRSUBSTNO(Text004, FIELDCAPTION("Bill-to Customer No.")), FALSE, '');
                    IF Confirmed THEN BEGIN
                        ServLine.SETRANGE("Document Type", "Document Type");
                        ServLine.SETRANGE("Document No.", "No.");
                        //08-05-2007 EDMS P3 PREPMT >>
                        IF "Document Type" = "Document Type"::Order THEN BEGIN
                            ServLine.SETFILTER("Prepmt. Amt. Inv.", '<>0');
                            IF ServLine.FINDFIRST THEN
                                ServLine.TESTFIELD("Prepmt. Amt. Inv.", 0);
                            ServLine.SETRANGE("Prepmt. Amt. Inv.");
                        END;
                        //08-05-2007 EDMS P3 PREPMT <<
                        ServLine.RESET
                    END ELSE
                        "Bill-to Customer No." := xRec."Bill-to Customer No.";
                END;
                //sp if required change bill to here
                /* IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN BEGIN
                    ShipAdd.SETRANGE("Customer No.","Sell-to Customer No.");
                       ShipAddPage.LOOKUPMODE := TRUE;
                       ShipAddPage.SETTABLEVIEW(ShipAdd);

                       IF ShipAddPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                         ShipAddPage.GETRECORD(ShipAdd);
                         //VALIDATE("Ship-to Code",ShipAdd.Code);
                         VALIDATE("Bill-to Address",ShipAdd.Code);
                       END;
                   END;
                   */
                //sp
                GetCust("Bill-to Customer No.");
                Cust.CheckBlockedCustOnDocs(Cust, "Document Type", FALSE, FALSE);
                Cust.TESTFIELD("Customer Posting Group");

                IF GUIALLOWED AND (CurrFieldNo <> 0) THEN BEGIN
                    "Amount Including VAT" := 0;
                END;

                IF GUIALLOWED AND (CurrFieldNo <> 0) THEN BEGIN
                    COMMIT;
                    CustCheckCreditLimit.ServiceHeaderCheckEDMS(Rec);
                END;

                VALIDATE("Vehicle Item Charge No.", Cust."Default Service Item Charge");  //07-09-2007 EDMS P3

                "Bill-to Customer Template Code" := '';

                "Bill-to Name" := COPYSTR(Cust.Name, 1, MAXSTRLEN("Bill-to Name"));

                "Bill-to Name 2" := COPYSTR(Cust."Name 2", 1, MAXSTRLEN("Bill-to Name 2"));
                ;
                /*//prabesh
                "Bill-to Address" := COPYSTR("Bill-to Address", 1, MAXSTRLEN("Bill-to Address"));;
                "Bill-to Address 2" := COPYSTR("Bill-to Address 2", 1, MAXSTRLEN("Bill-to Address 2"));;//
                */
                "Bill-to City" := Cust.City;
                "Bill-to Post Code" := Cust."Post Code";
                "Bill-to County" := Cust.County;
                "Bill-to Country/Region Code" := Cust."Country/Region Code";

                IF NOT SkipBillToContact THEN
                    "Bill-to Contact" := Cust.Contact;
                "Payment Terms Code" := Cust."Payment Terms Code";
                //22.08.2008. EDMS P2 >>
                IF Cust."Payment Method Code" <> '' THEN
                    //22.08.2008. EDMS P2 <<
                    "Payment Method Code" := Cust."Payment Method Code";
                "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                "Customer Posting Group" := Cust."Customer Posting Group";
                "Currency Code" := Cust."Currency Code";
                "Customer Price Group" := Cust."Customer Price Group";
                "Prices Including VAT" := Cust."Prices Including VAT";
                "Allow Line Disc." := Cust."Allow Line Disc.";
                "Invoice Disc. Code" := Cust."Invoice Disc. Code";
                "Customer Disc. Group" := Cust."Customer Disc. Group";
                "Customer Price Group" := Cust."Customer Price Group";
                "Language Code" := Cust."Language Code";
                Reserve := Cust.Reserve;
                "VAT Registration No." := Cust."VAT Registration No.";
                IF "Document Type" = "Document Type"::Order THEN
                    "Prepayment %" := Cust."Prepayment %";  //08-05-2007 EDMS P3 PREPMT

                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer, "Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser", "Service Person",
                  DATABASE::"Responsibility Center", "Responsibility Center",
                  DATABASE::"Deal Type", "Deal Type",
                  //DATABASE::Vehicle,VIN,
                  DATABASE::Make, "Make Code",
                  DATABASE::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method", "Payment Method Code",
                  DATABASE::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );


                //Sipradi-YS GEN6.1.0 25006145-1 BEGIN >> Get User Branch/Costcenter (Dimension)
                IF UserSetup.GET(USERID) THEN BEGIN
                    VALIDATE("Shortcut Dimension 1 Code", UserSetup."Shortcut Dimension 1 Code");
                    VALIDATE("Shortcut Dimension 2 Code", UserSetup."Shortcut Dimension 2 Code");
                END;
                //Sipradi-YS GEN6.1.0 25006145-1 END

                VALIDATE("Payment Terms Code");
                VALIDATE("Payment Method Code");
                VALIDATE("Currency Code");

                IF (xRec."Sell-to Customer No." = "Sell-to Customer No.") AND
                   (xRec."Bill-to Customer No." <> "Bill-to Customer No.")
                THEN
                    RecreateDmsServLines(FIELDCAPTION("Bill-to Customer No."));

                IF NOT SkipBillToContact THEN
                    UpdateBillToCont("Bill-to Customer No.");

                IF xRec."Bill-to Customer No." <> "Bill-to Customer No." THEN                 // 15.04.2014 Elva Baltic P21
                    FindContract;                                                               // 15.04.2014 Elva Baltic P21


                GetUserSetupEDMS; //12.14.2012 **Sipradi-YS
                Location.GET(UserSetup."Default Location");
                Location.TESTFIELD("Default Price Group");
                "Customer Price Group" := Location."Default Price Group";

            end;
        }
        field(5; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill-to Name';
        }
        field(6; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
        }
        field(7; "Bill-to Address"; Text[50])
        {
            Caption = 'Bill-to Address';
        }
        field(8; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(9; "Bill-to City"; Text[50])
        {
            Caption = 'Bill-to City';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity("Bill-to City","Bill-to Post Code",TRUE); //30.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //30.10.2012 EDMS >>
                PostCode.ValidateCity(
                  "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
                //30.10.2012 EDMS <<
            end;
        }
        field(10; "Bill-to Contact"; Text[50])
        {
            Caption = 'Bill-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';

            trigger OnValidate()
            begin
                VALIDATE("Planned Service Date", "Order Date");

                CheckServicePlan(FIELDNO("Order Date"));
            end;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                NoSeries: Record "308";
            begin
                TestNoSeriesDate(
                  "Posting No.", "Posting No. Series",
                  FIELDCAPTION("Posting No."), FIELDCAPTION("Posting No. Series"));
                TestNoSeriesDate(
                  "Prepayment No.", "Prepayment No. Series",
                  FIELDCAPTION("Prepayment No."), FIELDCAPTION("Prepayment No. Series"));
                TestNoSeriesDate(
                  "Prepmt. Cr. Memo No.", "Prepmt. Cr. Memo No. Series",
                  FIELDCAPTION("Prepmt. Cr. Memo No."), FIELDCAPTION("Prepmt. Cr. Memo No. Series"));

                VALIDATE("Document Date", "Posting Date");

                IF ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::Booking]) AND NOT ("Posting Date" = xRec."Posting Date")
                THEN
                    PriceMessageIfServLinesExist(FIELDCAPTION("Posting Date"));

                IF "Currency Code" <> '' THEN BEGIN
                    UpdateCurrencyFactor;
                    IF "Currency Factor" <> xRec."Currency Factor" THEN
                        ConfirmUpdateCurrencyFactor;
                END;
            end;
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            begin
                UpdateDMSServLines(FIELDCAPTION("Shipment Date"), CurrFieldNo <> 0);
            end;
        }
        field(22; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                    PaymentTerms.GET("Payment Terms Code");
                    IF (("Document Type" IN ["Document Type"::"5", "Document Type"::Booking]) AND
                      NOT (PaymentTerms."Calc. Pmt. Disc. on Cr. Memos"))
                    THEN
                        VALIDATE("Due Date", "Document Date")
                    ELSE
                        "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Document Date");
                END
                ELSE
                    VALIDATE("Due Date", "Document Date");
                //08-05-2007 EDMS P3 PREPMT >>
                IF xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" THEN BEGIN
                    IF xRec."Prepayment Due Date" = 0D THEN
                        "Prepayment Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Document Date");
                    VALIDATE("Prepmt. Payment Terms Code", "Payment Terms Code");
                END;
                //08-05-2007 EDMS P3 PREPMT <<
            end;
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                GLSetup.GET;
                IF "Payment Discount %" < GLSetup."VAT Tolerance %" THEN
                    "VAT Base Discount %" := "Payment Discount %"
                ELSE
                    "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                VALIDATE("VAT Base Discount %");
            end;
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE(Use As In-Transit=CONST(No));

            trigger OnValidate()
            begin
                IF ("Location Code" <> xRec."Location Code") AND (xRec."Sell-to Customer No." = "Sell-to Customer No.") THEN
                    MessageIfServLinesExist(FIELDCAPTION("Location Code"));

                // 10.03.2015 EDMS P21 >>
                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer, "Bill-to Customer No.",
                  DATABASE::Location, "Location Code",
                  DATABASE::"Salesperson/Purchaser", "Service Person",
                  DATABASE::"Responsibility Center", "Responsibility Center",
                  DATABASE::"Deal Type", "Deal Type",
                  DATABASE::Make, "Make Code",
                  DATABASE::Vehicle, "Vehicle Serial No.",
                  DATABASE::"Payment Method", "Payment Method Code"
                  );
                // 10.03.2015 EDMS P21 <<

                IF "Document Type" = "Document Type"::Booking THEN BEGIN
                    "TCard Container Entry No." := TCardMgt.GetInitialContainerNo("Location Code");
                END;
            end;
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                //MODIFY;  //25.02.2013 EDMS P8
            end;
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                //MODIFY;  //25.02.2013 EDMS P8
            end;
        }
        field(31; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF CurrFieldNo <> FIELDNO("Currency Code") THEN
                    UpdateCurrencyFactor
                ELSE BEGIN
                    IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                        UpdateCurrencyFactor;
                        RecreateDmsServLines(FIELDCAPTION("Currency Code"));
                    END
                    ELSE
                        IF "Currency Code" <> '' THEN BEGIN
                            UpdateCurrencyFactor;
                            IF "Currency Factor" <> xRec."Currency Factor" THEN
                                ConfirmUpdateCurrencyFactor;
                        END;
                END;
            end;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Currency Factor" <> xRec."Currency Factor" THEN
                    UpdateDMSServLines(FIELDCAPTION("Currency Factor"), FALSE);
            end;
        }
        field(34; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
            Editable = false;

            trigger OnValidate()
            var
                Currency: Record "4";
                RecalculatePrice: Boolean;
                SalesHeader: Record "36";
                ServLine: Record "25006146";
                ServLineCopy: Record "25006146";
            begin
                TESTFIELD(Status, Status::Open);

                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN

                    SalesHeader.RESET;
                    SalesHeader.SETCURRENTKEY("Service Document No.");
                    SalesHeader.SETFILTER("Document Type", '%1|%2', SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo");
                    SalesHeader.SETRANGE("Service Document No.", "No.");
                    IF SalesHeader.FINDFIRST THEN
                        ERROR(Text101);

                    ServLine.SETRANGE("Document Type", "Document Type");
                    ServLine.SETRANGE("Document No.", "No.");
                    ServLine.SETFILTER("Unit Price", '<>%1', 0);
                    ServLine.SETFILTER("VAT %", '<>%1', 0);
                    IF ServLine.FINDFIRST THEN BEGIN
                        RecalculatePrice :=
                          ConfirmLoc(
                            STRSUBSTNO(
                              Text024 +
                              Text026,
                              FIELDCAPTION("Prices Including VAT"), ServLine.FIELDCAPTION("Unit Price")),
                            TRUE, '');
                        ServLine.SetServHeader(Rec);

                        IF "Currency Code" = '' THEN
                            Currency.InitRoundingPrecision
                        ELSE
                            Currency.GET("Currency Code");
                        ServLine.LOCKTABLE;
                        LOCKTABLE;
                        ServLine.FINDSET;
                        REPEAT
                            //27.08.2007. EDMS P2 >>
                            ServLine.TESTFIELD("Prepayment %", 0);
                            //27.08.2007. EDMS P2 <<

                            ServLineCopy := ServLine;
                            ServLine.TESTFIELD("Prepmt. Amt. Inv.", 0); //08-05-2007 EDMS P3 PREPMT
                            IF NOT RecalculatePrice THEN BEGIN
                                ServLine."VAT Difference" := 0;
                                ServLine.InitOutstandingAmount;
                            END ELSE
                                IF "Prices Including VAT" THEN BEGIN
                                    ServLine."Unit Price" :=
                                      ROUND(
                                        ServLine."Unit Price" * (1 + (ServLine."VAT %" / 100)),
                                        Currency."Unit-Amount Rounding Precision");
                                    IF ServLine.Quantity <> 0 THEN BEGIN
                                        ServLine."Line Discount Amount" :=
                                          ROUND(
                                            ServLine.Quantity * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        ServLine.VALIDATE("Inv. Discount Amount",
                                          ROUND(
                                            ServLine."Inv. Discount Amount" * (1 + (ServLine."VAT %" / 100)),
                                            Currency."Amount Rounding Precision"));
                                        ServLine.UpdateAmounts

                                    END;
                                END ELSE BEGIN
                                    ServLine."Unit Price" :=
                                      ROUND(
                                        ServLine."Unit Price" / (1 + (ServLine."VAT %" / 100)),
                                        Currency."Unit-Amount Rounding Precision");
                                    IF ServLine.Quantity <> 0 THEN BEGIN
                                        ServLine."Line Discount Amount" :=
                                          ROUND(
                                            ServLine.Quantity * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        ServLine.VALIDATE("Inv. Discount Amount",
                                          ROUND(
                                            ServLine."Inv. Discount Amount" / (1 + (ServLine."VAT %" / 100)),
                                            Currency."Amount Rounding Precision"));
                                        ServLine.UpdateAmounts
                                    END;
                                END;
                            ServLine.MODIFY;
                        UNTIL ServLine.NEXT = 0;
                    END;
                END;
            end;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';

            trigger OnValidate()
            begin
                MessageIfServLinesExist(FIELDCAPTION("Invoice Disc. Code"));
            end;
        }
        field(40; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;

            trigger OnValidate()
            begin
                MessageIfServLinesExist(FIELDCAPTION("Language Code"));
            end;
        }
        field(43; "Service Person"; Code[10])
        {
            Caption = 'Service Person';
            TableRelation = Salesperson/Purchaser WHERE (Job Title=CONST(Service Advisor));

            trigger OnValidate()
            begin
                COMMIT;

                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Service Person",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Deal Type","Deal Type",
                  //DATABASE::Vehicle,VIN,
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );

                 ServLine.RESET;
                 ServLine.SETRANGE("Document Type","Document Type");
                 ServLine.SETRANGE("Document No.","No.");
                 IF ServLine.FINDSET THEN
                  REPEAT
                   ServLine.CallCreateDim;
                  UNTIL ServLine.NEXT = 0;
            end;
        }
        field(46;Comment;Boolean)
        {
            CalcFormula = Exist("Service Comment Line EDMS" WHERE (Type=FIELD(Document Type),
                                                                   No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47;"No. Printed";Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(52;"Applies-to Doc. Type";Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Order,Return Order';
            OptionMembers = " ","Order","Return Order";
        }
        field(53;"Applies-to Doc. No.";Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            TableRelation = IF (Applies-to Doc. Type=FILTER(Order)) "Posted Serv. Order Header".No.
                            ELSE IF (Applies-to Doc. Type=FILTER(Return Order)) "Posted Serv. Ret. Order Header".No.;

            trigger OnValidate()
            begin
                
                // 10.05.2014 Elva Baltic P21 >>
                /*
                IF "Applies-to Doc. No." <> '' THEN
                  TESTFIELD("Bal. Account No.",'');
                
                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                   ("Applies-to Doc. No." <> '')
                THEN BEGIN
                  SetAmountToApply("Applies-to Doc. No.","Bill-to Customer No.");
                  SetAmountToApply(xRec."Applies-to Doc. No.","Bill-to Customer No.");
                END ELSE
                  IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                    SetAmountToApply("Applies-to Doc. No.","Bill-to Customer No.")
                  ELSE IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                      SetAmountToApply(xRec."Applies-to Doc. No.","Bill-to Customer No.");
                */
                // 10.05.2014 Elva Baltic P21 <<

            end;
        }
        field(55;"Bal. Account No.";Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";

            trigger OnValidate()
            begin
                IF "Bal. Account No." <> '' THEN
                  CASE "Bal. Account Type" OF
                    "Bal. Account Type"::"G/L Account":
                      BEGIN
                        GLAcc.GET("Bal. Account No.");
                        GLAcc.CheckGLAcc;
                        GLAcc.TESTFIELD("Direct Posting",TRUE);
                      END;
                    "Bal. Account Type"::"Bank Account":
                      BEGIN
                        BankAcc.GET("Bal. Account No.");
                        BankAcc.TESTFIELD(Blocked,FALSE);
                        BankAcc.TESTFIELD("Currency Code","Currency Code");
                      END;
                  END;
            end;
        }
        field(58;Invoice;Boolean)
        {
            Caption = 'Invoice';
        }
        field(60;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Service Line EDMS".Amount WHERE (Document Type=FIELD(Document Type),
                                                                Document No.=FIELD(No.),
                                                                Bill-to Customer No.=FIELD(Sell-to Customer No.)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Service Line EDMS"."Amount Including VAT" WHERE (Document Type=FIELD(Document Type),
                                                                                Document No.=FIELD(No.),
                                                                                Bill-to Customer No.=FIELD(Sell-to Customer No.)));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63;"Posting No.";Code[20])
        {
            Caption = 'Posting No.';
        }
        field(66;"Prepayment No.";Code[20])
        {
            Caption = 'Prepayment No.';
        }
        field(67;"Last Prepayment No.";Code[20])
        {
            Caption = 'Last Prepayment No.';
            TableRelation = "Sales Invoice Header";
        }
        field(68;"Prepmt. Cr. Memo No.";Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';
        }
        field(69;"Last Prepmt. Cr. Memo No.";Code[20])
        {
            Caption = 'Last Prepmt. Cr. Memo No.';
            TableRelation = "Sales Invoice Header";
        }
        field(70;"VAT Registration No.";Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                 IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                  BEGIN
                   "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                   RecreateDmsServLines(FIELDCAPTION("Gen. Bus. Posting Group"));
                  END;
            end;
        }
        field(75;"EU 3-Party Trade";Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(76;"Transaction Type";Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";

            trigger OnValidate()
            begin
                UpdateDMSServLines(FIELDCAPTION("Transaction Type"),FALSE);
            end;
        }
        field(77;"Transport Method";Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";

            trigger OnValidate()
            begin
                UpdateDMSServLines(FIELDCAPTION("Transport Method"),FALSE);
            end;
        }
        field(79;"Sell-to Customer Name";Text[50])
        {
            Caption = 'Sell-to Customer Name';
            Editable = false;
        }
        field(80;"Sell-to Customer Name 2";Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
            Editable = false;
        }
        field(81;"Sell-to Address";Text[50])
        {
            Caption = 'Sell-to Address';
            Editable = false;
        }
        field(82;"Sell-to Address 2";Text[50])
        {
            Caption = 'Sell-to Address 2';
            Editable = false;
        }
        field(83;"Sell-to City";Text[50])
        {
            Caption = 'Sell-to City';
            Editable = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpCity("Sell-to City","Sell-to Post Code",TRUE); //30.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //30.10.2012 EDMS >>
                PostCode.ValidateCity(
                  "Sell-to City","Sell-to Post Code","Sell-to County","Sell-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                //30.10.2012 EDMS <<
            end;
        }
        field(84;"Sell-to Contact";Text[50])
        {
            Caption = 'Sell-to Contact';
            Editable = false;
        }
        field(85;"Bill-to Post Code";Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode("Bill-to City","Bill-to Post Code",TRUE);//30.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //30.10.2012 EDMS >>
                PostCode.ValidatePostCode(
                  "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                //30.10.2012 EDMS <<
            end;
        }
        field(86;"Bill-to County";Text[30])
        {
            Caption = 'Bill-to County';
        }
        field(87;"Bill-to Country/Region Code";Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            TableRelation = Country/Region;
        }
        field(88;"Sell-to Post Code";Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode("Sell-to City","Sell-to Post Code",TRUE);//30.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //30.10.2012 EDMS >>
                PostCode.ValidatePostCode(
                  "Sell-to City","Sell-to Post Code","Sell-to County","Sell-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                //30.10.2012 EDMS <<
            end;
        }
        field(89;"Sell-to County";Text[30])
        {
            Caption = 'Sell-to County';
        }
        field(90;"Sell-to Country/Region Code";Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = Country/Region;
        }
        field(94;"Bal. Account Type";Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(97;"Exit Point";Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";

            trigger OnValidate()
            begin
                UpdateDMSServLines(FIELDCAPTION("Exit Point"),FALSE);
            end;
        }
        field(98;Correction;Boolean)
        {
            Caption = 'Correction';
        }
        field(99;"Document Date";Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code"); //08-05-2007 EDMS P3 PREPMT
            end;
        }
        field(100;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
        }
        field(101;"Area";Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;

            trigger OnValidate()
            begin
                UpdateDMSServLines(FIELDCAPTION(Area),FALSE);
            end;
        }
        field(102;"Transaction Specification";Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";

            trigger OnValidate()
            begin
                UpdateDMSServLines(FIELDCAPTION("Transaction Specification"),FALSE);
            end;
        }
        field(104;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                recServiceLine: Record "25006146";
                tcDMS001: Label 'Do you want to change lines too?';
            begin
                TESTFIELD(Status,Status::Open);

                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Service Person",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Deal Type","Deal Type",
                  //DATABASE::Vehicle,VIN,
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );

                PaymentMethod.INIT;
                IF "Payment Method Code" <> '' THEN
                  PaymentMethod.GET("Payment Method Code");
                "Bal. Account Type" := PaymentMethod."Bal. Account Type";
                "Bal. Account No." := PaymentMethod."Bal. Account No.";

                IF "Bal. Account No." <> '' THEN BEGIN
                  TESTFIELD("Applies-to Doc. No.",'');
                END;
            end;
        }
        field(107;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(114;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                MessageIfServLinesExist(FIELDCAPTION("Tax Area Code"));
            end;
        }
        field(115;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                MessageIfServLinesExist(FIELDCAPTION("Tax Liable"));
            end;
        }
        field(116;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                IF xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group" THEN
                  RecreateDmsServLines(FIELDCAPTION("VAT Bus. Posting Group"));
            end;
        }
        field(117;Reserve;Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(119;"VAT Base Discount %";Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(120;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(121;"Invoice Discount Calculation";Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122;"Invoice Discount Value";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(130;"Prepayment %";Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                UpdateDMSServLines(FIELDCAPTION("Prepayment %"),CurrFieldNo <> 0);
            end;
        }
        field(131;"Prepayment No. Series";Code[10])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH ServiceHeader DO BEGIN
                  ServiceHeader := Rec;
                  ServiceSetup.GET;
                  ServiceSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                  IF NoSeriesMgt.LookupSeries(ServiceSetup."Posted Prepmt. Inv. Nos.","Prepayment No. Series") THEN
                    VALIDATE("Prepayment No. Series");
                  Rec := ServiceHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Prepayment No. Series" <> '' THEN BEGIN
                  ServiceSetup.GET;
                  ServiceSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                  NoSeriesMgt.TestSeries(ServiceSetup."Posted Prepmt. Inv. Nos.","Prepayment No. Series");
                END;
                TESTFIELD("Prepayment No.",'');
            end;
        }
        field(132;"Compress Prepayment";Boolean)
        {
            Caption = 'Compress Prepayment';
            InitValue = true;
        }
        field(133;"Prepayment Due Date";Date)
        {
            Caption = 'Prepayment Due Date';
        }
        field(134;"Prepmt. Cr. Memo No. Series";Code[10])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH ServiceHeader DO BEGIN
                  ServiceHeader := Rec;
                  ServiceSetup.GET;
                  ServiceSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                  IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode,"Prepmt. Cr. Memo No.") THEN
                    VALIDATE("Prepmt. Cr. Memo No.");
                  Rec := ServiceHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Prepmt. Cr. Memo No." <> '' THEN BEGIN
                  ServiceSetup.GET;
                  ServiceSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                  NoSeriesMgt.TestSeries(ServiceSetup."Posted Prepmt. Cr. Memo Nos.","Prepmt. Cr. Memo No.");
                END;
                TESTFIELD("Prepmt. Cr. Memo No.",'');
            end;
        }
        field(135;"Prepmt. Posting Description";Text[50])
        {
            Caption = 'Prepmt. Posting Description';
        }
        field(138;"Prepmt. Pmt. Discount Date";Date)
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        field(139;"Prepmt. Payment Terms Code";Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            var
                PaymentTerms: Record "3";
            begin
                IF ("Prepmt. Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                  PaymentTerms.GET("Prepmt. Payment Terms Code");
                  IF (("Document Type" IN ["Document Type"::"Return Order"]) AND
                     NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                  THEN BEGIN
                    VALIDATE("Prepayment Due Date","Document Date");
                    VALIDATE("Prepmt. Pmt. Discount Date",0D);
                    VALIDATE("Prepmt. Payment Discount %",0);
                  END ELSE BEGIN
                    "Prepayment Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                    "Prepmt. Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                    VALIDATE("Prepmt. Payment Discount %",PaymentTerms."Discount %")
                  END;
                END ELSE BEGIN
                  VALIDATE("Prepayment Due Date","Document Date");
                  VALIDATE("Prepmt. Pmt. Discount Date",0D);
                  VALIDATE("Prepmt. Payment Discount %",0);
                END;
            end;
        }
        field(140;"Prepmt. Payment Discount %";Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date"),FIELDNO("Document Date")]) THEN
                  TESTFIELD(Status,Status::Open);
                GLSetup.GET;
                IF "Payment Discount %" < GLSetup."VAT Tolerance %" THEN
                  "VAT Base Discount %" := "Payment Discount %"
                ELSE
                  "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                VALIDATE("VAT Base Discount %");
            end;
        }
        field(150;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(160;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(5043;"No. of Archived Versions";Integer)
        {
            CalcFormula = Max("Service Header Archive"."Version No." WHERE (Document Type=FIELD(Document Type),
                                                                            No.=FIELD(No.),
                                                                            Doc. No. Occurrence=FIELD(Doc. No. Occurrence)));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048;"Doc. No. Occurrence";Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5050;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate()
            begin
                MODIFY;

                CreateDim(
                  DATABASE::Campaign,"Campaign No.",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Service Person",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Deal Type","Deal Type",
                  //DATABASE::Vehicle,VIN,
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );
            end;
        }
        field(5051;"Sell-to Customer Template Code";Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            TableRelation = "Customer Template";

            trigger OnValidate()
            var
                SellToCustTemplate: Record "5105";
            begin
                TESTFIELD("Document Type","Document Type"::Quote);

                IF ("Sell-to Customer Template Code" <> xRec."Sell-to Customer Template Code") AND
                   (xRec."Sell-to Customer Template Code" <> '')
                THEN BEGIN
                  Confirmed := ConfirmLoc(STRSUBSTNO(Text004,FIELDCAPTION("Sell-to Customer Template Code")), FALSE, '');
                  IF Confirmed THEN BEGIN
                    ServLine.RESET;
                    ServLine.SETRANGE("Document Type","Document Type");
                    ServLine.SETRANGE("Document No.","No.");
                    IF "Sell-to Customer Template Code" = '' THEN BEGIN
                      IF NOT ServLine.ISEMPTY THEN
                        ERROR(Text005,FIELDCAPTION("Sell-to Customer Template Code"));
                      INIT;
                      ServiceSetup.GET;
                      InitRecord2;
                      "No. Series" := xRec."No. Series";
                      IF xRec."Posting No." <> '' THEN BEGIN
                        "Posting No. Series" := xRec."Posting No. Series";
                        "Posting No." := xRec."Posting No.";
                      END;
                      //08-05-2007 EDMS P3 PREPMT >>
                      IF xRec."Prepayment No." <> '' THEN BEGIN
                        "Prepayment No. Series" := xRec."Prepayment No. Series";
                        "Prepayment No." := xRec."Prepayment No.";
                      END;
                      IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                        "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                        "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                      END;
                      //08-05-2007 JEDMS P3 PREPMT <<
                      EXIT;
                    END;
                  END ELSE BEGIN
                    "Sell-to Customer Template Code" := xRec."Sell-to Customer Template Code";
                    EXIT;
                  END;
                END;

                IF SellToCustTemplate.GET("Sell-to Customer Template Code") THEN BEGIN
                  SellToCustTemplate.TESTFIELD("Gen. Bus. Posting Group");
                  "Gen. Bus. Posting Group" := SellToCustTemplate."Gen. Bus. Posting Group";
                  "VAT Bus. Posting Group" := SellToCustTemplate."VAT Bus. Posting Group";
                  IF "Bill-to Customer No." = '' THEN
                    VALIDATE("Bill-to Customer Template Code","Sell-to Customer Template Code");
                END;

                IF (xRec."Sell-to Customer Template Code" <> "Sell-to Customer Template Code") OR
                  (xRec."Currency Code" <> "Currency Code") THEN
                    RecreateDmsServLines(FIELDCAPTION("Sell-to Customer Template Code"));
            end;
        }
        field(5052;"Sell-to Contact No.";Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF ("Sell-to Customer No." <> '') AND (Cont.GET("Sell-to Contact No.")) THEN
                  Cont.SETRANGE("Company No.",Cont."Company No.")
                ELSE
                  IF "Sell-to Customer No." <> '' THEN BEGIN
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                    ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SETRANGE("No.","Sell-to Customer No.");
                    IF ContBusinessRelation.FINDFIRST THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                  END ELSE
                    Cont.SETFILTER("Company No.",'<>''''');

                IF "Sell-to Contact No." <> '' THEN
                  IF Cont.GET("Sell-to Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Sell-to Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "5054";
                Cont: Record "5050";
                Vehicle: Record "25006005";
            begin
                TESTFIELD(Status,Status::Open);
                HideValidationDialog := TRUE;
                IF ("Sell-to Contact No." <> xRec."Sell-to Contact No.") AND
                   (xRec."Sell-to Contact No." <> '')
                THEN BEGIN
                  Confirmed := ConfirmLoc(STRSUBSTNO(Text004,FIELDCAPTION("Sell-to Contact No.")), FALSE, '');
                  IF Confirmed THEN BEGIN
                    ServLine.RESET;
                    ServLine.SETRANGE("Document Type","Document Type");
                    ServLine.SETRANGE("Document No.","No.");
                    IF ("Sell-to Contact No." = '') AND ("Sell-to Customer No." = '') THEN BEGIN
                      IF NOT ServLine.ISEMPTY THEN
                        ERROR(Text005,FIELDCAPTION("Sell-to Contact No."));
                      INIT;
                      ServiceSetup.GET;
                      InitRecord2;
                      "No. Series" := xRec."No. Series";
                      IF xRec."Posting No." <> '' THEN BEGIN
                        "Posting No. Series" := xRec."Posting No. Series";
                        "Posting No." := xRec."Posting No.";
                      END;
                      IF xRec."Prepayment No." <> '' THEN BEGIN
                        "Prepayment No. Series" := xRec."Prepayment No. Series";
                        "Prepayment No." := xRec."Prepayment No.";
                      END;
                      IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                        "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                        "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                      END;
                      EXIT;
                    END;
                  END ELSE BEGIN
                    Rec := xRec;
                    EXIT;
                  END;
                END;

                IF ("Sell-to Customer No." <> '') AND ("Sell-to Contact No." <> '') THEN BEGIN
                  Cont.GET("Sell-to Contact No.");
                  ContBusinessRelation.RESET;
                  ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                  ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                  ContBusinessRelation.SETRANGE("No.","Sell-to Customer No.");
                  // IF ContBusinessRelation.FINDFIRST THEN               // 19.02.2015 EDMS P21
                  ContBusinessRelation.FINDFIRST;                         // 19.02.2015 EDMS P21
                  //04.04.2014 Elva Baltic P8 E0011 MMG7.00 >>
                  IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN BEGIN
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SETRANGE("Contact No.", Cont."Company No.");
                    IF ContBusinessRelation.FINDFIRST THEN BEGIN
                      Confirmed := ConfirmLoc(STRSUBSTNO(Text004,FIELDCAPTION("Sell-to Customer No.")), FALSE, '');
                      IF NOT Confirmed THEN
                        ERROR(Text038,Cont."No.",Cont.Name,"Sell-to Customer No.");
                      VALIDATE("Sell-to Customer No.", ContBusinessRelation."No.");
                    END ELSE
                      ERROR(Text038,Cont."No.",Cont.Name,"Sell-to Customer No.");
                  END;
                  //04.04.2014 Elva Baltic P8 E0011 MMG7.00 <<
                  Rec."Mobile Phone No." := Cont."Mobile Phone No.";
                END;

                UpdateSellToCust("Sell-to Contact No.");

                IF (Rec."Vehicle Registration No." = xRec."Vehicle Registration No.")
                 AND ("Vehicle Serial No." = xRec."Vehicle Serial No.") AND NOT FindCustomer THEN
                  FindContVehicle;
            end;
        }
        field(5053;"Bill-to Contact No.";Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF ("Bill-to Customer No." <> '') AND Cont.GET("Bill-to Contact No.") THEN
                  Cont.SETRANGE("Company No.",Cont."Company No.")
                ELSE
                  IF Cust.GET("Bill-to Customer No.") THEN BEGIN
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                    ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SETRANGE("No.","Bill-to Customer No.");
                    IF ContBusinessRelation.FINDFIRST THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                  END ELSE
                    Cont.SETFILTER("Company No.",'<>''''');

                IF "Bill-to Contact No." <> '' THEN
                  IF Cont.GET("Bill-to Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Bill-to Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "5054";
                Cont: Record "5050";
            begin
                TESTFIELD(Status,Status::Open);

                IF ("Bill-to Contact No." <> xRec."Bill-to Contact No.") AND
                   (xRec."Bill-to Contact No." <> '')
                THEN BEGIN
                  Confirmed := ConfirmLoc(STRSUBSTNO(Text004,FIELDCAPTION("Bill-to Contact No.")), FALSE, '');
                  IF Confirmed THEN BEGIN
                    ServLine.RESET;
                    ServLine.SETRANGE("Document Type","Document Type");
                    ServLine.SETRANGE("Document No.","No.");
                    IF ("Bill-to Contact No." = '') AND ("Bill-to Customer No." = '') THEN BEGIN
                      IF NOT ServLine.ISEMPTY THEN
                        ERROR(Text005,FIELDCAPTION("Bill-to Contact No."));
                      INIT;
                      ServiceSetup.GET;
                      InitRecord2;
                      "No. Series" := xRec."No. Series";
                      IF xRec."Posting No." <> '' THEN BEGIN
                        "Posting No. Series" := xRec."Posting No. Series";
                        "Posting No." := xRec."Posting No.";
                      END;
                      //08-05-2007 EDMS P3 PREPMT >>
                      IF xRec."Prepayment No." <> '' THEN BEGIN
                        "Prepayment No. Series" := xRec."Prepayment No. Series";
                        "Prepayment No." := xRec."Prepayment No.";
                      END;
                      IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                        "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                        "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                      END;
                      //08-05-2007 EDMS P3 PREPMT <<
                      EXIT;
                    END;
                  END ELSE BEGIN
                    "Bill-to Contact No." := xRec."Bill-to Contact No.";
                    EXIT;
                  END;
                END;

                IF ("Bill-to Customer No." <> '') AND ("Bill-to Contact No." <> '') THEN BEGIN
                  Cont.GET("Bill-to Contact No.");
                  ContBusinessRelation.RESET;
                  ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                  ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                  ContBusinessRelation.SETRANGE("No.","Bill-to Customer No.");
                    IF ContBusinessRelation.FINDFIRST THEN
                      IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                        ERROR(Text038,Cont."No.",Cont.Name,"Bill-to Customer No.");
                END;

                UpdateBillToCust("Bill-to Contact No.");
            end;
        }
        field(5054;"Bill-to Customer Template Code";Code[10])
        {
            Caption = 'Bill-to Customer Template Code';
            TableRelation = "Customer Template";

            trigger OnValidate()
            var
                BillToCustTemplate: Record "5105";
            begin
                TESTFIELD("Document Type","Document Type"::Quote);
                TESTFIELD(Status,Status::Open);

                IF ("Bill-to Customer Template Code" <> xRec."Bill-to Customer Template Code") AND
                   (xRec."Bill-to Customer Template Code" <> '')
                THEN BEGIN
                  Confirmed := ConfirmLoc(STRSUBSTNO(Text004,FIELDCAPTION("Bill-to Customer Template Code")), FALSE, '');
                  IF Confirmed THEN BEGIN
                    ServLine.RESET;
                    ServLine.SETRANGE("Document Type","Document Type");
                    ServLine.SETRANGE("Document No.","No.");
                    IF "Bill-to Customer Template Code" = '' THEN BEGIN
                      IF NOT ServLine.ISEMPTY THEN
                        ERROR(Text005,FIELDCAPTION("Bill-to Customer Template Code"));
                      INIT;
                      ServiceSetup.GET;
                      InitRecord2;
                      "No. Series" := xRec."No. Series";
                      IF xRec."Posting No." <> '' THEN BEGIN
                        "Posting No. Series" := xRec."Posting No. Series";
                        "Posting No." := xRec."Posting No.";
                      END;
                      //08-05-2007 EDMS P3 PREPMT >>
                      IF xRec."Prepayment No." <> '' THEN BEGIN
                        "Prepayment No. Series" := xRec."Prepayment No. Series";
                        "Prepayment No." := xRec."Prepayment No.";
                      END;
                      IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                        "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                        "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                      END;
                      //08-05-2007 EDMS P3 PREPMT <<
                      EXIT;
                    END;
                  END ELSE BEGIN
                    "Bill-to Customer Template Code" := xRec."Bill-to Customer Template Code";
                    EXIT;
                  END;
                END;

                IF BillToCustTemplate.GET("Bill-to Customer Template Code") THEN BEGIN
                  BillToCustTemplate.TESTFIELD("Customer Posting Group");
                  "Customer Posting Group" := BillToCustTemplate."Customer Posting Group";
                  "Invoice Disc. Code" := BillToCustTemplate."Invoice Disc. Code";
                  "Customer Price Group" := BillToCustTemplate."Customer Price Group";
                  "Customer Disc. Group" := BillToCustTemplate."Customer Disc. Group";
                  "Allow Line Disc." := BillToCustTemplate."Allow Line Disc.";
                  VALIDATE("Payment Terms Code", BillToCustTemplate."Payment Terms Code");
                  VALIDATE("Payment Method Code", BillToCustTemplate."Payment Method Code");
                END;

                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Service Person",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Deal Type","Deal Type",
                  //DATABASE::Vehicle,VIN,
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );

                IF (xRec."Sell-to Customer Template Code" = "Sell-to Customer Template Code") AND
                   (xRec."Bill-to Customer Template Code" <> "Bill-to Customer Template Code")
                THEN
                  RecreateDmsServLines(FIELDCAPTION("Bill-to Customer Template Code"));
            end;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF NOT UserMgt.CheckRespCenter(3,"Responsibility Center") THEN
                  ERROR (
                    Text027,
                     RespCenter.TABLECAPTION,UserMgt.GetServiceFilterEDMS);

                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Service Person",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Deal Type","Deal Type",
                  //DATABASE::Vehicle,VIN,
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );

                IF (xRec."Responsibility Center" <> "Responsibility Center") THEN
                  RecreateDmsServLines(FIELDCAPTION("Responsibility Center"));
            end;
        }
        field(5754;"Location Filter";Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5790;"Requested Delivery Date";Date)
        {
            Caption = 'Requested Delivery Date';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Promised Delivery Date" <> 0D THEN
                  ERROR(
                    Text028,
                    FIELDCAPTION("Requested Delivery Date"),
                    FIELDCAPTION("Promised Delivery Date"));

                IF "Requested Delivery Date" <> xRec."Requested Delivery Date" THEN
                  UpdateDMSServLines(FIELDCAPTION("Requested Delivery Date"),CurrFieldNo<>0);
            end;
        }
        field(5791;"Promised Delivery Date";Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Promised Delivery Date" <> xRec."Promised Delivery Date" THEN
                  UpdateDMSServLines(FIELDCAPTION("Promised Delivery Date"),CurrFieldNo<>0);
            end;
        }
        field(5792;"Shipping Time";DateFormula)
        {
            Caption = 'Shipping Time';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Shipping Time" <> xRec."Shipping Time" THEN
                  UpdateDMSServLines(FIELDCAPTION("Shipping Time"),CurrFieldNo <> 0);
            end;
        }
        field(5796;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5801;"Pst. Return Order No.";Code[20])
        {
            Caption = 'Posted Return Order No.';
        }
        field(5802;"Pst. Return Order No. Series";Code[10])
        {
            Caption = 'Return Order No. Series';
            TableRelation = "No. Series";
        }
        field(6210;"Login ID";Code[30])
        {
            Caption = 'Login ID';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';

            trigger OnValidate()
            begin

                MessageIfServLinesExist(FIELDCAPTION("Allow Line Disc."));
            end;
        }
        field(50056;"RV RR Code";Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Revisit,Repeat Repair';
            OptionMembers = " ",Revisit,"Repeat Repair";

            trigger OnValidate()
            begin
                InsertDefectEntry;
            end;
        }
        field(50058;"Quality Control";Code[20])
        {
            Description = 'PSF';
            TableRelation = Resource WHERE (Resource Type=CONST(Quality Control));
        }
        field(50059;"Floor Control";Code[20])
        {
            Description = 'PSF';
            TableRelation = Resource WHERE (Resource Type=CONST(Floor Control));
        }
        field(50060;"Insurance Type";Code[20])
        {
        }
        field(80200;"Quote No.";Code[20])
        {
            Caption = 'Quote No.';
        }
        field(80220;"Date Sent";Date)
        {
            Caption = 'Date Sent';
        }
        field(80230;"Time Sent";Time)
        {
            Caption = 'Time Sent';
        }
        field(80231;"Ship Add Name 2";Text[50])
        {
            Description = 'New field for shipping address';
        }
        field(90200;"Planned Service Date";Date)
        {
            Caption = 'Planned Service Date';

            trigger OnValidate()
            begin
                IF ("Planned Service Date" <> xRec."Planned Service Date") AND (xRec."Sell-to Customer No." = "Sell-to Customer No.") THEN
                 MessageIfServLinesExist(FIELDCAPTION("Planned Service Date"));
            end;
        }
        field(25006001;"Deal Type";Code[10])
        {
            Caption = 'Deal Type';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                recServiceLine: Record "25006146";
                tcDMS001: Label 'Do you want to change Deal Type in lines too?';
            begin
                TESTFIELD(Status,Status::Open);

                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Deal Type","Deal Type",
                  DATABASE::"Salesperson/Purchaser","Service Person",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  //DATABASE::Vehicle,VIN,
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );

                //04.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                //IF xRec."Deal Type" <> "Deal Type" THEN
                //  RecreateDmsServLines(FIELDCAPTION("Deal Type"));
                //04.04.2014 Elva Baltic P1 #RX MMG7.00 <<

                IF xRec."Deal Type" <> "Deal Type" THEN BEGIN           // 23.04.2015 EDMS P21
                  recServiceLine.RESET;
                  recServiceLine.SETRANGE("Document Type","Document Type");
                  recServiceLine.SETRANGE("Document No.","No.");
                  IF recServiceLine.FINDSET(TRUE,FALSE) THEN
                   BEGIN
                    Confirmed := ConfirmLoc(tcDMS001, TRUE, '');
                    IF Confirmed THEN
                     BEGIN
                      REPEAT
                       recServiceLine.VALIDATE("Deal Type Code","Deal Type");
                       recServiceLine.MODIFY;
                      UNTIL recServiceLine.NEXT = 0;
                     END;
                   END;                                                 // 23.04.2015 EDMS P21
                 END;
            end;
        }
        field(25006160;VIN;Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                // 23.04.2015 EDMS P21 >>
                // IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                OnLookupVIN;
                // 23.04.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);

                // 20.02.2015 EDMS P21 >>
                IF VIN = '' THEN BEGIN
                  VALIDATE("Vehicle Serial No.", '');
                  EXIT;
                END;

                //23
                IF xRec.VIN <> Rec.VIN THEN
                  insertOrRemoveFromPostedVIN(VIN,"No.");

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY(VIN);
                Vehicle.SETRANGE(VIN, VIN);
                IF Vehicle.FINDFIRST THEN BEGIN
                  IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                    VALIDATE("Vehicle Serial No.", Vehicle."Serial No.")
                END ELSE BEGIN
                  MessageLoc(STRSUBSTNO(Text137, Vehicle.TABLECAPTION, FIELDCAPTION(VIN), VIN), '');
                  IF "Document Type" <> "Document Type"::Quote THEN
                    VIN := xRec.VIN;
                END;

                // 20.02.2015 EDMS P21 <<
                SchemeVehicleTracking.RESET;
                SchemeVehicleTracking.SETRANGE("Vehicle Serial No.",Vehicle."Serial No.");
                IF SchemeVehicleTracking.FINDFIRST THEN REPEAT
                  IF SchemeVehicleTracking."Vehicle Serial No." = '' THEN
                    EXIT;
                  MembershipDetail.RESET;
                  MembershipDetail.SETRANGE("Membership Card No.",SchemeVehicleTracking."Membership Card No.");
                  MembershipDetail.SETRANGE("Customer No.","Sell-to Customer No.");
                  MembershipDetail.SETFILTER("Expiry Date",'>=%1',TODAY);
                  MembershipDetail.SETRANGE(Status,MembershipDetail.Status::Active);
                  IF MembershipDetail.FINDFIRST THEN BEGIN
                //    SchemeVehicleTracking.RESET;
                //    SchemeVehicleTracking.SETRANGE("Membership Card No.",MembershipDetail."Membership Card No.");
                //    SchemeVehicleTracking.SETRANGE("Vehicle Serial No.",Vehicle."Serial No.");
                //    IF SchemeVehicleTracking.FINDFIRST THEN BEGIN
                      "Scheme Code" := SchemeVehicleTracking."Scheme Code";
                      "Membership No." := SchemeVehicleTracking."Membership Card No.";
                    //END;
                  END ELSE BEGIN
                     "Scheme Code" := '';
                     "Membership No." := '';
                  END;
                  IF "Scheme Code" <> '' THEN
                    EXIT;
                UNTIL (SchemeVehicleTracking.NEXT = 0);

                //23
                //verifyIfItsRepatAlreadyDOC(Rec);
                // Bishesh Jimba 9Aug24
                  VehicleInsurance.RESET;
                  VehicleInsurance.SETRANGE(VIN,Rec.VIN);
                    IF VehicleInsurance.FINDFIRST THEN BEGIN
                      "Insurance Type" := VehicleInsurance.Type;
                      "Insurance Policy Number" := VehicleInsurance."Insurance Policy No.";
                      VehicleInsurance.CALCFIELDS(VehicleInsurance."Ins. Company Name");
                      "Insurance Company Name" := VehicleInsurance."Ins. Company Name";
                    END;
            end;
        }
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

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
                END ELSE BEGIN
                  MessageLoc(STRSUBSTNO(Text131, "Vehicle Registration No."), '');
                  // 20.02.2015 EDMS P21 >>
                  IF "Document Type" <> "Document Type"::Quote THEN
                    "Vehicle Registration No." := xRec."Vehicle Registration No.";
                  // 20.02.2015 EDMS P21 <<
                END;
            end;
        }
        field(25006180;Kilometrage;Decimal)
        {
            BlankZero = true;
            Caption = 'Kilometer';
            DecimalPlaces = 0:0;

            trigger OnValidate()
            begin
                TestVFRun1;
                CheckServicePlan(FIELDNO(Kilometrage));
                VerifyWarrantyExistence;

                verifyIfItsRepatAlreadyDOC(Rec); //PSF1.0
            end;
        }
        field(25006181;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);

                // 16.03.2015 EDMS P21 >>
                IF ("Make Code" <> xRec."Make Code") AND ("Model Code" <> '') THEN
                  VALIDATE("Model Code", '');
                // 16.03.2015 EDMS P21 <<
            end;
        }
        field(25006190;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
            end;
        }
        field(25006196;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));

            trigger OnLookup()
            var
                Item: Record "27";
            begin
                // 20.02.2015 EDMS P21 >>
                IF LookUpMgt.LookUpModelVersion(Item, "Model Version No.", "Make Code", "Model Code") THEN
                  VALIDATE("Model Version No.", Item."No.");
                // 20.02.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
            end;
        }
        field(25006200;"Model Commercial Name";Text[50])
        {
            CalcFormula = Lookup(Model."Commercial Name" WHERE (Make Code=FIELD(Make Code),
                                                                Code=FIELD(Model Code)));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006250;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(25006270;"Arrival Time";Time)
        {
            Caption = 'Arrival Time';
        }
        field(25006271;"Arrival Date";Date)
        {
            Caption = 'Arrival Date';
        }
        field(25006273;"Requested Finishing Date";Date)
        {
            Caption = 'Requested Finishing Date';

            trigger OnValidate()
            begin
                IF Rec."Requested Finishing Date" < Rec."Requested Starting Date" THEN
                ERROR(FinishDateBeforeStartErr);
            end;
        }
        field(25006275;"Requested Finishing Time";Time)
        {
            Caption = 'Requested Finishing Time';

            trigger OnValidate()
            begin
                IF Rec."Requested Finishing Time" < Rec."Requested Starting Time" THEN
                ERROR(FinishTimeBeforeStartErr);
            end;
        }
        field(25006276;"Warranty Claim No.";Code[20])
        {
            Caption = 'Warranty Claim No.';
        }
        field(25006280;"Return Date";Date)
        {
            Caption = 'Return Date';
        }
        field(25006290;"Requested Starting Date";Date)
        {
            Caption = 'Requested Starting Date';

            trigger OnValidate()
            var
                DateDiff: Integer;
            begin
                IF xRec."Requested Finishing Date" <> 0D THEN BEGIN
                  DateDiff := xRec."Requested Finishing Date" - xRec."Requested Starting Date";
                  IF DateDiff > -1 THEN
                    "Requested Finishing Date" := "Requested Starting Date"+DateDiff
                  ELSE
                    "Requested Finishing Date" := "Requested Starting Date";
                END ELSE BEGIN
                  "Requested Finishing Date" := "Requested Starting Date";
                END;
            end;
        }
        field(25006295;"Requested Starting Time";Time)
        {
            Caption = 'Requested Starting Time';

            trigger OnValidate()
            var
                TimeDiff: Integer;
            begin
                IF xRec."Requested Finishing Time" <> 0T THEN BEGIN
                  TimeDiff := xRec."Requested Finishing Time" - xRec."Requested Starting Time";
                  IF TimeDiff > -1 THEN
                    "Requested Finishing Time" := "Requested Starting Time"+TimeDiff
                  ELSE
                    "Requested Finishing Time" := "Requested Starting Time";
                END ELSE BEGIN
                  "Requested Finishing Time" := "Requested Starting Time";
                END;
            end;
        }
        field(25006300;"Planning Policy";Option)
        {
            Caption = 'Planning Policy';
            OptionCaption = 'Appointment,Queue';
            OptionMembers = Appointment,Queue;

            trigger OnValidate()
            begin
                IF "Planning Policy" <> xRec."Planning Policy" THEN BEGIN
                  IF "Document Type" IN ["Document Type"::Quote, "Document Type"::Order] THEN
                    ServiceScheduleMgt.ChangePlanningPolicy(Rec);
                END;
            end;
        }
        field(25006377;"Quote Applicable To Date";Date)
        {
            Caption = 'Quote Applicable To Date';
        }
        field(25006378;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Editable = false;
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                Model: Record "25006001";
                DocumentMgt: Codeunit "25006000";
                FillCustomer: Boolean;
                Vehi: Record "33019823";
            begin
                IF "Vehicle Serial No." = '' THEN BEGIN
                  "Vehicle Registration No." := '';
                  "Make Code" := '';
                  "Model Code" := '';
                  "Model Version No." := '';                                // 20.02.2015 EDMS P21
                  VIN := '';
                  "Vehicle Accounting Cycle No." := '';
                  "Vehicle Status Code" := '';
                  "Model Commercial Name" := '';

                  //SS1.00
                  "Scheme Code" := '';
                  "Membership No." := '';
                  //SS1.00
                  VALIDATE("Contract No.", '');                             // 15.04.2014 Elva Baltic P21
                  EXIT;
                END;

                Vehicle.GET("Vehicle Serial No.");
                IF Vehi.GET("Vehicle Serial No.") THEN;
                Vehi.CALCFIELDS("Default Vehicle Acc. Cycle No.");

                Vehicle.TESTFIELD("Make Code");
                Vehicle.TESTFIELD("Model Code");
                Vehicle.TESTFIELD("Model Version No.");
                Vehicle.TESTFIELD(Blocked,FALSE);  //08.05.2014 Elva Baltic P8 #S0084 MMG7.00


                VIN := Vehicle.VIN;
                VALIDATE("Vehicle Accounting Cycle No.",Vehi."Default Vehicle Acc. Cycle No.");
                "Vehicle Registration No." := Vehicle."Registration No.";
                "Make Code" := Vehicle."Make Code";
                "Model Code" := Vehicle."Model Code";
                "Model Version No." := Vehicle."Model Version No.";         // 20.02.2015 EDMS P21
                "Vehicle Status Code" := Vehicle."Status Code";

                IF Model.GET("Make Code","Model Code") THEN
                  "Model Commercial Name" := Model."Commercial Name"
                ELSE
                  "Model Commercial Name" := Vehicle."Model Commercial Name";

                IF "Document Type" <> "Document Type"::Quote THEN
                  UpdVehicleInfo("Vehicle Serial No.", Vehicle);

                IF (Rec."Sell-to Customer No." = xRec."Sell-to Customer No.") AND NOT FindVehicle THEN
                  FindVehicleCont;

                UpdateVehicleContact;

                DocumentMgt.ShowVehicleComments("Vehicle Serial No.");

                CheckRecallCampaigns("Vehicle Serial No.");

                VerifyWarrantyExistence; //**12.14.2012** Sipradi-YS

                //29.09.2011 EDMS P8 >>
                IF ("Vehicle Serial No." <> xRec."Vehicle Serial No.") AND (xRec."Vehicle Serial No." <> '') THEN
                  TireManagement.ChangeVehicleInServiceHeader(Rec, xRec."Vehicle Serial No.", "Vehicle Serial No.");
                //29.09.2011 EDMS P8 <<

                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 >>
                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Service Person",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Deal Type","Deal Type",
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );
                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 <<

                IF xRec."Vehicle Serial No." <> "Vehicle Serial No." THEN BEGIN               // 15.04.2014 Elva Baltic P21
                  FindContract;                                                               // 15.04.2014 Elva Baltic P21
                  SetHideValidationDialog(FALSE);                                             // 23.04.2015 EDMS P21
                  RecreateDmsServLines(FIELDCAPTION("Vehicle Serial No."));                   // 16.03.2015 EDMS P21
                END;

                //SS1.00
                SchemeVehicleTracking.RESET;
                SchemeVehicleTracking.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
                IF SchemeVehicleTracking.FINDFIRST THEN REPEAT
                  IF SchemeVehicleTracking."Vehicle Serial No." = '' THEN
                    EXIT;
                  MembershipDetail.RESET;
                  MembershipDetail.SETRANGE("Membership Card No.",SchemeVehicleTracking."Membership Card No.");
                  MembershipDetail.SETRANGE("Customer No.","Sell-to Customer No.");
                  MembershipDetail.SETFILTER("Expiry Date",'>=%1',TODAY);
                  MembershipDetail.SETRANGE(Status,MembershipDetail.Status::Active);
                  IF MembershipDetail.FINDFIRST THEN BEGIN
                //    SchemeVehicleTracking.RESET;
                //    SchemeVehicleTracking.SETRANGE("Membership Card No.",MembershipDetail."Membership Card No.");
                //    SchemeVehicleTracking.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
                //    IF SchemeVehicleTracking.FINDFIRST THEN BEGIN
                      "Scheme Code" := SchemeVehicleTracking."Scheme Code";
                      "Membership No." := SchemeVehicleTracking."Membership Card No.";
                    //END;
                  END ELSE BEGIN
                     "Scheme Code" := '';
                     "Membership No." := '';
                  END;
                  IF "Scheme Code" <> '' THEN
                    EXIT;
                UNTIL (SchemeVehicleTracking.NEXT = 0);
                //SS1.00
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = true;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006390;"Vehicle Item Charge No.";Code[20])
        {
            Caption = 'Vehicle Item Charge No.';
            TableRelation = "Item Charge";
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
        field(25006396;"Employee Signature Text";Text[100])
        {
        }
        field(25006630;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";

            trigger OnLookup()
            var
                ContractList: Page "25006046";
                                  ContractVehicle: Record "25006059";
                                  ContractTemp: Record "25006016" temporary;
                                  Customer: Record "18";
            begin
                IF Customer.GET("Bill-to Customer No.") THEN;
                Customer.SetContractFilter(ContractTemp, Contract.Status::Active, FALSE, Contract."Document Profile"::Service, "Order Date", "Vehicle Serial No.");
                IF ContractTemp.GET(ContractTemp."Contract Type"::Contract, "Contract No.") THEN;
                IF PAGE.RUNMODAL(0, ContractTemp) = ACTION::LookupOK THEN
                  VALIDATE("Contract No.",ContractTemp."Contract No.");
            end;

            trigger OnValidate()
            begin
                IF Contract.GET(Contract."Contract Type"::Contract, "Contract No.") AND ("Contract No." <> xRec."Contract No.") THEN
                  VALIDATE("Payment Terms Code", Contract."Payment Terms Code");

                IF xRec."Contract No." <> "Contract No." THEN
                  RecreateDmsServLines(FIELDCAPTION("Contract No."));
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006145,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Service Header EDMS",FIELDNO("Variable Field 25006802"),
                  "Make Code","Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25006860;"Work Status Code";Code[20])
        {
            Caption = 'Work Status Code';
            TableRelation = "Service Work Status EDMS";

            trigger OnValidate()
            var
                ServiceWorkStatus: Record "25006166";
                ServLaborAllocation: Record "25006271";
                ResourceUsed: Record "156";
            begin
                IF ServiceWorkStatus.GET("Work Status Code") THEN
                  "Work Status (System)" := ServiceWorkStatus."Service Order Status" + 1
                ELSE
                  "Work Status (System)" := "Work Status (System)"::" ";


                //Release Bay After Service is Finished
                //SIpradi YS Begin
                IF "Work Status (System)" = "Work Status (System)"::Finished THEN BEGIN
                    ServLaborAllocation.RESET;
                    ServLaborAllocation.SETRANGE("Source ID","No.");
                    ServLaborAllocation.FINDFIRST;
                    REPEAT
                      ResourceUsed.RESET;
                      ResourceUsed.SETRANGE("No.",ServLaborAllocation."Resource No.");
                      ResourceUsed.FIND('-');
                      IF ResourceUsed."Is Bay" THEN  BEGIN
                        ServLaborAllocation.Status := ServLaborAllocation.Status::Finished;
                        ServLaborAllocation.MODIFY(TRUE);
                      END;
                    UNTIL ServLaborAllocation.NEXT=0;
                END;

                //Sipradi YS End
            end;
        }
        field(25006861;"Work Status (System)";Option)
        {
            Caption = 'Work Status (System)';
            Editable = false;
            OptionCaption = ' ,Pending,In Process,Finished,On Hold,Booking';
            OptionMembers = " ",Pending,"In Process",Finished,"On Hold",Booking;
        }
        field(25007010;"Order Time";Time)
        {
            Caption = 'Order Time';
        }
        field(25007020;"Return Time";Time)
        {
            Caption = 'Return Time';
        }
        field(25007100;"Bill-to Contact Phone No.";Text[30])
        {
            Caption = 'Bill-to Contact Phone No.';
        }
        field(25007200;"Finished Quantity (Hours)";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" WHERE (Document Type=FIELD(Document Type),
                                                                                                  Document No.=FIELD(No.),
                                                                                                  Travel=CONST(No)));
            Caption = 'Finished Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007210;"Remaining Quantity (Hours)";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Remaining Quantity (Hours)" WHERE (Document Type=FIELD(Document Type),
                                                                                                   Document No.=FIELD(No.)));
            Caption = 'Remaining Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007300;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            var
                recDimValue: Record "349";
            begin
                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Service Person",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Deal Type","Deal Type",
                  //DATABASE::Vehicle,VIN,
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );

                //04.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                //RecreateDmsServLines(FIELDCAPTION("Vehicle Status Code"));
                //04.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
        }
        field(25007310;"Vehicle Comment";Boolean)
        {
            CalcFormula = Exist("Service Comment Line EDMS" WHERE (Type=CONST(Vehicle),
                                                                   No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007320;"Sell-to Customer Comment";Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE (Table Name=CONST(Customer),
                                                      No.=FIELD(Sell-to Customer No.)));
            Caption = 'Sell-to Customer Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007330;"Bill-to Customer Comment";Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE (Table Name=CONST(Customer),
                                                      No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Customer Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007340;"To Whom Place Items";Option)
        {
            Caption = 'To Whom Place Items';
            Description = '1:To Sell-to Customer bill 2: To Bill-to Customer bill';
            OptionCaption = 'Prompt,Sell-to Customer,Bill-to Customer';
            OptionMembers = Prompt,SellTo,BillTo;
        }
        field(25007380;"Initiator Code";Code[10])
        {
            Caption = 'Initiator Code';
            TableRelation = Salesperson/Purchaser;
        }
        field(25007390;"Schedule Start Date Time";Decimal)
        {
            CalcFormula = Min("Serv. Labor Allocation Entry"."Start Date-Time" WHERE (Source Type=CONST(Service Document),
                                                                                      Source Subtype=FIELD(Document Type),
                                                                                      Source ID=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007391;"Schedule End Date Time";Decimal)
        {
            CalcFormula = Max("Serv. Labor Allocation Entry"."End Date-Time" WHERE (Source Type=CONST(Service Document),
                                                                                    Source Subtype=FIELD(Document Type),
                                                                                    Source ID=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(25007392;"Prep Perc To Sell-To";Decimal)
        {
        }
        field(25007393;"Mobile Phone No.";Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(25007394;"TCard Container Entry No.";Integer)
        {
            BlankZero = true;
            TableRelation = "TCard Container".No. WHERE (Location Code=FIELD(Location Code));

            trigger OnValidate()
            var
                TCardContainer: Record "25006870";
            begin
                IF "TCard Container Entry No." <> 0 THEN BEGIN
                  TCardContainer.GET("TCard Container Entry No.");
                  CASE Rec."Document Type" OF
                    Rec."Document Type"::Booking:
                      BEGIN
                        IF TCardContainer.Type <> TCardContainer.Type::Booking THEN
                          ERROR(DocTypeContainerErr);
                      END;
                    Rec."Document Type"::Order:
                      BEGIN
                        IF TCardContainer.Type <> TCardContainer.Type::Order THEN
                          ERROR(DocTypeContainerErr);
                      END;
                    ELSE
                       ERROR(DocTypeContainerErr);
                  END;
                END;
            end;
        }
        field(25007395;"Booking No.";Code[20])
        {
        }
        field(25007396;"Booking Resource No.";Code[20])
        {
            TableRelation = Resource;
        }
        field(25007397;"Total Work (Hours)";Decimal)
        {
        }
        field(25007398;"Service Address Code";Code[10])
        {
            Caption = 'Service Address Code';
            TableRelation = "Ship-to Address".Code WHERE (Customer No.=FIELD(Sell-to Customer No.));

            trigger OnValidate()
            begin
                IF ShipToAddr.GET("Sell-to Customer No.","Service Address Code") THEN BEGIN
                  "Service Address Name" := ShipToAddr.Name;
                  "Service Address" := ShipToAddr.Address;
                  "Service Address 2" := ShipToAddr."Address 2";
                  "Service Address Post Code" := ShipToAddr."Post Code";
                  "Service Address City" := ShipToAddr.City;
                  "Service Address Contact" := ShipToAddr.Contact;
                  MODIFY;
                END;
            end;
        }
        field(25007399;"Service Address Name";Text[50])
        {
            Caption = 'Service Address Name';
        }
        field(25007400;"Service Address";Text[50])
        {
            Caption = 'Service Address';
        }
        field(25007401;"Service Address 2";Text[20])
        {
            Caption = 'Service Address 2';
        }
        field(25007402;"Service Address Post Code";Code[20])
        {
            Caption = 'Service Address Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(25007403;"Service Address City";Text[30])
        {
            Caption = 'Service Address City';
        }
        field(25007404;"Service Address Contact";Text[50])
        {
            Caption = 'Service Address Contact';
        }
        field(25007405;"Finished Travel Qty (Hours)";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" WHERE (Document Type=FIELD(Document Type),
                                                                                                  Document No.=FIELD(No.),
                                                                                                  Travel=CONST(Yes)));
            Caption = 'Finished Travel Quantity (Hours)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019831;"Promised Delivery Time";Time)
        {
        }
        field(33019832;"Job Finished Time";Time)
        {
        }
        field(33019833;"Job Finished Date";Date)
        {

            trigger OnValidate()
            begin
                //**SM 04 10 2013 to control back date in service order
                IF "Job Finished Date" <> 0D THEN BEGIN
                   IF "Job Finished Date" < WORKDATE THEN
                     ERROR('Back Date cannot be entered.');
                END;
            end;
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF NOT UserMgt.CheckRespCenter(3,"Accountability Center") THEN
                  ERROR (
                    Text027,
                     AccCenter.TABLECAPTION,UserMgt.GetSalesFilter());

                IF (xRec."Accountability Center" <> "Accountability Center") THEN
                  RecreateDmsServLines(FIELDCAPTION("Accountability Center"));
            end;
        }
        field(33020235;"Booked By";Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                GLSetup.GET;
                IF NOT GLSetup."Use Accountability Center" THEN
                  IF NOT UserMgt.CheckRespCenter2(0,"Responsibility Center","Booked By") THEN
                    ERROR(
                      Text061,"Booked By",
                      RespCenter.TABLECAPTION,UserMgt.GetSalesFilter2("Booked By"))
                ELSE
                  IF NOT UserMgt.CheckRespCenter2(0,"Accountability Center","Booked By") THEN
                    ERROR(
                      Text061,"Booked By",
                      AccCenter.TABLECAPTION,UserMgt.GetSalesFilter2("Booked By"));
            end;
        }
        field(33020236;"Job Description";Text[230])
        {
            Description = '//reduced';
        }
        field(33020237;Remarks;Text[250])
        {
        }
        field(33020238;"Booked on Date";Date)
        {
        }
        field(33020239;"Time Slot Booked";Time)
        {
        }
        field(33020240;"Job Type";Code[20])
        {
            TableRelation = IF (Job Category=CONST(Under Warranty)) "Job Type Master".No. WHERE (Type=FILTER(Service),
                                                                                                 Under Warranty=CONST(Yes))
                                                                                                 ELSE IF (Job Category=CONST(Post Warranty)) "Job Type Master".No. WHERE (Type=FILTER(Service),
                                                                                                                                                                          Post Warranty=CONST(Yes))
                                                                                                                                                                          ELSE IF (Job Category=CONST(Accidental Repair)) "Job Type Master".No. WHERE (Type=FILTER(Service),
                                                                                                                                                                                                                                                       Accidental Repair=CONST(Yes))
                                                                                                                                                                                                                                                       ELSE IF (Job Category=CONST(PDI)) "Job Type Master".No. WHERE (Type=FILTER(Service),
                                                                                                                                                                                                                                                                                                                      PDI=CONST(Yes))
                                                                                                                                                                                                                                                                                                                      ELSE IF (Job Category=CONST(DSS)) "Job Type Master".No. WHERE (Type=FILTER(Service),
                                                                                                                                                                                                                                                                                                                                                                                     DSS=CONST(Yes));

            trigger OnValidate()
            var
                ServiceLine: Record "25006146";
                Text000: Label 'You cannot change Job type in Header if SANJIVANI lines exists in Service Line.';
            begin
                "AMC Customer" := FALSE;
                IF CheckAMCReg THEN
                  "AMC Customer" := TRUE;
                IF xRec."Job Type"='SANJIVANI' THEN BEGIN
                  ServiceLine.RESET;
                  ServiceLine.SETRANGE("Document Type","Document Type");
                  ServiceLine.SETRANGE("Document No.","No.");
                  ServiceLine.SETRANGE("Job Type",'SANJIVANI');
                  IF ServiceLine.FINDFIRST THEN
                    ERROR(Text000);
                END;
            end;
        }
        field(33020241;"AMC Customer";Boolean)
        {
        }
        field(33020242;"Service Type";Option)
        {
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,6th type service,7th type Service,8th type Service,Bonus,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service","6th type Service","7th type Service"," 8th type Service",Bonus,Other;

            trigger OnValidate()
            var
                NotAllowed: Label 'Job Category must be Under Warranty';
            begin
                IF "Job Category" <> "Job Category"::"Under Warranty" THEN
                ERROR(NotAllowed);      //Agile CPJB 24 May 2016
            end;
        }
        field(33020243;"Activity Detail";Text[150])
        {
            Description = '//reduced';
        }
        field(33020244;"Is Booked";Boolean)
        {
        }
        field(33020245;"Order Posting No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33020246;"Job Slip Printed";Boolean)
        {
        }
        field(33020248;"Hour Reading";Decimal)
        {
        }
        field(33020249;"Bay Allocated";Boolean)
        {
            CalcFormula = Exist("Serv. Labor Alloc. Application" WHERE (Document No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020250;"Job Closed";Boolean)
        {
        }
        field(33020251;"Approx. Estimation";Decimal)
        {

            trigger OnValidate()
            begin
                CheckMobileNo;
            end;
        }
        field(33020252;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            Editable = true;
            TableRelation = "Service Package".No.;
        }
        field(33020253;"Assigned User ID";Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                GLSetup.GET;
                IF NOT GLSetup."Use Accountability Center" THEN
                  IF NOT UserMgt.CheckRespCenter2(0,"Responsibility Center","Assigned User ID") THEN
                    ERROR(
                      Text061,"Assigned User ID",
                      RespCenter.TABLECAPTION,UserMgt.GetSalesFilter2("Assigned User ID"))
                ELSE
                  IF NOT UserMgt.CheckRespCenter2(0,"Accountability Center","Assigned User ID") THEN
                    ERROR(
                      Text061,"Assigned User ID",
                      AccCenter.TABLECAPTION,UserMgt.GetSalesFilter2("Assigned User ID"));
            end;
        }
        field(33020257;"Actual Delivery Time";Time)
        {
        }
        field(33020258;"Job Category";Option)
        {
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI,DSS';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI,DSS;

            trigger OnValidate()
            var
                ServiceLineEDMS: Record "25006146";
                CannotChangeJobCategory: Label 'Please Delete Service Lines Before Changing Job Category! ';
            begin
                //Agile CPJB 24 May 2016
                "Service Type" := "Service Type"::" ";
                CLEAR("Job Type");

                ServiceLineEDMS.RESET;
                ServiceLineEDMS.SETRANGE("Document Type",ServiceLineEDMS."Document Type"::Order);
                ServiceLineEDMS.SETRANGE("Document No.","No.");
                IF ServiceLineEDMS.FINDFIRST THEN
                  ERROR(CannotChangeJobCategory);
                //Agile CPJB 24 May 2016
            end;
        }
        field(33020259;"Next Service Date";Date)
        {
        }
        field(33020260;"Scheme Status";Option)
        {
            CalcFormula = Lookup("Membership Details".Status WHERE (VIN=FIELD(VIN)));
            Description = 'active and inactive depends upon the expiry date and blocked is forceful cancellation of membership.';
            FieldClass = FlowField;
            OptionCaption = ' ,Active,Inactive,Blocked';
            OptionMembers = " ",Active,Inactive,Blocked;
        }
        field(33020261;"Driver Name";Text[50])
        {
        }
        field(33020262;"Driver Contact No.";Text[30])
        {
        }
        field(33020263;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020264;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020265;"Mobile No. for SMS";Code[50])
        {
            Description = 'SMS Send to Mobile No.';

            trigger OnValidate()
            begin
                ValidateMobileNo("Mobile No. for SMS",FIELDCAPTION("Mobile No. for SMS"),"No.");
            end;
        }
        field(33020266;"Qty. to Return";Decimal)
        {
        }
        field(33020267;"Delay Reason Code";Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Aggregate Repairs, Bodyshop / Panel Repairs, Delay in Customer Approval, Diagnosis Issue - Electronic, Diagnosis Issue - Mechanical, Major Job, Outside Jobs, Parts Not Available, Ready But Not Delivered, Work delayed - Tools availability, Work not started - manpower issue, Work not started - shopfloor overloaded, Work not started - walk-in customer, Work started but not completed, Others';
            OptionMembers = " ","Aggregate Repairs"," Bodyshop / Panel Repairs"," Delay in Customer Approval"," Diagnosis Issue - Electronic"," Diagnosis Issue - Mechanical"," Major Job"," Outside Jobs"," Parts Not Available"," Ready But Not Delivered"," Work delayed - Tools availability"," Work not started - manpower issue"," Work not started - shopfloor overloaded"," Work not started - walk-in customer"," Work started but not completed"," Others";
        }
        field(33020268;"Resources PSF";Code[20])
        {
            Description = 'PSF';
            TableRelation = Resource;
        }
        field(33020269;"Revisit Repair Reason";Code[20])
        {
            Description = 'PSF';

            trigger OnLookup()
            var
                PSF: Record "33019806";
            begin
                PSF.RESET;
                IF Rec."RV RR Code" = Rec."RV RR Code"::Revisit THEN
                  PSF.SETRANGE(Type,PSF.Type::Revisit)
                ELSE IF Rec."RV RR Code" = Rec."RV RR Code"::"Repeat Repair" THEN
                  PSF.SETRANGE(Type,PSF.Type::"Repeat")
                ELSE
                  PSF.SETRANGE(Code,'');
                IF PAGE.RUNMODAL(PAGE::"PSF Master",PSF)=ACTION::LookupOK THEN
                 "Revisit Repair Reason" := PSF.Code;
            end;
        }
        field(33020270;"Km Error";Boolean)
        {
        }
        field(33020272;"Insurance Company Name";Text[30])
        {
        }
        field(33020273;"Insurance Policy Number";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","No.")
        {
            Clustered = true;
        }
        key(Key2;"Document Type","Order Date")
        {
        }
        key(Key3;"Sell-to Customer No.")
        {
        }
        key(Key4;"Bill-to Customer No.")
        {
        }
        key(Key5;"Vehicle Serial No.")
        {
        }
        key(Key6;"Document Type","Sell-to Contact No.")
        {
        }
        key(Key7;"Bill-to Contact No.")
        {
        }
        key(Key8;"Document Type","Sell-to Customer No.")
        {
        }
        key(Key9;"Document Date","Vehicle Serial No.")
        {
        }
        key(Key10;"Document Date","Job Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Opp: Record "5092";
        Opp2: Record "5092";
        TempOpportunityEntry: Record "5093" temporary;
        SalesHeader: Record "36";
    begin

        GLSetup.GET;
        IF NOT GLSetup."Use Accountability Center" THEN
          IF NOT UserMgt.CheckRespCenter(3,"Responsibility Center") THEN
            ERROR(Text022,RespCenter.TABLECAPTION,UserMgt.GetSalesFilter)
        ELSE
          IF NOT UserMgt.CheckRespCenter(3,"Accountability Center") THEN
            ERROR(Text022,AccCenter.TABLECAPTION,UserMgt.GetSalesFilter);


        DmsServCommentLine.SETRANGE(Type,"Document Type");
        DmsServCommentLine.SETRANGE("No.","No.");
        DmsServCommentLine.DELETEALL;

        //17.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        ServLine.RESET;
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");
        ServLine.SETRANGE(Type,ServLine.Type::Item);
        IF ServLine.FINDFIRST THEN
          REPEAT
            ServLine.CheckReservationCancelation
          UNTIL ServLine.NEXT = 0;
        //17.04.2014 Elva Baltic P1 #RX MMG7.00 <<

        //23.02.2010 EDMS P2 >>
        IF ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) THEN BEGIN
          ServiceScheduleMgt.DontModifySalesLine(TRUE);
          ServiceScheduleMgt.DeleteAllocationFromServHdr(Rec);
        END;
        //23.02.2010 EDMS P2 <<

        DeleteServLines;

        ServicePlanDocumentLink.RESET;
        ServicePlanDocumentLink.SETCURRENTKEY("Document Type","Document No.");
        CASE Rec."Document Type" OF
          "Document Type"::Quote:
            ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::Quote);
          "Document Type"::Order:
            ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::Order);
          "Document Type"::"Return Order":
            ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::"Return Order");
        END;
        ServicePlanDocumentLink.SETRANGE("Document No.", Rec."No.");
        ServicePlanDocumentLink.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin

        ServiceSetup.GET;

        IF "No." = '' THEN
         BEGIN
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode2,xRec."No. Series","Posting Date","No.","No. Series");
         END;

        InitRecord2;

        IF GETFILTER("Sell-to Customer No.") <> '' THEN
         IF GETRANGEMIN("Sell-to Customer No.") = GETRANGEMAX("Sell-to Customer No.") THEN
          VALIDATE("Sell-to Customer No.",GETRANGEMIN("Sell-to Customer No."));

        IF GETFILTER("Sell-to Contact No.") <> '' THEN
         IF GETRANGEMIN("Sell-to Contact No.") = GETRANGEMAX("Sell-to Contact No.") THEN
          VALIDATE("Sell-to Contact No.",GETRANGEMIN("Sell-to Contact No."));

        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Service Header EDMS","Document Type","No.");

        GetUserSetupEDMS;

        //SM Agni
        IF "Work Status Code" <> 'BOOKING' THEN BEGIN
          "Arrival Date" := TODAY;
          "Arrival Time" := TIME;
        END ELSE BEGIN
          "Arrival Date" := 0D;
          "Arrival Time" := 0T;
        END;
        //SM Agni
    end;

    trigger OnRename()
    begin
        ERROR(Text003,TABLECAPTION);
    end;

    var
        Contract: Record "25006016";
        ServiceSetup: Record "25006120";
        CompanyInfo: Record "79";
        GLSetup: Record "98";
        ServiceScheduleSetup: Record "25006286";
        GLAcc: Record "15";
        ServiceHeader: Record "25006145";
        ServLine: Record "25006146";
        CustLedgEntry: Record "21";
        Cust: Record "18";
        PaymentTerms: Record "3";
        PaymentMethod: Record "289";
        CurrExchRate: Record "330";
        DmsServCommentLine: Record "25006148";
        PostCode: Record "225";
        BankAcc: Record "270";
        SalesShptHeader: Record "110";
        SalesInvHeader: Record "112";
        SalesCrMemoHeader: Record "114";
        ReturnRcptHeader: Record "6660";
        GenBusPostingGrp: Record "250";
        GenJnILine: Record "81";
        RespCenter: Record "5714";
        Location: Record "14";
        WhseRequest: Record "5765";
        ServicePlanDocumentLink: Record "25006157";
        VehicleComponent: Record "25006010";
        SalesHeader: Record "36";
        UserMgt: Codeunit "5700";
        NoSeriesMgt: Codeunit "396";
        CustCheckCreditLimit: Codeunit "312";
        GenJnlApply: Codeunit "225";
        DimMgt: Codeunit "408";
        ArchiveManagement: Codeunit "5063";
        ServiceScheduleMgt: Codeunit "25006201";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        ReservEntry: Record "337";
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        Text001: Label 'Do you want to print invoice %1?';
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Do you want to change %1?';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: Label 'You cannot change %1 because the order is associated with one or more purchase orders.';
        Text008: Label 'Deleting this document will cause a gap in the number series for shipments. ';
        Text009: Label 'An empty shipment %1 will be created to fill this gap in the number series.\\';
        Text010: Label 'Do you want to continue?';
        Text011: Label 'Deleting this document will cause a gap in the number series for posted invoices. ';
        Text012: Label 'An empty posted invoice %1 will be created to fill this gap in the number series.\\';
        Text013: Label 'Deleting this document will cause a gap in the number series for posted credit memos. ';
        Text014: Label 'An empty posted credit memo %1 will be created to fill this gap in the number series.\\';
        Text015: Label 'If you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\';
        Text017: Label 'You must delete the existing sales lines before you can change %1.';
        Text018: Label 'You have changed %1 on the service header, but it has not been changed on the existing service lines.\';
        Text019: Label 'You must update the existing service lines manually.';
        Text020: Label 'The change may affect the exchange rate used in the price calculation of the service lines.';
        Text021: Label 'Do you want to update the exchange rate?';
        Text022: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text024: Label 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ';
        Text026: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text027: Label 'Your identification is set up to process from %1 %2 only.';
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text029: Label 'Deleting this document will cause a gap in the number series for return receipts. ';
        Text030: Label 'An empty return receipt %1 will be created to fill this gap in the number series.\\';
        Text031: Label 'You have modified %1.\\';
        Text032: Label 'Do you want to update the lines?';
        Text035: Label 'You cannot Release Quote or Make Order unless you specify a customer on the quote.\\Do you want to create customer(s) now?';
        Text037: Label 'Contact %1 %2 is not related to customer %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text039: Label 'Contact %1 %2 is not related to a customer.';
        Text045: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text051: Label 'The services %1 %2 already exists.';
        tcSER001: Label 'The vehicle %1 %2, registration number %3,  VIN %4 exists on another service order. Do you want to Proceed?';
        SkipVehicleChoose: Boolean;
        LookUpMgt: Codeunit "25006003";
        Text053: Label 'You must cancel the approval process if you wish to change the %1.';
        Text054: Label 'The sales %1 %2 has item tracking. Do you want to delete it anyway?';
        Text055: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. ';
        Text056: Label 'An empty prepayment invoice %1 will be created to fill this gap in the number series.\\';
        SalesInvHeaderPrepmt: Record "112";
        SalesCrMemoHeaderPrepmt: Record "114";
        Text064: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text101: Label 'One or more sales invoice exist.';
        Text102: Label 'Pending service plan No. %1 exists for this vehicle.';
        Text121: Label 'The vehicle %1 %2, registration number %3,  VIN %4 exists in %5 other service orders. Do you want to Proceed?';
        Text122: Label 'You cannot Release Quote or Make Order unless you specify a vehicle on the quote.\\Do you want to create vehicle now?';
        Text123: Label 'You cannot Release Quote or Make Order unless you specify a sell-to contact or sell-to customer on the quote.\\Do you want to create contact now?';
        Text124: Label 'Service package %1 is blocked.';
        Text125: Label 'Do You want to link this vehice to contact No. %1?';
        EDMS001: Label 'The new kilometrage is less than the previous one.';
        VFMgt: Codeunit "25006004";
        ContBusRel: Record "5054";
        Text130: Label 'There are one or more pending recall campaigns for VIN %1. Please check recall campaign details';
        Text131: Label 'There is no vehicle with Registration No. %1';
        VehicleConfirm: Label 'There is a vehicle linked to this contact.\%1 %2\%3 %4\%5 %6\Do you want to apply this vehicle?';
        ContactConfirm: Label 'There is a customer linked to this vehicle.\%1 %2\Do you want to apply this customer?';
        FindVehicle: Boolean;
        FindCustomer: Boolean;
        TireManagement: Codeunit "25006125";
        Vehicle: Record "25006005";
        VehicleServicePlanStageTmp_CS: Record "25006132" temporary;
        AppMgt: Codeunit "1";
        AboutComponentsNotified: Boolean;
        Text132: Label 'There is component with pending plan stage.';
        LastModifiedRec: Record "25006145";
        Text133: Label 'No Service Package corresponds to characteristics of the vehicle.';
        ApplyCustEntries: Page "232";
                              ResourceTextFieldValue: Text[250];
                              ResourceTextFieldModified: Boolean;
                              ServicePrevParcedRsc: Record "25006145" temporary;
                              ServLaborApplicationGlobTmp: Record "25006277" temporary;
                              Text134: Label 'No Service Package Version corresponds to characteristics of the vehicle. (%1: %2)';
        Text135: Label 'Do you want to leave prices and discounts unchanged?';
        Text136: Label 'Cutomer No. %1 have %2 active contracts!';
        Text137: Label 'There is no %1 with %2 %3';
        Text138: Label 'Service Schedule Setup does not exist. Please create Service Schedule Setup Entry.';
        PricesInclVATValidated: Boolean;
        SavePricesConfirmed: Boolean;
        AlreadyConfirmed: Boolean;
        TCardMgt: Codeunit "25006870";
        DocTypeContainerErr: Label 'Document Type does not mach with Container Type';
        FinishDateBeforeStartErr: Label 'Finishing Date is before Starting Date';
        FinishTimeBeforeStartErr: Label 'Finishing Time is before Starting Time';
        ShipToAddr: Record "222";
        StplSysMgt: Codeunit "50000";
        DocumentProfile: Option Purchase,Sales,Service,Transfer;
        DocumentType: Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order";
        JobTypeMaster: Record "33020235";
        AMCRegVeh: Record "33020240";
        AMCApplied: Boolean;
        PackageInserted: Boolean;
        DuplicateServiceOrderNo: Code[20];
        AccCenter: Record "33019846";
        MemberDetails: Record "33019864";
        SchemeVehicleTracking: Record "33019875";
        MembershipDetail: Record "33019864";
        ExpiredAMC: Label 'The Vehicle AMC is expired.';
        ChangeBillTo: Label 'Do you want to apply AMC Account?';
        NotValidAMC: Label 'The Vehicle is not Registered for AMC.';
        ProcessCancelled: Label 'The vehicle with registration number %1,  VIN %2 already exists service order no %3.';
        InvalidHour: Label 'The new hour is less than the previous one.';
        Text061: Label '%1 is set up to process from %2 %3 only.';
        Text062: Label 'Vehicle has not been linked to any Contacts. Please inform authorised person to link Vehicle with Contacts.';
        VehicleInsurance: Record "25006033";

    [Scope('Internal')]
    procedure InitRecord()
    var
        LocCodeFilterStr: Code[20];
        SingleQuote: Char;
    begin
        CASE "Document Type" OF
          "Document Type"::Order:
            BEGIN
              IF ServiceSetup."Use Order No. as Posting No." THEN BEGIN
                "Posting No." := "No.";
                //"Posting No. Series" := "No. Series"
                 "Posting No. Series" := StplSysMgt.getLocWiseNoSeries(2,5)
              END ELSE
                //NoSeriesMgt.SetDefaultSeries("Posting No. Series",ServiceSetup."Posted Order Nos.");
                // Sipradi-YS GEN6.1.0 * Code to get location wise no. series
                //NoSeriesMgt.SetDefaultSeries("Posting No. Series",StplSysMgt.getLocWiseNoSeries(2,5));
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,DocumentType::"Posted Order"));
                // Sipradi-YS END
              NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",ServiceSetup."Posted Prepmt. Inv. Nos.");
              NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",ServiceSetup."Posted Prepmt. Cr. Memo Nos.");
            END;
          "Document Type"::"Return Order":
            BEGIN
              IF ServiceSetup."Use Order No. as Posting No." THEN BEGIN
                "Pst. Return Order No." := "No.";
                "Pst. Return Order No. Series" := "No. Series"
              END ELSE
                NoSeriesMgt.SetDefaultSeries("Pst. Return Order No. Series",ServiceSetup."Posted Return Order Nos.")
            END;
          "Document Type"::Booking:
            BEGIN
              "Location Code" := GETFILTER("Location Code");
            END;
        END;

        IF "Document Type" IN ["Document Type"::"Return Order"] THEN BEGIN
          GLSetup.GET;
          Correction := GLSetup."Mark Cr. Memos as Corrections";
        END;

        GLSetup.GET;
        IF NOT GLSetup."Use Accountability Center" THEN
          "Responsibility Center" := UserMgt.GetRespCenter(3,"Responsibility Center")
        ELSE
          "Accountability Center" := UserMgt.GetRespCenter(3,"Accountability Center");
        GetUserSetupEDMS;

        VALIDATE("Order Date",WORKDATE);
        VALIDATE("Order Time",TIME);

        IF "Posting Date" = 0D THEN
          "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;

        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

        IF NOT ServiceScheduleSetup.GET THEN
          IF NOT HideValidationDialog THEN
            MESSAGE(Text138);

        "Planning Policy" := ServiceScheduleSetup."Planning Policy";

        IF "Document Type" = "Document Type"::Booking THEN BEGIN
          SingleQuote := 39;
          FILTERGROUP(2);
          LocCodeFilterStr := DELCHR(GETFILTER("Location Code"),'=',FORMAT(SingleQuote));
          IF LocCodeFilterStr <> '' THEN
            VALIDATE("Location Code",GETFILTER("Location Code"));
          "Requested Starting Date" := GETRANGEMAX(Rec."Requested Starting Date");
          "Requested Finishing Date" := GETRANGEMAX(Rec."Requested Starting Date");
          FILTERGROUP(0);
          "Requested Starting Time" := TIME;
          "Requested Finishing Time" := TIME;
        END;
    end;

    [Scope('Internal')]
    procedure AssistEdit(OldSalesHeader: Record "25006145"): Boolean
    var
        SalesHeader2: Record "25006145";
    begin
        WITH ServiceHeader DO BEGIN
          COPY(Rec);
          ServiceSetup.GET;
          TestNoSeries;
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode2,OldSalesHeader."No. Series","No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            IF SalesHeader2.GET("Document Type","No.") THEN
              ERROR(Text051,LOWERCASE(FORMAT("Document Type")),"No.");
            Rec := ServiceHeader;
            EXIT(TRUE);
          END;
        END;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        CASE "Document Type" OF
          "Document Type"::Quote:
            ServiceSetup.TESTFIELD("Quote Nos.");
          "Document Type"::Order: BEGIN
              IF "Quote No." <> '' THEN
                ServiceSetup.TESTFIELD("Order Nos. from Quote")
              ELSE
                ServiceSetup.TESTFIELD("Order Nos.");
            END;
          "Document Type"::"Return Order":
            ServiceSetup.TESTFIELD("Return Order Nos.");
          "Document Type"::Booking:
            ServiceSetup.TESTFIELD("Service Booking Nos.");
        END;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        CASE "Document Type" OF
          "Document Type"::Quote:
            EXIT(ServiceSetup."Quote Nos.");
          "Document Type"::Order: BEGIN
              IF "Quote No." <> '' THEN
                EXIT(ServiceSetup."Order Nos. from Quote")
              ELSE
                EXIT(ServiceSetup."Order Nos.");
            END;
          "Document Type"::"Return Order":
            EXIT(ServiceSetup."Return Order Nos.");
          "Document Type"::Booking:
            EXIT(ServiceSetup."Service Booking Nos.");
        END;
    end;

    local procedure GetPostingNoSeriesCode(): Code[10]
    begin
        // Sipradi-YS GEN6.1.0 * Code to Retrieve Posting Nos Location Wise * Standard Code has been commented.
        /*IF "Document Type" IN ["Document Type"::"Return Order"] THEN
          EXIT(ServiceSetup."Posted Credit Memo Nos.");
        EXIT(ServiceSetup."Posted Invoice Nos.");
        */
        
        IF "Document Type" IN ["Document Type"::"Return Order"] THEN
          EXIT(StplSysMgt.getLocWiseNoSeries(2,7));
        EXIT(StplSysMgt.getLocWiseNoSeries(2,5));

    end;

    [Scope('Internal')]
    procedure ConfirmDeletion(): Boolean
    begin
        IF SalesShptHeader."No." <> '' THEN BEGIN
          Confirmed := ConfirmLoc(STRSUBSTNO(Text008 +Text009 +Text010,SalesShptHeader."No."), TRUE, '');
          IF NOT Confirmed THEN
            EXIT;
        END;
        IF SalesInvHeader."No." <> '' THEN BEGIN
          Confirmed := ConfirmLoc(STRSUBSTNO(Text011 +Text012 +Text010,SalesInvHeader."No."), TRUE, '');
          IF NOT Confirmed THEN
            EXIT;
        END;
        IF SalesCrMemoHeader."No." <> '' THEN BEGIN
          Confirmed := ConfirmLoc(STRSUBSTNO(Text013 +Text014 +Text010,SalesCrMemoHeader."No."), TRUE, '');
          IF NOT Confirmed THEN
            EXIT;
        END;
        IF ReturnRcptHeader."No." <> '' THEN BEGIN
          Confirmed := ConfirmLoc(STRSUBSTNO(Text029 +Text030 +Text010,ReturnRcptHeader."No."), TRUE, '');
          IF NOT Confirmed THEN
            EXIT;
        END;
        //08-05-2007 EDMS P3 PREPMT >>
        IF "Prepayment No." <> '' THEN BEGIN
          Confirmed := ConfirmLoc(STRSUBSTNO(Text053 +Text054 +Text010,SalesInvHeaderPrepmt.TABLENAME,
            SalesInvHeaderPrepmt."No."), TRUE, '');
          IF NOT Confirmed THEN
            EXIT;
        END;
        IF "Prepmt. Cr. Memo No." <> '' THEN BEGIN
          Confirmed := ConfirmLoc(STRSUBSTNO(Text055 +Text056 +Text010,SalesCrMemoHeaderPrepmt."No."), TRUE, '');
          IF NOT Confirmed THEN
            EXIT;
        END;
        //08-05-2007 EDMS P3 PREPMT <<

        EXIT(TRUE);
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        IF NOT (("Document Type" = "Document Type"::Quote) AND (CustNo = '')) THEN BEGIN
          IF CustNo <> Cust."No." THEN
            Cust.GET(CustNo);
        END ELSE
          CLEAR(Cust);
    end;

    [Scope('Internal')]
    procedure DmsServLinesExist(): Boolean
    begin
        ServLine.RESET;
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");
        EXIT(ServLine.FINDSET);
    end;

    [Scope('Internal')]
    procedure MessageIfServLinesExist(ChangedFieldName: Text[100])
    begin
        IF DmsServLinesExist THEN
          MessageLoc(STRSUBSTNO(Text018 + Text019, ChangedFieldName), '');
    end;

    [Scope('Internal')]
    procedure PriceMessageIfServLinesExist(ChangedFieldName: Text[100])
    begin
        IF DmsServLinesExist THEN
          MessageLoc(STRSUBSTNO(Text018 + Text020, ChangedFieldName), '');
    end;

    local procedure UpdateCurrencyFactor()
    begin
        IF "Currency Code" <> '' THEN BEGIN
          IF ("Document Type" IN ["Document Type"::Quote,"Document Type"::"4"]) AND
             ("Posting Date" = 0D)
          THEN
            CurrencyDate := WORKDATE
          ELSE
            CurrencyDate := "Posting Date";

          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
        END ELSE
          "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        Confirmed := ConfirmLoc(Text021, FALSE, '');
        IF Confirmed THEN
          VALIDATE("Currency Factor")
        ELSE
          "Currency Factor" := xRec."Currency Factor";
    end;

    [Scope('Internal')]
    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    [Scope('Internal')]
    procedure SetSkipVehicleChoose(NewSkipVehicleChoose: Boolean)
    begin
        SkipVehicleChoose := NewSkipVehicleChoose;
    end;

    [Scope('Internal')]
    procedure UpdateDMSServLines(ChangedFieldName: Text[100];AskQuestion: Boolean)
    var
        Question: Text[250];
        UpdateLines: Boolean;
    begin
        IF DmsServLinesExist AND AskQuestion THEN BEGIN
          Question := STRSUBSTNO(
            Text031 +
            Text032,ChangedFieldName);
          Confirmed := ConfirmLoc(Question, TRUE, '');
          IF NOT Confirmed THEN
            EXIT
          ELSE
            UpdateLines := TRUE;
        END;
        IF DmsServLinesExist THEN BEGIN
          ServLine.LOCKTABLE;
          MODIFY;

          ServLine.RESET;
          ServLine.SETRANGE("Document Type","Document Type");
          ServLine.SETRANGE("Document No.","No.");
          IF ServLine.FINDSET THEN
            REPEAT
              CASE ChangedFieldName OF
                FIELDCAPTION("Currency Factor") :
                  IF ServLine.Type <> ServLine.Type::" " THEN BEGIN
                    ServLine.VALIDATE("Unit Price");
                    ServLine.VALIDATE("Unit Cost (LCY)");
                  END;
                FIELDCAPTION("Requested Delivery Date") :
                  IF ServLine."No." <> '' THEN
                    ServLine.VALIDATE("Requested Delivery Date","Requested Delivery Date");
                FIELDCAPTION("Promised Delivery Date") :
                  IF ServLine."No." <> '' THEN
                    ServLine.VALIDATE("Promised Delivery Date","Promised Delivery Date");
                //21.02.2010 EDMS P2 >>
                FIELDCAPTION("Prepayment %"):
                  IF ServLine."No." <> '' THEN
                    ServLine.VALIDATE("Prepayment %","Prepayment %");
                //21.02.2010 EDMS P2 <<
                FIELDCAPTION("Shipping Time"):
                  IF ServLine."No." <> '' THEN
                    ServLine.VALIDATE("Shipping Time","Shipping Time");
                FIELDCAPTION("Shipment Date"):
                  IF ServLine."No." <> '' THEN
                    ServLine.VALIDATE("Shipment Date","Shipment Date");
              END;
              //DMSServLineReserve.AssignForPlanning(DMSServLine);
              ServLine.MODIFY(TRUE);
            UNTIL ServLine.NEXT = 0;
        END;
    end;

    local procedure DeleteServLines()
    begin
        ServLine.RESET;
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");
        ServLine.DELETEALL(TRUE);
        IF GET("Document Type", "No.") THEN;
    end;

    [Scope('Internal')]
    procedure CheckCustomerCreated(Prompt: Boolean): Boolean
    var
        Cont: Record "5050";
        Confirmed: Boolean;
    begin
        IF ("Bill-to Customer No." <> '') AND ("Sell-to Customer No." <> '') THEN
          EXIT(TRUE);


        IF Prompt THEN BEGIN
          Confirmed := ConfirmLoc(Text035,TRUE, '');
          IF NOT Confirmed THEN
            EXIT(FALSE);
        END;

        IF "Sell-to Customer No." = '' THEN BEGIN
          TESTFIELD("Sell-to Contact No.");

          TESTFIELD("Sell-to Customer Template Code");
          Cont.GET("Sell-to Contact No.");
          Cont.CreateCustomer("Sell-to Customer Template Code");
          COMMIT;
          GET("Document Type"::Quote,"No.");
        END;

        IF "Bill-to Customer No." = '' THEN BEGIN
          TESTFIELD("Bill-to Contact No.");
          TESTFIELD("Bill-to Customer Template Code");
          Cont.GET("Bill-to Contact No.");
          Cont.CreateCustomer("Bill-to Customer Template Code");
          COMMIT;
          GET("Document Type"::Quote,"No.");
        END;

        VALIDATE("Sell-to Customer No.");  //01.02.2013 EDMS P8

        EXIT(("Bill-to Customer No." <> '') AND ("Sell-to Customer No." <> ''));
    end;

    [Scope('Internal')]
    procedure UpdateSellToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "5054";
        Cont: Record "5050";
        Cust: Record "18";
        recVehicle: Record "25006005";
    begin
        IF Cust.GET(CustomerNo) THEN BEGIN
          IF Cust."Primary Contact No." <> '' THEN
            "Sell-to Contact No." := Cust."Primary Contact No."
          ELSE BEGIN
            ContBusRel.RESET;
            ContBusRel.SETCURRENTKEY("Link to Table","No.");
            ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
            ContBusRel.SETRANGE("No.","Sell-to Customer No.");
            IF ContBusRel.FINDFIRST THEN BEGIN
              "Sell-to Contact No." := ContBusRel."Contact No.";
            END;            // 19.02.2015 EDMS P21
          END;              // 19.02.2015 EDMS P21

          //27.01.2015 EB.P7 #E0062 MMG7.00 >>
          IF (Rec."Vehicle Registration No." = xRec."Vehicle Registration No.")
             AND ("Vehicle Serial No." = xRec."Vehicle Serial No.") AND NOT FindCustomer
          THEN
            IF NOT SkipVehicleChoose THEN
              FindContVehicle;
          //27.01.2015 EB.P7 #E0062 MMG7.00 <<
          //  END;          // 19.02.2015 EDMS P21
          //END;            // 19.02.2015 EDMS P21

          "Sell-to Contact" := Cust.Contact;
          IF (Rec."Sell-to Contact No." <> xRec."Sell-to Contact No.") THEN
            IF NOT SkipVehicleChoose THEN
            IF NOT SkipSellToContact THEN //27.10.2014 EB.P8 #S0218 MMG7.00
              VALIDATE("Sell-to Contact No.");
        END;
    end;

    [Scope('Internal')]
    procedure UpdateBillToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "5054";
        Cont: Record "5050";
        Cust: Record "18";
        recVehicle: Record "25006005";
    begin
        IF Cust.GET(CustomerNo) THEN BEGIN
          IF Cust."Primary Contact No." <> '' THEN
            "Bill-to Contact No." := Cust."Primary Contact No."
          ELSE BEGIN
            ContBusRel.RESET;
            ContBusRel.SETCURRENTKEY("Link to Table","No.");
            ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
            ContBusRel.SETRANGE("No.","Bill-to Customer No.");
            IF ContBusRel.FINDFIRST THEN
              "Bill-to Contact No." := ContBusRel."Contact No.";
          END;
          "Bill-to Contact" := Cust.Contact;
        END;
          IF ("Bill-to Contact No." <> '') AND Cont.GET("Bill-to Contact No.") THEN
           "Bill-to Contact Phone No." := Cont."Phone No.";

          IF "Vehicle Serial No." <> ''  THEN
           BEGIN
            recVehicle.GET("Vehicle Serial No.");
           END;
    end;

    [Scope('Internal')]
    procedure UpdateSellToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "5054";
        Cust: Record "18";
        Cont: Record "5050";
        CustTemplate: Record "5105";
        ContComp: Record "5050";
        recVehicle: Record "25006005";
    begin

        IF Cont.GET(ContactNo) THEN BEGIN
          "Sell-to Contact No." := Cont."No.";

          IF Cont.Type = Cont.Type::Person THEN
            "Sell-to Contact" := Cont.Name
          ELSE
            IF Cust.GET("Sell-to Customer No.") THEN
              "Sell-to Contact" := Cust.Contact
            ELSE
              "Sell-to Contact" := '';
          "Phone No." := Cont."Phone No.";
        END ELSE BEGIN
            "Sell-to Contact" := '';
            EXIT;
          END;

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
        IF ContBusinessRelation.FINDFIRST THEN BEGIN
          IF ("Sell-to Customer No." <> '') AND
             ("Sell-to Customer No." <> ContBusinessRelation."No.")
          THEN
            ERROR(Text037,Cont."No.",Cont.Name,"Sell-to Customer No.")
          ELSE IF "Sell-to Customer No." = '' THEN BEGIN
            SkipSellToContact := TRUE;
            VALIDATE("Sell-to Customer No.",ContBusinessRelation."No.");
            SkipSellToContact := FALSE;
          END;
        END ELSE BEGIN
          IF "Document Type" = "Document Type"::Quote THEN BEGIN
            Cont.TESTFIELD("Company No.");
            ContComp.GET(Cont."Company No.");
            "Sell-to Customer Name" := ContComp."Company Name";
            "Sell-to Customer Name 2" := ContComp."Name 2";
            "Sell-to Address" := ContComp.Address;
            "Sell-to Address 2" := ContComp."Address 2";
            "Sell-to City" := ContComp.City;
            "Sell-to Post Code" := ContComp."Post Code";
            "Sell-to County" := ContComp.County;
            "Sell-to Country/Region Code" := ContComp."Country/Region Code";
            IF ("Sell-to Customer Template Code" = '') AND (NOT CustTemplate.ISEMPTY) THEN
              VALIDATE("Sell-to Customer Template Code",Cont.FindCustomerTemplate);
          END ELSE
            ERROR(Text039,Cont."No.",Cont.Name);
        END;

        IF ("Sell-to Customer No." = "Bill-to Customer No.") OR
           ("Bill-to Customer No." = '')
        THEN
          VALIDATE("Bill-to Contact No.","Sell-to Contact No.");
    end;

    [Scope('Internal')]
    procedure UpdateBillToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "5054";
        Cust: Record "18";
        Cont: Record "5050";
        CustTemplate: Record "5105";
        ContComp: Record "5050";
    begin
        IF Cont.GET(ContactNo) THEN BEGIN
          "Bill-to Contact No." := Cont."No.";
          "Bill-to Contact Phone No." := Cont."Phone No.";
          IF Cont.Type = Cont.Type::Person THEN
            "Bill-to Contact" := Cont.Name
          ELSE
            IF Cust.GET("Bill-to Customer No.") THEN
              "Bill-to Contact" := Cust.Contact
            ELSE
              "Bill-to Contact" := '';
        END ELSE BEGIN
            "Bill-to Contact" := '';
            EXIT;
          END;

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
        IF ContBusinessRelation.FINDFIRST THEN BEGIN
          IF "Bill-to Customer No." = '' THEN BEGIN
            SkipBillToContact := TRUE;
            VALIDATE("Bill-to Customer No.",ContBusinessRelation."No.");
            SkipBillToContact := FALSE;
            "Bill-to Customer Template Code" := '';
          END ELSE
            IF "Bill-to Customer No." <> ContBusinessRelation."No." THEN
              ERROR(Text037,Cont."No.",Cont.Name,"Bill-to Customer No.");
        END ELSE BEGIN
          IF "Document Type" = "Document Type"::Quote THEN BEGIN
            Cont.TESTFIELD("Company No.");
            ContComp.GET(Cont."Company No.");
            "Bill-to Name" := ContComp."Company Name";
            "Bill-to Name 2" := ContComp."Name 2";
            "Bill-to Address" := ContComp.Address;
            "Bill-to Address 2" := ContComp."Address 2";
            "Bill-to City" := ContComp.City;
            "Bill-to Post Code" := ContComp."Post Code";
            "Bill-to County" := ContComp.County;
            "Bill-to Country/Region Code" := ContComp."Country/Region Code";
            "VAT Registration No." := ContComp."VAT Registration No.";
            VALIDATE("Currency Code",ContComp."Currency Code");
            "Language Code" := ContComp."Language Code";
            IF ("Bill-to Customer Template Code" = '') AND (NOT CustTemplate.ISEMPTY) THEN
              VALIDATE("Bill-to Customer Template Code",Cont.FindCustomerTemplate);
          END ELSE
            ERROR(Text039,Cont."No.",Cont.Name);
        END;
    end;

    [Scope('Internal')]
    procedure CheckCreditMaxBeforeInsert()
    var
        SalesHeader: Record "36";
        ContBusinessRelation: Record "5054";
        Cont: Record "5050";
        CustCheckCreditLimit: Codeunit "312";
    begin
        IF GETFILTER("Sell-to Customer No.") <> '' THEN BEGIN
          IF GETRANGEMIN("Sell-to Customer No.") = GETRANGEMAX("Sell-to Customer No.") THEN BEGIN
            SalesHeader."Bill-to Customer No." := GETRANGEMIN("Sell-to Customer No.");
            CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
          END
        END ELSE
          IF GETFILTER("Sell-to Contact No.") <> '' THEN
            IF GETRANGEMIN("Sell-to Contact No.") = GETRANGEMAX("Sell-to Contact No.") THEN BEGIN
              Cont.GET(GETRANGEMIN("Sell-to Contact No."));
              ContBusinessRelation.RESET;
              ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
              ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
              ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
              IF ContBusinessRelation.FINDFIRST THEN BEGIN
                SalesHeader."Bill-to Customer No." := ContBusinessRelation."No.";
                CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
              END;
            END;
    end;

    [Scope('Internal')]
    procedure CreateInvtPutAwayPick()
    var
        WhseRequest: Record "5765";
    begin
        WhseRequest.RESET;
        WhseRequest.SETCURRENTKEY("Source Document","Source No.");
        CASE "Document Type" OF
          "Document Type"::Order:
            WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Sales Order");
          "Document Type"::"Return Order":
            WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Sales Return Order");
        END;
        WhseRequest.SETRANGE("Source No.","No.");
        REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt",TRUE,FALSE,WhseRequest);
    end;

    [Scope('Internal')]
    procedure FindContVehicle(): Code[20]
    var
        Vehicle: Record "25006005";
        VehCount: Integer;
        Cont: Record "5050";
        VehicleContact: Record "25006013";
        Confirmed: Boolean;
    begin
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
           Confirmed := ConfirmLoc(STRSUBSTNO(VehicleConfirm,Vehicle."Make Code",Vehicle."Model Code",
             Vehicle.FIELDCAPTION("Registration No."),Vehicle."Registration No.",
             Vehicle.FIELDCAPTION(VIN),Vehicle.VIN), TRUE, '');
           IF Confirmed THEN
             VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
          END;
         ELSE
          BEGIN
            COMMIT;
            IF NOT HideValidationDialog THEN
              IF PAGE.RUNMODAL(PAGE::"Vehicle List",Vehicle) = ACTION::LookupOK THEN //!!
                VALIDATE("Vehicle Serial No.",Vehicle."Serial No.")
            ELSE BEGIN
              Vehicle.FINDFIRST;
              VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
            END;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure FindVehicleCont(): Code[20]
    var
        Vehicle: Record "25006005";
        CustomerCount: Integer;
        Contact: Record "5050";
        VehicleContact: Record "25006013";
        ContBusRelation: Record "5054";
        Customer: Record "18";
        ContactCount: Integer;
        MarketingSetup: Record "5079";
        ContactBusinessRelation: Record "5054";
        Customer2: Record "18";
    begin
        IF "Vehicle Serial No." = '' THEN
          EXIT;

        FindCustomer := TRUE;
        //29.05.2013 Elva Baltic P15 >>
        ContBusRelation.RESET;
        Customer.RESET;
        VehicleContact.RESET;
        VehicleContact.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
        MarketingSetup.GET;

        IF VehicleContact.FINDFIRST THEN
          REPEAT
            ContBusRelation.SETRANGE("Contact No.", VehicleContact."Contact No.");

            IF ContBusRelation.FINDFIRST THEN
              REPEAT
                IF (ContBusRelation."Business Relation Code" = MarketingSetup."Bus. Rel. Code for Customers") AND (Customer.GET(ContBusRelation."No.")) THEN
                  VehicleContact.MARK(TRUE);
              UNTIL ContBusRelation.NEXT = 0;
          UNTIL VehicleContact.NEXT = 0;
        VehicleContact.MARKEDONLY(TRUE);

        ContactCount := VehicleContact.COUNT;

        IF ContactCount=0 THEN
          ERROR(Text062);
        CASE ContactCount OF
         0:
          BEGIN
           Contact.MARKEDONLY(FALSE);
          END;
         1:
          BEGIN
           Contact.FINDFIRST;
           IF "Sell-to Contact No." <> VehicleContact."Contact No." THEN BEGIN       // 19.02.2015 EDMS P21
             Confirmed := ConfirmLoc(STRSUBSTNO(ContactConfirm,Customer."No.", Customer.Name ), TRUE,'');
             IF Confirmed THEN
               VALIDATE("Sell-to Contact No.",VehicleContact."Contact No.");
           END;                                                                      // 19.02.2015 EDMS P21
          END;
         ELSE
          BEGIN
            COMMIT;
            IF PAGE.RUNMODAL(PAGE::"Vehicle Contacts", VehicleContact) = ACTION::LookupOK THEN
              VALIDATE("Sell-to Contact No.",VehicleContact."Contact No.");
          END;
        END;
        //29.05.2013 Elva Baltic P15 <<
    end;

    [Scope('Internal')]
    procedure UpdVehicleInfo(VehSerialNo: Code[20];recVehicle: Record "25006005")
    var
        recServHeader: Record "25006145";
        recSalesLine: Record "37";
    begin
        //11.07.2007. EDMS P2 >>
        IF NOT HideValidationDialog THEN
          IF VIN <> '' THEN
           BEGIN
            recServHeader.SETRANGE("Document Type","Document Type");
            recServHeader.SETFILTER("No.",'<>%1',"No.");
            recServHeader.SETRANGE("Vehicle Serial No.",VehSerialNo);
            CASE recServHeader.COUNT OF
              0:
                EXIT;
              1:
                //MessageLoc(STRSUBSTNO(
                  //tcSER001,recVehicle."Make Code",recVehicle."Model Code",recVehicle."Registration No.",recVehicle.VIN
                  //), '');
                ERROR(ProcessCancelled,recVehicle."Registration No.",recVehicle.VIN,DuplicateServiceOrderNo);
              ELSE
                //MessageLoc(STRSUBSTNO(
                //  Text121,recVehicle."Make Code",recVehicle."Model Code",recVehicle."Registration No.",recVehicle.VIN, recServHeader.COUNT
                //  ), '');
                ERROR(ProcessCancelled,recVehicle."Registration No.",recVehicle.VIN,DuplicateServiceOrderNo);
            END;
           END;
        //11.07.2007. EDMS P2 <<
    end;

    [Scope('Internal')]
    procedure GetUserSetup()
    var
        UserSetup: Record "91";
        SingleInstanceMgt: Codeunit "25006001";
        UserProfileMgt: Codeunit "25006002";
        UserProfile: Record "25006067";
        ServSetup: Record "25006120";
        ServLocation: Code[20];
    begin
        ServSetup.GET;

        IF UserSetup.GET(USERID) THEN
         BEGIN
          IF UserSetup."Salespers./Purch. Code" <> '' THEN
           VALIDATE("Service Person",UserSetup."Salespers./Purch. Code");
         END;

        IF UserProfileMgt.CurrProfileID <> '' THEN BEGIN
          IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
           BEGIN
            IF UserProfile."Spec. Service Setup" THEN
             BEGIN //For Vehicle Salespersons
              VALIDATE("Initiator Code",UserSetup."Salespers./Purch. Code");
              VALIDATE("Service Person",UserProfile."Spec. Order Receiver");
              UserProfile.TESTFIELD("Spec. Service User Profile");
              IF UserProfile.GET(UserProfile."Spec. Service User Profile") THEN
               BEGIN
                ServLocation := UserProfile."Def. Service Location Code";
                IF ServLocation = '' THEN
                  ServLocation := ServSetup."Def. Service Location Code";
                IF ServLocation <> '' THEN
                 VALIDATE("Location Code",ServLocation);
                IF UserProfile."Default Deal Type Code" <> '' THEN
                  VALIDATE("Deal Type",UserProfile."Default Deal Type Code");
               END;
             END
            ELSE
             BEGIN //For Service Employees
              ServLocation := UserProfile."Def. Service Location Code";
              IF ServLocation = '' THEN
               ServLocation := ServSetup."Def. Service Location Code";
              IF ServLocation <> '' THEN
               VALIDATE("Location Code",ServLocation);
              IF UserProfile."Default Deal Type Code" <> '' THEN
                VALIDATE("Deal Type",UserProfile."Default Deal Type Code");
             END;
           END;
        END ELSE BEGIN
          ServLocation := ServSetup."Def. Service Location Code";  //26.02.2013 EDMS P8
          IF ServLocation <> '' THEN
            VALIDATE("Location Code",ServLocation);
          IF ServSetup."Deal Type Mandatory" THEN
            TESTFIELD("Deal Type");
        END;
        "Assigned User ID" := USERID;
    end;

    [Scope('Internal')]
    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          MODIFY;
          IF DmsServLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer;OldParentDimSetID: Integer)
    var
        ATOLink: Record "904";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        IF NewParentDimSetID = OldParentDimSetID THEN
          EXIT;
        IF NOT CONFIRM(Text064) THEN
          EXIT;

        ServLine.RESET;
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");
        ServLine.LOCKTABLE;
        IF ServLine.FINDSET(TRUE,FALSE) THEN
          REPEAT
            NewDimSetID := DimMgt.GetDeltaDimSetID(ServLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
            IF ServLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
              ServLine."Dimension Set ID" := NewDimSetID;
              DimMgt.UpdateGlobalDimFromDimSetID(
                ServLine."Dimension Set ID", ServLine."Shortcut Dimension 1 Code", ServLine."Shortcut Dimension 2 Code");
              ServLine.MODIFY;
            END;
          UNTIL ServLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateDim(Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20];Type5: Integer;No5: Code[20];Type6: Integer;No6: Code[20];Type7: Integer;No7: Code[20];Type8: Integer;No8: Code[20];Type9: Integer;No9: Code[20])
    var
        SourceCodeSetup: Record "242";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        OldDimSetID: Integer;
    begin
        // Sipradi-YS GEN6.1.0 - 25006145-1 * Following Standard Code is commented to Override Retrieving of Dimension
        /*
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        TableID[6] := Type6;
        No[6] := No6;
        TableID[7] := Type7;
        No[7] := No7;
        TableID[8] := Type8;  //25.10.2013 EDMS P8
        No[8] := No8;
        // 10.03.2015 EDMS P21 >>
        TableID[9] := Type9;
        No[9] := No9;
        // 10.03.2015 EDMS P21 <<
        
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID,No,SourceCodeSetup."Service Management EDMS",
                             "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
        
        IF (OldDimSetID <> "Dimension Set ID") AND DmsServLinesExist THEN BEGIN
          MODIFY;
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
        */

    end;

    [Scope('Internal')]
    procedure RecreateDmsServLines(ChangedFieldName: Text[100])
    var
        ServLineTmp: Record "25006146" temporary;
        SIEAssgnt: Record "25006706";
        SIEAssgntTmp: Record "25006706" temporary;
        ReservationEntryTemp: Record "337" temporary;
    begin
        IF DmsServLinesExist THEN BEGIN
          Confirmed := ConfirmLoc(STRSUBSTNO(Text015 + Text004,ChangedFieldName), FALSE, '');
          IF Confirmed THEN BEGIN
        //    DocDim.LOCKTABLE;//26.01.2012 EDMS

            // 23.04.2015 EDMS P21 >>
            IF ("Currency Code" = xRec."Currency Code") AND NOT AlreadyConfirmed THEN  BEGIN
              SavePricesConfirmed := ConfirmLoc(Text135, FALSE, '');
              AlreadyConfirmed := TRUE;
            END;
            // 23.04.2015 EDMS P21 <<

            ServLine.LOCKTABLE;
            ReservEntry.LOCKTABLE;
            MODIFY;

            ServLine.RESET;
            ServLine.SETRANGE("Document Type","Document Type");
            ServLine.SETRANGE("Document No.","No.");
            IF ServLine.FINDSET(TRUE,FALSE) THEN BEGIN
              REPEAT
               ServLine.TESTFIELD("Prepmt. Amt. Inv.",0);
               ServLine."Bill-to Customer No.":="Bill-to Customer No.";
               ServLine."Contract No." := "Contract No.";                                  // 15.04.2014 Elva Baltic P21

               ServLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
               IF ServLine.Type <> ServLine.Type::" " THEN
                ServLine.VALIDATE("VAT Bus. Posting Group","VAT Bus. Posting Group");
               ServLine.MODIFY;
               ServLineTmp := ServLine;
               ServLineTmp.INSERT;
               CopyReservation(ServLine, ServLineTmp, ReservationEntryTemp, 1)
              UNTIL ServLine.NEXT = 0;

              SIEAssgnt.SETRANGE("Applies-to Type",DATABASE::"Service Line EDMS");
              SIEAssgnt.SETRANGE("Applies-to Doc. Type","Document Type");
              SIEAssgnt.SETRANGE("Applies-to Doc. No.","No.");
              IF SIEAssgnt.FINDFIRST THEN BEGIN
                REPEAT
                  SIEAssgntTmp.INIT;
                  SIEAssgntTmp := SIEAssgnt;
                  SIEAssgntTmp.INSERT
                UNTIL SIEAssgnt.NEXT=0;
                SIEAssgnt.DELETEALL;
              END;

              IF ServLine.FINDSET THEN BEGIN
                REPEAT
                  ServLine.SetRecreate(TRUE);
                  ServLine.DELETE(TRUE);
                UNTIL ServLine.NEXT = 0;
              END;
              ServLine.INIT;
              ServLine."Line No." := 0;
              ServLineTmp.FINDSET;
              REPEAT
                ServLine.INIT;  //06.03.2008. EDMS P2 delete condition "if "Package No." = '' "
                ServLine."Line No." := ServLineTmp."Line No.";
                ServLine.VALIDATE(Type,ServLineTmp.Type);
                IF ServLineTmp."No." = '' THEN BEGIN
                  ServLine.VALIDATE(Description,ServLineTmp.Description);
                  ServLine.VALIDATE("Description 2",ServLineTmp."Description 2");
                END ELSE BEGIN
                  ServLine."Standard Time" := ServLineTmp."Standard Time";
                  ServLine.VALIDATE("No.",ServLineTmp."No.");
                  IF ServLine.Type <> ServLine.Type::" " THEN BEGIN
                    ServLine.VALIDATE("Unit of Measure Code",ServLineTmp."Unit of Measure Code");
                    ServLine.VALIDATE("Variant Code",ServLineTmp."Variant Code");
                    ServLine."Standard Time" := ServLineTmp."Standard Time";
                    IF ServLineTmp.Quantity <> 0 THEN
                      ServLine.VALIDATE(Quantity,ServLineTmp.Quantity);
                    ServLine."Purchase Order No." := ServLineTmp."Purchase Order No.";
                    ServLine."Purch. Order Line No." := ServLineTmp."Purch. Order Line No.";
                    ServLine.Split := ServLineTmp.Split;
                    ServLine.Description := ServLineTmp.Description;
                    ServLine."Description 2" := ServLineTmp."Description 2";
                    ServLine."Drop Shipment" := ServLine."Purch. Order Line No." <> 0;

                    //06.03.2008. EDMS P2 >>
                    ServLine.Group := ServLineTmp.Group;
                    ServLine."Group ID" := ServLineTmp."Group ID";
                    ServLine.VIN := ServLineTmp.VIN;
                    ServLine."Package No." := ServLineTmp."Package No.";
                    ServLine."Package Version No." := ServLineTmp."Package Version No.";
                    ServLine."Package Version Spec. Line No." := ServLineTmp."Package Version Spec. Line No.";
                    ServLine.VALIDATE("Line Discount %",ServLineTmp."Line Discount %");
                    //06.03.2008. EDMS P2 <<
                    ServLine."Location Code" := ServLineTmp."Location Code";
                    ServLine.Status := ServLineTmp.Status;
                    ServLine."Variable Field 25006800" := ServLineTmp."Variable Field 25006800";
                    ServLine."Variable Field 25006801" := ServLineTmp."Variable Field 25006801";
                    ServLine."Variable Field 25006802" := ServLineTmp."Variable Field 25006802";
                    //2012.03.14 EDMS P8 >>
                    ServLine."Tire Operation Type" := ServLineTmp."Tire Operation Type";
                    ServLine."Vehicle Axle Code" := ServLineTmp."Vehicle Axle Code";
                    ServLine."Tire Position Code" := ServLineTmp."Tire Position Code";
                    ServLine."Tire Code" := ServLineTmp."Tire Code";
                    ServLine."New Vehicle Axle Code" := ServLineTmp."New Vehicle Axle Code";
                    ServLine."New Tire Position Code" := ServLineTmp."New Tire Position Code";
                    //2012.03.14 EDMS P8 <<

                    ServLine."External Serv. Tracking No." := ServLineTmp."External Serv. Tracking No.";

                    // 10.04.2014 Elva Baltic P21 >>
                    IF SavePricesConfirmed THEN BEGIN
                      ServLine.VALIDATE("Unit Price", ServLineTmp."Unit Price");
                      ServLine.VALIDATE("Line Discount %", ServLineTmp."Line Discount %");
                    END;
                    // 10.04.2014 Elva Baltic P21 <<
                  END;
                END;
                ServLine.INSERT;
                ServiceScheduleMgt.ResourcesCopyLineToLine(ServLineTmp."Document Type", ServLineTmp."Document No.",
                  ServLineTmp.Type, ServLineTmp."Line No.",
                  ServLine."Document Type", ServLine."Document No.", ServLine."Line No.");
                CopyReservation(ServLine, ServLineTmp, ReservationEntryTemp, 2)
              UNTIL ServLineTmp.NEXT = 0;

              IF ServLineTmp.FINDFIRST THEN
              REPEAT
                SIEAssgntTmp.SETRANGE("Applies-to Doc. Line No.",ServLineTmp."Line No.");
                IF SIEAssgntTmp.FINDFIRST THEN
                 REPEAT
                   SIEAssgnt.INIT;
                   SIEAssgnt := SIEAssgntTmp;
                   SIEAssgnt.INSERT;
                 UNTIL SIEAssgntTmp.NEXT = 0;
              UNTIL ServLineTmp.NEXT = 0;

              // 16.03.2015 EDMS P21 >>
              IF SavePricesConfirmed AND ("Prices Including VAT" <> xRec."Prices Including VAT")
                 AND NOT PricesInclVATValidated
              THEN BEGIN
                VALIDATE("Prices Including VAT");
                PricesInclVATValidated := TRUE;
              END;
              // 16.03.2015 EDMS P21 <<
            END;
          END ELSE
            ERROR(
              Text017,ChangedFieldName);
        END
    end;

    [Scope('Internal')]
    procedure InsertServPackage()
    var
        SPVersion: Record "25006135";
    begin
        SPVersion.FILTERGROUP(2);

        InsertLookupSPVersion(SPVersion);
    end;

    [Scope('Internal')]
    procedure InsertServPackageRecall()
    var
        RecallCampaignVehicle: Record "25006172";
        ServicePackage: Record "25006134";
        SPVersion: Record "25006135";
        RecallsNoFilter: Text[250];
        PackageNoFilter: Text[250];
        Text001: Label 'No records to list.';
    begin
        RecallCampaignVehicle.RESET;
        RecallCampaignVehicle.SETRANGE(VIN, VIN);
        RecallCampaignVehicle.SETRANGE(Serviced,FALSE);
        RecallCampaignVehicle.SETRANGE("Active Campaign",TRUE);
        RecallCampaignVehicle.FINDFIRST;

        REPEAT
          RecallsNoFilter += ''''+RecallCampaignVehicle."Campaign No."+'''|'
        UNTIL RecallCampaignVehicle.NEXT = 0;
        RecallsNoFilter := COPYSTR(RecallsNoFilter, 1, STRLEN(RecallsNoFilter)-1);
        ServicePackage.SETCURRENTKEY("Recall Campaign No.");
        ServicePackage.SETFILTER("Recall Campaign No.", RecallsNoFilter);
        IF NOT ServicePackage.FINDFIRST THEN
          ERROR(Text001);
        REPEAT
          PackageNoFilter += ''''+ ServicePackage."No." +'''|'
        UNTIL ServicePackage.NEXT = 0;
        PackageNoFilter := COPYSTR(PackageNoFilter, 1, STRLEN(PackageNoFilter)-1);
        SPVersion.FILTERGROUP(2);
        SPVersion.SETFILTER("Package No.", PackageNoFilter);

        InsertLookupSPVersion(SPVersion);
    end;

    [Scope('Internal')]
    procedure InsertServPackageByRecallNo(RecallCampaignVehicleNo: Code[20])
    var
        ServicePackage: Record "25006134";
        SPVersion: Record "25006135";
        RecallsNoFilter: Text[250];
        PackageNoFilter: Text[250];
        Text001: Label 'No records to list.';
    begin
        ServicePackage.SETCURRENTKEY("Recall Campaign No.");
        ServicePackage.SETRANGE("Recall Campaign No.", RecallCampaignVehicleNo);
        IF NOT ServicePackage.FINDFIRST THEN
          EXIT;
        REPEAT
          PackageNoFilter += ''''+ ServicePackage."No." +'''|'
        UNTIL ServicePackage.NEXT = 0;
        PackageNoFilter := COPYSTR(PackageNoFilter, 1, STRLEN(PackageNoFilter)-1);
        SPVersion.SETFILTER("Package No.", PackageNoFilter);

        InsertLookupSPVersion(SPVersion);
    end;

    [Scope('Internal')]
    procedure InsertLookupSPVersion(var SPVersion: Record "25006135")
    var
        SPVersionSpec: Record "25006136";
        ServLine: Record "25006146";
        ServicePackage: Record "25006134";
        LastLineNo: Integer;
        Text001: Label 'No records to list.';
        ServicePackageVersionSelect: Page "25006164";
    begin
        SPVersionAssignFilter(SPVersion);
        IF SPVersion.FINDFIRST THEN;
        IF SPVersion.COUNT > 1 THEN BEGIN
          ServicePackageVersionSelect.SETTABLEVIEW(SPVersion);
          ServicePackageVersionSelect.LOOKUPMODE(TRUE);
          //IF NOT (ServicePackageVersionSelect.RUNMODAL = ACTION::LookupOK) THEN
          IF NOT (PAGE.RUNMODAL(PAGE::"Service Package Version-Select", SPVersion) = ACTION::LookupOK) THEN
            EXIT;
        END;
        InsertSPVersion(SPVersion);
    end;

    [Scope('Internal')]
    procedure InsertSPVersion(var SPVersion: Record "25006135")
    var
        SPVersionSpec: Record "25006136";
        ServLine: Record "25006146";
        ServicePackage: Record "25006134";
        Text001: Label 'No records to list.';
    begin
        IF SPVersion."Package No." <> '' THEN BEGIN
          ServicePackage.GET(SPVersion."Package No.");
          IF ServicePackage.Blocked THEN
            ERROR(STRSUBSTNO(Text124, SPVersion."Package No."));

          WITH SPVersionSpec DO BEGIN
            RESET;
            SETRANGE("Package No.",SPVersion."Package No.");
            SETRANGE("Version No.",SPVersion."Version No.");
            IF FINDSET THEN BEGIN
              REPEAT
                SPVersionSpec.SetCurrPlanStage(VehicleServicePlanStageTmp_CS);
                SPVersionSpec.CreateServLine("Document Type",Rec."No.");
              UNTIL NEXT = 0;
              Rec."Package No." := SPVersion."Package No.";
            END ELSE BEGIN
              ERROR(Text134, SPVersion.TABLECAPTION, SPVersion."Version No.");
            END;
          END
        END ELSE
          ERROR(Text133, SPVersion.TABLECAPTION);
    end;

    [Scope('Internal')]
    procedure InsertServPackagePlaned()
    var
        VehicleServicePlan: Record "25006126";
        VehicleServicePlanStage: Record "25006132";
        ServicePackage: Record "25006134";
        SPVersion: Record "25006135";
        Text001: Label 'No records to list.';
    begin
        CLEAR(VehicleServicePlanStageTmp_CS);
        VehicleServicePlan.RESET;
        VehicleServicePlan.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleServicePlan.SETRANGE(Active, TRUE);
        IF NOT VehicleServicePlan.FINDFIRST THEN
          ERROR(Text001)
        ELSE
        IF VehicleServicePlan.COUNT > 1 THEN BEGIN
          IF PAGE.RUNMODAL(PAGE::"Vehicle Service Plans", VehicleServicePlan) = ACTION::LookupOK THEN
            VehicleServicePlan.SETRANGE("No.", VehicleServicePlan."No.")
          ELSE
            VehicleServicePlan.SETRANGE("No.", '0');  // IT should not record within such filter by NO
        END;
        IF VehicleServicePlan.FINDFIRST THEN BEGIN
          VehicleServicePlanStage.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
          VehicleServicePlanStage.SETRANGE("Plan No.", VehicleServicePlan."No.");
          VehicleServicePlanStage.SETRANGE(Status, VehicleServicePlanStage.Status::Pending);
          IF VehicleServicePlanStage.FINDFIRST THEN BEGIN
            VehicleServicePlanStageTmp_CS := VehicleServicePlanStage;
            IF ServicePackage.GET(VehicleServicePlanStage."Package No.") THEN BEGIN
              SPVersion.SETRANGE("Package No.", ServicePackage."No.");
              InsertLookupSPVersion(SPVersion);
            END ELSE
              ERROR(Text001)
          END;
        END ELSE
          ERROR(Text001)
    end;

    [Scope('Internal')]
    procedure PriceErrorIfServLinesExist(ChangedFieldName: Text[100];FilledTableNr: Integer)
    var
        RecRF: RecordRef;
    begin
        RecRF.OPEN(FilledTableNr);
        IF DmsServLinesExist AND NOT HideValidationDialog THEN
          ERROR(Text028,ChangedFieldName,RecRF.CAPTION);
    end;

    local procedure TestNoSeriesDate(No: Code[20];NoSeriesCode: Code[10];NoCapt: Text[1024];NoSeriesCapt: Text[1024])
    var
        NoSeries: Record "308";
    begin
        IF (No <> '') AND (NoSeriesCode <> '') THEN BEGIN
          NoSeries.GET(NoSeriesCode);
          IF NoSeries."Date Order" THEN
            ERROR(
              Text045,
              FIELDCAPTION("Posting Date"),NoSeriesCapt,NoSeriesCode,
              NoSeries.FIELDCAPTION("Date Order"),NoSeries."Date Order","Document Type",
              NoCapt,No);
        END;
    end;

    [Scope('Internal')]
    procedure ShowSIEAssgnt()
    var
        SIEAssgnt: Record "25006706";
        SIEAssgntsForm: Page "25006757";
    begin
        GET("Document Type","No.");
        TESTFIELD("No.");

        CLEAR(SIEAssgnt);
        WITH SIEAssgnt DO BEGIN
          RESET;
          SETRANGE("Applies-to Type",DATABASE::"Service Line EDMS");
          SETRANGE("Applies-to Doc. Type","Document Type");
          SETRANGE("Applies-to Doc. No.","No.");
          IF NOT FINDLAST THEN BEGIN
            SIEAssgnt."Applies-to Type" := DATABASE::"Service Line EDMS";
            SIEAssgnt."Applies-to Doc. Type" := "Document Type";
            SIEAssgnt."Applies-to Doc. No." := "No.";
          END;
          SIEAssgnt."Applies-to Doc. Line No." := 0;
        END;

        SIEAssgntsForm.Initialize(SIEAssgnt);
        SIEAssgntsForm.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure InvoiceExist(): Boolean
    var
        SalesHeader: Record "36";
    begin
        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Service Document No.");
        SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Invoice);
        SalesHeader.SETRANGE("Service Document No.","No.");
        IF SalesHeader.FINDFIRST THEN
         EXIT(TRUE)
    end;

    [Scope('Internal')]
    procedure GetVFCaption(intFieldNo: Integer): Text[30]
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.GetVFCaption(DATABASE::"Service Header EDMS",intFieldNo,"Make Code"));
    end;

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Service Header EDMS",intFieldNo));
    end;

    [Scope('Internal')]
    procedure TestVFRun1()
    var
        ServOrdInfoPaneMgt: Codeunit "25006104";
    begin
        //14.09.2007. P2 >>
        IF Kilometrage > 0 THEN BEGIN
          IF Kilometrage < ServOrdInfoPaneMgt.CalcLastVisitVFRun1("Vehicle Serial No.") THEN
            ERROR(EDMS001);
          TestVFRun1ForComponent;
        END;
        //14.09.2007. P2 <<
    end;

    [Scope('Internal')]
    procedure TestVFRun2()
    var
        ServOrdInfoPaneMgt: Codeunit "25006104";
    begin
        /*IF "Variable Field Run 2" > 0 THEN BEGIN
          IF "Variable Field Run 2" < ServOrdInfoPaneMgt.CalcLastVisitVFRun2("Vehicle Serial No.") THEN
            MessageLoc(STRSUBSTNO(EDMS001, AppMgt.CaptionClassTranslate(GLOBALLANGUAGE,'7,25006145,25006255')), '');
          TestVFRun1ForComponent;
        END;*/ // Commented by Bishesh Jimba 9 Aug 24

    end;

    [Scope('Internal')]
    procedure TestVFRun3()
    var
        ServOrdInfoPaneMgt: Codeunit "25006104";
    begin
        /*IF "Variable Field Run 3" > 0 THEN BEGIN
          IF "Variable Field Run 3" < ServOrdInfoPaneMgt.CalcLastVisitVFRun3("Vehicle Serial No.") THEN
            MessageLoc(STRSUBSTNO(EDMS001, AppMgt.CaptionClassTranslate(GLOBALLANGUAGE,'7,25006145,25006260')), '');
          TestVFRun1ForComponent;
        END;*/ // Commented by Bishesh Jimba 9 Aug 24

    end;

    [Scope('Internal')]
    procedure TestVFRun1ForComponent()
    var
        VehicleServicePlanStage: Record "25006132";
        ServOrdInfoPaneMgt: Codeunit "25006104";
        CompPendingPlanExists: Boolean;
    begin
        // for now do not check actual value
        ServiceSetup.GET;
        IF ServiceSetup."Notify About Components" THEN
          IF NOT (("Document Type" = LastModifiedRec."Document Type") AND ("No." = LastModifiedRec."No.")) THEN
            AboutComponentsNotified := FALSE;
          LastModifiedRec := Rec;
          IF NOT AboutComponentsNotified THEN BEGIN
            VehicleComponent.RESET;
            VehicleComponent.SETRANGE("Parent Vehicle Serial No.", "Vehicle Serial No.");
            IF VehicleComponent.FINDFIRST THEN
              REPEAT
                VehicleServicePlanStage.RESET;
                VehicleServicePlanStage.SETCURRENTKEY(Status,"Expected Service Date");
                VehicleServicePlanStage.SETRANGE(Status, VehicleServicePlanStage.Status::Pending);
                VehicleServicePlanStage.SETRANGE("Vehicle Serial No.", VehicleComponent."No.");
                CompPendingPlanExists := VehicleServicePlanStage.FINDFIRST;
              UNTIL ((VehicleComponent.NEXT = 0) OR CompPendingPlanExists);
              IF CompPendingPlanExists THEN BEGIN
                MessageLoc(Text132, '');
                AboutComponentsNotified := TRUE;
              END;
          END;
    end;

    [Scope('Internal')]
    procedure CheckVehicleCreated(Prompt: Boolean): Boolean
    var
        Vehicle: Record "25006005";
    begin
        IF ("Vehicle Serial No." <> '') THEN
          EXIT(TRUE);

        IF Prompt THEN BEGIN
          Confirmed := ConfirmLoc(Text122,TRUE, '');
          IF NOT Confirmed THEN
            EXIT(FALSE);
        END;

        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        TESTFIELD(VIN);

        Vehicle.RESET;
        Vehicle."Serial No." := '';
        Vehicle.INSERT(TRUE);
        Vehicle.VALIDATE(VIN, VIN);
        Vehicle.VALIDATE("Make Code", "Make Code");
        Vehicle.VALIDATE("Model Code", "Model Code");
        IF "Model Version No." <> '' THEN
          Vehicle.VALIDATE("Model Version No.", "Model Version No.");
        IF "Vehicle Registration No." <> '' THEN
          Vehicle.VALIDATE("Registration No.", "Vehicle Registration No.");
        IF "Vehicle Status Code" <> '' THEN
          Vehicle.VALIDATE("Status Code", "Vehicle Status Code");
        Vehicle.MODIFY(TRUE);

        // "Vehicle Serial No." := Vehicle."Serial No.";         // 16.03.2015 EDMS P21
        VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");    // 16.03.2015 EDMS P21

        EXIT("Vehicle Serial No." <> '');
    end;

    [Scope('Internal')]
    procedure CheckContactCreated(Prompt: Boolean): Boolean
    var
        Contact: Record "25006005";
    begin
        IF ("Sell-to Contact No." <> '') THEN
          EXIT(TRUE);
        IF ("Sell-to Customer No." <> '') THEN
          EXIT(TRUE);

        IF Prompt THEN BEGIN
          Confirmed := ConfirmLoc(Text123,TRUE, '');
          IF NOT Confirmed THEN
            EXIT(FALSE);
        END;
        EXIT(CreateContactFromServHeader);
    end;

    [Scope('Internal')]
    procedure CreateContactFromServHeader(): Boolean
    var
        Cont: Record "5050";
    begin
        Cont.INIT;

        Cont.VALIDATE(Name,"Sell-to Customer Name");
        Cont.VALIDATE("Name 2","Sell-to Customer Name 2");
        Cont.VALIDATE(Address,"Sell-to Address");
        Cont.VALIDATE("Address 2","Sell-to Address 2");
        Cont.VALIDATE(City,"Sell-to City");
        Cont.VALIDATE("Post Code","Sell-to Post Code");

        Cont."No." := '';
        Cont.SetSkipDefault; //Upgrade 2017
        Cont.INSERT(TRUE);
        VALIDATE("Sell-to Contact No.",Cont."No.");
        MODIFY(TRUE);
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure CheckRecallCampaigns(VehSerialNo: Code[20])
    var
        Vehicle: Record "25006005";
        RecallCampaignVeh: Record "25006172";
    begin
        Vehicle.RESET;
        IF NOT Vehicle.GET(VehSerialNo) THEN
         EXIT;

        ServiceSetup.GET;
        IF NOT ServiceSetup."Recall Campaign Warnings" THEN
         EXIT;

        RecallCampaignVeh.RESET;
        RecallCampaignVeh.SETRANGE(VIN,Vehicle.VIN);
        IF RecallCampaignVeh.FINDFIRST THEN
         REPEAT
          RecallCampaignVeh.CALCFIELDS("Active Campaign");
          IF (RecallCampaignVeh."Active Campaign") AND NOT RecallCampaignVeh.Serviced THEN
            MessageLoc(STRSUBSTNO(Text130,Vehicle.VIN), '');
         UNTIL RecallCampaignVeh.NEXT = 0;
    end;

    [Scope('Internal')]
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

    [Scope('Internal')]
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

    [Scope('Internal')]
    procedure SetAmountToApply(AppliesToDocNo: Code[20];CustomerNo: Code[20])
    var
        CustLedgEntry: Record "21";
    begin
        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETRANGE("Document No.",AppliesToDocNo);
        CustLedgEntry.SETRANGE("Customer No.",CustomerNo);
        CustLedgEntry.SETRANGE(Open,TRUE);
        IF CustLedgEntry.FINDFIRST THEN BEGIN
          IF CustLedgEntry."Amount to Apply" = 0 THEN  BEGIN
            CustLedgEntry.CALCFIELDS("Remaining Amount");
            CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
          END ELSE
            CustLedgEntry."Amount to Apply" := 0;
          CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
        END;
    end;

    [Scope('Internal')]
    procedure CheckServicePlan(FieldPar: Integer)
    var
        VehicleServicePlanStage: Record "25006132";
        PlanDateFormula: Code[20];
    begin
        IF "Vehicle Serial No." = '' THEN
          EXIT;
        ServiceSetup.GET;

        IF NOT ServiceSetup."Service Plan Notification" THEN
          EXIT;

        IF IsAchievedServPlanStageByField(FieldPar, VehicleServicePlanStage) THEN
          MessageLoc(STRSUBSTNO(Text102, VehicleServicePlanStage."Plan No."), '');
    end;

    [Scope('Internal')]
    procedure IsAchievedServPlanStageByField(FieldPar: Integer;var VehicleServicePlanStage: Record "25006132"): Boolean
    var
        VehicleServicePlan: Record "25006126";
        PlanDateFormula: Code[20];
        MakeCheck: Boolean;
    begin
        ServiceSetup.GET;
        
        VehicleServicePlanStage.RESET;
        VehicleServicePlanStage.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleServicePlanStage.SETRANGE(Status, VehicleServicePlanStage.Status::Pending);
        
        CASE FieldPar OF
          FIELDNO(Kilometrage):
            BEGIN
              IF (Kilometrage = 0) THEN
                EXIT(FALSE);
              VehicleServicePlanStage.SETRANGE(Kilometrage, 0,
                                               Kilometrage + ServiceSetup."Notify Before (Kilometrage)");
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage.Kilometrage = 0) THEN
                  EXIT(FALSE);
            END;
          /*FIELDNO("Variable Field Run 2"):
            BEGIN
              IF ("Variable Field Run 2" = 0) THEN
                EXIT(FALSE);
              VehicleServicePlanStage.SETRANGE("Variable Field Run 2", 0.0000000001,
                                               "Variable Field Run 2" + ServiceSetup."Notify Before (VF Run 2)");
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Variable Field Run 2" = 0) THEN
                  EXIT(FALSE);
            END;
          FIELDNO("Variable Field Run 3"):
            BEGIN
              IF ("Variable Field Run 3" = 0) THEN
                EXIT(FALSE);
              VehicleServicePlanStage.SETRANGE("Variable Field Run 3", 0.0000000001,
                                               "Variable Field Run 3" + ServiceSetup."Notify Before (VF Run 3)");
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Variable Field Run 3" = 0) THEN
                  EXIT(FALSE);
            END;*/// commented by Bishesh Jimba 9 Aug 24
          FIELDNO("Order Date"):
            BEGIN
              IF ("Order Date" = 0D) THEN
                EXIT(FALSE);
              //08.05.2013 EDMS P8 >>
              EXIT(IsAchievedServStageByInterval(VehicleServicePlanStage));
              //08.05.2013 EDMS P8 <<
              /*
              PlanDateFormula := '-' +FORMAT(ServiceSetup."Notify Before (Date Formula)");
              VehicleServicePlanStage.SETRANGE("Expected Service Date",
                                               010101D,
                                               CALCDATE(ServiceSetup."Notify Before (Date Formula)","Order Date"));
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Expected Service Date" = 0D) THEN
                  EXIT(FALSE);
              */
            END;
        END;
        EXIT(VehicleServicePlanStage.FINDFIRST);

    end;

    [Scope('Internal')]
    procedure IsAchievedServStageByInterval(var VehicleServicePlanStage: Record "25006132"): Boolean
    var
        VehicleServicePlan: Record "25006126";
        ServicePlanManagement: Codeunit "25006103";
        PlanDateFormula: Code[20];
        LastServiceDate: Date;
        NotifyBorderDate: Date;
        ExpectedServiceDate: Date;
        MakeCheck: Boolean;
    begin
        ServiceSetup.GET;

        VehicleServicePlanStage.RESET;
        VehicleServicePlanStage.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleServicePlanStage.SETRANGE(Status, VehicleServicePlanStage.Status::Pending);
        NotifyBorderDate := CALCDATE(ServiceSetup."Notify Before (Date Formula)","Order Date");
        IF VehicleServicePlanStage.FINDFIRST THEN
          REPEAT
            //08.05.2013 EDMS P8 >>
            VehicleServicePlan.GET("Vehicle Serial No.", VehicleServicePlanStage."Plan No.");
            MakeCheck := FALSE;
            IF VehicleServicePlan."Auto Order By Exp. Date" THEN
              MakeCheck := TRUE
            ELSE
              IF FORMAT(VehicleServicePlanStage."Service Interval") <> '' THEN
                MakeCheck := TRUE;
            //08.05.2013 EDMS P8 <<
            IF MakeCheck THEN BEGIN
              ExpectedServiceDate := ServicePlanManagement.GetExpectedDateByIntervalGlob("Vehicle Serial No.",
                VehicleServicePlanStage."Plan No.", VehicleServicePlanStage);
              IF ((ExpectedServiceDate <= NotifyBorderDate) AND (ExpectedServiceDate > 0D)) THEN
                VehicleServicePlanStage.MARK(TRUE);
            END;
          UNTIL VehicleServicePlanStage.NEXT = 0;
          VehicleServicePlanStage.MARKEDONLY(TRUE);
        EXIT(VehicleServicePlanStage.FINDFIRST);
    end;

    [Scope('Internal')]
    procedure UpdateVehicleContact()
    var
        VehicleContact: Record "25006013";
    begin
        ServiceSetup.GET;
        IF NOT ServiceSetup."Offer Link Vehicle and Contact" THEN
          EXIT;

        IF "Sell-to Contact No." = '' THEN
          EXIT;

        VehicleContact.RESET;
        VehicleContact.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        IF VehicleContact.COUNT > 0 THEN
          EXIT;

        Confirmed := ConfirmLoc(STRSUBSTNO(Text125, "Sell-to Contact No."), FALSE, '');
        IF NOT Confirmed THEN
          EXIT;

        VehicleContact.INIT;
        VehicleContact.VALIDATE("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleContact.VALIDATE("Relationship Code", ServiceSetup."Link Relationship Code");
        VehicleContact.VALIDATE("Contact No.", "Sell-to Contact No.");
        VehicleContact.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure CopyReservation(var ServiceLine: Record "25006146";var ServiceLineTemp: Record "25006146";var ReservationEntryTemp: Record "337";CopyWay: Integer)
    var
        ReservationEntry: Record "337";
        ReservationEntry2: Record "337";
        ReservationEntryTemp2: Record "337" temporary;
    begin
        IF CopyWay = 1 THEN BEGIN
          ReservationEntry.RESET;
          ReservationEntry.SETCURRENTKEY("Source ID");
          ReservationEntry.SETRANGE("Source ID", ServiceLine."Document No.");
          ReservationEntry.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
          ReservationEntry.SETRANGE("Source Subtype", ServiceLine."Document Type");
          ReservationEntry.SETRANGE("Source Ref. No.", ServiceLine."Line No.");
          IF ReservationEntry.FINDFIRST THEN
            REPEAT
              ReservationEntryTemp := ReservationEntry;
              ReservationEntryTemp.INSERT;
              IF ReservationEntry2.GET(ReservationEntry."Entry No.", NOT ReservationEntry.Positive) THEN BEGIN
                ReservationEntryTemp := ReservationEntry2;
                ReservationEntryTemp.INSERT;
              END;
            UNTIL ReservationEntry.NEXT = 0;
        END;

        IF CopyWay = 2 THEN BEGIN
          ReservationEntryTemp.RESET;
          ReservationEntryTemp.SETCURRENTKEY("Source ID");
          ReservationEntryTemp.SETRANGE("Source ID", ServiceLineTemp."Document No.");
          ReservationEntryTemp.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
          ReservationEntryTemp.SETRANGE("Source Subtype", ServiceLineTemp."Document Type");
          ReservationEntryTemp.SETRANGE("Source Ref. No.", ServiceLineTemp."Line No.");
          ReservationEntryTemp.SETRANGE("Reservation Status", ReservationEntryTemp."Reservation Status"::Reservation);
          IF ReservationEntryTemp.FINDFIRST THEN
            REPEAT
              ReservationEntry := ReservationEntryTemp;
              ReservationEntry."Source Ref. No." := ServiceLine."Line No.";
              ReservationEntry.INSERT;
              ReservationEntryTemp2 := ReservationEntryTemp;
              ReservationEntryTemp2.INSERT;
            UNTIL ReservationEntryTemp.NEXT = 0;
          IF ReservationEntryTemp2.FINDFIRST THEN
            REPEAT
              IF ReservationEntryTemp.GET(ReservationEntryTemp2."Entry No.", NOT ReservationEntryTemp2.Positive) THEN BEGIN
                ReservationEntry := ReservationEntryTemp;
                ReservationEntry.INSERT;
              END;
            UNTIL ReservationEntryTemp2.NEXT = 0;
         END;
    end;

    [Scope('Internal')]
    procedure SetNotFindVehicle()
    begin
        FindCustomer := TRUE;
        FindVehicle := TRUE;
    end;

    [Scope('Internal')]
    procedure SPVersionAssignFilter(var ServicePackageVersionPar: Record "25006135")
    var
        Vehicle: Record "25006005";
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        FieldRef1: FieldRef;
        FieldRef2: FieldRef;
        VFUsage1: Record "25006006";
        VFUsage2: Record "25006006";
        VariableField: Record "25006002";
    begin
        // filter standard fields
        ServicePackageVersionPar.SETFILTER("Make Code", '''''|%1', "Make Code");
        ServicePackageVersionPar.SETFILTER("Model Code", '''''|%1', "Model Code");
        IF NOT Vehicle.GET("Vehicle Serial No.") THEN
          EXIT;
        ServicePackageVersionPar.SETFILTER("Prod. Year From",'..%1', Vehicle."Production Year");
        ServicePackageVersionPar.SETFILTER("Prod. Year To",'''''|%1..',Vehicle."Production Year");
        VFMgt.AssignFilterSPVerToVeh(Vehicle, ServicePackageVersionPar);
    end;

    [Scope('Internal')]
    procedure OnLookupVehicleRegistrationNo()
    begin
        IF "Vehicle Registration No." <> '' THEN BEGIN
          Vehicle.RESET;
          Vehicle.SETCURRENTKEY("Registration No.");
          Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
          IF Vehicle.FINDFIRST THEN;
          Vehicle.SETRANGE("Registration No.");
        END;

        IF LookUpMgt.LookUpVehicleAMT(Vehicle,'') THEN
         VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
    end;

    [Scope('Internal')]
    procedure OnLookupVIN()
    var
        Vehicle: Record "25006005";
    begin
        IF LookUpMgt.LookUpVehicleAMT(Vehicle,'') THEN
          VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");
    end;

    [Scope('Internal')]
    procedure SetCurrPlanStage(VehicleServicePlanStagePar: Record "25006132")
    begin
        VehicleServicePlanStageTmp_CS := VehicleServicePlanStagePar;
    end;

    [Scope('Internal')]
    procedure CreateServHeader(DocType: Integer;OrderDate: Date;PlannedServiceDate: Date;HeaderDescription: Text[250];SelltoCustomerNo: Code[20];BilltoCustomerNo: Code[20];VehicleSerialNo: Code[20])
    begin
        INIT;
        SetHideValidationDialog(TRUE);
        SetNotFindVehicle;
        VALIDATE("Document Type", DocType);
        INSERT(TRUE);
        VALIDATE(Description, HeaderDescription);
        SetDatesSchema1(OrderDate, PlannedServiceDate, PlannedServiceDate, PlannedServiceDate);
        SetSkipVehicleChoose(TRUE);
        VALIDATE("Sell-to Customer No.", SelltoCustomerNo);
        VALIDATE("Bill-to Customer No.", BilltoCustomerNo);
        VALIDATE("Vehicle Serial No.", VehicleSerialNo);
        MODIFY(TRUE);
    end;

    [Scope('Internal')]
    procedure InsertServPlanDocLink(VehicleServicePlanStage: Record "25006132")
    var
        ServPlanDocumentLink: Record "25006157";
        LineNo: Integer;
    begin
        WITH VehicleServicePlanStage DO BEGIN
          ServPlanDocumentLink.RESET;
          ServPlanDocumentLink.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
          ServPlanDocumentLink.SETRANGE("Serv. Plan No.", "Plan No.");
          ServPlanDocumentLink.SETRANGE("Plan Stage Recurrence", Recurrence);
          ServPlanDocumentLink.SETRANGE("Serv. Plan Stage Code", Code);
          IF ServPlanDocumentLink.FINDLAST THEN
            LineNo := ServPlanDocumentLink."Line No." + 10000
          ELSE
            LineNo := 10000;

          ServPlanDocumentLink.INIT;
          ServPlanDocumentLink.VALIDATE("Vehicle Serial No.", "Vehicle Serial No.");
          ServPlanDocumentLink.VALIDATE("Serv. Plan No.", "Plan No.");
          ServPlanDocumentLink.VALIDATE("Plan Stage Recurrence", Recurrence);
          ServPlanDocumentLink.VALIDATE("Serv. Plan Stage Code", Code);
          ServPlanDocumentLink."Line No." := LineNo;
          ServPlanDocumentLink.INSERT(TRUE);
          CASE "Document Type" OF
            "Document Type"::Order:
              ServPlanDocumentLink.VALIDATE("Document Type", ServPlanDocumentLink."Document Type"::Order);
            "Document Type"::"Return Order":
              ServPlanDocumentLink.VALIDATE("Document Type", ServPlanDocumentLink."Document Type"::"Return Order");
            ELSE
              ServPlanDocumentLink.VALIDATE("Document Type", ServPlanDocumentLink."Document Type"::Quote);
          END;
          ServPlanDocumentLink.VALIDATE("Document No.", "No.");
          ServPlanDocumentLink.MODIFY(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure ConfirmLoc(MessageTxt: Text[1024];ActiveButton: Boolean;RunParStr: Text[1024]): Boolean
    begin
        // RunParStr not used for now
        IF HideValidationDialog THEN
          EXIT(TRUE)
        ELSE
          EXIT(CONFIRM(MessageTxt,ActiveButton));
    end;

    [Scope('Internal')]
    procedure MessageLoc(MessageTxt: Text[1024];RunParStr: Text[1024])
    begin
        // RunParStr not used for now
        IF NOT HideValidationDialog THEN
          MESSAGE(MessageTxt);
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
        //DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        IF "No." <> '' THEN
          MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          MODIFY;
          IF ServiceLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;

        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;

    [Scope('Internal')]
    procedure SetDatesSchema1(OrderDate: Date;PlanDate: Date;Date3: Date;Date4: Date)
    begin
        // it supposed to be used as default - schema agreed for Sitra case
        // "Document Date" is used as actual service date
        IF OrderDate = 0D THEN
          OrderDate := WORKDATE;
        IF PlanDate = 0D THEN
          PlanDate := WORKDATE;
        VALIDATE("Order Date", OrderDate);
        VALIDATE("Planned Service Date", PlanDate);
        IF PlanDate < WORKDATE THEN
          VALIDATE("Document Date", WORKDATE)
        ELSE
          VALIDATE("Document Date", PlanDate);
    end;

    [Scope('Internal')]
    procedure "--SERVICE RESOURCES--"()
    begin
    end;

    [Scope('Internal')]
    procedure SetResourceTextFieldValue(TextValue: Text[250])
    begin
        IF NOT ResourceTextFieldModified THEN
          ResourceTextFieldModified := (ResourceTextFieldValue <> TextValue);
        ResourceTextFieldValue := TextValue;
        SaveRelatedResourcesToDB(0);
    end;

    [Scope('Internal')]
    procedure GetResourceTextFieldValue(): Text[250]
    begin
        IF (ServicePrevParcedRsc."Document Type" <> "Document Type") OR
            (ServicePrevParcedRsc."No." <> "No.") THEN BEGIN
          ResourceTextFieldModified := FALSE;
          ServicePrevParcedRsc.TRANSFERFIELDS(Rec);
          ResourceTextFieldValue := GetRelatedResourcesFromDB(0);
        END;
        EXIT(ResourceTextFieldValue);
    end;

    [Scope('Internal')]
    procedure GetRelatedResourcesFromDB(RunMode: Integer) RetValue: Text[250]
    var
        ServLaborApplication: Record "25006277";
        ServiceLine: Record "25006146";
        isItDocAllocation: Boolean;
        StatusArray: array [10] of Integer;
        isTempTableUse: Boolean;
    begin
        RetValue := '';
        ServLaborApplicationGlobTmp.RESET;
        ServLaborApplicationGlobTmp.DELETEALL;
        ServLaborApplication.RESET;
        ServLaborApplication.SETRANGE("Document Type", "Document Type");
        ServLaborApplication.SETRANGE("Document No.", "No.");
        ServLaborApplication.SETRANGE("Document Line No.", 0);
        IF ServLaborApplication.FINDFIRST THEN BEGIN
          REPEAT
            ServLaborApplicationGlobTmp.SETRANGE("Resource No.", ServLaborApplication."Resource No.");
            IF NOT ServLaborApplicationGlobTmp.FINDLAST THEN BEGIN
              IF (STRLEN(RetValue)+ STRLEN(ServLaborApplication."Resource No."+',') <= MAXSTRLEN(RetValue)) THEN
                RetValue += ServLaborApplication."Resource No."+',';
              ServLaborApplicationGlobTmp.INIT;
              ServLaborApplicationGlobTmp.TRANSFERFIELDS(ServLaborApplication);
              ServLaborApplicationGlobTmp.INSERT;
            END;
          UNTIL ServLaborApplication.NEXT = 0;
          IF STRLEN(RetValue) > 1 THEN
            RetValue := COPYSTR(RetValue, 1, STRLEN(RetValue)-1);
        END;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure SetRelatedResources(RecourcesTextSource: Text[250];RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "25006277";
        Posit: Integer;
        ServiceSetup: Record "25006120";
        ResourceToAdd: Text[30];
        Resource: Record "156";
        RecourcesText: Text[250];
        RecourcesTextToModify: Text[250];
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "25006146";
        StatusArray: array [10] of Integer;
        LineNo: Integer;
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        // THAT FUNCTION SAVE IT ONLY INTO TEMPORARY TABLE
        // for now it stores only resources uniquely (one certain resource - one line)
        ServiceSetup.GET;
        AdjustFlagsToArray(RunMode, StatusArray);
        isItAllowedMessage := (StatusArray[1] = 1);
        isItDocAllocation := (StatusArray[2] = 1);

        RecourcesText := RecourcesTextSource;
        ResourcesCount := 0;
        ServLaborApplicationGlobTmp.RESET;
        ServLaborApplicationGlobTmp.DELETEALL;
        REPEAT
          Posit := STRPOS(RecourcesText, ',');
          IF Posit > 0 THEN BEGIN
            ResourceToAdd := COPYSTR(RecourcesText, 1, Posit - 1);
            RecourcesText := COPYSTR(RecourcesText, Posit + 1, STRLEN(RecourcesText)-Posit);
          END ELSE BEGIN
            ResourceToAdd := RecourcesText;
            RecourcesText := '';
          END;
          IF Resource.GET(ResourceToAdd) THEN BEGIN
            ServLaborApplicationGlobTmp.SETRANGE("Resource No.", ResourceToAdd);
            IF NOT ServLaborApplicationGlobTmp.FINDLAST THEN BEGIN
              Resource.TESTFIELD(Blocked, FALSE);
              LineNo := 0;
              ServLaborApplicationGlobTmp.RESET;
              IF ServLaborApplicationGlobTmp.FINDLAST THEN
                LineNo := ServLaborApplicationGlobTmp."Line No.";
              ServLaborApplicationGlobTmp.INIT;
              ServLaborApplicationGlobTmp."Allocation Entry No." := 0;
              ServLaborApplicationGlobTmp."Document Type" := "Document Type";
              ServLaborApplicationGlobTmp."Document No." := "No.";
              ServLaborApplicationGlobTmp."Document Line No." := 0;
              ServLaborApplicationGlobTmp."Resource No." := ResourceToAdd;
              ServLaborApplicationGlobTmp."Line No." := LineNo + 10000;
              ServLaborApplicationGlobTmp.INSERT;
            END;
          END;
        UNTIL RecourcesText = '';
        ServLaborApplicationGlobTmp.SETRANGE("Resource No.");
        EXIT(ServLaborApplicationGlobTmp.COUNT);
    end;

    [Scope('Internal')]
    procedure SaveRelatedResourcesToDB(RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "25006277";
        ServLaborAllocationEntryLoc: Record "25006271";
        ServiceScheduleMgt: Codeunit "25006201";
        Posit: Integer;
        ServiceSetup: Record "25006120";
        ResourceToAdd: Text[30];
        Resource: Record "156";
        RecourcesTextToModify: Text[250];
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "25006146";
        isFound: Boolean;
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        ResourcesCount := 0;
        IF ResourceTextFieldModified THEN BEGIN

          SetRelatedResources(ResourceTextFieldValue, 0);

          ServLaborApplication.RESET;
          ServLaborApplication.SETRANGE("Document Type", "Document Type");
          ServLaborApplication.SETRANGE("Document No.", "No.");
          ServLaborApplication.SETRANGE("Document Line No.", 0);
          IF ServLaborApplicationGlobTmp.FINDFIRST THEN BEGIN
            REPEAT
              IF Resource.GET(ServLaborApplicationGlobTmp."Resource No.") THEN BEGIN
                ServLaborApplication.SETRANGE("Resource No.", ServLaborApplicationGlobTmp."Resource No.");
                isFound := ServLaborApplication.FINDLAST;
                IF NOT isFound THEN BEGIN
                  Resource.TESTFIELD(Blocked, FALSE);

                  ServLaborApplication.INIT;
                  ServLaborApplication."Allocation Entry No." := 0;
                  ServLaborApplication."Document Type" := "Document Type";
                  ServLaborApplication."Document No." := "No.";
                  ServLaborApplication."Document Line No." := 0;
                  ServLaborApplication."Resource No." := ServLaborApplicationGlobTmp."Resource No.";
                  ServLaborApplication.INSERT(TRUE);
                END;
              END;
            UNTIL ServLaborApplicationGlobTmp.NEXT = 0;
          END;
          ServLaborApplication.SETRANGE("Document Line No.", 0);
          ServLaborApplication.SETRANGE("Resource No.");
          ServLaborApplicationGlobTmp.RESET;
          // here get remove unneed records
          IF ServLaborApplication.FINDFIRST THEN BEGIN
            REPEAT
              //Allocation Entry No.,Document Type,Document No.,Line No.
              ServLaborApplicationGlobTmp.SETRANGE("Resource No.", ServLaborApplication."Resource No.");
              IF NOT ServLaborApplicationGlobTmp.FINDLAST THEN
                IF NOT ServLaborAllocationEntryLoc.GET(ServLaborApplication."Allocation Entry No.") THEN BEGIN
                  ServLaborApplication.DELETE(TRUE);
                  ServLaborApplication.FINDFIRST;
                END ELSE BEGIN
                  // MESSAGE('IT is not allowed to delete allocated records');
              END;
            UNTIL ServLaborApplication.NEXT = 0;
          END;
          IF ServLaborApplication.FINDFIRST THEN BEGIN
            ServLaborApplicationGlobTmp.SETRANGE("Resource No.", ServLaborApplication."Resource No.");
            IF NOT ServLaborApplicationGlobTmp.FINDLAST THEN
              IF NOT ServLaborAllocationEntryLoc.GET(ServLaborApplication."Allocation Entry No.") THEN
                ServLaborApplication.DELETE(TRUE);
          END;

          //ServiceScheduleMgt.RemoveDuplicates(ServLaborApplication);

        END;
        CLEAR(ResourceTextFieldModified);
        CLEAR(ServicePrevParcedRsc);
        EXIT(ServLaborApplication.COUNT);
    end;

    [Scope('Internal')]
    procedure RelatedResourcesList(var RelatedResources: Text[250])
    var
        ServLaborAllocApplication: Record "25006277";
    begin
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Document Type", "Document Type");
        ServLaborAllocApplication.SETRANGE("Document No.", "No.");
        ServLaborAllocApplication.SETRANGE("Document Line No.", 0);
        PAGE.RUNMODAL(PAGE::"Service Line Resources", ServLaborAllocApplication);
        RelatedResources := GetRelatedResourcesFromDB(0);
        SetResourceTextFieldValue(RelatedResources);
    end;

    [Scope('Internal')]
    procedure DeleteResourcesOfLine()
    var
        ServLaborAllocApplication: Record "25006277";
    begin
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Document Type", "Document Type");
        ServLaborAllocApplication.SETRANGE("Document No.", "No.");
        ServLaborAllocApplication.SETRANGE("Document Line No.", 0);
        ServLaborAllocApplication.DELETEALL(TRUE);
    end;

    [Scope('Internal')]
    procedure "--SMALL TECHN--"()
    begin
    end;

    [Scope('Internal')]
    procedure CutNextDigit(var Flags: Integer) RetValue: Integer
    begin
        RetValue := Flags MOD 10;
        Flags := Flags DIV 10;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure AdjustFlagsToArray(Flags: Integer;var ArrayEDMS: array [10] of Integer)
    var
        i: Integer;
    begin
        FOR i := 1 TO 10 DO BEGIN
          IF (CutNextDigit(Flags) > 0) THEN
            ArrayEDMS[i] := i-1
          ELSE
            ArrayEDMS[i] := -1;
        END;
    end;

    [Scope('Internal')]
    procedure IsIntInArrayTen(CheckValue: Integer;var ArrayEDMS: array [10] of Integer) RetValue: Boolean
    var
        i: Integer;
    begin
        FOR i := 1 TO 10 DO BEGIN
          IF (CheckValue = ArrayEDMS[i]) THEN
            RetValue := TRUE;
        END;

        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure LookupShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;

    [Scope('Internal')]
    procedure ServiceLinesExist(): Boolean
    begin
        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
        ServLine.RESET;
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");
        EXIT(ServLine.FINDFIRST);
        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;

    [Scope('Internal')]
    procedure ShowShortcutDimCode(var ShortcutDimCode: array [8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    [Scope('Internal')]
    procedure CalcAmountIncVAT() AmountIncVAT: Decimal
    begin
        IF Status = Status::Released THEN BEGIN
          ServLine.RESET;
          ServLine.SETRANGE("Document Type","Document Type");
          ServLine.SETRANGE("Document No.","No.");
          ServLine.CALCSUMS("Amount Including VAT");
          EXIT(ServLine."Amount Including VAT");
        END ELSE
          EXIT(0);
    end;

    [Scope('Internal')]
    procedure FindContract()
    var
        ContractVehicle: Record "25006059";
        ContractTemp: Record "25006016" temporary;
        Customer: Record "18";
    begin
        IF ("Bill-to Customer No." = '') OR ("Vehicle Serial No." = '') THEN
          EXIT;

        Customer.GET("Bill-to Customer No.");
        Customer.SetContractFilter(ContractTemp, Contract.Status::Active, FALSE, Contract."Document Profile"::Service, "Order Date", "Vehicle Serial No.");

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
    end;

    [Scope('Internal')]
    procedure GetPostingNoSeries()
    var
        UserSetup: Record "91";
    begin
        // Sipradi-YS GEN6.1.0 25006145.1 BEGIN >> Getting Posting No. Series based on user Branch,Cost Center and document type.
        /*VALIDATE("Posting No. Series",StplSysMgt.getLocWiseNoSeries(2,"Shortcut Dimension 1 Code",
                  "Shortcut Dimension 2 Code"));
                  */
        IF "Posting No. Series" = '' THEN BEGIN
          ServiceSetup.GET;
          IF "Document Type" IN ["Document Type"::"Return Order"] THEN
           VALIDATE("Posting No. Series",ServiceSetup."Posted Credit Memo Nos.")
          ELSE
           VALIDATE("Posting No. Series",ServiceSetup."Posted Invoice Nos.");
        END;

    end;

    local procedure GetDocumentType(): Integer
    begin
        CASE "Document Type" OF
          "Document Type"::Quote:
            EXIT(DocumentType::Quote);
          "Document Type"::Order:
            EXIT(DocumentType::Order);
          "Document Type"::"Return Order":
            EXIT(DocumentType::"Return Order");
        END;
    end;

    [Scope('Internal')]
    procedure InitRecord2()
    begin
        CASE "Document Type" OF
          "Document Type"::Order:
            BEGIN
              IF ServiceSetup."Use Order No. as Posting No." THEN BEGIN
                "Posting No." := "No.";
                "Posting No. Series" := StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,DocumentType::"Posted Invoice")
              END ELSE
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,DocumentType::"Posted Invoice"));
              NoSeriesMgt.SetDefaultSeries("Order Posting No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,DocumentType::"Posted Order"));
              NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",ServiceSetup."Posted Prepmt. Inv. Nos.");
              NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",ServiceSetup."Posted Prepmt. Cr. Memo Nos.");
            END;
          "Document Type"::"Return Order":
            BEGIN
              IF ServiceSetup."Use Order No. as Posting No." THEN BEGIN
                "Pst. Return Order No." := "No.";
                "Pst. Return Order No. Series" := "No. Series"
              END ELSE
                NoSeriesMgt.SetDefaultSeries("Pst. Return Order No. Series",ServiceSetup."Posted Return Order Nos.")
            END;
        END;

        IF "Document Type" IN ["Document Type"::"Return Order"] THEN BEGIN
          GLSetup.GET;
          Correction := GLSetup."Mark Cr. Memos as Corrections";
        END;
        GLSetup.GET;
        IF NOT GLSetup."Use Accountability Center" THEN
          "Responsibility Center" := UserMgt.GetRespCenter(3,"Responsibility Center")
        ELSE
          "Accountability Center" := UserMgt.GetRespCenter(3,"Accountability Center");
        VALIDATE("Order Date",WORKDATE);
        VALIDATE("Order Time",TIME);

        IF "Posting Date" = 0D THEN
          "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;

        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

        ServiceScheduleSetup.GET;
        "Planning Policy" := ServiceScheduleSetup."Planning Policy";
    end;

    local procedure GetNoSeriesCode2(): Code[10]
    begin
        CASE "Document Type" OF
          "Document Type"::Quote:
            EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,DocumentType::Quote));
          "Document Type"::Order:
            IF "Is Booked" THEN
              EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,DocumentType::Booking))
            ELSE
              EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,DocumentType::Order));
          "Document Type"::"Return Order":
            EXIT(ServiceSetup."Return Order Nos.");
        END;
    end;

    [Scope('Internal')]
    procedure CheckAMCReg(): Boolean
    begin
        AMCApplied := FALSE;
        TESTFIELD(VIN);
        JobTypeMaster.RESET;
        JobTypeMaster.SETRANGE(Type,JobTypeMaster.Type::Service);
        JobTypeMaster.SETRANGE("No.","Job Type");
        IF JobTypeMaster.FINDFIRST THEN BEGIN
          IF JobTypeMaster.AMC THEN BEGIN
            AMCRegVeh.RESET;
            AMCRegVeh.SETRANGE("VIN Code",VIN);
            IF AMCRegVeh.FINDFIRST THEN BEGIN
              IF AMCRegVeh."Valid Until" >= TODAY THEN BEGIN
                IF CONFIRM(ChangeBillTo,FALSE,FIELDCAPTION(VIN)) THEN BEGIN
                  JobTypeMaster.TESTFIELD("Bill to Customer");
                  VALIDATE("Bill-to Customer No.",JobTypeMaster."Bill to Customer");
                  AMCApplied := TRUE;
                END;
              END
              ELSE
                ERROR(ExpiredAMC);
            END
            ELSE
              ERROR(NotValidAMC);
          END;
        END;
        EXIT(AMCApplied);
    end;

    [Scope('Internal')]
    procedure TestHour()
    var
        ServOrdInfoPaneMgt: Codeunit "25006104";
    begin
        IF "Hour Reading" > 0 THEN
         IF "Hour Reading" < ServOrdInfoPaneMgt.CalcLastVisitHour("Vehicle Serial No.") THEN
          ERROR(InvalidHour);
    end;

    [Scope('Internal')]
    procedure CloseJob()
    var
        CloseJobWithReason: Label 'Do you want to close job for vehicle with Registration No : %1, VIN : %2 ?';
    begin
        IF CONFIRM(CloseJobWithReason,FALSE,FIELDCAPTION("No.")) THEN BEGIN

        END;
    end;

    [Scope('Internal')]
    procedure InsertWarrantyApproval(ServHeader: Record "25006145")
    var
        WarrantyAppLines: Record "33020237";
        UserSetup: Record "91";
        ServLine: Record "25006146";
        WarrantyLineCreated: Boolean;
        WLCreated: Label 'Approval Request Successfully sent.';
        WLNotFound: Label 'No Warranty Lines within the Service Lines.';
        JobTypeMaster: Record "33020235";
    begin
        WarrantyLineCreated := FALSE;
        ServLine.RESET;
        ServLine.SETRANGE("Document Type","Document Type"::Order);
        ServLine.SETRANGE("Document No.",ServHeader."No.");
        //ServLine.SETRANGE(Type,ServLine.Type::Item);
        ServLine.SETRANGE("Need Approval",TRUE);
        ServLine.SETRANGE("Warranty Claim No.",'');
        IF ServLine.FINDFIRST THEN BEGIN
          ServLine.TESTFIELD(Quantity);
          ServLine.TESTFIELD("Job Type");
          JobTypeMaster.RESET;
          JobTypeMaster.SETRANGE(Type,JobTypeMaster.Type::Job);
          JobTypeMaster.SETRANGE("No.",ServLine."Job Type");
          IF JobTypeMaster.FINDFIRST THEN
            IF (JobTypeMaster."Needs Warranty Approval") AND NOT (JobTypeMaster."Needs Approval") THEN //SM for other job type approval
               ServLine.TESTFIELD("Warranty Code");
          ServLine.TESTFIELD("Bill-to Customer No.");
          ServLine.TESTFIELD("Unit of Measure Code");
          ServLine.TESTFIELD("Approval Reason"); //**SM 15-08-2013 needs approval reason to send approval
          //ServLine.TESTFIELD("Line Amount");
          UserSetup.GET(USERID);
          WarrantyAppLines.RESET;

          WITH ServHeader DO BEGIN
            REPEAT
            CLEAR(WarrantyAppLines);
            WarrantyAppLines.INIT;
            WarrantyAppLines."Serv. Order No." := "No.";
            WarrantyAppLines.VIN := VIN;
            WarrantyAppLines."Make Code" := "Make Code";
            WarrantyAppLines."Model Code" := "Model Code";
            WarrantyAppLines."Model Version No." := "Model Version No.";
            WarrantyAppLines."Sell to Customer No." := "Sell-to Customer No.";
            WarrantyAppLines."Bill to Customer No." := ServLine."Bill-to Customer No.";
            IF ServLine.Type = ServLine.Type::Item THEN BEGIN
              WarrantyAppLines.Type :=  WarrantyAppLines.Type::Item;
              WarrantyAppLines."Item No." := ServLine."No.";
              WarrantyAppLines."Item Name" := ServLine.Description;
            END
            ELSE IF ServLine.Type = ServLine.Type::Labor THEN BEGIN
              WarrantyAppLines.Type := WarrantyAppLines.Type::Labor;
              WarrantyAppLines."Labor Code (System)" := ServLine."No.";
            END;
            WarrantyAppLines."Job Type" := ServLine."Job Type";
            WarrantyAppLines."Aggregate Job Type" := "Job Type";
            WarrantyAppLines."Aggregate Service Type" := "Service Type";
            WarrantyAppLines."Warranty Code" := ServLine."Warranty Code";
            WarrantyAppLines."Complain Date" := TODAY;
            WarrantyAppLines.Status := WarrantyAppLines.Status::Pending;
            WarrantyAppLines.Quantity := ServLine.Quantity;
            WarrantyAppLines."Unit of Measure Code" := ServLine."Unit of Measure Code";
            WarrantyAppLines.Amount := ServLine."Line Amount";
            WarrantyAppLines."Gen. Bus. Posting Group" := ServLine."Gen. Bus. Posting Group";
            WarrantyAppLines."Gen. Prod. Posting Group" := ServLine."Gen. Prod. Posting Group";
            WarrantyAppLines."Global Dimension 1 Code" := UserSetup."Shortcut Dimension 1 Code";
            WarrantyAppLines."Global Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
            WarrantyAppLines."Requested By" := UserSetup."User ID";
            WarrantyAppLines.Location := ServLine."Location Code";
            WarrantyAppLines."Responsibility Center" := ServLine."Responsibility Center";
            WarrantyAppLines."Accountability Center" := ServLine."Accountability Center";
            WarrantyAppLines.Kilometrage := ServHeader.Kilometrage;
            WarrantyAppLines."Complaint Report Date" := ServHeader."Posting Date";
            WarrantyAppLines."Veh. Regd. No." := ServHeader."Vehicle Registration No.";
            WarrantyAppLines."Job Date" := ServHeader."Document Date";
            WarrantyAppLines."Reason Code" := ServLine."Approval Reason"; //**SM 15-08-2013 to get approval reason from service line
            WarrantyAppLines.INSERT(TRUE);
            WarrantyLineCreated := TRUE;
            ServLine."Warranty Claim No." := WarrantyAppLines."Claim No.";
            ServLine.MODIFY;
            UNTIL ServLine.NEXT=0;
          END;
        END;
        IF WarrantyLineCreated THEN
          MESSAGE(WLCreated)
        ELSE
          ERROR(WLNotFound);
    end;

    [Scope('Internal')]
    procedure RemoveServPackage(ShowMessage: Boolean)
    var
        NoPackage: Label 'There is no any package withing the filter.';
        PackageRemoved: Label 'Service Package %1 removed successfully. ';
        CurrPackage: Code[20];
        MultiplePackagae: Boolean;
        DeleteSucess: Boolean;
        StillMoreLines: Label 'There are still more Package inserted in lines. Please remove them manually.';
        MultiplePack: Label 'Multiple Service Packages in service lines are removed successfully.';
    begin
        MultiplePackagae := FALSE;
        DeleteSucess := FALSE;
        CurrPackage := "Package No.";
        IF "Package No." <> '' THEN BEGIN
          ServLine.RESET;
          ServLine.SETRANGE("Document Type","Document Type");
          ServLine.SETRANGE("Document No.","No.");
          ServLine.SETRANGE("Package No.","Package No.");
          IF ServLine.FINDSET THEN BEGIN
            ServLine.DELETEALL;
            "Package No." := '';
            DeleteSucess := TRUE;
          END;
        END;

        ServLine.RESET;
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");
        ServLine.SETFILTER("Package No.",'<>%1','');
        IF ServLine.FINDSET THEN BEGIN
          ServLine.DELETEALL;
          MultiplePackagae := TRUE;
        END;
        COMMIT;
        IF DeleteSucess AND (NOT MultiplePackagae) AND ShowMessage THEN
          MESSAGE(PackageRemoved,CurrPackage)
        ELSE IF DeleteSucess AND MultiplePackagae AND ShowMessage THEN
          MESSAGE(MultiplePack)
        ELSE
          IF ShowMessage THEN
            ERROR(NoPackage);
    end;

    [Scope('Internal')]
    procedure VerifyWarrantyExistence()
    var
        WarrantyUsage: Record "25006038";
        VehWarranty: Record "25006036";
        Vehicle: Record "25006005";
    begin
        IF Vehicle.GET("Vehicle Serial No.") THEN BEGIN
          WarrantyUsage.RESET;
          WarrantyUsage.SETRANGE("Make Code",Vehicle."Make Code");
          WarrantyUsage.SETRANGE("Model Code",Vehicle."Model Code");
          WarrantyUsage.SETRANGE("Model Version No.",Vehicle."Model Version No.");
          WarrantyUsage.SETRANGE("Warranty Type Code",'VEHICLE');
          IF WarrantyUsage.FINDFIRST THEN BEGIN
            VehWarranty.RESET;
            VehWarranty.SETRANGE("Vehicle Serial No.",Vehicle."Serial No.");
            IF NOT VehWarranty.FINDFIRST THEN BEGIN
              //Insert Vehicle Warranty
              VehWarranty.INIT;
              VehWarranty."Vehicle Serial No." := Vehicle."Serial No.";
              VehWarranty."Warranty Type Code" := WarrantyUsage."Warranty Type Code";
              VehWarranty."Starting Date" := Vehicle."Sales Date";
              VehWarranty."Term Date Formula" := WarrantyUsage."Term Date Formula";
              VehWarranty."Kilometrage Limit" := WarrantyUsage."Kilometrage Limit";
              VehWarranty.INSERT(TRUE);
            END;
          END;
          VehWarranty.RESET;
          VehWarranty.SETRANGE("Vehicle Serial No.",Vehicle."Serial No.");
          IF VehWarranty.FINDSET THEN REPEAT
            //Check Vehicle Warranty
            IF Vehicle."Sales Date" = 0D THEN
              MESSAGE('Please Update the Vehicles Sales Date.')
            ELSE BEGIN
              IF (CALCDATE(FORMAT(VehWarranty."Term Date Formula"),Vehicle."Sales Date") < TODAY) OR
                 (Kilometrage > VehWarranty."Kilometrage Limit") THEN
                   VehWarranty.Status := VehWarranty.Status::"Not Active"
              ELSE
                   VehWarranty.Status := VehWarranty.Status::Active;
            END;
            VehWarranty.MODIFY;

          UNTIL VehWarranty.NEXT=0;
        END;
    end;

    [Scope('Internal')]
    procedure CheckMobileNo()
    var
        JobTypeMaster: Record "33020235";
    begin
        //TESTFIELD("Job Type");
        //JobTypeMaster.GET("Job Type",JobTypeMaster.Type::Service);
        //IF JobTypeMaster."Mobile No. Required" THEN
          IF "Mobile No. for SMS" = '' THEN
            ERROR('Please enter Mobile No. for SMS.');
    end;

    [Scope('Internal')]
    procedure ValidateMobileNo(MobileNo: Code[50];FieldCaption: Text[30];RecID: Code[20])
    var
        MarketingSetup: Record "5079";
        Length: Integer;
        Sequence: Code[250];
        SequenceRule: Code[10];
        TotalRules: Integer;
        RuleFinished: Boolean;
        i: Integer;
        ValidNumber: Boolean;
    begin
        IF MobileNo <> '' THEN BEGIN
          IF STRLEN(MobileNo) = 10 THEN BEGIN
            Length := 1;
            REPEAT
              IF MobileNo[Length] IN ['1','2','3','4','5','6','7','8','9','0'] THEN BEGIN
              END
              ELSE
                ERROR('%1 should only consists of numeric combination for Record %2.',FieldCaption,RecID);
              Length += 1;
            UNTIL Length > 10;

            MarketingSetup.GET;
            Sequence := MarketingSetup."Valid Mobile Nos. Format";
            //--Finding Total Rules
            IF Sequence <> '' THEN BEGIN
              REPEAT
                IF STRPOS(Sequence,',') > 0 THEN BEGIN
                  Sequence := DELSTR(Sequence,1,STRPOS(Sequence,','));
                  TotalRules += 1;
                END
                ELSE
                  RuleFinished := TRUE;
              UNTIL RuleFinished = TRUE;
            END;
            //--Loop through Rules
            Sequence := MarketingSetup."Valid Mobile Nos. Format";
            ValidNumber := FALSE;
            FOR i:=1 TO TotalRules+1 DO BEGIN
              IF COPYSTR(MobileNo,1,STRLEN(SELECTSTR(i,Sequence))) = (SELECTSTR(i,Sequence)) THEN
                ValidNumber := TRUE;
            END;
            IF NOT ValidNumber THEN
              ERROR('%1 is not valid for record %2',FieldCaption,RecID);
          END
          ELSE
            ERROR('%1 must have 10 numeric characters for %2',FieldCaption,RecID);
        END;
    end;

    [Scope('Internal')]
    procedure GetUserSetupEDMS()
    var
        UserSetup: Record "91";
        SingleInstanceMgt: Codeunit "25006001";
        UserProfileMgt: Codeunit "25006002";
        UserProfile: Record "25006067";
        ServSetup: Record "25006120";
        ServLocation: Code[20];
    begin
        ServSetup.GET;
        IF UserSetup.GET(USERID) THEN
         BEGIN
          IF UserSetup."Salespers./Purch. Code" <> '' THEN
           VALIDATE("Service Person",UserSetup."Salespers./Purch. Code");
         END;

        IF UserProfileMgt.CurrProfileID <> '' THEN
         BEGIN
          IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
           BEGIN
            IF UserProfile."Spec. Service Setup" THEN
             BEGIN //For Vehicle Salespersons
              VALIDATE("Initiator Code",UserSetup."Salespers./Purch. Code");
              VALIDATE("Service Person",UserProfile."Spec. Order Receiver");
              UserProfile.TESTFIELD("Spec. Service User Profile");
              IF UserProfile.GET(UserProfile."Spec. Service User Profile") THEN
               BEGIN
                ServLocation := UserProfile."Def. Service Location Code";
                IF ServLocation = '' THEN
                  ServLocation := ServSetup."Def. Service Location Code";
                IF ServLocation <> '' THEN
                 VALIDATE("Location Code",ServLocation);
                IF UserProfile."Default Deal Type Code" <> '' THEN
                  VALIDATE("Deal Type",UserProfile."Default Deal Type Code");
               END;
             END
            ELSE
             BEGIN //For Service Employees
              ServLocation := UserProfile."Def. Service Location Code";
              IF ServLocation = '' THEN
               ServLocation := ServSetup."Def. Service Location Code";
              IF ServLocation <> '' THEN
               VALIDATE("Location Code",ServLocation);
              IF UserProfile."Default Deal Type Code" <> '' THEN
                VALIDATE("Deal Type",UserProfile."Default Deal Type Code");
             END;
           END;
         END;
        "Assigned User ID" := USERID;
    end;

    [Scope('Internal')]
    procedure SendSMS()
    var
        SMSTemplate: Record "33020257";
        SysMgt: Codeunit "50000";
    begin
        CheckMobileNo;
        IF "Approx. Estimation" > 0 THEN BEGIN
          SMSTemplate.RESET;
          SMSTemplate.SETRANGE(Type,SMSTemplate.Type::"Apporximate Estimate");
          IF SMSTemplate.FINDSET THEN
            SysMgt.InsertSMSDetail(SMSTemplate.Type::"Apporximate Estimate","No.","Mobile No. for SMS",STRSUBSTNO(SMSTemplate."Message Text","Bill-to Name","Vehicle Registration No.","Approx. Estimation"));
        END;
    end;

    [Scope('Internal')]
    procedure SendSMSBooking()
    var
        SMSTemplate: Record "33020257";
        SysMgt: Codeunit "50000";
    begin
        CheckMobileNo;
        SMSTemplate.RESET;
        SMSTemplate.SETRANGE(Type,SMSTemplate.Type::"Service Booking");
        IF SMSTemplate.FINDSET THEN
          SysMgt.InsertSMSDetail(SMSTemplate.Type::"Service Booking","No.","Mobile No. for SMS",STRSUBSTNO(SMSTemplate."Message Text","Bill-to Name","No.","Vehicle Registration No.","Arrival Date"));
    end;

    local procedure insertOrRemoveFromPostedVIN(_VIN: Code[20];ServCode: Code[20])
    var
        ServiceOrderCompare: Record "14125607";
        PostedSalesInvoiceLine: Record "25006150";
        PostedSalesInvoiceHdr: Record "25006149";
        lineNo: Integer;
        ServHdr: Record "25006145";
        Vehicle: Record "25006005";
        SerialNo: Code[50];
        ServiceOrder: Record "14125607";
        sttpl: Codeunit "50000";
    begin
        IF NOT sttpl.isBAW THEN
          EXIT;


        ServiceOrderCompare.RESET;
        ServiceOrderCompare.SETRANGE("Document No.",ServCode);
        ServiceOrderCompare.SETRANGE("Past Invoice",TRUE);
        ServiceOrderCompare.DELETEALL;



        ServiceOrderCompare.RESET;
        ServiceOrderCompare.SETRANGE("Document No.",ServCode);
        IF ServiceOrderCompare.FINDLAST THEN
          lineNo := ServiceOrderCompare."Line No."
        ELSE
          lineNo := 0;

        CLEAR(SerialNo);
        Vehicle.RESET;
        Vehicle.SETRANGE(VIN,_VIN);
        IF Vehicle.FINDFIRST THEN
          SerialNo := Vehicle."Serial No.";

        ServiceOrder.RESET;
        ServiceOrder.SETRANGE("Document No.",ServCode);
        ServiceOrder.SETRANGE(Type,ServiceOrder.Type::Header);
        IF NOT ServiceOrder.FINDFIRST THEN BEGIN
          lineNo+=10000;
          ServiceOrder.INIT;
          ServiceOrder."Document No." := ServCode;
          ServiceOrder.Type := ServiceOrder.Type::Header;
          ServiceOrder."Line No." := lineNo;
          ServiceOrder.VIN := _VIN;
          ServiceOrder."Vehicle Registration No." := Vehicle."Registration No.";
          ServiceOrder."Vehicle Serial No." := Vehicle."Serial No.";
          ServiceOrder.INSERT;
          END;




        CLEAR(ServiceOrderCompare);

        IF VIN = '' THEN BEGIN
         ServHdr.RESET;
         ServHdr.SETRANGE("No.",ServCode);
         IF ServHdr.FINDFIRST THEN
           _VIN := ServHdr.VIN
        END;
        // ELSE
         //ERROR('Service Order has been posted.');



        PostedSalesInvoiceHdr.RESET;
        PostedSalesInvoiceHdr.SETRANGE("Vehicle Serial No.",SerialNo);
        IF PostedSalesInvoiceHdr.FINDLAST THEN BEGIN
          PostedSalesInvoiceLine.RESET;
          PostedSalesInvoiceLine.SETRANGE("Document No.",PostedSalesInvoiceHdr."No.");
          IF PostedSalesInvoiceLine.FINDSET THEN
            REPEAT
              CLEAR(ServiceOrderCompare);
              lineNo += 10000;
              ServiceOrderCompare.RESET;
              ServiceOrderCompare.SETRANGE("Document No.",ServCode);
              ServiceOrderCompare.SETRANGE("Past Invoice",TRUE);
              ServiceOrderCompare.SETRANGE("Posted Service Order No.",PostedSalesInvoiceLine."Document No.");
              ServiceOrderCompare.SETRANGE("No.",PostedSalesInvoiceLine."No.");
              IF NOT ServiceOrderCompare.FINDFIRST THEN BEGIN
                ServiceOrderCompare.INIT;
                ServiceOrderCompare."Document No." := ServCode;
                ServiceOrderCompare."Line No." := lineNo;
                ServiceOrderCompare.VIN := _VIN;
                ServiceOrderCompare."Vehicle Registration No." := PostedSalesInvoiceHdr."Vehicle Registration No.";
                ServiceOrderCompare."Vehicle Serial No." := PostedSalesInvoiceHdr."Vehicle Serial No.";
                ServiceOrderCompare."Posted Service Order No." := PostedSalesInvoiceLine."Document No.";
                ServiceOrderCompare.Type := ServiceOrderCompare.Type::Line;
                ServiceOrderCompare."Line Type" := PostedSalesInvoiceLine.Type;
                ServiceOrderCompare."No." := PostedSalesInvoiceLine."No.";
                ServiceOrderCompare.Descrption := PostedSalesInvoiceLine.Description;
                ServiceOrderCompare.Qunatity := PostedSalesInvoiceLine.Quantity;
                ServiceOrderCompare."Line Amt. Inc VAT" := PostedSalesInvoiceLine."Line Amount";
                ServiceOrderCompare."Past Invoice" := TRUE;
                ServiceOrderCompare.INSERT;
              END ELSE BEGIN
                ServiceOrderCompare.VIN := _VIN;
                ServiceOrderCompare."Posted Service Order No." := PostedSalesInvoiceLine."Document No.";
                ServiceOrderCompare.Type := ServiceOrderCompare.Type::Line;
                ServiceOrderCompare."Line Type" := PostedSalesInvoiceLine.Type;
                ServiceOrderCompare."No." := PostedSalesInvoiceLine."No.";
                ServiceOrderCompare.Descrption := PostedSalesInvoiceLine.Description;
                ServiceOrderCompare.Qunatity := PostedSalesInvoiceLine.Quantity;
                ServiceOrderCompare."Line Amt. Inc VAT" := PostedSalesInvoiceLine."Line Amount";
                ServiceOrderCompare."Past Invoice" := TRUE;
                ServiceOrderCompare.MODIFY;
                END;
              UNTIL PostedSalesInvoiceLine.NEXT = 0;
          END;
    end;

    local procedure verifyIfItsRepatAlready(var ServHdr: Record "25006145")
    var
        PostedServiceInv: Record "112";
        ServSetup: Record "25006120";
        sttpl: Codeunit "50000";
    begin
        IF NOT sttpl.isBAW THEN
          EXIT;
        ServSetup.GET;
        PostedServiceInv.SETCURRENTKEY("No.","Posting Date");
        //PostedServiceInv.SETASCENDING("No.","Posting Date",TRUE);
        PostedServiceInv.RESET;
        PostedServiceInv.SETRANGE("Vehicle Serial No.",ServHdr."Vehicle Serial No.");
        PostedServiceInv.SETRANGE("Model Version No.",ServHdr."Model Version No.");
        PostedServiceInv.SETRANGE("Document Profile",PostedServiceInv."Document Profile"::Service);
        IF PostedServiceInv.FINDLAST THEN BEGIN //since it not giving right document according to posting date
        IF ((ServHdr."Arrival Date" - PostedServiceInv."Posting Date") <= ServSetup."Revisit Repair Period") THEN
          ServHdr."RV RR Code" := ServHdr."RV RR Code"::Revisit;
        END;
    end;

    local procedure verifyIfItsRepatAlreadyBYKm(var ServHdr: Record "25006145")
    var
        PostedServiceInv: Record "112";
        ServSetup: Record "25006120";
        km: BigInteger;
        sttpl: Codeunit "50000";
    begin
        IF NOT sttpl.isBAW THEN
          EXIT;
        
        ServSetup.GET;
        /*PostedServiceInv.SETCURRENTKEY("No.","Posting Date");
        PostedServiceInv.SETASCENDING("No.",TRUE);
        PostedServiceInv.RESET;
        PostedServiceInv.SETRANGE("Vehicle Serial No.",ServHdr."Vehicle Serial No.");
        PostedServiceInv.SETRANGE("Model Version No.",ServHdr."Model Version No.");
        PostedServiceInv.SETRANGE("Document Profile",PostedServiceInv."Document Profile"::Service);
        IF PostedServiceInv.FINDLAST THEN BEGIN
        IF ((ServHdr.Kilometrage - PostedServiceInv.Kilometrage) <= ServSetup."Revisit Repair KM") THEN
          ServHdr."RV RR Code" := ServHdr."RV RR Code"::Revisit;
        END;
        */
        km := 0;
        PostedServiceInv.SETCURRENTKEY("No.","Posting Date");
        PostedServiceInv.SETASCENDING("No.",TRUE);
        PostedServiceInv.RESET;
        PostedServiceInv.SETRANGE("Vehicle Serial No.",ServHdr."Vehicle Serial No.");
        PostedServiceInv.SETRANGE("Model Version No.",ServHdr."Model Version No.");
        PostedServiceInv.SETRANGE("Document Profile",PostedServiceInv."Document Profile"::Service);
        IF PostedServiceInv.FINDSET THEN REPEAT
         IF km < PostedServiceInv.Kilometrage THEN
          km := PostedServiceInv.Kilometrage;
        UNTIL PostedServiceInv.NEXT = 0;
        
        IF ((ServHdr.Kilometrage - km) <= ServSetup."Revisit Repair KM") THEN
          ServHdr."RV RR Code" := ServHdr."RV RR Code"::Revisit;

    end;

    [Scope('Internal')]
    procedure verifyIfItsRepatAlreadyDOC(var ServHdr: Record "25006145")
    var
        PostedServiceInv: Record "112";
        ServSetup: Record "25006120";
        dateFilter: Date;
        PostedServiceInv1: Record "112";
        sttpl: Codeunit "50000";
    begin
        IF NOT sttpl.isBAW THEN
          EXIT;
        dateFilter := 0D;
        ServSetup.GET;
        PostedServiceInv1.SETCURRENTKEY("No.","Posting Date");
        //PostedServiceInv.SETASCENDING("No.","Posting Date",TRUE);
        PostedServiceInv1.RESET;
        PostedServiceInv1.SETRANGE("Vehicle Serial No.",ServHdr."Vehicle Serial No.");
        PostedServiceInv1.SETRANGE("Model Version No.",ServHdr."Model Version No.");
        PostedServiceInv1.SETRANGE("Document Profile",PostedServiceInv1."Document Profile"::Service);
        IF PostedServiceInv1.FINDSET THEN REPEAT
          IF dateFilter < PostedServiceInv1."Posting Date" THEN
            dateFilter := PostedServiceInv1."Posting Date";
          UNTIL PostedServiceInv1.NEXT = 0;

        PostedServiceInv.RESET;
        PostedServiceInv.SETRANGE("Vehicle Serial No.",ServHdr."Vehicle Serial No.");
        PostedServiceInv.SETRANGE("Model Version No.",ServHdr."Model Version No.");
        PostedServiceInv.SETRANGE("Document Profile",PostedServiceInv."Document Profile"::Service);
        PostedServiceInv.SETRANGE("Posting Date",dateFilter);
        IF PostedServiceInv.FINDFIRST THEN BEGIN
          IF ((ServHdr.Kilometrage - PostedServiceInv.Kilometrage) <= ServSetup."Revisit Repair KM")
            OR ((ServHdr."Arrival Date" - PostedServiceInv."Posting Date") <= ServSetup."Revisit Repair Period") THEN
               ServHdr."RV RR Code" := ServHdr."RV RR Code"::Revisit
               ELSE
               ServHdr."RV RR Code" := ServHdr."RV RR Code"::" ";
          END;
    end;

    local procedure InsertDefectEntry()
    var
        DefectPage: Page "14125504";
                        DefectRec: Record "14125606";
                        DefectRec1: Record "14125606";
                        LineNo: Integer;
    begin
        IF ("RV RR Code" = "RV RR Code"::" ") THEN
          EXIT;
        DefectRec1.RESET;
        DefectRec1.SETRANGE("Service Order No.", Rec."No.");
        IF DefectRec1.FINDLAST THEN
            LineNo := DefectRec1."Line No." + 10000
        ELSE
          LineNo := 10000;
        DefectRec.INIT;
        DefectRec."Service Order No." := Rec."No.";
        DefectRec."Line No." := LineNo;
        DefectRec.VIN := Rec.VIN;
        DefectRec.Type := DefectRec.Type::Order;
        DefectRec."Is Complain" := TRUE;
        DefectRec."RV RR Code" := Rec."RV RR Code";
        DefectRec.INSERT(TRUE);
    end;
}

