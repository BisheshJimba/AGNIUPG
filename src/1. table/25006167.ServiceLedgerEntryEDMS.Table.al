table 25006167 "Service Ledger Entry EDMS"
{
    // 11.06.2015 EB.P30 #T041
    //   Added fields:
    //     "Resource Cost Amount"
    //     "Quantity (Hours)"
    //   Added functions:
    //     GetResourceTextFieldValue
    //     ShowDetLedgEntries
    // 
    // 12.05.2015 EB.P30 #T030
    //   Added field:
    //     "Resource Cost Amount"
    // 
    // 12.06.2013 EDMS P8
    //   * Code merge with NAV2009
    // 
    // 2012.07.31 EDMS, P8
    //   * changed type of field 'Variable Field Run 1' - now it is decimal
    // 
    // 28.01.2010 EDMSB P2
    //   * Added field "Standard Time", "Campaign No.", "Labor Group Code", "Labor Subgroup Code", "Amount Including VAT (LCY)"
    //   * Added key "Campaign No.,Entry Type,Type"
    // 
    // 20.10.2008. EDMS P2
    //   * Added field "Deal Type Code"
    // 
    // 10.05.2008. EDMS P2
    //   * Added key "Make Code,Model Code,Model Version No.,Posting Date"
    // 
    // 05.03.2008 EDMS P2
    //   * Added fields "Package No."
    //                  "Package Version No."
    //                  "Package Version Spec. Line No."
    // 
    // 26.07.2007. EDMS P2
    //   * Added key "Payment Method Code,Entry Type,Document Type,Document No."
    // 
    // 10.07.2007. EDMS P2
    //   * Added key "Entry Type,Resource No.,Type,Payment Method Code,No.,Posting Date"

    Caption = 'Service Ledger Entry EDMS';
    DrillDownPageID = 25006211;
    LookupPageID = 25006211;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Usage,Sale,Info';
            OptionMembers = Usage,Sale,Info;
        }
        field(30; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Order,Invoice,Credit Memo,Blanket Order,Return Order,Payment,Refund';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order",Payment,Refund;
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(60; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(70; "Make Code"; Code[20])
        {
            Caption = 'Make code';
            TableRelation = Make;
        }
        field(80; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(90;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));
        }
        field(100;"Customer No.";Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(110;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(120;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(130;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(140;"User ID";Code[50])
        {
            Caption = 'User ID';
        }
        field(150;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service";
        }
        field(160;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Labor)) "Service Labor".No.
                            ELSE IF (Type=CONST(Ext. Service)) "External Service";
        }
        field(170;"Amount (LCY)";Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(175;"Amount Including VAT (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
        }
        field(180;Amount;Decimal)
        {
            Caption = 'Amount';
        }
        field(185;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(190;"Total Cost";Decimal)
        {
            Caption = 'Cost Amount';
        }
        field(200;"Line Discount Amount";Decimal)
        {
            Caption = 'Line Discount Amount';
        }
        field(205;"Inv. Discount Amount";Decimal)
        {
            Caption = 'Inv. Discount Amount';
        }
        field(206;"Line Discount Amount (LCY)";Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';
        }
        field(207;"Inv. Discount Amount (LCY)";Decimal)
        {
            Caption = 'Inv. Discount Amount (LCY)';
        }
        field(210;"Unit Cost";Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(220;Quantity;Decimal)
        {
            Caption = 'Quantity';
        }
        field(230;"Charged Qty.";Decimal)
        {
            Caption = 'Charged Qty.';
        }
        field(240;Chargeable;Boolean)
        {
            Caption = 'Chargeable';
        }
        field(250;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
        }
        field(260;"Unit Price";Decimal)
        {
            Caption = 'Unit Price';
        }
        field(270;"Discount %";Decimal)
        {
            Caption = 'Discount %';
        }
        field(280;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(290;"Service Order Type";Code[10])
        {
            Caption = 'Service Order Type';
            TableRelation = "Service Order Type";
        }
        field(300;"Service Order No.";Code[20])
        {
            Caption = 'Service Order No.';
            TableRelation = "Posted Serv. Order Header"."Order No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(310;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(320;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(330;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(340;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(350;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(360;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(370;Open;Boolean)
        {
            Caption = 'Open';
            Description = 'A check mark in this field indicates that the entry is open. The entry is open until a linked sales invoice has been posted.';
        }
        field(380;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
        }
        field(390;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(400;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(410;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(420;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(430;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(440;"Pre-Assigned No.";Code[20])
        {
            Caption = 'Previous Document No.';
        }
        field(450;"Service Receiver";Code[10])
        {
            Caption = 'Service Receiver';
            TableRelation = Salesperson/Purchaser;
        }
        field(460;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(470;"Remaining Amount";Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Cust. Ledger Entry No.=FIELD(Cust. Ledger Entry No.),
                                                                         Posting Date=FIELD(Date Filter)));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(480;"Cust. Ledger Entry No.";Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(481;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(490;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(500;"Serv. Order Remaining Amt";Decimal)
        {
            CalcFormula = Sum("Service Ledger Entry EDMS".Amount WHERE (Service Order No.=FIELD(Document No.),
                                                                        Document Type=FILTER(<>Order)));
            Caption = 'Serv. Order Remaining Amt';
            FieldClass = FlowField;
        }
        field(510;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(570;Kilometrage;Integer)
        {
        }
        field(580;"Variable Field Run 2";Decimal)
        {
            CaptionClass = '7,25006167,580';
        }
        field(590;"Variable Field Run 3";Decimal)
        {
            CaptionClass = '7,25006167,590';
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
        field(50061;"For Km";Boolean)
        {
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006005;"Minutes Per UoM";Decimal)
        {
            Caption = 'Minutes Per UoM';
        }
        field(25006006;"Quantity (Hours)";Decimal)
        {
            Caption = 'Quantity (Hours)';
        }
        field(25006030;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006040;"Labor Group Code";Code[10])
        {
            Caption = 'Labor Group Code';
            TableRelation = "Service Labor Group".Code;
        }
        field(25006050;"Labor Subgroup Code";Code[10])
        {
            Caption = 'Labor Subgroup Code';
            TableRelation = "Service Labor Subgroup".Code WHERE (Group Code=FIELD(Labor Group Code));
        }
        field(25006150;"Standard Time";Decimal)
        {
            Caption = 'Standard Time';
            DecimalPlaces = 0:5;
        }
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006210;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
            TableRelation = "Service Package".No.;
        }
        field(25006276;"Warranty Claim No.";Code[20])
        {
            Caption = 'Warranty Claim No.';
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
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006167,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006800"),
                  "Make Code","Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,25006167,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006801"),
                  "Make Code","Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006167,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006802"),
                  "Make Code","Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25006810;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006820;"Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
            Description = 'at begin holds line No. of posted order only';
            TableRelation = "Posted Serv. Order Line"."Line No." WHERE (Document No.=FIELD(Document No.));
        }
        field(25007240;"Plan No.";Code[10])
        {
            Caption = 'Plan No.';
            TableRelation = "Vehicle Service Plan".No. WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25007245;"Plan Stage Recurrence";Integer)
        {
            Caption = 'Plan Stage Recurrence';
            TableRelation = "Vehicle Service Plan Stage".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                     Plan No.=FIELD(Plan No.));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(25007250;"Plan Stage Code";Code[10])
        {
            Caption = 'Code';
            TableRelation = "Vehicle Service Plan Stage".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                     Plan No.=FIELD(Plan No.),
                                                                     Recurrence=FIELD(Plan Stage Recurrence));
        }
        field(25007255;"Parent Vehicle Serial No.";Code[20])
        {
            Caption = 'Parent Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";
        }
        field(25007260;"Resource Cost Amount";Decimal)
        {
            CalcFormula = Sum("Det. Serv. Ledger Entry EDMS"."Cost Amount" WHERE (Service Ledger Entry No.=FIELD(Entry No.)));
            Caption = 'Resource Cost Amount';
            FieldClass = FlowField;
        }
        field(25007270;"Finished Hours";Decimal)
        {
            CalcFormula = Sum("Det. Serv. Ledger Entry EDMS"."Finished Quantity (Hours)" WHERE (Service Ledger Entry No.=FIELD(Entry No.)));
            FieldClass = FlowField;
        }
        field(25007271;"Service Address Code";Code[10])
        {
            Caption = 'Service Address Code';
            TableRelation = "Ship-to Address";
        }
        field(25007272;"Service Address";Text[50])
        {
            Caption = 'Service Address';
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020235;"Job Type";Code[20])
        {
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
        field(33020239;"External Service Purchased";Boolean)
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
            end;
        }
        field(33020244;"Is Booked";Boolean)
        {
        }
        field(33020245;"Hour Reading";Decimal)
        {
        }
        field(33020246;"Job Category";Option)
        {
            Editable = false;
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI;
        }
        field(33020247;"Next Service Date";Date)
        {
            Editable = false;
        }
        field(33020257;"Job Type (Service Header)";Code[20])
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
        field(33020267;"Delay Reason Code";Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Additional Job,Parts Not Avilable,Parts Delay,Diagnosis And Troubleshooting,Customer Approval Delay,ERP Issue,Internet Issue';
            OptionMembers = " ","Additional Job","Parts Not Avilable","Parts Delay","Diagnosis And Troubleshooting","Customer Approval Delay","ERP Issue","Internet Issue";
        }
        field(33020268;"Resources PSF";Code[20])
        {
            Description = 'PSF';
        }
        field(33020269;"Revisit Repair Reason";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Document No.","Posting Date")
        {
        }
        key(Key3;"Service Order No.","Document Type")
        {
            SumIndexFields = Amount;
        }
        key(Key4;"Document Type","Document No.","Posting Date")
        {
        }
        key(Key5;"Document Type","Service Order No.","Bill-to Customer No.")
        {
        }
        key(Key6;"Vehicle Serial No.","Entry Type","Posting Date")
        {
        }
        key(Key7;"Entry Type",Type,"Payment Method Code","No.","Posting Date")
        {
        }
        key(Key8;"Payment Method Code","Entry Type","Document Type","Document No.")
        {
        }
        key(Key9;"Make Code","Model Code","Model Version No.","Posting Date")
        {
        }
        key(Key10;"Vehicle Serial No.","Entry Type",Kilometrage)
        {
        }
        key(Key11;"Campaign No.","Entry Type",Type)
        {
        }
        key(Key12;"Vehicle Serial No.","Posting Date","Entry Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        cuVFMgt: Codeunit "25006004";
        cuLookupMgt: Codeunit "25006003";

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(cuVFMgt);
        EXIT(cuVFMgt.IsVFActive(DATABASE::"Service Ledger Entry EDMS",intFieldNo));
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    var
        DimMgt: Codeunit "408";
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    end;

    [Scope('Internal')]
    procedure GetResourceTextFieldValue() ResourcesNo: Text[250]
    var
        DetServLedgEntry: Record "25006188";
    begin
        DetServLedgEntry.RESET;
        DetServLedgEntry.SETRANGE("Service Ledger Entry No.", "Entry No.");
        IF DetServLedgEntry.FINDSET THEN
          REPEAT
            ResourcesNo += DetServLedgEntry."Resource No." + ',';
          UNTIL DetServLedgEntry.NEXT=0;
        IF STRLEN(ResourcesNo) > 1 THEN
          ResourcesNo := COPYSTR(ResourcesNo, 1, STRLEN(ResourcesNo)-1);
    end;

    [Scope('Internal')]
    procedure ShowDetLedgEntries()
    var
        DetLedgEntry: Record "25006188";
    begin
        DetLedgEntry.RESET;
        DetLedgEntry.SETRANGE("Service Ledger Entry No.", "Entry No.");
        IF (Type = Type::Labor) THEN
          PAGE.RUNMODAL(PAGE::"Det. Serv. Ledger Entries EDMS", DetLedgEntry);
    end;
}

