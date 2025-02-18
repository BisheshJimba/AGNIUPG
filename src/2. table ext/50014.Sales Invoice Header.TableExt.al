tableextension 50014 tableextension50014 extends "Sales Invoice Header"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 23.01.2013 EDMS P8
    //   * Added fields: Resources
    // 
    // 21.07.2008. EDMS P2
    //   * Added key "DMS Service Order No.,DMS Service Document"
    // 
    // 24.09.2007. EDMS P2
    //   * Added new field Kilometrage
    // 
    // 06.08.2007. EDMS P2
    //   * Added new key "Posting Date"
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Bill-to Name"(Field 5)".


        //Unsupported feature: Property Modification (Data type) on ""Bill-to Name 2"(Field 6)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name"(Field 13)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name 2"(Field 14)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }

        //Unsupported feature: Property Modification (Data type) on ""Sell-to Customer Name"(Field 79)".


        //Unsupported feature: Property Modification (Data type) on ""Sell-to Customer Name 2"(Field 80)".


        //Unsupported feature: Property Modification (CalcFormula) on "Closed(Field 1302)".


        //Unsupported feature: Property Modification (CalcFormula) on "Cancelled(Field 1310)".


        //Unsupported feature: Property Modification (CalcFormula) on "Corrective(Field 1311)".

        field(50001; "Battery Document"; Boolean)
        {
        }
        field(50002; "Direct Sales"; Boolean)
        {
            Description = '//for direct vehicle sales';
        }
        field(50003; "Vehicle Regd. No."; Code[30])
        {
            // FieldClass = FlowField;
            // CalcFormula = Lookup ("Posted Serv. Order Header"."Vehicle Registration No." WHERE ("Order No."=FIELD("Service Order No."))); //need to solve table error
        }
        field(50004; "Salesperson Name"; Text[50])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Salesperson Code")));
        }
        field(50005; "VIN from Posted Service"; Code[20])
        {
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Posted Serv. Order Header".VIN WHERE ("Order No."=FIELD("Service Order No."))); //need to solve table error
        }
        field(50006; "DRP No./ARE1 No."; Code[20])
        {
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."DRP No./ARE1 No." WHERE ("Serial No."=FIELD("Vehicle Sr. No."))); //need to solve table error
        }
        field(50007; "VIN - Vehicle Sales"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Sr. No.")));
        }
        field(50008; "Direct Sales Commission No."; Code[20])
        {
            Editable = false;
            TableRelation = "G/L Entry"."Document No." WHERE("G/L Account No." = CONST('308014'));
        }
        field(50009; "Prospect Line No."; Integer)
        {
            Description = 'CNY.CRM Populate Pipeline Management Details for the Prospect';
            // TableRelation = "Pipeline Management Details"."Line No." WHERE ("Prospect No."=FIELD("Sell-to Contact No."),
            //                                                                 "Pipeline Status"=CONST(Open));//need to solve table error
        }
        field(50011; "Return Reason"; Code[10])
        {
            TableRelation = "Return Reason".Code;
        }
        field(50040; Returned; Boolean)
        {
            Editable = false;
        }
        field(50041; "Sales Return No."; Code[20])
        {
            Editable = false;
            TableRelation = "Sales Cr.Memo Header"."No.";
        }
        field(50042; "Vehicle Sr. No."; Code[20])
        {
            Description = 'For Vehicle Trade';
            TableRelation = Vehicle."Serial No.";
        }
        field(50043; "Make Code - VT"; Code[20])
        {
            Description = 'For Vehicle Trade';
            FieldClass = FlowField;
            TableRelation = Make;
            CalcFormula = Lookup(Vehicle."Make Code" WHERE("Serial No." = FIELD("Vehicle Sr. No.")));
        }
        field(50044; "Model Code - VT"; Code[20])
        {
            Description = 'For Vehicle Trade';
            FieldClass = FlowField;
            TableRelation = Model.Code;
            CalcFormula = Lookup(Vehicle."Model Code" WHERE("Serial No." = FIELD("Vehicle Sr. No.")));
        }
        field(50045; "Model Version No. - VT"; Code[20])
        {
            Description = 'For Vehicle Trade';
            // FieldClass = FlowField;
            TableRelation = Item;
            // CalcFormula = Lookup(Vehicle."Model Version No." WHERE ("Serial No."=FIELD("Vehicle Sr. No."))); //need to solve table error
        }
        field(50046; "Approx Estimate"; Decimal)
        {
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Posted Serv. Order Header"."Approx. Estimation" WHERE ("Order No."=FIELD("Service Order No."))); //need to solve table error
        }
        field(50047; "Vehicle Segment"; Code[20])
        {
            Description = 'For Vehicle Trade';
        }
        field(50048; "Remaining-Amount"; Decimal)
        {
            Editable = false;
        }
        field(50055; "Invertor Serial No."; Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(50056; "RV RR Code"; Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Revisit,Repeat Repair';
            OptionMembers = " ",Revisit,"Repeat Repair";
        }
        field(50057; "Quality Control"; Code[20])
        {
            Description = 'PSF';
            TableRelation = Resource;
        }
        field(50059; "Floor Control"; Code[20])
        {
            Description = 'PSF';
            TableRelation = Resource;
        }
        field(50060; "Insurance Type"; Code[20])
        {
        }
        field(50097; Dispatched; Boolean)
        {
            Description = 'For Vehicle Trade';
        }
        field(50098; "Vehicle Location"; Code[20])
        {
            Description = 'For Vehicle Trade';
            // FieldClass = FlowField;
            TableRelation = Vehicle;
            // CalcFormula = Lookup(Vehicle."Current Location of VIN" WHERE ("Serial No."=FIELD("Vehicle Sr. No."))); //need to solve table error
        }
        field(50099; "Commission Posted"; Boolean)
        {
            Editable = true;
        }
        field(60000; "Allotment Date"; Date)
        {
        }
        field(60001; "Allotment Time"; Time)
        {
        }
        field(60002; "Confirmed Time"; Time)
        {
        }
        field(60003; "Confirmed Date"; Date)
        {
        }
        field(70000; "Dealer PO No."; Code[20])
        {
            Description = 'For Dealer Portal';
        }
        field(70001; "Dealer Tenant ID"; Code[30])
        {
            Description = 'For Dealer Portal';
        }
        field(70002; "Dealer Line No."; Integer)
        {
            Description = 'For Dealer Portal';
        }
        field(70003; "Order Type"; Option)
        {
            OptionCaption = ' ,Stock order,Rush Order,VOR order,Accidental';
            OptionMembers = " ","Stock order","Rush Order","VOR order",Accidental;
        }
        field(70004; "Swift Code"; Text[50])
        {
        }
        field(70005; "Ship Add Name 2"; Text[50])
        {
            Description = 'for shipping address';
        }
        field(90160; "Sync Status"; Option)
        {
            Caption = 'Job Queue Status';
            Editable = false;
            OptionCaption = ' ,Scheduled for Sync,Error,Synched,Synching';
            OptionMembers = " ","Scheduled for Sync",Error,Synched,Synching;

            trigger OnLookup()
            var
                JobQueueEntry: Record "Job Queue Entry";
            begin
            end;
        }
        field(90161; "Sync Queue Entry ID"; Guid)
        {
            Caption = 'Job Queue Entry ID';
            Editable = false;
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006005; "Prepmt. Bill-to Cust. Changed"; Boolean)
        {
            Caption = 'Prepmt. Bill-to Cust. Changed';
        }
        field(25006120; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
        }
        field(25006130; "Service Document"; Boolean)
        {
            Caption = 'Service Document';
        }
        field(25006140; "Order Creator"; Code[10])
        {
            Caption = 'Order Creator';
            Description = 'Internal';
            TableRelation = "Salesperson/Purchaser";
        }
        field(25006150; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006170; "Vehicle Registration No."; Code[30])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE ("Serial No."=FIELD("Vehicle Serial No.")));//need to solve table error
        }
        field(25006276; "Warranty Claim No."; Code[20])
        {
            Caption = 'Warranty Claim No.';
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Make;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Model.Code WHERE("Make Code" = FIELD("Make Code"));
        }
        field(25006372; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only For Service or Spare Parts Trade';
            // TableRelation = Item."No." WHERE (Type=CONST("Model Version"),
            //                                 "Make Code"=FIELD("Make Code"),
            //                                 "Model Code"=FIELD("Model Code"));//need to add in table and option in type

            trigger OnLookup()
            var
                recModelVersion: Record Item;
            begin
                recModelVersion.RESET;
                IF cuLookUpMgt.LookUpModelVersion(recModelVersion, "Model Version No.", "Make Code", "Model Code") THEN;//internal scope error
            end;
        }
        field(25006377; "Quote Applicable To Date"; Date)
        {
            Caption = 'Quote Applicable To Date';
        }
        field(25006378; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006390; "Vehicle Item Charge No."; Code[20])
        {
            Caption = 'Vehicle Item Charge No.';
            TableRelation = "Item Charge";
        }
        field(25006391; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(25006392; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
        }
        field(25006400; Resources; Code[100])
        {
        }
        field(25006670; VIN; Code[20])
        {
            Caption = 'VIN';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Vehicle;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,112,25006800';
            Enabled = false;

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                // IF cuLookUpMgt.LookUpVariableField(VFOptions, DATABASE::Vehicle, FIELDNO("Variable Field 25006800"), "Make Code", "Variable Field 25006800") THEN BEGIN//internal scope error
                begin
                    VALIDATE("Variable Field 25006800", VFOptions.Code);
                END;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,112,25006801';
            Enabled = false;

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                // IF cuLookUpMgt.LookUpVariableField(VFOptions, DATABASE::Vehicle, FIELDNO("Variable Field 25006801"),"Make Code", "Variable Field 25006801") THEN BEGIN//internal scope error
                begin
                    VALIDATE("Variable Field 25006801", VFOptions.Code);
                END;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,112,25006802';
            Enabled = false;

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                // IF cuLookUpMgt.LookUpVariableField(VFOptions, DATABASE::Vehicle, FIELDNO("Variable Field 25006802"),"Make Code", "Variable Field 25006802") THEN BEGIN//internal scope error
                begin
                    VALIDATE("Variable Field 25006802", VFOptions.Code);
                END;
            end;
        }
        field(25006995; Kilometrage; Decimal)
        {
        }
        field(25006996; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,112,25006996';
            Enabled = false;
        }
        field(25006997; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,112,25006997';
            Enabled = false;
        }
        field(33019833; "Job Finished Date"; Date)
        {
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011; "Sys. LC No."; Code[20])
        {
            Caption = 'LC No.';
            // TableRelation = "LC Details"."No." WHERE ("Transaction Type"=CONST(Sale),
            //                                         "Issued To/Received From"=FIELD("Sell-to Customer No."),
            //                                         Released=CONST(Yes),
            //                                         Closed=CONST(No));//need to solve table error

            trigger OnValidate()
            var
                LCDetail: Record "LC Details";
                LCAmendDetail: Record "LC Amend. Details";
                Text33020011: Label 'LC has amendments and amendment is not released.';
                Text33020012: Label 'LC has amendments and  amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
            end;
        }
        field(33020012; "Bank LC No."; Code[20])
        {
        }
        field(33020013; "LC Amend No."; Code[20])
        {
            Caption = 'Amendment No.';
            TableRelation = "LC Amend. Details"."Version No." WHERE("No." = FIELD("Sys. LC No."));
        }
        field(33020014; "Posted Serv. Order No."; Code[20])
        {
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Posted Serv. Order Header"."No." WHERE ("Order No."=FIELD("Service Order No.")));//need to solve table error
        }
        field(33020017; "Financed By"; Code[20])
        {
            Description = 'Financed Bank';
            TableRelation = Contact;
        }
        field(33020018; "Re-Financed By"; Code[20])
        {
            Description = 'Re-Financed Bank';
            TableRelation = Contact;
        }
        field(33020019; "Financed Amount"; Decimal)
        {
        }
        field(33020235; "Job Type"; Code[20])
        {
            Editable = true;
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Posted Serv. Order Header"."Job Type" WHERE ("Order No."=FIELD("Service Order No.")));//need to solve error in table
        }
        field(33020236; "Package No."; Code[20])
        {
            Editable = false;
            TableRelation = "Service Package"."No.";
        }
        field(33020244; "Job Type (Before Posting)"; Code[20])
        {
        }
        field(33020245; "Debit Note"; Boolean)
        {
        }
        field(33020247; "Warranty Settlement"; Boolean)
        {
        }
        field(33020248; "GPD PO No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Inv. Header"."Order No." WHERE("No." = FIELD("External Document No.")));
        }
        field(33020252; "Scheme Code"; Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253; "Membership No."; Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020267; "Delay Reason Code"; Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Additional Job,Parts Not Avilable,Parts Delay,Diagnosis And Troubleshooting,Customer Approval Delay,ERP Issue,Internet Issue';
            OptionMembers = " ","Additional Job","Parts Not Avilable","Parts Delay","Diagnosis And Troubleshooting","Customer Approval Delay","ERP Issue","Internet Issue";
        }
        field(33020272; "Insurance Company Name"; Text[30])
        {
        }
        field(33020273; "Insurance Policy Number"; Code[20])
        {
        }
        field(33020299; "Warranty Settlement (Battery)"; Boolean)
        {
        }
        field(33020300; "Financed By Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Financed By")));
        }
        field(33020301; Check; Boolean)
        {
            Description = 'For Commercial Invoice';
        }
        field(33020302; "Commercial Invoiced"; Boolean)
        {
        }
        field(33020311; "Posting Time"; Time)
        {
        }
        field(33020312; "Tax Invoice Printed By"; Code[50])
        {
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(33020500; "Booked Date"; Date)
        {
        }
        field(33020510; "Tender Sales"; Boolean)
        {
        }
        field(33020511; "Job Category"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI;
        }
        field(33020512; "Advance Payment"; Boolean)
        {
        }
        field(33020513; "Scheme Type"; Code[20])
        {
            TableRelation = "Service Scheme Line";
        }
        field(33020600; "Service Type"; Option)
        {
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,6th type service,7th type Service,8th type Service,Bonus,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service","6th type Service","7th type Service"," 8th type Service",Bonus,Other;

            trigger OnValidate()
            var
                NotAllowed: Label 'Job Category must be Under Warranty';
            begin
            end;
        }
        field(33020601; "Posted By"; Code[50])
        {
        }
        field(33020605; "Forward Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020606; "Forward Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(33020607; "Forwarded PI Quotes"; Code[20])
        {
        }
        field(33020608; "Province No."; Option)
        {
            OptionCaption = ' ,Province 1, Province 2, Bagmati Province, Gandaki Province, Province 5, Karnali Province, Sudur Pachim Province ';
            OptionMembers = " ","Province 1"," Province 2"," Bagmati Province"," Gandaki Province"," Province 5"," Karnali Province"," Sudur Pachim Province";
        }
        field(33020609; "Dealer VIN"; Code[20])
        {
        }
        field(33020610; "Revisit Repair Reason"; Code[20])
        {
            Description = 'PSF';
        }
        field(33020611; "Resource PSF"; Code[20])
        {
        }
        field(33020612; "Fleet No."; Code[20])
        {
            TableRelation = "Fixed Asset" WHERE("FA Class Code" = CONST('BUS/AUTO'),
                                                 "Responsible Employee" = CONST(''));
        }
        field(33020613; "Total CBM"; Decimal)
        {
            DecimalPlaces = 10 : 10;
            // FieldClass = FlowField;
            // CalcFormula = Sum("Sales Invoice Line".CBM WHERE ("Document No."=FIELD("No.")));//need to add in table
        }
        field(33020614; Trip; Text[2])
        {
        }
        field(33020615; "Trip Start Date"; Date)
        {
        }
        field(33020616; "Trip Start Time"; Time)
        {
        }
        field(33020617; "Trip End Date"; Date)
        {
        }
        field(33020618; "Trip End Time"; Time)
        {
        }
    }
    keys
    {
        key(Key1; "Document Profile")
        {
        }
        key(Key2; "Vehicle Serial No.")
        {
        }
        key(Key3; "Service Order No.", "Service Document")
        {
        }
        // key(Key4;"Shortcut Dimension 1 Code","Posting Date")
        // {
        // } //field does not exist issue
        key(Key5; "Debit Note")
        {
        }

        //Unsupported feature: Move on ""Document Exchange Status"(Key)".

    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    PostSalesDelete.IsDocumentDeletionAllowed("Posting Date");
    TESTFIELD("No. Printed");
    LOCKTABLE;
    #4..9
    ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
    PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetSalesDeferralDocType,'','',
      SalesCommentLine."Document Type"::"Posted Invoice","No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ERROR('Posted Sales Invoice can not be deleted.');
    #1..12
    */
    //end;


    //Unsupported feature: Code Modification on "SetSecurityFilterOnRespCenter(PROCEDURE 5)".

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
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    {
    #1..5
    }
    */
    //end;


    //Unsupported feature: Code Modification on "ShowCorrectiveCreditMemo(PROCEDURE 19)".

    //procedure ShowCorrectiveCreditMemo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CALCFIELDS(Cancelled);
    IF NOT Cancelled THEN
      EXIT;

    IF CancelledDocument.FindSalesCancelledInvoice("No.") THEN BEGIN
      SalesCrMemoHeader.GET(CancelledDocument."Cancelled By Doc. No.");
      PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
      PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader);
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "ShowCancelledCreditMemo(PROCEDURE 20)".

    //procedure ShowCancelledCreditMemo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CALCFIELDS(Corrective);
    IF NOT Corrective THEN
      EXIT;

    IF CancelledDocument.FindSalesCorrectiveInvoice("No.") THEN BEGIN
      SalesCrMemoHeader.GET(CancelledDocument."Cancelled Doc. No.");
      PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
      PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader);
    END;
    */
    //end;

    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(cuVFMgt);
        // EXIT(cuVFMgt.IsVFActive(DATABASE::"Sales Invoice Header",intFieldNo));//internal scope issue
    end;

    procedure PrintRecords2(ShowRequestForm: Boolean)
    var
        SalesInvHeader: Record "Sales Invoice Header";
        DocumentReport: Record "Document Report";
        DocumentProfile: Option ,"Spare Parts Trade","Vehicles Trade",Service;
        FunctionalType: Option " ",Sale,Purchase,Service;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,Transfer,"Posted Order","Posted Invoice","Posted Credit Memo","Posted Return Order","Posted Shipment",Contract,"Process Checklist";
    begin
        //Sipradi-YS *Code to use document selection table for report
        SalesInvHeader.COPY(Rec);
        SalesInvHeader.FIND('-');
        DocumentReport.RESET;
        DocumentReport.SETRANGE("Document Profile", SalesInvHeader."Document Profile");
        DocumentReport.SETRANGE("Document Functional Type", FunctionalType::Sale);
        DocumentReport.SETRANGE("Document Type", DocumentType::Invoice);
        IF DocumentReport.FINDSET THEN
            REPEAT
                DocumentReport.TESTFIELD("Report ID");
                REPORT.RUNMODAL(DocumentReport."Report ID", ShowRequestForm, FALSE, SalesInvHeader);
            UNTIL DocumentReport.NEXT = 0;
    end;

    var
        cuLookUpMgt: Codeunit LookUpManagement;
        cuVFMgt: Codeunit "Variable Field Management";
}

