table 33020086 "Follow Up Details"
{
    Permissions = TableData 25006005 = rm;

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            Enabled = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                codVin: Code[20];
            begin
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;

            trigger OnValidate()
            begin
                //SRT August 28th 2019 >> to generate dealer service order no. series
                IF "Dealer Tenant ID" <> '' THEN BEGIN
                    IF "No." <> xRec."No." THEN BEGIN
                        ServiceSetup.GET;
                        NoSeriesMngt.TestManual(GetNoSeries);
                        "No. Series" := '';
                    END;
                END;
                //SRT August 28th 2019 <<
            end;
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Editable = false;
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                ContBusRel: Record "5054";
                Cont: Record "5050";
                recServContract: Record "25006016";
            begin
            end;
        }
        field(5; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill-to Name';
            Editable = false;
        }
        field(6; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
            Editable = false;
        }
        field(7; "Bill-to Address"; Text[50])
        {
            Caption = 'Bill-to Address';
            Editable = false;
        }
        field(8; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
            Editable = false;
        }
        field(9; "Bill-to City"; Text[50])
        {
            Caption = 'Bill-to City';
            Editable = false;
        }
        field(10; "Bill-to Contact"; Text[50])
        {
            Caption = 'Bill-to Contact';
            Editable = false;
        }
        field(15; Type; Option)
        {
            OptionCaption = 'Service,Sales';
            OptionMembers = Service,Sales;
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';
            Editable = false;
        }
        field(20; "Posting Date"; Date)
        {
            CaptionClass = GetCaption(20);
            Caption = 'Posting Date';
            Editable = false;

            trigger OnValidate()
            var
                NoSeries: Record "308";
            begin
            end;
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location WHERE(Use As In-Transit=CONST(No));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(43; "Service Person"; Code[20])
        {
            Caption = 'Service Person';
            Editable = false;
        }
        field(44; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
        }
        field(63; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            Editable = false;
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            Editable = false;
        }
        field(79; "Sell-to Customer Name"; Text[50])
        {
            Caption = 'Sell-to Customer Name';
            Editable = false;
        }
        field(80; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
            Editable = false;
        }
        field(81; "Sell-to Address"; Text[50])
        {
            Caption = 'Sell-to Address';
            Editable = false;
        }
        field(82; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
            Editable = false;
        }
        field(83; "Sell-to City"; Text[50])
        {
            Caption = 'Sell-to City';
            Editable = false;
        }
        field(84; "Sell-to Contact"; Text[50])
        {
            Caption = 'Sell-to Contact';
            Editable = false;
        }
        field(85; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            Editable = false;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(86; "Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County';
            Editable = false;
        }
        field(87; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            Editable = false;
            TableRelation = Country/Region;
        }
        field(88;"Sell-to Post Code";Code[20])
        {
            Caption = 'Sell-to Post Code';
            Editable = false;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89;"Sell-to County";Text[30])
        {
            Caption = 'Sell-to County';
            Editable = false;
        }
        field(90;"Sell-to Country/Region Code";Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            Editable = false;
            TableRelation = Country/Region;
        }
        field(116;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            Editable = false;
            TableRelation = "VAT Business Posting Group";
        }
        field(150;Description;Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5051;"Sell-to Customer Template Code";Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            Editable = false;
            TableRelation = "Customer Template";

            trigger OnValidate()
            var
                SellToCustTemplate: Record "5105";
            begin
            end;
        }
        field(5052;"Sell-to Contact No.";Code[20])
        {
            Caption = 'Sell-to Contact No.';
            Editable = false;
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "5054";
                Cont: Record "5050";
            begin
            end;
        }
        field(5053;"Bill-to Contact No.";Code[20])
        {
            Caption = 'Bill-to Contact No.';
            Editable = false;
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "5054";
                Cont: Record "5050";
            begin
            end;
        }
        field(5054;"Bill-to Customer Template Code";Code[10])
        {
            Caption = 'Bill-to Customer Template Code';
            Editable = false;
            TableRelation = "Customer Template";

            trigger OnValidate()
            var
                BillToCustTemplate: Record "5105";
            begin
            end;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(5754;"Location Filter";Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5796;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(50025;"Pending Calls Reason";Code[20])
        {
            TableRelation = "General Master".Code WHERE (Category=CONST(FOLLOWUP),
                                                         Sub Category=CONST(PENDINGCALL),
                                                         Disable=CONST(No));

            trigger OnValidate()
            begin
                GeneralMaster.RESET;
                GeneralMaster.SETRANGE(Category,'FOLLOWUP');
                GeneralMaster.SETRANGE("Sub Category",'PENDINGCALL');
                GeneralMaster.SETRANGE(Code,"Pending Calls Reason");
                IF GeneralMaster.FINDFIRST THEN
                  "Follow Up Comment" := GeneralMaster.Description;
            end;
        }
        field(50026;"Operating Location";Text[50])
        {
            TableRelation = District.Code WHERE (Blocked=CONST(No));
        }
        field(80000;"Dealer Tenant ID";Text[30])
        {
            Description = 'SRT (for dealer service follow up integration)- take precautions before changing these fields';
            TableRelation = "Dealer Information"."Tenant ID";
            ValidateTableRelation = false;
        }
        field(80001;"Dealer Company Name";Text[30])
        {
            Description = 'SRT (for dealer service follow up integration) take precautions before changing these fields';
            TableRelation = "Dealer Information"."Company Name" WHERE (Tenant ID=FIELD(Dealer Tenant ID));
            ValidateTableRelation = false;
        }
        field(80002;"Dealer Location";Code[10])
        {
            Description = 'no table relation required take precautions before changing these fields';
        }
        field(80003;"Dealer Service Order No.";Code[20])
        {
            Description = 'no table relation required take precautions before changing these fields';
        }
        field(80004;"No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(80005;"Dealer Serv. Amt Incl. VAT";Decimal)
        {
            Description = 'data will be synced from dealer ASC ERP portal';
        }
        field(81300;"Amount Including VAT";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = -Sum("Service Ledger Entry EDMS"."Amount Including VAT" WHERE (Document Type=FILTER(Invoice),
                                                                                         Service Order No.=FIELD(No.)));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(81301;"Remarks - Cust. Effort Code";Code[35])
        {
            TableRelation = IF (Type=CONST(Sales)) "General Master".Code WHERE (Category=CONST(SALES FOLLOWUP),
                                                                                Sub Category=CONST(REMARKS))
                                                                                ELSE IF (Type=CONST(Service)) "General Master".Code WHERE (Category=CONST(SERIVCE FOLLOWUP),
                                                                                                                                           Sub Category=CONST(REMARKS));

            trigger OnValidate()
            var
                GeneralMaster: Record "33020061";
            begin
                GeneralMaster.RESET;
                GeneralMaster.SETRANGE("Sub Category",'REMARKS');
                GeneralMaster.SETRANGE(Code,"Remarks - Cust. Effort Code");

                IF Type = Type::Service THEN BEGIN
                  GeneralMaster.SETRANGE(Category,'SERIVCE FOLLOWUP');
                 END
                ELSE IF Type = Type::Sales THEN BEGIN
                  GeneralMaster.SETRANGE(Category,'SALES FOLLOWUP');
                END;

                IF GeneralMaster.FINDFIRST THEN BEGIN
                    "Remarks - Customer Effort" := GeneralMaster.Description;
                END;
            end;
        }
        field(81302;"Preferred Service Location";Code[50])
        {
            TableRelation = Location.Code WHERE (Use As Service Location=CONST(Yes));

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN BEGIN
                  Vehicle."Preferred Service Location" := "Preferred Service Location";
                  Vehicle.MODIFY;
                END;
            end;
        }
        field(81303;"Driver Name";Text[100])
        {
        }
        field(81304;"FeedBack Posted";Boolean)
        {
        }
        field(25006160;VIN;Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
            begin
            end;
        }
        field(25006170;"Vehicle Registration No.";Code[20])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                /*
                Vehicle.RESET;
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                IF LookupMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                */

            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
            begin
            end;
        }
        field(25006180;Kilometrage;Decimal)
        {
            BlankZero = true;
            Caption = 'Kilometrage';
            DecimalPlaces = 0:0;
            Editable = false;
        }
        field(25006181;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(25006190;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            TableRelation = Model.Code;
        }
        field(25006200;"Model Commercial Name";Text[50])
        {
            Caption = 'Model Commercial Name';
            Editable = false;
        }
        field(25006250;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            Editable = false;
            TableRelation = "Gen. Product Posting Group";
        }
        field(25006270;"Arrival Time";Time)
        {
            Caption = 'Arrival Time';
            Editable = false;
        }
        field(25006271;"Arrival Date";Date)
        {
            Caption = 'Arrival Date';
            Editable = false;
        }
        field(25006276;"Warranty Claim No.";Code[20])
        {
            Caption = 'Warranty Claim No.';
            Editable = false;
        }
        field(25006280;"Return Date";Date)
        {
            Caption = 'Return Date';
            Editable = false;
        }
        field(25006290;"Requested Starting Date";Date)
        {
            Caption = 'Requested Starting Date';
            Editable = false;
        }
        field(25006295;"Requested Starting Time";Time)
        {
            Caption = 'Requested Starting Time';
            Editable = false;
        }
        field(25006378;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Editable = false;
            TableRelation = Vehicle;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25007010;"Order Time";Time)
        {
            Caption = 'Order Time';
            Editable = false;
        }
        field(25007020;"Return Time";Time)
        {
            Caption = 'Return Time';
            Editable = false;
        }
        field(25007100;"Bill-to Contact Phone No.";Text[30])
        {
            Caption = 'Bill-to Contact Phone No.';
            Editable = false;
        }
        field(33019831;"Promised Delivery Time";Time)
        {
            Editable = false;
        }
        field(33019832;"Job Finished Time";Time)
        {
            Editable = false;
        }
        field(33020235;"Booked By";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(33020236;"Job Description";Text[250])
        {
            Editable = false;
        }
        field(33020237;Remarks;Text[250])
        {
            Editable = false;
        }
        field(33020238;"Booked on Date";Date)
        {
            Editable = false;
        }
        field(33020239;"Time Slot Booked";Time)
        {
            Editable = false;
        }
        field(33020240;"Job Type";Code[20])
        {
            Editable = false;
        }
        field(33020241;"AMC Customer";Boolean)
        {
            Editable = false;
        }
        field(33020242;"Service Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service",Other;
        }
        field(33020244;"Is Booked";Boolean)
        {
            Editable = false;
        }
        field(33020259;"Mobile No. for SMS";Text[30])
        {
            Description = 'SMS Send to Mobile No.';
            Editable = false;
        }
        field(33020260;"Follow Up Comment";Text[250])
        {
        }
        field(33020261;"Follow Up Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,Post Service Feedback,Service Reminder,Post Sales Feedback';
            OptionMembers = " ","Post Service Feedback","Service Reminder","Post Sales Feedback";
        }
        field(33020262;"Assigned User ID";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(33020263;"Scheduled Date";Date)
        {
            Editable = false;
        }
        field(33020264;"Scheduled Time";Time)
        {
            Editable = false;
        }
        field(33020265;"Contacted Date";Date)
        {

            trigger OnValidate()
            begin
                "Call Status" := "Call Status" ::Contacted;
                //SRT Jan 3rd 2020 >>
                IF "Contacted Date" <> 0D THEN
                  IF "Contacted Date" > TODAY THEN
                    ERROR('Contacted date cannot be in future date.');
                //SRT Jan 3rd 2020 <<
            end;
        }
        field(33020266;"Contacted Time";Time)
        {
        }
        field(33020267;"Contact Person";Text[80])
        {
        }
        field(33020268;"Missed Follow Up";Boolean)
        {
            Editable = false;
        }
        field(33020269;"Call Status";Option)
        {
            Editable = false;
            OptionCaption = 'Pending,Contacted';
            OptionMembers = Pending,Contacted;
        }
        field(33020270;"Feedback Status";Option)
        {
            OptionCaption = ' ,Satisfied,Dissatisfied,Pending Call';
            OptionMembers = " ",Satisfied,Dissatisfied,"Pending Call";
        }
        field(33020271;"Any Complaints";Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(33020272;"Any Suggestions";Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(33020273;"Followup Taken By";Text[100])
        {
        }
        field(33020274;"Contact Status";Boolean)
        {
            Editable = true;
        }
        field(33020275;"CCCR No.";Code[30])
        {

            trigger OnValidate()
            begin
                /*IF "CCCR No." <> '' THEN BEGIN
                  FollowupDetails.RESET;
                  FollowupDetails.SETRANGE("CCCR No.","CCCR No.");
                  FollowupDetails.SETRANGE("Follow Up Type","Follow Up Type");
                  FollowupDetails.SETFILTER("No.", '<>%1',"No.");
                  FollowupDetails.SETRANGE(Posted,FALSE);
                  IF FollowupDetails.FINDFIRST THEN
                    ERROR('%1 has already been selected in follow up details %2.',"CCCR No.",FollowupDetails."No.");
                END;*/

            end;
        }
        field(33020276;"Warranty Status";Boolean)
        {
            Description = 'Exist("Vehicle Warranty" WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),Status=FILTER(Active)))';
            Editable = false;
        }
        field(33020277;"Lost Customer";Boolean)
        {
            Editable = false;
        }
        field(33020278;"Contact Phone No.";Text[150])
        {
        }
        field(33020279;"Driver Contact No.";Text[100])
        {
        }
        field(33020280;"Job Closed Date";Date)
        {
            Description = 'Lookup("Sales Invoice Header"."Posting Date" WHERE (Order No.=FIELD(No.)))';
            Editable = false;
        }
        field(33020281;"Bill Amount";Decimal)
        {
            CalcFormula = -Sum("Service Ledger Entry EDMS".Amount WHERE (Document Type=FILTER(Invoice),
                                                                         Service Order No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020282;"Reminder for Next Service";Text[50])
        {
        }
        field(33020283;"Wrong No";Option)
        {
            Description = ' ,Yes,No';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(33020284;"Vehicle Application";Text[30])
        {
            Description = 'SRT';
            TableRelation = "CRM Master Template".Code WHERE (Master Options=CONST(Application));
        }
        field(33020285;Cost;Text[30])
        {
            Description = 'Question';
        }
        field(33020286;"Quality of Service";Text[30])
        {
            Description = 'Question';
        }
        field(33020287;"Behavior of Staff";Text[30])
        {
            Description = 'Question';
        }
        field(33020288;"Cust. Effort Score Rating(1-5)";Integer)
        {
            Caption = 'Net Promoter Score';
            Description = 'Question';

            trigger OnValidate()
            begin
                IF "Cust. Effort Score Rating(1-5)" <> 0 THEN BEGIN
                  IF "Cust. Effort Score Rating(1-5)" >= 11 THEN
                    ERROR(Text001);
                END;
            end;
        }
        field(33020289;"Remarks - Customer Effort";Text[250])
        {
            Description = 'Question';
        }
        field(33020290;"Model Version No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Version No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            FieldClass = FlowField;
        }
        field(33020291;"Recovered Status";Text[50])
        {
        }
        field(33020292;"Immediate and Further Action";Text[100])
        {
            Editable = false;
        }
        field(33020293;"Invalid Serivce Followup";Boolean)
        {
            FieldClass = Normal;
        }
        field(33020294;"Delivered Date";Date)
        {
            CaptionClass = GetCaption(33020294);
            Editable = false;
        }
        field(33020295;"Delivered By User ID";Code[50])
        {
            Editable = false;
        }
        field(33020296;"DRP No.";Code[20])
        {
            Editable = false;
        }
        field(33020297;"Sales Officer's Name";Text[50])
        {
            Editable = false;
        }
        field(33020298;"Probable Follow Up Date";Date)
        {
            Editable = false;
        }
        field(33020299;Posted;Boolean)
        {
            Editable = false;
        }
        field(33020300;"Posted By";Code[50])
        {
            Editable = false;
        }
        field(33020301;"Posted Date and Time";DateTime)
        {
            Editable = false;
        }
        field(33020302;"SalesPerson Code";Code[20])
        {

            trigger OnValidate()
            begin
                CALCFIELDS("SalesPerson Name");
            end;
        }
        field(33020303;"SalesPerson Name";Text[50])
        {
            CalcFormula = Lookup(Salesperson/Purchaser.Name WHERE (Code=FIELD(SalesPerson Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020304;Returned;Boolean)
        {
        }
        field(33020305;"Dealer Case";Boolean)
        {
            CalcFormula = Lookup(Customer."Is Dealer" WHERE (No.=FIELD(Bill-to Customer No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //SRT August 28h 2019 >>  to generate dealer service order no. series
        IF "Dealer Tenant ID" <> '' THEN BEGIN
          ServiceSetup.GET;
          IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMngt.InitSeries(GetNoSeries,xRec."No. Series",0D,"No.","No. Series");
          END;
        END;
        //SRT August 28th 2019 <<
    end;

    trigger OnModify()
    begin
        "Assigned User ID" := USERID;
    end;

    var
        [InDataSet]
        FieldEnable: Boolean;
        Text001: Label 'The rating should not be greater than 10.';
        GeneralMaster: Record "33020061";
        "--SRT---": Integer;
        NoSeriesMngt: Codeunit "396";
        ServiceSetup: Record "25006120";
        FollowupDetails: Record "33020086";

    [Scope('Internal')]
    procedure GetCaption(FieldNo: Integer): Text[30]
    var
        CompanyInfo: Record "79";
    begin
        CompanyInfo.GET;
        CASE FieldNo OF
          20:
            BEGIN
              IF CompanyInfo."Enable Complaint for Loan" THEN
                EXIT('Disbursement Date')
              ELSE
                EXIT('Posting Date');
            END;
          33020294:
            BEGIN
              IF CompanyInfo."Enable Complaint for Loan" THEN
                EXIT('1st EMI Start Date')
              ELSE
                 EXIT('Delivered Date')
            END;
        END
    end;

    [Scope('Internal')]
    procedure "--SRT--"()
    begin
    end;

    [Scope('Internal')]
    procedure AssistEdit(xFollowup: Record "33020086"): Boolean
    var
        ServiceSetup: Record "25006120";
    begin
        ServiceSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries,xFollowup."No. Series","No. Series") THEN BEGIN
          ServiceSetup.GET;
          TestNoSeries;
          NoSeriesMngt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    var
        ServiceSetup: Record "25006120";
    begin
        ServiceSetup.GET;
        ServiceSetup.TESTFIELD("Dealer Service Followup Nos.");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    var
        ServiceSetup: Record "25006120";
    begin
        ServiceSetup.GET;
        EXIT(ServiceSetup."Dealer Service Followup Nos.");
    end;
}

