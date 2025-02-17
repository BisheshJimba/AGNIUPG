table 25006149 "Posted Serv. Order Header"
{
    // 12.02.2016 EB.P7
    //   Added field Mobile Phone No.
    // 
    // 23.02.2015 EDMS P21
    //   Added field:
    //     25006196 "Model Version No."
    // 
    // 19.06.2014 Elva Baltic P8 #F0005 EDMS7.10
    //   * Increased size of Resources field
    // 
    // 05.08.2008. EDMS P2
    //   * Added function LookupAdjmtValueEntries
    // 
    // 26.05.2008. EDMS P2
    //   * Added field Description
    // 
    // 25.03.2008. EDMS P2
    //   * Added new fields Requested Starting Date
    //                      Requested Starting Time
    // 
    // //09-02-2007 EDMS P3
    //   Added new fields: Vehicle Serial No.
    // //15-02-2007 EDMS P3
    //   Deleted fields: 140 "Vehicle Notes"
    //                  25006205 "Short Description"
    //                  25007250 "Sales Version Code"
    //                  25007230 "Sub Series"
    //                  25007220 "Series"
    //                  25007040 "Last Visit Date"
    //                  25006480 "Number of Doors"
    //                  25006210 "Prod. year"
    //                  340 "Sold Date"
    //                  25006240 "Initial Registration Date"

    Caption = 'Posted Serv. Order Header';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    DrillDownPageID = 25006197;
    LookupPageID = 25006197;

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
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
        }
        field(10; "Bill-to Contact"; Text[50])
        {
            Caption = 'Bill-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(22; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE(Use As In-Transit=CONST(No));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(31; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(34; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
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
        }
        field(43; "Service Advisor"; Code[10])
        {
            Caption = 'Service Advisor';
            TableRelation = Salesperson/Purchaser;
        }
        field(44;"Order No.";Code[20])
        {
            Caption = 'Order No.';
        }
        field(46;Comment;Boolean)
        {
            CalcFormula = Exist("Service Comment Line EDMS" WHERE (Type=CONST(Service Order),
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
        field(58;Invoice;Boolean)
        {
            Caption = 'Invoice';
        }
        field(60;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Posted Serv. Order Line".Amount WHERE (Document No.=FIELD(No.)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Posted Serv. Order Line"."Amount Including VAT" WHERE (Document No.=FIELD(No.)));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"VAT Registration No.";Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75;"EU 3-Party Trade";Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(76;"Transaction Type";Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77;"Transport Method";Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(79;"Sell-to Customer Name";Text[50])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(80;"Sell-to Customer Name 2";Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(81;"Sell-to Address";Text[50])
        {
            Caption = 'Sell-to Address';
        }
        field(82;"Sell-to Address 2";Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(83;"Sell-to City";Text[50])
        {
            Caption = 'Sell-to City';
        }
        field(84;"Sell-to Contact";Text[50])
        {
            Caption = 'Sell-to Contact';
        }
        field(85;"Bill-to Post Code";Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
        field(97;"Exit Point";Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(98;Correction;Boolean)
        {
            Caption = 'Correction';
        }
        field(99;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(100;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
        }
        field(101;"Area";Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(102;"Transaction Specification";Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(107;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(110;"Order No. Series";Code[10])
        {
            Caption = 'Order No. Series';
            TableRelation = "No. Series";
        }
        field(116;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(117;Reserve;Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
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
                ShowDimensions;
            end;
        }
        field(5050;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5051;"Sell-to Customer Template Code";Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            TableRelation = "Customer Template";
        }
        field(5052;"Sell-to Contact No.";Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;
        }
        field(5053;"Bill-to Contact No.";Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;
        }
        field(5054;"Bill-to Customer Template Code";Code[10])
        {
            Caption = 'Bill-to Customer Template Code';
            TableRelation = "Customer Template";
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
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
        }
        field(5791;"Promised Delivery Date";Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(5796;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(6210;"Login ID";Code[30])
        {
            Caption = 'Login ID';
            Editable = false;
            TableRelation = Location;
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(50056;"RV RR Code";Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Revisit,Repeat Repair';
            OptionMembers = " ",Revisit,"Repeat Repair";
        }
        field(50057;"Posted By";Code[30])
        {
        }
        field(50058;"Quality Control";Code[20])
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
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006160;VIN;Code[20])
        {
            Caption = 'VIN';
        }
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                Vehicle.RESET;
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                IF LookupMgt.LookUpVehicleAMT(Vehicle,'') THEN
            end;
        }
        field(25006180;Kilometrage;Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0:0;
        }
        field(25006181;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006190;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            TableRelation = Model.Code;
        }
        field(25006196;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            Editable = false;
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));
        }
        field(25006200;"Model Commercial Name";Text[50])
        {
            Caption = 'Model Commercial Name';
            Editable = true;
            FieldClass = Normal;
        }
        field(25006250;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(25006255;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006255';
        }
        field(25006260;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006180';
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
        }
        field(25006275;"Requested Finishing Time";Time)
        {
            Caption = 'Requested Finishing Time';
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
        }
        field(25006295;"Requested Starting Time";Time)
        {
            Caption = 'Requested Starting Time';
        }
        field(25006378;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006390;"Vehicle Item Charge No.";Code[20])
        {
            Caption = 'Vehicle Item Charge No.';
            TableRelation = "Item Charge";
        }
        field(25006400;Resources;Code[250])
        {
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006149,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,25006149,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006149,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25006860;"Work Status";Code[20])
        {
            Caption = 'Work Status';
            TableRelation = "Service Work Status EDMS";
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
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" WHERE (Document No.=FIELD(No.),
                                                                                                  Document Type=CONST(Order)));
            Caption = 'Finished Quantity (Hours)';
            Description = 'Service Schedule ';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007210;"Remaining Quantity (Hours)";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Remaining Quantity (Hours)" WHERE (Document No.=FIELD(No.)));
            Caption = 'Remaining Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007300;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25007310;"Vehicle Comment";Boolean)
        {
            Caption = 'Vehicle Comment';
            Description = 'Exist("Service Comment Line EDMS" WHERE (Type=CONST(Vehicle),No.=FIELD(Vehicle Serial No.)))';
            Editable = false;
            FieldClass = Normal;
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
            OptionCaption = 'Not Defined,Sell-to Customer,Bill-to Customer';
            OptionMembers = ND,SellTo,BillTo;
        }
        field(25007380;"Initiator Code";Code[10])
        {
            Caption = 'Initiator Code';
            TableRelation = Salesperson/Purchaser;
        }
        field(25007393;"Mobile Phone No.";Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(25007398;"Service Address Code";Code[10])
        {
            Caption = 'Service Address Code';
            TableRelation = "Ship-to Address".Code WHERE (Customer No.=FIELD(Sell-to Customer No.));
        }
        field(25007400;"Service Address";Text[50])
        {
            Caption = 'Service Address';
        }
        field(33019831;"Promised Delivery Time";Time)
        {
        }
        field(33019832;"Job Finished Time";Time)
        {
        }
        field(33019833;"Job Finished Date";Date)
        {
            Description = 'To improve the workshop performance';
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020235;"Booked By";Code[50])
        {
            TableRelation = "User Setup";
        }
        field(33020236;"Job Description";Text[250])
        {
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
            TableRelation = "Job Type Master".No.;
        }
        field(33020241;"AMC Customer";Boolean)
        {
        }
        field(33020242;"Service Type";Option)
        {
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,6th type Service,7th type Service,8th type Service,Bonus,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service","6th type Service","7th type Service","8th type Service",Bonus,Other;
        }
        field(33020243;"Activity Detail";Text[250])
        {
        }
        field(33020244;"Is Booked";Boolean)
        {
        }
        field(33020247;"Vehicle GatePass Printed";Boolean)
        {
            Description = 'Finished Job Vehicle Gatepass';
        }
        field(33020248;"Hour Reading";Decimal)
        {
        }
        field(33020251;"Approx. Estimation";Decimal)
        {
        }
        field(33020252;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
            TableRelation = "Service Package".No.;
        }
        field(33020253;"Assigned User ID";Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";
        }
        field(33020254;"Is Invoiced";Boolean)
        {
            Editable = false;
        }
        field(33020255;"Invoice No.";Code[20])
        {
            Editable = false;
            TableRelation = "Sales Invoice Header".No. WHERE (Posted Serv. Order No.=FIELD(No.));
        }
        field(33020257;"Actual Delivery Time";Time)
        {
            Editable = false;
        }
        field(33020258;"Job Category";Option)
        {
            Editable = false;
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI;
        }
        field(33020259;"Next Service Date";Date)
        {
        }
        field(33020260;"CSI Exists";Boolean)
        {
            CalcFormula = Exist("Service Satisfaction Feedback" WHERE (Service Order No.=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(33020261;"Driver Name";Text[100])
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
            Description = 'PSF';

            trigger OnLookup()
            var
                PSF: Record "33019806";
            begin
            end;
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
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Posting Date")
        {
        }
        key(Key3;"Vehicle Serial No.")
        {
        }
        key(Key4;"Order No.")
        {
        }
        key(Key5;"Posting Date","Job Type")
        {
        }
        key(Key6;"Document Date","Vehicle Serial No.")
        {
        }
        key(Key7;"Order Date")
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
    begin
    end;

    var
        DimMgt: Codeunit "408";
        Comment: Record "25006148";
        VFMgt: Codeunit "25006004";
        LookupMgt: Codeunit "25006003";

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Posted Serv. Order Header",intFieldNo));
    end;

    [Scope('Internal')]
    procedure LookupAdjmtValueEntries()
    var
        ValueEntry: Record "5802";
        SalesInvHdr: Record "112";
    begin
        SalesInvHdr.RESET;
        SalesInvHdr.SETCURRENTKEY("Service Order No.", "Service Document");
        SalesInvHdr.SETRANGE("Service Order No.", "No.");
        SalesInvHdr.SETRANGE("Service Document", TRUE);
        IF SalesInvHdr.FINDFIRST THEN;

        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.",SalesInvHdr."No.");
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SETRANGE(Adjustment,TRUE);
        PAGE.RUNMODAL(0,ValueEntry);
    end;

    [Scope('Internal')]
    procedure Navigate()
    var
        NavigateForm: Page "344";
    begin
        NavigateForm.SetDoc("Posting Date","No.");
        NavigateForm.RUN;
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
    end;

    [Scope('Internal')]
    procedure GetResourceNo(DocumentNo: Code[20]): Code[1024]
    var
        PostedServLine: Record "25006150";
        ResourceUsed: Code[1024];
    begin
        ResourceUsed := '';
        PostedServLine.RESET;
        PostedServLine.SETRANGE("Document No.",DocumentNo);
        PostedServLine.SETRANGE(Type,PostedServLine.Type::Labor);
        IF PostedServLine.FINDSET THEN REPEAT
          IF ResourceUsed = '' THEN
            ResourceUsed += PostedServLine.Resources
          ELSE IF (STRLEN(ResourceUsed)+STRLEN(PostedServLine.Resources))<1024 THEN BEGIN
            ResourceUsed += ', '+PostedServLine.Resources;
          END;
        UNTIL PostedServLine.NEXT=0;
        EXIT(ResourceUsed);
    end;
}

