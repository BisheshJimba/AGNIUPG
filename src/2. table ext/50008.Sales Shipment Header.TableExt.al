tableextension 50008 tableextension50008 extends "Sales Shipment Header"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."

    //Unsupported feature: Property Insertion (Permissions) on ""Sales Shipment Header"(Table 110)".

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

        field(50008; "Direct Sales Commission No."; Code[20])
        {
            TableRelation = "G/L Entry"."Document No." WHERE("G/L Account No." = CONST('308014'));
        }
        field(50011; "Return Reason"; Code[10])
        {
            TableRelation = "Return Reason".Code;
        }
        field(50055; "Invertor Serial No."; Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
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
        field(25006120; "Service Order No. EDMS"; Code[20])
        {
            Caption = 'Service Order No. EDMS';
        }
        field(25006130; "Service Document EDMS"; Boolean)
        {
            Caption = 'Service Document EDMS';
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
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE(Serial No.=FIELD(Vehicle Serial No.))); //need to solve table error
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
            // TableRelation = Item."No." WHERE("Item Type" = CONST("Model Version"), //need to add item type
            //                                 "Make Code" = FIELD("Make Code"),
            //                                 "Model Code" = FIELD("Model Code"));

            trigger OnLookup()
            var
                recModelVersion: Record Item;
            begin
                recModelVersion.RESET;
                // IF cuLookUpMgt.LookUpModelVersion(recModelVersion, "Model Version No.", "Make Code", "Model Code") THEN; //need to solve error in codeunit
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
        field(25006391; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(25006392; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
        }
        field(25006670; VIN; Code[20])
        {
            Caption = 'VIN';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Vehicle;
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
            // TableRelation = "LC Details"."No." WHERE("Transaction Type"=CONST(Sale),
            //                                         "Issued To/Received From"=FIELD("Sell-to Customer No."),
            //                                         Released=CONST(Yes), //need to solve table error
            //                                         Closed=CONST(No));

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
        field(33020017; "Financed By"; Code[20])
        {
            Description = 'Financed Bank';
            TableRelation = Contact;
        }
        field(33020018; "Re-Financed By"; Code[20])
        {
            Description = 'To Account';
            TableRelation = Contact;
        }
        field(33020019; "Financed Amount"; Decimal)
        {
        }
        field(33020235; "Job Type"; Code[20])
        {
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Posted Serv. Order Header"."Job Type" WHERE ("Order No."=FIELD("Service Order No. EDMS"))); //need to solve error in table
        }
        field(33020236; "Package No."; Code[20])
        {
            Editable = false;
            TableRelation = "Service Package"."No.";
        }
        field(33020244; "Job Type (Before Posting)"; Code[20])
        {
        }
        field(33020248; "Vehicle Delivered"; Boolean)
        {
        }
        field(33020249; "Vehicle Delivery Date"; Date)
        {
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
        field(33020613; "Total CBM"; Decimal)
        {
            DecimalPlaces = 10 : 10;
            // FieldClass = FlowField;
            // CalcFormula = Sum("Sales Shipment Line".CBM WHERE("Document No." = FIELD("No."), //need to solve error in table
            //                                                    Quantity = FILTER(<> 0)));
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
        field(99008515; "BizTalk Shipment Notification"; Boolean)
        {
            Caption = 'BizTalk Shipment Notification';
        }
        field(99008519; "Customer Order No."; Code[20])
        {
            Caption = 'Customer Order No.';
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
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TESTFIELD("No. Printed");
    LOCKTABLE;
    PostSalesDelete.DeleteSalesShptLines(Rec);
    #4..9

    IF CertificateOfSupply.GET(CertificateOfSupply."Document Type"::"Sales Shipment","No.") THEN
      CertificateOfSupply.DELETE(TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ERROR('Posted Sales Shipment can not be deleted');
    #1..12
    */
    //end;

    procedure PrintRecords2(ShowRequestForm: Boolean)
    var
        DocumentReport: Record "Document Report";
        SalesShptHeader: Record "Sales Shipment Header"; //added var
        DocumentProfile: Option ,"Spare Parts Trade","Vehicles Trade",Service;
        FunctionalType: Option " ",Sale,Purchase,Service;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,Transfer,"Posted Order","Posted Invoice","Posted Credit Memo","Posted Return Order","Posted Shipment",Contract,"Process Checklist";
    begin
        //Sipradi-YS *Code to use document selection table for report
        // WITH SalesShptHeader DO BEGIN
        //     COPY(Rec);
        //     FIND('-');
        //     DocumentReport.RESET;
        //     DocumentReport.SETRANGE("Document Profile", SalesShptHeader."Document Profile");
        //     DocumentReport.SETRANGE("Document Functional Type", FunctionalType::Sale);
        //     DocumentReport.SETRANGE("Document Type", DocumentType::Shipment);
        //     DocumentReport.FINDSET;
        //     REPEAT
        //         DocumentReport.TESTFIELD("Report ID");
        //         REPORT.RUNMODAL(DocumentReport."Report ID", ShowRequestForm, FALSE, SalesShptHeader);
        //     UNTIL DocumentReport.NEXT = 0;
        // END;
        SalesShptHeader.Copy(Rec);
        if SalesShptHeader.FindFirst() then begin
            DocumentReport.Reset();
            DocumentReport.SetRange("Document Profile", SalesShptHeader."Document Profile");
            DocumentReport.SetRange("Document Functional Type", FunctionalType::Sale);
            DocumentReport.SetRange("Document Type", DocumentType::Shipment);
            if DocumentReport.FindSet() then
                repeat
                    DocumentReport.TestField("Report ID");
                    Report.RunModal(DocumentReport."Report ID", ShowRequestForm, false, SalesShptHeader);
                until DocumentReport.Next() = 0;
        end;
    end;

    procedure DeliverVehicle(var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        Vehicle: Record Vehicle;
        SalesShipmentLine: Record "Sales Shipment Line";
        Text000: Label 'Vehicle %1 is now delivered from the system.Please Report Print Vehicle Delivery';
        Vehi: Record "Vehicles With Flowfield";
    begin
        SalesShipmentLine.RESET;
        SalesShipmentLine.SETRANGE("Document No.", SalesShipmentHeader."No.");
        IF SalesShipmentLine.FINDFIRST THEN BEGIN
            Vehicle.RESET;
            // Vehicle.SETRANGE("Serial No.", SalesShipmentLine."Vehicle Serial No."); //need to add vehicle serial no
            Vehicle.FINDFIRST;
            // IF Vehi.GET(SalesShipmentLine."Vehicle Serial No.") THEN;
            // Vehi.CALCFIELDS("Sales Invoice No."); //***SM 28-07-2013 sales invoice must be done before the vehicle delivery //v2 //need to add sales invoice no
            // Vehi.TESTFIELD("Sales Invoice No.");//v2
            // Vehi.CALCFIELDS("Insurance Policy No."); //need to solve table error
            // Vehi.TESTFIELD("Insurance Policy No.");//***SM 28-07-2013 ins. policy no. before the vehicle delivery //v2
            // Vehicle."Vehicle Delivered" := TRUE; //need to solve table error
            // Vehicle."Vehicle Delivery Date" := TODAY; //need to solve table error
            Vehicle.MODIFY;
            MESSAGE(Text000, Vehicle.VIN);
        END;

        SalesShipmentHeader."Vehicle Delivered" := TRUE;
        SalesShipmentHeader."Vehicle Delivery Date" := TODAY;
        SalesShipmentHeader.MODIFY;
    end;

    var
        // cuLookUpMgt: Codeunit 25006003; need to 
        SalesShptLine: Record "Sales Shipment Line";
}

