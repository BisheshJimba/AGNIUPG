table 25006170 "Service Line Archive"
{
    // 12.05.2015 EB.P30 #T030
    //   Added field:
    //     "Resource Cost Amount"

    Caption = 'Service Line Archive';
    DrillDownPageID = 25006191;
    LookupPageID = 25006191;
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Description = 'komentars';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Service Header Archive".No. WHERE(Document Type=FIELD(Document Type));
        }
        field(4;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(5;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";
        }
        field(6;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Labor)) "Service Labor"
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
        field(16;"Outstanding Quantity";Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(22;"Unit Price";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
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
        field(38;"Appl.-to Item Entry";Integer)
        {
            Caption = 'Appl.-to Item Entry';
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
        field(71;"Purchase Order No.";Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Purchase Header".No. WHERE (Document Type=CONST(Order));
        }
        field(72;"Purch. Order Line No.";Integer)
        {
            Caption = 'Purch. Order Line No.';
            Editable = false;
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                            Document No.=FIELD(Purchase Order No.));
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
            TableRelation = "Service Line EDMS"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                  Document No.=FIELD(Document No.));
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
            CalcFormula = -Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.),
                                                                   Source Ref. No.=FIELD(Line No.),
                                                                   Source Type=CONST(25006146),
                                                                   Source Subtype=FIELD(Document Type),
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
        field(101;"System-Created Entry";Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(103;"Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
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
        field(109;"Prepayment %";Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(110;"Prepmt. Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Line Amount"));
            Caption = 'Prepmt. Line Amount';
            MinValue = 0;
        }
        field(111;"Prepmt. Amt. Inv.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Amt. Inv."));
            Caption = 'Prepmt. Amt. Inv.';
            Editable = false;
        }
        field(112;"Prepmt. Amt. Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Incl. VAT';
            Editable = false;
        }
        field(113;"Prepayment Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount';
            Editable = false;
        }
        field(114;"Prepmt. VAT Base Amt.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. VAT Base Amt.';
            Editable = false;
        }
        field(115;"Prepayment VAT %";Decimal)
        {
            Caption = 'Prepayment VAT %';
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;
        }
        field(116;"Prepmt. VAT Calc. Type";Option)
        {
            Caption = 'Prepmt. VAT Calc. Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(117;"Prepayment VAT Identifier";Code[10])
        {
            Caption = 'Prepayment VAT Identifier';
            Editable = false;
        }
        field(118;"Prepayment Tax Area Code";Code[20])
        {
            Caption = 'Prepayment Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(119;"Prepayment Tax Liable";Boolean)
        {
            Caption = 'Prepayment Tax Liable';
        }
        field(120;"Prepayment Tax Group Code";Code[10])
        {
            Caption = 'Prepayment Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(121;"Prepmt Amt to Deduct";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt to Deduct"));
            Caption = 'Prepmt Amt to Deduct';
            MinValue = 0;
        }
        field(122;"Prepmt Amt Deducted";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt Deducted"));
            Caption = 'Prepmt Amt Deducted';
            Editable = false;
        }
        field(123;"Prepayment Line";Boolean)
        {
            Caption = 'Prepayment Line';
            Editable = false;
        }
        field(124;"Prepmt. Amount Inv. Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. Incl. VAT';
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
        field(5047;"Version No.";Integer)
        {
            Caption = 'Version No.';
        }
        field(5048;"Doc. No. Occurrence";Integer)
        {
            Caption = 'Doc. No. Occurrence';
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
        field(5416;"Outstanding Qty. (Base)";Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5495;"Reserved Qty. (Base)";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Document No.),
                                                                            Source Ref. No.=FIELD(Line No.),
                                                                            Source Type=CONST(25006146),
                                                                            Source Subtype=FIELD(Document Type),
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
        field(5712;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
        }
        field(5790;"Requested Delivery Date";Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(5791;"Promised Delivery Date";Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(5917;"Qty. to Consume";Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume';
            DecimalPlaces = 0:5;
        }
        field(5918;"Quantity Consumed";Decimal)
        {
            Caption = 'Quantity Consumed';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5919;"Qty. to Consume (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume (Base)';
            DecimalPlaces = 0:5;
        }
        field(5920;"Qty. Consumed (Base)";Decimal)
        {
            Caption = 'Qty. Consumed (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
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
        field(60000;"External No.";Code[20])
        {
            Caption = 'External No.';
        }
        field(60100;Group;Boolean)
        {
            Caption = 'Group';
        }
        field(60110;"Group ID";Integer)
        {
            Caption = 'Group ID';
            TableRelation = "Service Line EDMS"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                  Document No.=FIELD(Document No.),
                                                                  Group=CONST(Yes));
        }
        field(60120;"Group Description";Text[30])
        {
            CalcFormula = Lookup("Service Line Archive".Description WHERE (Document Type=FIELD(Document Type),
                                                                           Document No.=FIELD(Document No.),
                                                                           Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                           Version No.=FIELD(Version No.),
                                                                           Line No.=FIELD(Group ID)));
            Caption = 'Group Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90000;"Posting Date";Date)
        {
            CalcFormula = Lookup("Service Header Archive"."Posting Date" WHERE (Document Type=FIELD(Document Type),
                                                                                No.=FIELD(Document No.),
                                                                                Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                Version No.=FIELD(Version No.)));
            Caption = 'Posting Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90200;"Planned Service Date";Date)
        {
            Caption = 'Planned Service Date';
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
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
        field(25006130;"Ext. Service Tracking No.";Code[20])
        {
            Caption = 'Ext. Service Tracking No.';
            TableRelation = IF (Type=FILTER(External Service)) "External Serv. Tracking No."."External Serv. Tracking No." WHERE (External Service No.=FIELD(No.));
        }
        field(25006150;"Standard Time";Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time (Hours)';
            DecimalPlaces = 0:5;
        }
        field(25006160;"Standard Time Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Standard Time Line No.';
            Editable = false;
        }
        field(25006170;"Vehicle Registration No.";Code[20])
        {
            CalcFormula = Lookup("Service Header Archive"."Vehicle Registration No." WHERE (Document Type=FIELD(Document Type),
                                                                                            No.=FIELD(Document No.),
                                                                                            Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                            Version No.=FIELD(Version No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006190;"Model Code";Code[20])
        {
            CalcFormula = Lookup("Service Header Archive"."Model Code" WHERE (Document Type=FIELD(Document Type),
                                                                              No.=FIELD(Document No.),
                                                                              Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                              Version No.=FIELD(Version No.)));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Model.Code;
        }
        field(25006210;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
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
            TableRelation = "Service Work Group";
        }
        field(25006300;"Package Version No.";Integer)
        {
            Caption = 'Package Version No.';
            Editable = false;
            TableRelation = "Service Package Version"."Version No." WHERE (Package No.=FIELD(Package No.));
        }
        field(25006310;"Package Version Spec. Line No.";Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Service Package Version Line"."Line No." WHERE (Package No.=FIELD(Package No.),
                                                                             Version No.=FIELD(Package Version No.));
        }
        field(25006373;VIN;Code[20])
        {
            CalcFormula = Lookup("Service Header Archive".VIN WHERE (Document Type=FIELD(Document Type),
                                                                     No.=FIELD(Document No.),
                                                                     Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                     Version No.=FIELD(Version No.)));
            Caption = 'VIN';
            FieldClass = FlowField;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006600;"Sell-to Customer Bill %";Decimal)
        {
            Caption = 'Sell-to Customer Bill %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(25006610;"Sell-to Customer Bill Amount";Decimal)
        {
            Caption = 'Sell-to Customer Bill Amount';
        }
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25007110;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
        field(25007120;"Resource No.";Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(25007150;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job.No. WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
        field(25007155;"Real Time (Hours)";Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time (Hours)';
        }
        field(25007180;Split;Boolean)
        {
            Caption = 'Split';
        }
        field(25007190;Status;Code[10])
        {
            Caption = 'Status';
            TableRelation = "Service Work Status EDMS";
        }
        field(25007195;"BOM Item No.";Code[20])
        {
            Caption = 'BOM Item No.';
            TableRelation = Item;
        }
        field(25007200;"Finished Quantity (Hours)";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" WHERE (Document Type=FIELD(Document Type),
                                                                                                  Document No.=FIELD(Document No.),
                                                                                                  Document Line No.=FIELD(Line No.)));
            Caption = 'Finished Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007210;"Remaining Quantity (Hours)";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Remaining Quantity (Hours)" WHERE (Document Type=FIELD(Document Type),
                                                                                                   Document No.=FIELD(Document No.),
                                                                                                   Document Line No.=FIELD(Line No.)));
            Caption = 'Remaining Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007220;"Sell-to Customer Name";Text[50])
        {
            CalcFormula = Lookup("Service Header EDMS"."Sell-to Customer Name" WHERE (Sell-to Customer No.=FIELD(Sell-to Customer No.)));
            Caption = 'Sell-to Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007230;"Bill-to Name";Text[50])
        {
            CalcFormula = Lookup("Service Header EDMS"."Bill-to Name" WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Name';
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
        field(33020234;"Job Category";Option)
        {
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI;
        }
        field(33020235;"Job Type";Code[20])
        {
            Description = 'Relation to master table Job Type Master';
            TableRelation = "Job Type Master".No.;

            trigger OnValidate()
            var
                VehicleWarranty: Record "25006036";
                ServiceHeader1: Record "25006145";
                Nowarranty: Label 'There is no any warranty active for %1.';
                ServMgtSetup: Record "25006120";
                JobMaster: Record "33020235";
            begin
            end;
        }
        field(33020236;"Warranty Approved";Boolean)
        {
        }
        field(33020237;"Approved Date";Date)
        {
        }
        field(33020238;"Customer Verified";Boolean)
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
        field(33020254;Resources;Code[250])
        {
        }
        field(33020260;"HS Code";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Doc. No. Occurrence","Version No.","Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount,"Amount Including VAT";
        }
        key(Key2;"Document Type","Document No.","Line No.","Doc. No. Occurrence","Version No.")
        {
        }
        key(Key3;"Sell-to Customer No.")
        {
        }
        key(Key4;"Bill-to Customer No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit "408";

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        ServPricesIncVar: Integer;
        ServHeader: Record "25006145";
    begin
        IF NOT ServHeader.GET("Document Type","Document No.") THEN BEGIN
          ServHeader."No." := '';
          ServHeader.INIT;
        END;
        IF ServHeader."Prices Including VAT" THEN
          ServPricesIncVar := 1
        ELSE
          ServPricesIncVar := 0;
        CLEAR(ServHeader);
        EXIT('2,'+FORMAT(ServPricesIncVar)+',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "2000000041";
    begin
        Field.GET(DATABASE::"Service Line EDMS",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","Document No."));
    end;
}

