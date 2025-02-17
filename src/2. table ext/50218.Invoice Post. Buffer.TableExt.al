tableextension 50218 tableextension50218 extends "Invoice Post. Buffer"
{
    // 23.01.2013
    //   * Added field in primary key: "Vehicle Serial No."
    fields
    {
        field(50001; "VIN - COGS"; Code[20])
        {

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
                frmVehicleList: Page "25006033";
            begin
            end;
        }
        field(50097; "COGS Type"; Option)
        {
            Description = 'Used for Alternative of way of Item Charge';
            OptionCaption = ' ,ACCESSORIES-CV,ACCESSORIES-PC,BANK CHARGE-CV,BANK CHARGE-PC,BATTERY-CV,BATTERY-PC,BODY BUILDING-CV,BODY BUILDING-PC,CHASSIS REGISTR-CV,CHASSIS REGISTR-PC,CLEARING & FORW-CV,CLEARING & FORW-PC,CUSTOM DUTY-CV,CUSTOM DUTY-PC,DENT / PENT-CV,DENT / PENT-PC,DRIVER-CV,DRIVER-PC,FOREIGN CHARGE-CV,FOREIGN CHARGE-PC,FUEL & OIL-CV,FUEL & OIL-PC,INSURANCE MANAG-CV,INSURANCE MANAG-PC,INSURANCE-CV,INSURANCE-PC,,L/C & BANK CHAR-CV,L/C & BANK CHAR-PC,LUBRICANTS-CV,LUBRICANTS-PC,NEW CHASSIS REP-CV,NEW CHASSIS REP-PC,PARKING CHARGE-CV,PARKING CHARGE-PC,PRAGYANPAN-CV,PRAGYANPAN-PC,SERVICE CHARGE-CV,SERVICE CHARGE-PC,SPARES-CV,SPARES-PC,TRANSPORTATION-CV,TRANSPORTATION-PC,VEHICLE LOGISTI-CV,VEHICLE LOGISTI-PC,VEHICLE TAX-CV,VEHICLE TAX-PC';
            OptionMembers = " ","ACCESSORIES-CV","ACCESSORIES-PC","BANK CHARGE-CV","BANK CHARGE-PC","BATTERY-CV","BATTERY-PC","BODY BUILDING-CV","BODY BUILDING-PC","CHASSIS REGISTR-CV","CHASSIS REGISTR-PC","CLEARING & FORW-CV","CLEARING & FORW-PC","CUSTOM DUTY-CV","CUSTOM DUTY-PC","DENT / PENT-CV","DENT / PENT-PC","DRIVER-CV","DRIVER-PC","FOREIGN CHARGE-CV","FOREIGN CHARGE-PC","FUEL & OIL-CV","FUEL & OIL-PC","INSURANCE MANAG-CV","INSURANCE MANAG-PC","INSURANCE-CV","INSURANCE-PC",,"L/C & BANK CHAR-CV","L/C & BANK CHAR-PC","LUBRICANTS-CV","LUBRICANTS-PC","NEW CHASSIS REP-CV","NEW CHASSIS REP-PC","PARKING CHARGE-CV","PARKING CHARGE-PC","PRAGYANPAN-CV","PRAGYANPAN-PC","SERVICE CHARGE-CV","SERVICE CHARGE-PC","SPARES-CV","SPARES-PC","TRANSPORTATION-CV","TRANSPORTATION-PC","VEHICLE LOGISTI-CV","VEHICLE LOGISTI-PC","VEHICLE TAX-CV","VEHICLE TAX-PC";
        }
        field(50098; "Document Class"; Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets";
        }
        field(50099; "Document Subclass"; Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF (Document Class=CONST(Customer)) Customer
                            ELSE IF (Document Class=CONST(Vendor)) Vendor
                            ELSE IF (Document Class=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Document Class=CONST(Fixed Assets)) "Fixed Asset";
        }
        field(59000;"TDS Group";Code[20])
        {
            TableRelation = "TDS Posting Group";
        }
        field(59001;"TDS%";Decimal)
        {
        }
        field(59002;"TDS Type";Option)
        {
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(59003;"TDS Amount";Decimal)
        {
        }
        field(59004;"TDS Base Amount";Decimal)
        {
        }
        field(90002;"Cost Type";Option)
        {
            OptionCaption = ' ,Fixed Cost,Variable Cost';
            OptionMembers = " ","Fixed Cost","Variable Cost";
        }
        field(25006050;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No';
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
        }
        field(33020252;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020254;"Service Order No.";Code[20])
        {
            Description = 'Used for External Service Order';
            Editable = true;
            TableRelation = "Posted Serv. Order Header";
            ValidateTableRelation = false;
        }
        field(33020255;"Localized VAT Identifier";Option)
        {
            Description = 'VAT1.00';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Type,G/L Account,Gen. Bus. Posting Group,Gen. Prod. Posting Group,VAT Bus. Posting Group,VAT Prod. Posting Group,Tax Area Code,Tax Group Code,Tax Liable,Use Tax,Dimension Set ID,Job No.,Fixed Asset Line No.,Deferral Code"(Key)".

        key(Key1;Type,"G/L Account","Gen. Bus. Posting Group","Gen. Prod. Posting Group","VAT Bus. Posting Group","VAT Prod. Posting Group","Tax Area Code","Tax Group Code","Tax Liable","Use Tax","Dimension Set ID","Job No.","Fixed Asset Line No.","Deferral Code","Vehicle Serial No.")
        {
            Clustered = true;
        }
    }

    //Unsupported feature: Variable Insertion (Variable: SalesHeader) (VariableCollection) on "PrepareSales(PROCEDURE 1)".



    //Unsupported feature: Code Modification on "PrepareSales(PROCEDURE 1)".

    //procedure PrepareSales();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CLEAR(Rec);
        Type := SalesLine.Type;
        "System-Created Entry" := TRUE;
        #4..11
        "Job No." := SalesLine."Job No.";
        "VAT %" := SalesLine."VAT %";
        "VAT Difference" := SalesLine."VAT Difference";
        IF Type = Type::"Fixed Asset" THEN BEGIN
          "FA Posting Date" := SalesLine."FA Posting Date";
          "Depreciation Book Code" := SalesLine."Depreciation Book Code";
        #18..30
          "VAT Amount" := 0;
          "VAT Amount (ACY)" := 0;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..14

        //SS1.00
        "Scheme Code" := SalesLine."Scheme Code";
        "Membership No." := SalesLine."Membership No.";
        //SS1.00

        //EDMS >>
        IF SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.") THEN BEGIN
         IF SalesHeader."Document Profile" = SalesHeader."Document Profile"::"Vehicles Trade" THEN
          BEGIN
           "Vehicle Serial No." := SalesLine."Vehicle Serial No.";
           "Vehicle Accounting Cycle No." := SalesLine."Vehicle Accounting Cycle No.";
          END;

         IF SalesHeader."Document Profile" = SalesHeader."Document Profile"::Service THEN
          BEGIN
           SalesHeader.TESTFIELD("Vehicle Serial No.");
           "Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
           "Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
          END;
        END;
        //EDMS <<

        #15..33
        */
    //end;


    //Unsupported feature: Code Modification on "PreparePurchase(PROCEDURE 6)".

    //procedure PreparePurchase();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CLEAR(Rec);
        Type := PurchLine.Type;
        "System-Created Entry" := TRUE;
        #4..37
          "VAT Amount" := 0;
          "VAT Amount (ACY)" := 0;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..40
        //EDMS >>
        "Vehicle Serial No." := PurchLine."Vehicle Serial No.";
        "Vehicle Accounting Cycle No." := PurchLine."Vehicle Accounting Cycle No.";
        //EDMS <<

        //AGNI UPG 2009 RD >>
        "VIN - COGS" := PurchLine."VIN - COGS";
        "COGS Type" := PurchLine."COGS Type";
        //AGNI UPG 2009 RD <<

         //**SM 25 10 2013 to flow document class and subclass in gen jnl lines
         "Document Class" := PurchLine."Document Class";
         "Document Subclass" := PurchLine."Document Subclass"; //SM
         //**SM 25 10 2013 to flow document class and subclass in gen jnl lines
         "Cost Type" := PurchLine."Cost Type";
        "Localized VAT Identifier" := PurchLine."Localized VAT Identifier";//aakrista
        */
    //end;


    //Unsupported feature: Code Modification on "Update(PROCEDURE 12)".

    //procedure Update();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        Rec := InvoicePostBuffer;
        IF FIND THEN BEGIN
          Amount += InvoicePostBuffer.Amount;
        #4..7
          "VAT Difference" += InvoicePostBuffer."VAT Difference";
          "VAT Base Amount (ACY)" += InvoicePostBuffer."VAT Base Amount (ACY)";
          Quantity += InvoicePostBuffer.Quantity;
          IF NOT InvoicePostBuffer."System-Created Entry" THEN
            "System-Created Entry" := FALSE;
          MODIFY;
        #14..19
          END;
          INSERT;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..10
          //AGNI UPG 2009 >>
          // TDS2.00 28 JUNE 2015 >>
          "TDS Amount" += InvoicePostBuffer."TDS Amount";
          "TDS Base Amount" += InvoicePostBuffer."TDS Base Amount";
          // TDS2.00 28 JUNE 2015 <<
          //AGNI UPG 2009 <<
        #11..22
        */
    //end;

    procedure SetTDSAccount(var PurchLine: Record "39")
    begin
        //TDS2.00
        IF PurchLine."TDS Group" <> '' THEN
          "TDS Group" := PurchLine."TDS Group";
        IF PurchLine."TDS%" <> 0 THEN
          "TDS%" := PurchLine."TDS%";
        IF PurchLine."TDS Type" <> PurchLine."TDS Type"::" " THEN
          "TDS Type" := PurchLine."TDS Type";
    end;

    procedure SetTDSAmounts(TotalTDSAmount: Decimal;TotalTDSBaseAmount: Decimal)
    begin
        //TDS2.00
        "TDS Amount" := TotalTDSAmount;
        "TDS Base Amount" := TotalTDSBaseAmount;
    end;

    procedure ReverseTDSAmounts()
    begin
        //TDS2.00
        "TDS Amount" := -"TDS Amount";
        "TDS Base Amount" := -"TDS Base Amount";
    end;

    procedure UpdateTDSFields(PurchLine: Record "39")
    begin
        //TDS2.00
        IF PurchLine."TDS Group" <> '' THEN
          "TDS Group" := PurchLine."TDS Group";
        IF PurchLine."TDS%" <> 0 THEN
          "TDS%" := PurchLine."TDS%";
        IF PurchLine."TDS Type" <> PurchLine."TDS Type"::" " THEN
          "TDS Type" := PurchLine."TDS Type";
    end;
}

