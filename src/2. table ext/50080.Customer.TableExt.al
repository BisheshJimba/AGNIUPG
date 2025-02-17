tableextension 50080 tableextension50080 extends Customer
{
    // 24.11.2015 EB.P7 #T017
    //   OnInsert Modified, code moved to Events
    //   Added function GetInsertFromContacts
    //   Moved function CustomerUpdateFromTemplate to Events
    //   OnDelete Modified code moved to events
    //   Blocked field OnValidate Code moved to events
    // 
    // 09.03.2015 EDMS P21
    //   Added field:
    //     25006120 "Item Charge Invoice Deal Type"
    // 
    // 17.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified functions:
    //     GetActiveContractQty
    //     ShowActiveContracts
    //     SetContractFilter
    // 
    // 18.02.2014 Elva Baltic P15 #F100 MMG7.00
    //   * Added functions:
    //     - BillToNoActiveContracts(BillToNo, Suspend)
    // 
    // 04.02.2014 Elva Baltic P7 #F044 MMG7.00
    //   * OnInsert modified to add customer template functionality
    // 
    // 12.08.2013 EDMS P8
    //   * Added fields "No. of Serv. Quotes"
    // 
    // 26.07.2007. EDMS P2
    //   * Added function - GetFirstBankAccount
    // 
    // 21.06.2007. EDMS P2
    //   * Added new key - Name
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Name(Field 2)".


        //Unsupported feature: Property Modification (Data type) on ""Name 2"(Field 4)".

        modify(City)
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }

        //Unsupported feature: Property Modification (Data type) on "Contact(Field 8)".


        //Unsupported feature: Property Modification (Data type) on ""Phone No."(Field 9)".

        modify("Territory Code")
        {

            //Unsupported feature: Property Modification (Name) on ""Territory Code"(Field 15)".

            TableRelation = "Dealer Segment Type";
            Caption = 'Dealer Segment Type';
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 38)".


        //Unsupported feature: Property Modification (CalcFormula) on "Balance(Field 58)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance (LCY)"(Field 59)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Change"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Change (LCY)"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Sales (LCY)"(Field 62)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Profit (LCY)"(Field 63)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Inv. Discounts (LCY)"(Field 64)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pmt. Discounts (LCY)"(Field 65)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance Due"(Field 66)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance Due (LCY)"(Field 67)".


        //Unsupported feature: Property Modification (CalcFormula) on "Payments(Field 69)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Invoice Amounts"(Field 70)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cr. Memo Amounts"(Field 71)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Finance Charge Memo Amounts"(Field 72)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Payments (LCY)"(Field 74)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Inv. Amounts (LCY)"(Field 75)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cr. Memo Amounts (LCY)"(Field 76)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Fin. Charge Memo Amounts (LCY)"(Field 77)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Orders"(Field 78)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Shipped Not Invoiced"(Field 79)".

        modify("Post Code")
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount"(Field 97)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount"(Field 98)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount (LCY)"(Field 99)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount (LCY)"(Field 100)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reminder Amounts"(Field 105)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reminder Amounts (LCY)"(Field 106)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Orders (LCY)"(Field 113)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Shipped Not Invoiced (LCY)"(Field 114)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pmt. Disc. Tolerance (LCY)"(Field 117)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pmt. Tolerance (LCY)"(Field 118)".


        //Unsupported feature: Property Modification (CalcFormula) on "Refunds(Field 120)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Refunds (LCY)"(Field 121)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Other Amounts"(Field 122)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Other Amounts (LCY)"(Field 123)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Invoices (LCY)"(Field 125)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Invoices"(Field 126)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Bill-to No. Of Archived Doc."(Field 130)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Sell-to No. Of Archived Doc."(Field 131)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contract Gain/Loss Amount"(Field 5902)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Serv. Orders (LCY)"(Field 5910)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Serv Shipped Not Invoiced(LCY)"(Field 5911)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Serv.Invoices(LCY)"(Field 5912)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Quotes"(Field 7171)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Blanket Orders"(Field 7172)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Orders"(Field 7173)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Invoices"(Field 7174)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Return Orders"(Field 7175)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Credit Memos"(Field 7176)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Bill-To No. of Quotes"(Field 7182)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Bill-To No. of Blanket Orders"(Field 7183)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Bill-To No. of Orders"(Field 7184)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Bill-To No. of Invoices"(Field 7185)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Bill-To No. of Return Orders"(Field 7186)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Bill-To No. of Credit Memos"(Field 7187)".



        //Unsupported feature: Code Modification on ""No."(Field 1).OnValidate".

        //trigger "(Field 1)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "No." <> xRec."No." THEN BEGIN
          SalesSetup.GET;
          NoSeriesMgt.TestManual(SalesSetup."Customer Nos.");
          "No. Series" := '';
        END;
        IF "Invoice Disc. Code" = '' THEN
          "Invoice Disc. Code" := "No.";
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..7

        */
        //end;


        //Unsupported feature: Code Modification on "Name(Field 2).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
          "Search Name" := Name;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
          "Search Name" := Name;

        //default vat posting group for customer
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Def. Taxable VAT Bus. Code");
        VALIDATE("VAT Bus. Posting Group",SalesSetup."Def. Taxable VAT Bus. Code");
        //default vat posting group for customer
        */
        //end;


        //Unsupported feature: Code Insertion on ""Phone No."(Field 9)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        IF (STRLEN("Phone No.") > 20) THEN
          ERROR(Text017);
        */
        //end;


        //Unsupported feature: Code Modification on ""VAT Registration No."(Field 86).OnValidate".

        //trigger "(Field 86)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF VATRegNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Customer) THEN
          IF "VAT Registration No." <> xRec."VAT Registration No." THEN
            VATRegistrationLogMgt.LogCustomer(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3

        TESTFIELD("Customer Posting Group");
        CustPostingGrp.GET("Customer Posting Group");
        IF "VAT Registration No." <> '' THEN BEGIN
        IF CustPostingGrp."Check Duplicate VAT Reg. No." THEN
          AgniMgt.CheckDuplicateVATRegNo(DATABASE::Customer,"VAT Registration No.","No.");
        END;
        */
        //end;
        field(50000; "Temp Key"; Integer)
        {
        }
        field(50001; "Citizenship No."; Code[30])
        {
        }
        field(50002; "Citizenship Issued District"; Code[20])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(District));
        }
        field(50003; "Mobile No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF (STRLEN("Mobile No.") > 20) THEN
                    ERROR(Text016);
            end;
        }
        field(50004; "Is Dealer"; Boolean)
        {
        }
        field(50007; "Is Privilage"; Boolean)
        {
        }
        field(70000; "Location Code for Dealer"; Code[10])
        {
            TableRelation = Location;
        }
        field(80019; "Legal Action Taken"; Text[3])
        {
            Description = 'KSKL1.0';
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST("Legal Action Taken"));
        }
        field(80020; "Legal Status"; Text[10])
        {
            Description = 'KSKL1.0';
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST("Legal Status"));
        }
        field(80021; "Date of Company Redg"; Date)
        {
            Description = 'KSKL 1.0,Nepali';
        }
        field(80022; PAN; Code[20])
        {
            Description = 'KSKL 1.0';
        }
        field(80023; "Previous PAN"; Code[20])
        {
            Description = 'KSKL 1.0';
        }
        field(80024; "PAN Issue Date"; Text[15])
        {
            Description = 'KSKL 1.0';
        }
        field(80025; "PAN Issue District"; Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(80026; "Company  Redg No."; Code[20])
        {
            Description = 'KSKL 1.0';
        }
        field(80027; "Address Type"; Code[20])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE(Type = CONST("Address Type"));
        }
        field(80028; "Street Adress And Tole"; Text[30])
        {
            Description = 'KSKL 1.0';
        }
        field(80029; "Ward No."; Text[30])
        {
            Description = 'KSKL 1.0';
        }
        field(80030; "City VDC Municipality"; Text[30])
        {
            Description = 'KSKL 1.0';
        }
        field(80031; "Address District"; Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE(Type = CONST(District));
        }
        field(80032; "PO Box"; Text[30])
        {
            Description = 'KSKL 1.0';
        }
        field(80033; Country; Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Country));
        }
        field(80034; "Telephone No."; Text[30])
        {
            Description = 'KSKL 1.0';
        }
        field(80035; "Business Activity Code"; Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST("Business Activity Code"));
        }
        field(80036; "Fax 1"; Text[30])
        {
            Description = 'KSKL 1.0';
        }
        field(80037; Group; Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Group));
        }
        field(80042; "Date of Regestration"; Text[30])
        {
            Description = 'KSKL 1.0';

            trigger OnValidate()
            var
                KSKLMgt: Codeunit "KSKL Mgt";
            begin
                //KSKLMgt.dateConversion("Date of Company Redg");
            end;
        }
        field(80052; "Passport Expiry Date"; Text[15])
        {
            Description = 'KSKL1.0,Nepali';

            trigger OnValidate()
            var
                KSKLMgt: Codeunit "KSKL Mgt";
            begin
                //"Passport Expiry Date Text" := KSKLMgt.dateConversion("Passport Expiry Date");
            end;
        }
        field(80053; "Passport Expiry Date Text"; Text[30])
        {
            Description = 'KSKL 1.0';
        }
        field(80056; "Indian Ebassy Reg Date"; Date)
        {
            Description = 'KSKL 1.0';

            trigger OnValidate()
            var
                KSKLMgt: Codeunit "KSKL Mgt";
            begin
                //"Indian Ebassy Reg Date Text" := KSKLMgt.dateConversion("Indian Ebassy Reg Date");
            end;
        }
        field(80057; "Indian Ebassy Reg Date Text"; Text[30])
        {
            Description = 'KSKL 1.0';
        }
        field(80059; "Gurantee Type"; Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST("Guarantee Type"));
        }
        field(80060; "Date of Leaving"; Date)
        {
            Description = 'KSKL 1.0';

            trigger OnValidate()
            var
                KSKLMgt: Codeunit "KSKL Mgt";
            begin
                //"Date of Leaving Text" := KSKLMgt.dateConversion("Date of Leaving");
            end;
        }
        field(80062; "Fathers Name"; Text[50])
        {
            Description = 'KSKL 1.0';
        }
        field(80063; "Last Modified Date"; Date)
        {
            Description = 'KSKL 1.0';
        }
        field(80064; "Related Entity Number"; Code[30])
        {
            Description = 'KSKL1.0';
            TableRelation = "Customer Related Entity";
        }
        field(80065; "Comp Regd No Issud Authority"; Code[20])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST("Commercial Registration Organization"));
        }
        field(25006010; "No. of Active Contracts"; Integer)
        {
            Caption = 'No. of Serv. Orders';
            FieldClass = FlowField;
            CalcFormula = Count(Contract WHERE("Bill-to Customer No." = FIELD("No."),
                                                Status = CONST(Active)));
        }
        field(25006100; "Corresponding Vendor No."; Code[20])
        {
            Caption = 'Corresponding Vendor No.';
            TableRelation = Vendor;
        }
        field(25006110; "Default Service Item Charge"; Code[20])
        {
            Caption = 'Default Service Item Charge';
            TableRelation = "Item Charge";
        }
        field(25006120; "Item Charge Invoice Deal Type"; Code[10])
        {
            Caption = 'Item Charge Invoice Deal Type';
            TableRelation = "Deal Type";
        }
        field(25006160; Internal; Boolean)
        {
            Caption = 'Internal';
            Description = 'TRUE means that customer is not a real customer';
        }
        field(25006200; "Form Initiated"; Boolean)
        {
            Caption = 'Form Initiated';
        }
        field(25006210; "No. of Serv. Quotes"; Integer)
        {
            Caption = 'No. of Serv. Quotes';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Service Header EDMS" WHERE("Document Type" = CONST(Quote),
                                                             "Sell-to Customer No." = FIELD("No.")));
        }
        field(25006211; "No. of Serv. Orders"; Integer)
        {
            Caption = 'No. of Serv. Orders';
            FieldClass = FlowField;
            CalcFormula = Count("Service Header EDMS" WHERE("Document Type" = CONST(Order),
                                                             "Sell-to Customer No." = FIELD("No.")));
        }
        field(25006212; "No. of Serv. Invoices"; Integer)
        {
            Caption = 'No. of Serv. Invoices';
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Invoice),
                                                      "Sell-to Customer No." = FIELD("No."),
                                                      "Document Profile" = CONST(Service)));
        }
        field(25006213; "No. of Serv. Return Orders"; Integer)
        {
            Caption = 'No. of Serv. Return Orders';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Service Header EDMS" WHERE("Document Type" = CONST("Return Order"),
                                                             "Sell-to Customer No." = FIELD("No.")));
        }
        field(25006214; "No. of Serv. Credit Memos"; Integer)
        {
            Caption = 'No. of Serv. Credit Memos';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                      "Sell-to Customer No." = FIELD("No."),
                                                      "Document Profile" = CONST(Service)));
        }
        field(25006215; "No. of Serv. Pstd. Orders"; Integer)
        {
            Caption = 'No. of Serv. Pstd. Orders';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Posted Serv. Order Header" WHERE("Sell-to Customer No." = FIELD("No.")));
        }
        field(25006216; "No. of Serv. Pstd. Invoices"; Integer)
        {
            Caption = 'No. of Serv. Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Invoice Header" WHERE("Sell-to Customer No." = FIELD("No."),
                                                              "Document Profile" = CONST(Service)));
        }
        field(25006217; "No. of Serv. Pstd. Ret. Orders"; Integer)
        {
            Caption = 'No. of Serv. Pstd. Ret. Orders';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Posted Serv. Ret. Order Header" WHERE("Sell-to Customer No." = FIELD("No.")));
        }
        field(25006218; "No. of Serv. Pstd. Cr. Memos"; Integer)
        {
            Caption = 'No. of Serv. Pstd. Cr. Memos';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Cr.Memo Header" WHERE("Sell-to Customer No." = FIELD("No."),
                                                              "Document Profile" = CONST(Service)));
        }
        field(25006219; "No. of Serv. Pstd. Shipments"; Integer)
        {
            Caption = 'No. of Serv. Pstd. Shipments';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Shipment Header" WHERE("Sell-to Customer No." = FIELD("No."),
                                                               "Document Profile" = CONST(Service)));
        }
        field(25006220; "Bill-To No. of S. Quotes"; Integer)
        {
            Caption = 'Bill-To No. of Serv. Quotes';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Service Header EDMS" WHERE("Document Type" = CONST(Quote),
                                                             "Bill-to Customer No." = FIELD("No.")));
        }
        field(25006221; "Bill-To No. of S. Orders"; Integer)
        {
            Caption = 'Bill-To No. of Serv. Orders';
            FieldClass = FlowField;
            CalcFormula = Count("Service Header EDMS" WHERE("Document Type" = CONST(Order),
                                                             "Bill-to Customer No." = FIELD("No.")));
        }
        field(25006222; "Bill-To No. of S. Invoices"; Integer)
        {
            Caption = 'Bill-To No. of Serv. Invoices';
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Invoice),
                                                      "Bill-to Customer No." = FIELD("No."),
                                                      "Document Profile" = CONST(Service)));
        }
        field(25006223; "Bill-To No. of S. Ret. Orders"; Integer)
        {
            Caption = 'Bill-To No. of Serv. Return Orders';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Service Header EDMS" WHERE("Document Type" = CONST("Return Order"),
                                                             "Bill-to Customer No." = FIELD("No.")));
        }
        field(25006224; "Bill-To No. of S. Credit Memos"; Integer)
        {
            Caption = 'Bill-To No. of Serv. Credit Memos';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                      "Bill-to Customer No." = FIELD("No."),
                                                      "Document Profile" = CONST(Service)));
        }
        field(25006225; "Bill-To No. of S. Pstd. Orders"; Integer)
        {
            Caption = 'Bill-To No. of Serv. Pstd. Orders';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Posted Serv. Order Header" WHERE("Bill-to Customer No." = FIELD("No.")));
        }
        field(25006226; "Bill-To No. of S. Pstd. Inv."; Integer)
        {
            Caption = 'Bill-To No. of Serv. Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Invoice Header" WHERE("Bill-to Customer No." = FIELD("No."),
                                                              "Document Profile" = CONST(Service)));
        }
        field(25006227; "Bill-To No. of S. Pstd. R.Ord."; Integer)
        {
            Caption = 'Bill-To No. of Serv. Pstd. Ret. Orders';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Posted Serv. Ret. Order Header" WHERE("Bill-to Customer No." = FIELD("No.")));
        }
        field(25006228; "Bill-To No. of S. Pstd. C.Mem."; Integer)
        {
            Caption = 'Bill-To No. of Serv. Pstd. Cr. Memos';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Cr.Memo Header" WHERE("Bill-to Customer No." = FIELD("No."),
                                                              "Document Profile" = CONST(Service)));
        }
        field(25006229; "Bill-To No. of S. Pstd. Shipm."; Integer)
        {
            Caption = 'Bill-To No. of Pstd. Shipments';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Shipment Header" WHERE("Bill-to Customer No." = FIELD("No."),
                                                               "Document Profile" = CONST(Service)));
        }
        field(25006230; "Outstanding Orders SP (LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Outstanding Orders Spare Parts (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Order),
                                                                             "Bill-to Customer No." = FIELD("No."),
                                                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                             "Currency Code" = FIELD("Currency Filter"),
                                                                             "Document Profile" = CONST("Spare Parts Trade")));
        }
        field(25006231; "Shipped Not Invoiced SP (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Shipped Not Invoiced Spare Parts (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Shipped Not Invoiced (LCY)" WHERE("Document Type" = CONST(Order),
                                                                               "Bill-to Customer No." = FIELD("No."),
                                                                               "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                               "Currency Code" = FIELD("Currency Filter"),
                                                                               "Document Profile" = CONST("Spare Parts Trade")));
        }
        field(25006232; "Outstanding Invoices SP (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Outstanding Invoices Spare Parts (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Invoice),
                                                                             "Bill-to Customer No." = FIELD("No."),
                                                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                             "Currency Code" = FIELD("Currency Filter"),
                                                                             "Document Profile" = CONST("Spare Parts Trade")));
        }
        field(25006233; "Outst. Serv. Orders EDMS (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Outstanding Serv. Orders (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Service Line EDMS"."Amount Including VAT" WHERE("Document Type" = CONST(Order),
                                                                                "Bill-to Customer No." = FIELD("No."),
                                                                                "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                "Currency Code" = FIELD("Currency Filter")));
        }
        field(25006234; "Outst. Serv.Invoices EDMS(LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Outstanding Serv. Invoices (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Invoice),
                                                                             "Bill-to Customer No." = FIELD("No."),
                                                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                             "Currency Code" = FIELD("Currency Filter"),
                                                                             "Document Profile" = CONST(Service)));
        }
        field(25006240; "No. of S.Pstd. Return Receipts"; Integer)
        {
            Caption = 'No. of Pstd. Return Receipts';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Return Receipt Header" WHERE("Sell-to Customer No." = FIELD("No."),
                                                               "Document Profile" = CONST(Service)));
        }
        field(25006241; "Bill-To No. of S.Pstd. Ret. R."; Integer)
        {
            Caption = 'Bill-To No. of Pstd. Return R.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Return Receipt Header" WHERE("Bill-to Customer No." = FIELD("No."),
                                                               "Document Profile" = CONST(Service)));
        }
        field(33019851; "Sipradi Customer No."; Code[20])
        {
        }
        field(33019852; "Duplicate Customer"; Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                IF NOT "Duplicate Customer" THEN
                    "Duplicate Customer No." := '';
            end;
        }
        field(33019853; "Duplicate Customer No."; Code[20])
        {
            Editable = true;
            TableRelation = IF ("Duplicate Customer" = CONST(true)) Customer."No.";

            trigger OnValidate()
            var
                Cust: Record Customer;
                AlreadyMarkedAsDuplicate: Label '%1 is already marked as Duplicate for %2.';
            begin
                Cust.RESET;
                Cust.SETRANGE("No.", "Duplicate Customer No.");
                Cust.SETRANGE("Duplicate Customer", TRUE);
                IF Cust.FINDFIRST THEN
                    ERROR(AlreadyMarkedAsDuplicate, "No.", Cust."No.");
            end;
        }
        field(33019854; "Corrected Phone No."; Text[250])
        {
        }
        field(33019855; "Long Fax"; Text[250])
        {
        }
        field(33019856; "Customer Type"; Option)
        {
            OptionCaption = ' ,BTD,SPD,LBD';
            OptionMembers = " ",BTD,SPD,LBD;
        }
        field(33019857; "Non-Billable"; Boolean)
        {

            trigger OnValidate()
            begin
                //default vat posting group for customer
                SalesSetup.GET;
                SalesSetup.TESTFIELD("Def. Taxable VAT Bus. Code");
                SalesSetup.TESTFIELD("Def. NonTaxable VAT Bus. Code");
                IF "Non-Billable" THEN
                    "VAT Bus. Posting Group" := SalesSetup."Def. NonTaxable VAT Bus. Code"
                ELSE
                    "VAT Bus. Posting Group" := SalesSetup."Def. Taxable VAT Bus. Code";
                //default vat posting group for customer
            end;
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(33019962; Type; Option)
        {
            OptionMembers = " ",Individual,Institutional,Nominee;
        }
        field(33019963; "Credit Limit Total"; Decimal)
        {
            CalcFormula = Sum("Customer Credit Limit Detail"."Credit Limit (LCY)" WHERE(Customer No.=FIELD(No.),
                                                                                         Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                         Global Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
            FieldClass = FlowField;
        }
        field(33019964;"Father's Name";Text[30])
        {
        }
        field(33019965;"Mother's Name";Text[30])
        {
        }
        field(33019966;"Date of Birth";Date)
        {
        }
        field(33019967;Gender;Text[30])
        {
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Gender));
        }
        field(33019968;Class;Option)
        {
            OptionCaption = ',ECD/PPC,Nursery,LKG,UKG,KG,1,2,3,4,5,6,7,8,9,10,11,12,JDFA,Left';
            OptionMembers = ,"ECD/PPC",Nursery,LKG,UKG,KG,"1","2","3","4","5","6","7","8","9","10","11","12",JDFA,Left;
        }
        field(33019969;"Guardian's Name";Text[30])
        {
        }
        field(33019970;Caste;Text[10])
        {
        }
        field(33019971;"Bank Account Name";Text[30])
        {
        }
        field(33019972;"Bank Account No.";Text[30])
        {
        }
        field(33019973;Section;Text[3])
        {
        }
        field(33019974;Saved;Boolean)
        {
        }
        field(33019975;"Province No.";Option)
        {
            OptionCaption = ' ,PROVINCE 1, PROVINCE 2, BAGMATI PROVINCE, GANDAKI PROVINCE, PROVINCE 5, KARNALI PROVINCE, SUDUR PACHIM PROVINCE';
            OptionMembers = " ","PROVINCE 1"," PROVINCE 2"," BAGMATI PROVINCE"," GANDAKI PROVINCE"," PROVINCE 5"," KARNALI PROVINCE"," SUDUR PACHIM PROVINCE";
        }
        field(33019976;"Nominee Account";Code[20])
        {
            Description = 'For Hire Purchase Only';

            trigger OnLookup()
            begin
                Customer.RESET;
                NomineeList.SETRECORD(Customer);
                NomineeList.SETTABLEVIEW(Customer);
                NomineeList.LOOKUPMODE(TRUE);
                IF NomineeList.RUNMODAL = ACTION::LookupOK THEN
                BEGIN
                  NomineeList.GETRECORD(Customer);
                  VALIDATE("Nominee Account", Customer."Nominee Account");
                END;
            end;
        }
        field(33019977;"Balance at Date";Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                         Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                         Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                         Currency Code=FIELD(Currency Filter),
                                                                         Posting Date=FIELD(Date Filter)));
            FieldClass = FlowField;
        }
        field(33019978;Status;Option)
        {
            Caption = 'Status';
            Description = ' ,Left,Retired,Terminated,Confirmed';
            OptionCaption = ' ,Left,Retired,Terminated,Confirmed';
            OptionMembers = " ",Left,Retired,Terminated,Confirmed;
        }
        field(33019979;"Sys LC No.";Code[20])
        {
            Description = 'For TR Loan @Agni';
            TableRelation = "LC Details".No. WHERE (Transaction Type=FILTER(Purchase),
                                                    Released=FILTER(Yes));
        }
        field(33019980;"Skip Mahindra Customer";Boolean)
        {
        }
        field(33019981;"Is Nominee";Boolean)
        {
        }
        field(33019982;"SMS Not Required";Boolean)
        {
        }
        field(33019983;"Previous Citizenship No";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019984;Passport;Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019985;"Prev Passport";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019986;"Voter ID";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019987;"Prev Voter ID";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019988;"Voter ID issued Date";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019989;"Ind Emb Regd No";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019990;"Grand Father Name";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019991;"Spouse 1 Name";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019992;"Spouse 2 Name";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019993;"Subject Nationality";Text[5])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Country));
        }
        field(33019994;"Marital Status";Text[5])
        {
            Description = 'KSKL 1.0';
        }
        field(33019995;"Previous Customer No";Code[10])
        {
            Description = 'KSKL 1.0';
        }
        field(33019996;"Subject Name";Text[55])
        {
            Description = 'KSKL 1.0';
        }
        field(33019997;"Subject Prev Name";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019998;"Address 1 Line 1";Code[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33019999;"Address 1 Line 2";Code[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33020000;"Address 1 Line 3";Code[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33020001;"Address 1 Country";Text[20])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Country));
        }
        field(33020002;"Address 2 Type";Code[20])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Address Type));
        }
        field(33020003;"Address 2 Line 1";Code[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33020004;"Address 2 Line 2";Code[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33020005;"Address 2 Line 3";Code[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33020006;"Address 2 District";Text[20])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE (Type=CONST(District));
        }
        field(33020007;"Address 2 Power Box";Text[30])
        {
            Description = 'KSKL 1.0';
        }
        field(33020008;"Address 2 Country";Text[20])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Country));
        }
        field(33020009;"Telephone Number 2";Text[20])
        {
            Description = 'KSKL 1.0';

            trigger OnValidate()
            begin
                phoneNoValidation("Telephone Number 2");
            end;
        }
        field(33020010;"Fax 2";Text[20])
        {
            Description = 'KSKL 1.0';
        }
        field(33020011;Loan;Boolean)
        {
        }
        field(33020012;"Nature of Data";Code[10])
        {
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Nature of Data));
        }
        field(33020013;"Citizenship Issued Date";Text[15])
        {
            Description = 'Nepali';
        }
        field(33020014;"Employment Type";Text[10])
        {
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Employment Type));
        }
        field(33020015;"Employer Name";Text[30])
        {
        }
        field(33020016;"Monthly Income";Decimal)
        {
        }
        field(33020017;"Employment Commer Register ID";Code[10])
        {
        }
        field(33020018;"Subject Employer Address";Text[30])
        {
        }
        field(33020019;Designation;Text[30])
        {
        }
        field(33020020;"Type of Security";Text[10])
        {
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Type of Security));
        }
        field(33020021;"Security Ownership Type";Text[10])
        {
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Security Owernship Type));
        }
        field(33020022;"Customer Credit Limit";Decimal)
        {
        }
        field(33020023;"Passport No";Code[20])
        {
        }
        field(33020024;"Prevent BG Credit Limit";Boolean)
        {
        }
        field(33020025;"Student Joining Date";Date)
        {
        }
        field(33020026;"Student Left  Date";Date)
        {
        }
        field(33020027;NAV;Boolean)
        {
        }
        field(33020028;"WH Code";Code[10])
        {
            TableRelation = Location.Code;
        }
        field(33020029;"Skip PipeLine";Boolean)
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);

        ServiceItem.SETRANGE("Customer No.","No.");
        #4..36
        SalesLineDisc.SETRANGE("Sales Code","No.");
        SalesLineDisc.DELETEALL;

        SalesPrepmtPct.SETCURRENTKEY("Sales Type","Sales Code");
        SalesPrepmtPct.SETRANGE("Sales Type",SalesPrepmtPct."Sales Type"::Customer);
        SalesPrepmtPct.SETRANGE("Sales Code","No.");
        SalesPrepmtPct.DELETEALL;

        StdCustSalesCode.SETRANGE("Customer No.","No.");
        StdCustSalesCode.DELETEALL(TRUE);

        #48..127
        VATRegistrationLogMgt.DeleteCustomerLog(Rec);

        DimMgt.DeleteDefaultDim(DATABASE::Customer,"No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..39
        #45..130
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnInsert".

    //trigger (Variable: CustTemplate)()
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
        IF "No." = '' THEN BEGIN
          SalesSetup.GET;
          SalesSetup.TESTFIELD("Customer Nos.");
          NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        IF "Invoice Disc. Code" = '' THEN
          "Invoice Disc. Code" := "No.";

        IF NOT (InsertFromContact OR (InsertFromTemplate AND (Contact <> ''))) THEN
          UpdateContFromCust.OnInsert(Rec);

        DimMgt.UpdateDefaultDim(
          DATABASE::Customer,"No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CompanyInfo.GET;
        {IF CompanyInfo."Agni Hire Purchase Company" THEN //aakrista
          VALIDATE(Type,Type::Nominee);}
        //VALIDATE(Type,Type::Nominee);//aakrista commented

        IF "No." <> xRec."No." THEN BEGIN
          SalesSetup.GET;
          NoSeriesMgt.TestManual(SalesSetup."Customer Nos.");
          "No. Series" := '';
        END;
        #1..5
        //--------@yuran 19-jul-2013 Syncs No. Series in all companies>>
        //AgniMgt.SyncMasterData(DATABASE::Customer,"No.","No. Series");
        //--------@yuran 19-jul-2013 Syncs No. Series in all companies<<
        IF "Invoice Disc. Code" = '' THEN
          "Invoice Disc. Code" := "No.";
        //default vat posting group for customer
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Def. Taxable VAT Bus. Code");
        VALIDATE("VAT Bus. Posting Group",SalesSetup."Def. Taxable VAT Bus. Code");
        //default vat posting group for customer
        #10..15
        "Prices Including VAT" := FALSE;
        */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Last Date Modified" := TODAY;

        IF (Name <> xRec.Name) OR
        #4..7
           (City <> xRec.City) OR
           ("Phone No." <> xRec."Phone No.") OR
           ("Telex No." <> xRec."Telex No.") OR
           ("Territory Code" <> xRec."Territory Code") OR
           ("Currency Code" <> xRec."Currency Code") OR
           ("Language Code" <> xRec."Language Code") OR
           ("Salesperson Code" <> xRec."Salesperson Code") OR
           ("Country/Region Code" <> xRec."Country/Region Code") OR
           ("Fax No." <> xRec."Fax No.") OR
           ("Telex Answer Back" <> xRec."Telex Answer Back") OR
           ("VAT Registration No." <> xRec."VAT Registration No.") OR
           ("Post Code" <> xRec."Post Code") OR
           (County <> xRec.County) OR
           ("E-Mail" <> xRec."E-Mail") OR
        #22..28
            IF FIND THEN;
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..10
           ("Dealer Segment Type" <> xRec."Dealer Segment Type") OR
        #12..17
           //("VAT Registration No." <> xRec."VAT Registration No.") OR
        #19..31
        IF Saved THEN BEGIN
          UserSetup.GET(USERID); //MIN 4/12/2019
          IF NOT UserSetup."Can Edit Customer Card" THEN
           ERROR(NoModifyPermissionErr);
        END;
        */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: ContractTemp) (ParameterCollection) on "SetContractFilter(PROCEDURE 21)".


    //Unsupported feature: Parameter Insertion (Parameter: StatusPar) (ParameterCollection) on "SetContractFilter(PROCEDURE 21)".


    //Unsupported feature: Parameter Insertion (Parameter: SuspendedPar) (ParameterCollection) on "SetContractFilter(PROCEDURE 21)".


    //Unsupported feature: Parameter Insertion (Parameter: DocumentProfile) (ParameterCollection) on "SetContractFilter(PROCEDURE 21)".


    //Unsupported feature: Parameter Insertion (Parameter: Date) (ParameterCollection) on "SetContractFilter(PROCEDURE 21)".


    //Unsupported feature: Parameter Insertion (Parameter: VehicleSerialNo) (ParameterCollection) on "SetContractFilter(PROCEDURE 21)".


    //Unsupported feature: Variable Insertion (Variable: ContractVehicle) (VariableCollection) on "SetContractFilter(PROCEDURE 21)".


    //Unsupported feature: Property Modification (Name) on "CreateAndShowNewInvoice(PROCEDURE 21)".



    //Unsupported feature: Code Modification on "CreateAndShowNewInvoice(PROCEDURE 21)".

    //procedure CreateAndShowNewInvoice();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Invoice",SalesHeader)
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CLEAR(ContractTemp);
        Contract.RESET;
        Contract.SETRANGE("Bill-to Customer No.", "No.");
        Contract.SETRANGE("Contract Type", Contract."Contract Type"::Contract);
        Contract.SETFILTER("Document Profile", '%1|%2', Contract."Document Profile"::" ", DocumentProfile);
        Contract.SETRANGE("Starting Date", 0D, Date);
        Contract.SETFILTER("Expiration Date", '%1|>=%2', 0D, Date);
        Contract.SETRANGE(Status, StatusPar);
        Contract.SETRANGE(Suspended, SuspendedPar);
        IF Contract.FINDSET THEN
          REPEAT
            IF (VehicleSerialNo <> '') THEN BEGIN
              ContractVehicle.RESET;
              ContractVehicle.SETRANGE("Contract Type", Contract."Contract Type");
              ContractVehicle.SETRANGE("Contract No.", Contract."Contract No.");
              IF ContractVehicle.ISEMPTY THEN BEGIN
                ContractTemp.INIT;
                ContractTemp := Contract;
                ContractTemp.INSERT;
              END ELSE BEGIN
                ContractVehicle.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                IF ContractVehicle.FINDFIRST THEN BEGIN
                  ContractTemp.INIT;
                  ContractTemp := Contract;
                  ContractTemp.INSERT;
                END;
              END;
            END ELSE BEGIN
              ContractTemp.INIT;
              ContractTemp := Contract;
              ContractTemp.INSERT;
            END;
          UNTIL Contract.NEXT = 0;
        */
    //end;


    //Unsupported feature: Code Modification on "CreateAndShowNewCreditMemo(PROCEDURE 22)".

    //procedure CreateAndShowNewCreditMemo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Credit Memo",SalesHeader)
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
        PAGE.RUN(PAGE::"Credit Note",SalesHeader)
        */
    //end;

    procedure CreateAndShowNewInvoice()
    var
        SalesHeader: Record "36";
    begin
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Invoice",SalesHeader)
    end;

    procedure GetLinkedVendor(): Code[20]
    var
        ContBusRel: Record "5054";
    begin
        ContBusRel.SETCURRENTKEY("Link to Table","No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("No.","No.");
        IF ContBusRel.FIND('-') THEN BEGIN
          ContBusRel.SETRANGE("Contact No.",ContBusRel."Contact No.");
          ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
          ContBusRel.SETRANGE("No.");
          IF ContBusRel.FIND('-') THEN
            EXIT(ContBusRel."No.");
        END;
    end;

    procedure GetFirstBankAccount(Customer: Record "18"): Text[30]
    var
        CustBankAccount: Record "287";
    begin
        CustBankAccount.RESET;
        CustBankAccount.SETRANGE("Customer No.", Customer."No.");
        IF CustBankAccount.FINDFIRST THEN
          EXIT(CustBankAccount.IBAN)
        ELSE
          EXIT('');
    end;

    procedure ShowVehicles()
    var
        ContBusRel: Record "5054";
        VehicleContact: Record "25006013";
    begin
        ContBusRel.RESET;
        ContBusRel.SETCURRENTKEY("Link to Table","No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("No.","No.");
        IF ContBusRel.FINDFIRST THEN BEGIN
          VehicleContact.RESET;
          VehicleContact.SETCURRENTKEY("Contact No.");
          VehicleContact.SETRANGE("Contact No.",ContBusRel."Contact No.");
          PAGE.RUNMODAL(PAGE::"Contact Vehicles",VehicleContact);
        END;
    end;

    procedure GetActiveContractQty(StatusPar: Option Inactive,Active;SuspendedPar: Boolean;DocumentProfile: Option " ","Spare Parts Trade",,Service;Date: Date;VehicleSerialNo: Code[20]) RetVal: Integer
    var
        ContractTemp: Record "25006016" temporary;
    begin
        SetContractFilter(ContractTemp, StatusPar, SuspendedPar, DocumentProfile, Date, VehicleSerialNo);
        EXIT(ContractTemp.COUNT);
    end;

    procedure ShowActiveContracts(StatusPar: Option Inactive,Active;SuspendedPar: Boolean;DocumentProfile: Option " ","Spare Parts Trade",,Service;Date: Date;VehicleSerialNo: Code[20])
    var
        ContractQty: Integer;
        ContractTemp: Record "25006016" temporary;
    begin
        SetContractFilter(ContractTemp, StatusPar, SuspendedPar, DocumentProfile, Date, VehicleSerialNo);
        ContractQty := ContractTemp.COUNT;
        IF ContractQty = 0 THEN
          EXIT;
        IF ContractQty = 1 THEN BEGIN
          IF Contract.GET(ContractTemp."Contract Type", ContractTemp."Contract No.") THEN
            PAGE.RUNMODAL(PAGE::Contract, Contract);
        END ELSE
          PAGE.RUNMODAL(PAGE::"Contract List EDMS", ContractTemp);
    end;

    procedure GetInsertFromContact(): Boolean
    begin
        EXIT(InsertFromContact);
    end;

    local procedure phoneNoValidation(Ph: Text)
    begin
        IF Ph <> '' THEN BEGIN
          IF COPYSTR(Ph,1,4) <> '+977' THEN
            ERROR('Phone number should start from +977');
          END;
    end;

    //Unsupported feature: Deletion (VariableCollection) on "CreateAndShowNewInvoice(PROCEDURE 21).SalesHeader(Variable 1000)".


    var
        CustTemplate: Record "5105";
        Cust: Record "18";

    var
        Cust: Record "18";

    var
        UserSetup: Record "91";
        Contract: Record "25006016";

    var
        Text100: Label 'Do you want to use a Customer Template to create a Customer?';

    var
        Text101: Label 'The Creation of the customer has been aborted.';

    var
        Text26500: Label 'Customer with the same %1 already exists.';
        tcDMS005: Label 'You have no right to block/unblock customer!';
        CompanyRec: Record 2000000006;
        NoSeriesLine: Record 309;
        LastNoUsed: Code[10];
        AgniMgt: Codeunit 50000;
        CustPostingGrp: Record 92;
        NoModifyPermissionErr: Label 'You do not have permission to modify customer card.';
        VFSetup: Record 33020064;
        NomineeList: Page 33020129;
                         Customer: Record 18;
                         HirePurchaseSetup: Record 33020064;
                         CompanyInfo: Record 79;
                         Text016: Label 'Mobile No. cannot be more than 20 digits.';
        Text017: Label 'Phone No. cannot be more than 20 digits.';
}

