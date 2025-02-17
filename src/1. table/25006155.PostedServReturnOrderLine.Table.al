table 25006155 "Posted Serv. Return Order Line"
{
    // 12.05.2015 EB.P30 #T030
    //   Added field:
    //     "Resource Cost Amount"
    // 
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified field:
    //     25007120 Resource No. (Code 20) to Resources (Code 100)
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management, added fields:
    //   *   Vehicle Axle Code
    //   *   Tire Position Code
    //   *   Tire Code
    //   *   Tire Entry
    //   *   Vehicle Serial No.
    // 
    // //09-02-2007 EDMS P3
    //   Added new fields: Job. No.   (posted line also)

    Caption = 'Posted Serv. Return Order Line';
    DrillDownPageID = 25006191;
    LookupPageID = 25006191;
    PasteIsValid = false;

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Posted Serv. Ret. Order Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service,Materials';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service",Materials;
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item WHERE (Make Code=FIELD(Make Code))
                            ELSE IF (Type=CONST(Labor)) "Service Labor" WHERE (Make Code=FIELD(Make Code))
                            ELSE IF (Type=CONST(External Service)) "External Service";
        }
        field(7;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));
        }
        field(11;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(12;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(13;"Unit of Measure";Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(22;"Unit Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(23;"Unit Cost (LCY)";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(25;"VAT %";Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(27;"Line Discount %";Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28;"Line Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(29;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(30;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(32;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(40;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(41;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(42;"Customer Price Group";Code[10])
        {
            Caption = 'Customer Price Group';
            Editable = false;
            TableRelation = "Customer Price Group";
        }
        field(67;"Profit %";Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(68;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer.No.;
        }
        field(69;"Inv. Discount Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
        }
        field(71;"Purchase Order No.";Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
        }
        field(72;"Purch. Order Line No.";Integer)
        {
            Caption = 'Purch. Order Line No.';
            Editable = false;
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document No.=FIELD(Purchase Order No.));
        }
        field(73;"Drop Shipment";Boolean)
        {
            Caption = 'Drop Shipment';
            Editable = true;
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(77;"VAT Calculation Type";Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(80;"Attached to Line No.";Integer)
        {
            Caption = 'Attached to Line No.';
            Editable = false;
            TableRelation = "Sales Line"."Line No." WHERE (Document No.=FIELD(Document No.));
        }
        field(85;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(86;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(87;"Tax Group Code";Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(89;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(91;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(95;"Reserved Quantity";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry".Quantity WHERE (Source Type=CONST(25006150),
                                                                   Source ID=FIELD(Document No.),
                                                                   Source Ref. No.=FIELD(Line No.),
                                                                   Reservation Status=CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(96;Reserve;Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(99;"VAT Base Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100;"Unit Cost";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(103;"Line Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
        }
        field(104;"VAT Difference";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(106;"VAT Identifier";Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(5402;"Variant Code";Code[20])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
        }
        field(5403;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(5405;Planned;Boolean)
        {
            Caption = 'Planned';
            Editable = false;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        field(5415;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;
        }
        field(5495;"Reserved Qty. (Base)";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Source Type=CONST(25006150),
                                                                            Source ID=FIELD(Document No.),
                                                                            Source Ref. No.=FIELD(Line No.),
                                                                            Reservation Status=CONST(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(5702;"Substitution Available";Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE (Type=CONST(Item),
                                                           No.=FIELD(No.),
                                                           Substitute Type=CONST(Item)));
            Caption = 'Substitution Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5703;"Originally Ordered No.";Code[20])
        {
            Caption = 'Originally Ordered No.';
            TableRelation = IF (Type=CONST(Item)) Item;
        }
        field(5704;"Originally Ordered Var. Code";Code[10])
        {
            Caption = 'Originally Ordered Var. Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(Originally Ordered No.));
        }
        field(5706;"Unit of Measure (Cross Ref.)";Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
        }
        field(5709;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5710;Nonstock;Boolean)
        {
            Caption = 'Nonstock';
            Editable = false;
        }
        field(5711;"Purchasing Code";Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5712;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
        }
        field(5713;"Special Order";Boolean)
        {
            Caption = 'Special Order';
            Editable = false;
        }
        field(5714;"Special Order Purchase No.";Code[20])
        {
            Caption = 'Special Order Purchase No.';
        }
        field(5715;"Special Order Purch. Line No.";Integer)
        {
            Caption = 'Special Order Purch. Line No.';
            TableRelation = IF (Special Order=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document No.=FIELD(Special Order Purchase No.));
        }
        field(5790;"Requested Delivery Date";Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(5791;"Promised Delivery Date";Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(5794;"Planned Delivery Date";Date)
        {
            Caption = 'Planned Delivery Date';
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002;"Customer Disc. Group";Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006005;"Minutes Per UoM";Decimal)
        {
            Caption = 'Minutes Per UoM';
            Editable = false;
        }
        field(25006006;"Quantity (Hours)";Decimal)
        {
            Caption = 'Quantity (Hours)';
            Editable = false;
        }
        field(25006014;"Product Subgroup Code";Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code WHERE (Item Category Code=FIELD(Item Category Code),
                                                           Product Group Code=FIELD(Product Group Code));
        }
        field(25006015;Prepayment;Boolean)
        {
            Caption = 'Prepayment';
        }
        field(25006030;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006100;"Vehicle Axle Code";Code[10])
        {
            Caption = 'Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25006110;"Tire Position Code";Code[10])
        {
            Caption = 'Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                Axle Code=FIELD(Vehicle Axle Code));
        }
        field(25006120;"Tire Code";Code[20])
        {
            Caption = 'Tire Code';
            TableRelation = Tire.Code;
        }
        field(25006125;"Tire Operation Type";Option)
        {
            Caption = 'Tire Operation Type';
            OptionCaption = ' ,Put on,Take off,Position Change';
            OptionMembers = " ","Put on","Take off","Position Change";
        }
        field(25006126;"New Vehicle Axle Code";Code[10])
        {
            Caption = 'New Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25006127;"New Tire Position Code";Code[10])
        {
            Caption = 'New Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                Axle Code=FIELD(Vehicle Axle Code));
        }
        field(25006130;"Ext. Service Tracking No.";Code[20])
        {
            Caption = 'Ext. Service Tracking No.';
            TableRelation = IF (Type=FILTER(External Service)) "External Serv. Tracking No."."External Serv. Tracking No." WHERE (External Service No.=FIELD(No.));
        }
        field(25006140;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(25006150;"Standard Time";Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(25006160;"Standard Time Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Standard Time Line No.';
            Editable = false;
        }
        field(25006180;"Symptom Code";Code[20])
        {
            Caption = 'Symptom Code';
            TableRelation = "Service Symptom EDMS".Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006190;"Cause Code";Code[20])
        {
            Caption = 'Cause Code';
        }
        field(25006193;"Parts Manufacturer Code";Code[10])
        {
            Caption = 'Parts Manufacturer Code';
            TableRelation = "Process Checklist Setup".Field20 WHERE (Primary Key=FIELD(Make Code));
        }
        field(25006195;"Parts Manuf. Payment Method";Code[10])
        {
            Caption = 'Parts Manuf. Payment Method';
        }
        field(25006200;"Package Type";Option)
        {
            Caption = 'Package Type';
            OptionCaption = 'Package,Service Package,Instruction';
            OptionMembers = Package,"Service Package",Instruction;
        }
        field(25006210;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            TableRelation = "Service Package".No.;
        }
        field(25006220;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006250;"Service Work Shift Code";Code[10])
        {
            Caption = 'Service Work Shift Code';
            TableRelation = "Service Package";
        }
        field(25006290;Number;Decimal)
        {
            BlankZero = true;
            Caption = 'Number';
            DecimalPlaces = 0:2;
        }
        field(25006300;"Package Version No.";Integer)
        {
            Caption = 'Package Version No.';
            TableRelation = "Service Package Version"."Version No." WHERE (Package No.=FIELD(Package No.));
        }
        field(25006310;"Package Version Spec. Line No.";Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            NotBlank = true;
            TableRelation = "Service Package Version"."Version No." WHERE (Make Code=FIELD(Make Code),
                                                                           Package No.=FIELD(Package No.));
        }
        field(25006373;VIN;Code[20])
        {
            Caption = 'vin';
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006440;"Fixed Price";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Fixed Price';
            Editable = false;
        }
        field(25006520;"Purchase Receipt";Code[20])
        {
            Caption = 'Purchase Receipt';
            Editable = false;
        }
        field(25006530;"Purch. Rcpt. Line";Integer)
        {
            Caption = 'Purch. Rcpt. Line';
            Editable = false;
        }
        field(25006600;"Payer Part %";Decimal)
        {
            Caption = 'Payer Part %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type';
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006155,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Damage Part Type",FIELDNO("Variable Field 25006800"),
                  '', "Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,25006155,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Damage Part Type",FIELDNO("Variable Field 25006801"),
                  '', "Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006155,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Damage Part Type",FIELDNO("Variable Field 25006802"),
                  '', "Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25007110;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
        field(25007120;Resources;Code[100])
        {
            Caption = 'Resources';
        }
        field(25007130;"Transfer Document No.";Code[20])
        {
            Caption = 'Transfer Document No.';
        }
        field(25007150;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job.No. WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
        field(25007180;Split;Boolean)
        {
            Caption = 'Split';
        }
        field(25007200;"Finished Quantity (Hours)";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" WHERE (Document No.=FIELD(Document No.),
                                                                                                  Document Line No.=FIELD(Line No.)));
            Caption = 'Finished Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007210;"Remaining Quantity (Hours)";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Remaining Quantity (Hours)" WHERE (Document No.=FIELD(Document No.),
                                                                                                   Document Line No.=FIELD(Line No.)));
            Caption = 'Remaining Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007260;"Resource Cost Amount";Decimal)
        {
            Caption = 'Resource Cost Amount';
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(33020260;"HS Code";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
            SumIndexFields = Amount,"Amount Including VAT";
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit "408";
        LookUpMgt: Codeunit "25006003";
        VFMgt: Codeunit "25006004";

    [Scope('Internal')]
    procedure FilterPstdDocLineValueEntries(var ValueEntry: Record "5802")
    var
        SalesCrMemoHdr: Record "114";
    begin
        SalesCrMemoHdr.RESET;
        SalesCrMemoHdr.SETCURRENTKEY("Service Return Order No.", "Service Document");
        SalesCrMemoHdr.SETRANGE("Service Return Order No.", "Document No.");
        SalesCrMemoHdr.SETRANGE("Service Document", TRUE);
        IF SalesCrMemoHdr.FINDFIRST THEN;

        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.",SalesCrMemoHdr."No.");
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Credit Memo");
        ValueEntry.SETRANGE("Document Line No.","Line No.");
    end;

    [Scope('Internal')]
    procedure CalcVATAmountLines(var PostServRetOrd: Record "25006154";var VATAmountLine: Record "290")
    begin
        VATAmountLine.DELETEALL;
        SETRANGE("Document No.",PostServRetOrd."No.");
        IF FINDSET THEN
          REPEAT
            VATAmountLine.INIT;
            VATAmountLine."VAT Identifier" := "VAT Identifier";
            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
            VATAmountLine."VAT %" := "VAT %";
            VATAmountLine."VAT Base" := Amount;
            VATAmountLine."VAT Amount" := "Amount Including VAT" - Amount;
            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
            VATAmountLine."Line Amount" := "Line Amount";
            VATAmountLine.Quantity := "Quantity (Base)";
            VATAmountLine."Calculated VAT Amount" := "Amount Including VAT" - Amount - "VAT Difference";
            VATAmountLine."VAT Difference" := "VAT Difference";
            VATAmountLine.InsertLine;
          UNTIL NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ShowItemTrackingLines()
    var
        ItemTrackingMgt: Codeunit "6500";
    begin
        //22.10.2015 NAV2016 Merge>>
        //ItemTrackingMgt.CallPostedItemTrackingForm3(RowID1);
        //22.10.2015 NAV2016 Merge<<
    end;

    [Scope('Internal')]
    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "6500";
        PostedRetServHdr: Record "25006154";
        SalesCrMemoLine: Record "115";
    begin
        IF NOT PostedRetServHdr.GET("Document No.") THEN
          EXIT;
        SalesCrMemoLine.SETCURRENTKEY("Service Order No. EDMS","Service Order Line No. EDMS");
        SalesCrMemoLine.SETRANGE("Service Order No. EDMS", PostedRetServHdr."Return Order No.");
        SalesCrMemoLine.SETRANGE("Service Order Line No. EDMS", "Line No.");
        IF NOT SalesCrMemoLine.FINDFIRST THEN
          EXIT;

        EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Cr.Memo Line",
          0,SalesCrMemoLine."Document No.",'',0,SalesCrMemoLine."Line No."));
    end;

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Damage Part Type",intFieldNo));
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
    end;
}

