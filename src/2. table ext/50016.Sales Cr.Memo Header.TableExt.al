tableextension 50016 tableextension50016 extends "Sales Cr.Memo Header"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 11.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 23.07.2008. EDMS P2
    //   * Added keey "DMS Service Order No.,DMS Service Document"
    // 
    // 24.09.2007. EDMS P2
    //   * Added new field Kilometrage
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


        //Unsupported feature: Property Modification (CalcFormula) on "Paid(Field 1302)".


        //Unsupported feature: Property Modification (CalcFormula) on "Cancelled(Field 1310)".


        //Unsupported feature: Property Modification (CalcFormula) on "Corrective(Field 1311)".

        field(50006; "DRP No./ARE1 No."; Code[20])
        {
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."DRP No./ARE1 No." WHERE("Serial No." = FIELD("Vehicle Sr. No."))); //need to solce table error
        }
        field(50007; "VIN - Vehicle Sales"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Sr. No.")));
        }
        field(50008; "Direct Sales Commission No."; Code[20])
        {
            TableRelation = "G/L Entry";
        }
        field(50011; "Return Reason"; Code[10])
        {
            TableRelation = "Return Reason".Code;
        }
        field(50042; "Vehicle Sr. No."; Code[20])
        {
            Description = 'For Vehicle Trade';
            TableRelation = Vehicle."Serial No.";
        }
        field(50043; "Make Code - VT"; Code[20])
        {
            Description = 'For Vehicle Trade';
            TableRelation = Make;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle."Make Code" WHERE("Serial No." = FIELD("Vehicle Sr. No.")));
        }
        field(50044; "Model Code - VT"; Code[20])
        {
            Description = 'For Vehicle Trade';
            FieldClass = FlowField;
            TableRelation = Model;
            CalcFormula = Lookup(Vehicle."Model Code" WHERE("Serial No." = FIELD("Vehicle Sr. No.")));
        }
        field(50045; "Model Version No. - VT"; Code[20])
        {
            Description = 'For Vehicle Trade';
            TableRelation = Item;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."Model Version No." WHERE("Serial No." = FIELD("Vehicle Sr. No.")));//need to solve table error
        }
        field(50055; "Invertor Serial No."; Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(50056; "RV RR Code"; Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Revisit,Repair';
            OptionMembers = " ",Revisit,Repair;
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
        field(25006007; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
        }
        field(25006120; "Service Return Order No."; Code[20])
        {
            Caption = 'Service Return Order No.';
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
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE("Serial No." = FIELD("Vehicle Serial No.")));//need to solve table error
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
            // TableRelation = Item."No." WHERE("Item Type" = CONST("Model Version"), //need to add item type in item
            //                                 "Make Code" = FIELD("Make Code"),
            //                                 "Model Code" = FIELD("Model Code"));

            trigger OnLookup()
            var
                recModelVersion: Record Item;
            begin
                recModelVersion.RESET;
                // IF cuLookUpMgt.LookUpModelVersion(recModelVersion, "Model Version No.", "Make Code", "Model Code") THEN; //internal scope issue
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
            FieldClass = FlowField;
            TableRelation = Vehicle;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,114,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                // IF cuLookUpMgt.LookUpVariableField(VFOptions, DATABASE::Vehicle, FIELDNO("Variable Field 25006800"), "Make Code", "Variable Field 25006800") THEN BEGIN //internal scope issue
                //     VALIDATE("Variable Field 25006800", VFOptions.Code);
                // END;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,114,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                // IF cuLookUpMgt.LookUpVariableField(VFOptions, DATABASE::Vehicle, FIELDNO("Variable Field 25006801"), //internal scope issue
                //   "Make Code", "Variable Field 25006801") THEN BEGIN
                //     VALIDATE("Variable Field 25006801", VFOptions.Code);
                // END;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,114,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                // IF cuLookUpMgt.LookUpVariableField(VFOptions, DATABASE::Vehicle, FIELDNO("Variable Field 25006802"), //internal scope issue
                //   "Make Code", "Variable Field 25006802") THEN BEGIN
                //     VALIDATE("Variable Field 25006802", VFOptions.Code);
                // END;
            end;
        }
        field(25006995; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,114,25006995';
        }
        field(25006996; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,114,25006996';
        }
        field(25006997; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,114,25006997';
        }
        field(25006998; "Automatic CM Item Return"; Boolean)
        {
            Caption = 'Automatic CM Item Return';
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011; "Sys. LC No."; Code[20])
        {
            Caption = 'LC No.';
            // TableRelation = "LC Details"."No." WHERE("Transaction Type" = CONST(Sale),
            //                                         "Issued To/Received From" = FIELD("Sell-to Customer No."),
            //                                         Released = const(Yes), //need to solve table error
            //                                         Closed = CONST(No));

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
        field(33020244; "Job Type (Before Posting)"; Code[20])
        {
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
        field(33020311; "Posting Time"; Time)
        {
        }
        field(33020312; "Printed By"; Code[50])
        {
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
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
        field(99008509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
        }
        field(99008510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
        }
        field(99008517; "BizTalk Sales Credit Memo"; Boolean)
        {
            Caption = 'BizTalk Sales Credit Memo';
        }
        field(99008521; "BizTalk Document Sent"; Boolean)
        {
            Caption = 'BizTalk Document Sent';
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
        key(Key3; "Service Return Order No.", "Service Document")
        {
        }
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
      SalesCommentLine."Document Type"::"Posted Credit Memo","No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ERROR('Posted Sales Credit Memo can not be deleted');
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

    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(cuVFMgt);
        // EXIT(cuVFMgt.IsVFActive(DATABASE::"Sales Cr.Memo Header",intFieldNo)); //internal scope error
    end;

    procedure PrintRecords2(ShowRequestForm: Boolean)
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        DocumentReport: Record "Document Report";
        DocumentProfile: Option ,"Spare Parts Trade","Vehicles Trade",Service;
        FunctionalType: Option " ",Sale,Purchase,Service;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,Transfer,"Posted Order","Posted Invoice","Posted Credit Memo","Posted Return Order","Posted Shipment",Contract,"Process Checklist";
    begin
        /*WITH SalesCrMemoHeader DO BEGIN
          COPY(Rec);
          FIND('-');
          ReportSelection.SETRANGE(Usage,ReportSelection.Usage::"S.Cr.Memo");
          ReportSelection.SETFILTER("Report ID",'<>0');
          ReportSelection.FIND('-');
          REPEAT
            REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,FALSE,SalesCrMemoHeader);
          UNTIL ReportSelection.NEXT = 0;
        END;
        */
        SalesCrMemoHeader.COPY(Rec);
        SalesCrMemoHeader.FIND('-');
        DocumentReport.RESET;
        DocumentReport.SETRANGE("Document Profile", SalesCrMemoHeader."Document Profile");
        DocumentReport.SETRANGE("Document Functional Type", FunctionalType::Sale);
        DocumentReport.SETRANGE("Document Type", DocumentType::"Credit Memo");
        DocumentReport.FINDSET;
        REPEAT
            DocumentReport.TESTFIELD("Report ID");
            REPORT.RUNMODAL(DocumentReport."Report ID", ShowRequestForm, FALSE, SalesCrMemoHeader);
        UNTIL DocumentReport.NEXT = 0;

    end;

    var
        cuLookUpMgt: Codeunit LookUpManagement;
        cuVFMgt: Codeunit "Variable Field Management";
}

