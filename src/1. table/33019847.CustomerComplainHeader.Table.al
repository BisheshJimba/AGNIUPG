table 33019847 "Customer Complain Header"
{

    fields
    {
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                DocumentMgt: Codeunit "25006000";
                codVin: Code[20];
                recVeh: Record "25006005";
            begin
                Cust.RESET;
                Cust.SETRANGE("No.", "Customer No.");
                IF Cust.FINDFIRST THEN BEGIN
                    "Customer Name" := COPYSTR(Cust.Name, 1, MAXSTRLEN("Customer Name"));
                    "Customer Name 2" := COPYSTR(Cust."Name 2", 1, MAXSTRLEN("Customer Name 2"));
                    ;
                    Address := COPYSTR(Cust.Address, 1, MAXSTRLEN(Address));
                    ;
                    "Address 2" := COPYSTR(Cust."Address 2", 1, MAXSTRLEN("Address 2"));
                    ;
                    City := Cust.City;
                    "Post Code" := Cust."Post Code";
                    Country := Cust.County;
                    "Country/Region Code" := Cust."Country/Region Code";
                    "Phone No." := Cust."Phone No.";
                END;
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                testingh: Code[10];
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    ServiceSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode1);
                    "No. Series" := '';
                END;
            end;
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = true;
            TableRelation = Location WHERE(Use As In-Transit=CONST(No));

            trigger OnValidate()
            begin
                //IF ("Location Code" <> xRec."Location Code") AND (xRec."Sell-to Customer No." = "Sell-to Customer No.") THEN
                // MessageIfServLinesExist(FIELDCAPTION("Location Code"));
            end;
        }
        field(43; "Service Person"; Code[10])
        {
            Caption = 'Service Person';
            TableRelation = Salesperson/Purchaser WHERE (Job Title=CONST(Service Advisor));
        }
        field(79;"Customer Name";Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Customer No.)));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80;"Customer Name 2";Text[50])
        {
            CalcFormula = Lookup(Customer."Name 2" WHERE (No.=FIELD(Customer No.)));
            Caption = 'Customer Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(81;Address;Text[50])
        {
            CalcFormula = Lookup(Customer.Address WHERE (No.=FIELD(Customer No.)));
            Caption = 'Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(82;"Address 2";Text[50])
        {
            CalcFormula = Lookup(Customer."Address 2" WHERE (No.=FIELD(Customer No.)));
            Caption = 'Address 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(83;City;Text[50])
        {
            Caption = 'City';
            Editable = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpCity(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity(City,"Post Code");
            end;
        }
        field(84;Contact;Text[50])
        {
            Caption = 'Contact';
            Editable = false;
        }
        field(85;"Post Code";Code[20])
        {
            TableRelation = "Post Code";
        }
        field(89;Country;Text[30])
        {
            Caption = 'Country';
        }
        field(90;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = Country/Region;
        }
        field(107;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(120;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,On Progress,Closed';
            OptionMembers = Open,"On Progress",Closed;
        }
        field(5052;"Contact No.";Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF ("Customer No." <> '') AND (Cont.GET("Contact No.")) THEN
                  Cont.SETRANGE("Company No.",Cont."Company No.")
                ELSE
                  IF "Customer No." <> '' THEN BEGIN
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                    ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SETRANGE("No.","Customer No.");
                    IF ContBusinessRelation.FIND('-') THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                  END ELSE
                    Cont.SETFILTER("Company No.",'<>''''');

                IF "Contact No." <> '' THEN
                  IF Cont.GET("Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "5054";
                Cont: Record "5050";
                Vehicle: Record "25006005";
            begin
                /*TESTFIELD(Status,Status::Open);
                HideValidationDialog := TRUE;
                IF ("Sell-to Contact No." <> xRec."Sell-to Contact No.") AND
                   (xRec."Sell-to Contact No." <> '')
                THEN BEGIN
                  IF HideValidationDialog THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed := CONFIRM(Text004,FALSE,FIELDCAPTION("Sell-to Contact No."));
                  IF Confirmed THEN BEGIN
                    ServLine.RESET;
                    ServLine.SETRANGE("Document Type","Document Type");
                    ServLine.SETRANGE("Document No.","No.");
                    IF ("Sell-to Contact No." = '') AND ("Sell-to Customer No." = '') THEN BEGIN
                      IF ServLine.FIND('-') THEN
                        ERROR(Text005,FIELDCAPTION("Sell-to Contact No."));
                      INIT;
                      ServiceSetup.GET;
                      InitRecord2;
                      "No. Series" := xRec."No. Series";
                      IF xRec."Posting No." <> '' THEN BEGIN
                        "Posting No. Series" := xRec."Posting No. Series";
                        "Posting No." := xRec."Posting No.";
                      END;
                      IF xRec."Prepayment No." <> '' THEN BEGIN
                        "Prepayment No. Series" := xRec."Prepayment No. Series";
                        "Prepayment No." := xRec."Prepayment No.";
                      END;
                      IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                        "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                        "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                      END;
                      EXIT;
                    END;
                  END ELSE BEGIN
                    Rec := xRec;
                    EXIT;
                  END;
                END;
                
                IF ("Sell-to Customer No." <> '') AND ("Sell-to Contact No." <> '') THEN BEGIN
                  Cont.GET("Sell-to Contact No.");
                  ContBusinessRelation.RESET;
                  ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                  ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                  ContBusinessRelation.SETRANGE("No.","Sell-to Customer No.");
                    IF ContBusinessRelation.FIND('-') THEN
                      IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                        ERROR(Text038,Cont."No.",Cont.Name,"Sell-to Customer No.");
                END;
                */
                
                
                
                
                /*
                UpdateSellToCust("Contact No.");
                
                IF (Rec."Vehicle Registration No." = xRec."Vehicle Registration No.")
                 AND ("Vehicle Serial No." = xRec."Vehicle Serial No.") AND NOT FindCustomer THEN
                  FindContVehicle;
                */

            end;
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
        field(25006160;VIN;Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                 VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
                bFillCustomer: Boolean;
            begin
                IF VIN = '' THEN
                  VALIDATE("Vehicle Serial No.",'')
                ELSE BEGIN
                  recVehicle.RESET;
                  recVehicle.SETCURRENTKEY(VIN);
                  recVehicle.SETRANGE(VIN,VIN);
                  IF recVehicle.FINDFIRST THEN
                    VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                END;
            end;
        }
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
                Vehicle2: Record "25006005";
            begin
                IF "Vehicle Registration No." <> '' THEN BEGIN
                  Vehicle.RESET;
                  Vehicle.SETCURRENTKEY("Registration No.");
                  Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
                  IF Vehicle.FINDFIRST THEN;
                  Vehicle.SETRANGE("Registration No.");
                END;

                IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                 VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
            end;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                /*IF "Vehicle Registration No." = '' THEN BEGIN
                  VALIDATE("Vehicle Serial No.",'');
                  EXIT;
                END;
                
                Vehicle.RESET;
                Vehicle.SETCURRENTKEY("Registration No.");
                Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                  IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                    VALIDATE("Vehicle Serial No.",Vehicle."Serial No.")
                END ELSE
                  MESSAGE(STRSUBSTNO(Text131, "Vehicle Registration No."));
                */

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
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
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
            CalcFormula = Lookup(Model."Commercial Name" WHERE (Make Code=FIELD(Make Code),
                                                                Code=FIELD(Model Code)));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006378;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Editable = false;
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                Model: Record "25006001";
                DocumentMgt: Codeunit "25006000";
                FillCustomer: Boolean;
            begin
                /*
                IF "Vehicle Serial No." = '' THEN
                 BEGIN
                  "Vehicle Registration No." := '';
                  "Make Code" := '';
                  "Model Code" := '';
                  "Model Version No." := '';
                  VIN := '';
                  "Vehicle Accounting Cycle No." := '';
                  "Vehicle Status Code" := '';
                  "Model Commercial Name" := '';
                
                  EXIT;
                 END;
                
                Vehicle.GET("Vehicle Serial No.");
                Vehicle.CALCFIELDS("Default Vehicle Acc. Cycle No.");
                Vehicle.TESTFIELD("Make Code");
                Vehicle.TESTFIELD("Model Code");
                Vehicle.TESTFIELD("Model Version No.");
                
                VIN := Vehicle.VIN;
                VALIDATE("Vehicle Accounting Cycle No.",Vehicle."Default Vehicle Acc. Cycle No.");
                "Vehicle Registration No." := Vehicle."Registration No.";
                "Make Code" := Vehicle."Make Code";
                "Model Code" := Vehicle."Model Code";
                "Model Version No." := Vehicle."Model Version No.";
                "Vehicle Status Code" := Vehicle."Status Code";
                {
                IF Model.GET("Make Code","Model Code") THEN
                  "Model Commercial Name" := Model."Commercial Name"
                ELSE
                  "Model Commercial Name" := Vehicle."Model Commercial Name";
                IF "Document Type" <> "Document Type"::Quote THEN
                  UpdVehicleInfo("Vehicle Serial No.", Vehicle);
                }
                
                IF (Rec."Customer No." = xRec."Customer No.") AND NOT FindVehicle THEN
                  FindVehicleCont;
                
                UpdateVehicleContact;
                */
                //DocumentMgt.ShowVehicleComments("Vehicle Serial No.");
                
                //CheckRecallCampaigns("Vehicle Serial No.");

            end;
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
        field(25007300;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            var
                recDimValue: Record "349";
            begin
                /*
                CreateDim(
                  DATABASE::"Vehicle Status", "Vehicle Status Code",
                  DATABASE::Customer,"Bill-to Customer No.",
                  DATABASE::"Salesperson/Purchaser","Service Person",
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::"Deal Type","Deal Type",
                  DATABASE::Vehicle,VIN,
                  DATABASE::Make,"Make Code");
                
                //RecreateDmsServLines(FIELDCAPTION("Vehicle Status Code"));
                */

            end;
        }
        field(33020253;"Assigned User ID";Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                IF NOT UserMgt.CheckRespCenter2(0,"Accountability Center","Assigned User ID") THEN
                  ERROR(
                    Text061,"Assigned User ID",
                    RespCenter.TABLECAPTION,UserMgt.GetSalesFilter2("Assigned User ID"));
            end;
        }
        field(33020254;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center".Code;
        }
        field(33020255;"Complain Closed";Boolean)
        {
            Editable = false;
        }
        field(33020256;"Complain Type";Option)
        {
            OptionCaption = ' ,No Complain,Minor Complain,Hot Complain';
            OptionMembers = " ","No Complain","Minor Complain","Hot Complain";
        }
        field(33020257;"Timely Delivery";Integer)
        {
            BlankNumbers = BlankZero;

            trigger OnValidate()
            begin
                Sum := "Timely Delivery" + Cost + "Quality of Service" + "Behavior of Staff";
            end;
        }
        field(33020258;Cost;Integer)
        {
            BlankNumbers = BlankZero;

            trigger OnValidate()
            begin
                Sum := "Timely Delivery" + Cost + "Quality of Service" + "Behavior of Staff";
            end;
        }
        field(33020259;"Quality of Service";Integer)
        {
            BlankNumbers = BlankZero;

            trigger OnValidate()
            begin
                Sum := "Timely Delivery" + Cost + "Quality of Service" + "Behavior of Staff";
            end;
        }
        field(33020260;"Behavior of Staff";Integer)
        {
            BlankNumbers = BlankZero;

            trigger OnValidate()
            begin
                Sum := "Timely Delivery" + Cost + "Quality of Service" + "Behavior of Staff";
            end;
        }
        field(33020261;"Sum";Integer)
        {
            BlankNumbers = BlankZero;
            Editable = false;
        }
        field(33020262;"Service Order No.";Code[20])
        {
            Editable = false;
        }
        field(33020263;"Delivery Date";Date)
        {
            Editable = false;
        }
        field(33020264;"Repeat Problem";Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(33020265;"Service Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service",Other;
        }
        field(33020266;"Phone No.";Text[30])
        {
            CalcFormula = Lookup(Customer."Phone No." WHERE (No.=FIELD(Customer No.)));
            FieldClass = FlowField;
        }
        field(33020267;"Contact Date";Date)
        {
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
        ServiceSetup.GET;

        IF "No." = '' THEN
         BEGIN
            NoSeriesMgt.InitSeries(GetNoSeriesCode1,xRec."No. Series",0D,"No.","No. Series");
         END;


        "Assigned User ID" := USERID;
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID","Assigned User ID");
        IF UserSetup.FINDFIRST THEN BEGIN
          "Accountability Center" := UserSetup."Default Accountability Center";
          "Location Code" := UserSetup."Default Location";
        END;
    end;

    trigger OnRename()
    begin
        "Assigned User ID" := USERID;
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID","Assigned User ID");
        IF UserSetup.FINDFIRST THEN BEGIN
          "Accountability Center" := UserSetup."Default Accountability Center";
          "Location Code" := UserSetup."Default Location";
        END;
    end;

    var
        ServiceSetup: Record "25006120";
        GLSetup: Record "98";
        ServiceScheduleSetup: Record "25006286";
        GLAcc: Record "15";
        Cust: Record "18";
        PostCode: Record "225";
        RespCenter: Record "33019846";
        Location: Record "14";
        UserMgt: Codeunit "5700";
        NoSeriesMgt: Codeunit "396";
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        SkipSellToContact: Boolean;
        LookUpMgt: Codeunit "25006003";
        ContBusRel: Record "5054";
        FindVehicle: Boolean;
        FindCustomer: Boolean;
        StplSysMgt: Codeunit "50000";
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Do you want to change %1?';
        Text010: Label 'Do you want to continue?';
        Text026: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text027: Label 'Your identification is set up to process from %1 %2 only.';
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text031: Label 'You have modified %1.\\';
        Text037: Label 'Contact %1 %2 is not related to customer %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than customer %3.';
        NRGE02: Label 'This field can be used only for documents with type %1';
        Text039: Label 'Contact %1 %2 is not related to a customer.';
        Text045: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        tcSER001: Label 'The vehicle %1 %2, registration number %3,  VIN %4 exists on another service order. Do you want to Proceed?';
        Text052: Label 'You have changed %1 on the service header, but it has not been changed on the existing service lines.\';
        Text121: Label 'The vehicle %1 %2, registration number %3,  VIN %4 exists in %5 other service orders. Do you want to Proceed?';
        Text122: Label 'You cannot Release Quote or Make Order unless you specify a vehicle on the quote.\\Do you want to create vehicle now?';
        Text123: Label 'You cannot Release Quote or Make Order unless you specify a sell-to contact or sell-to customer on the quote.\\Do you want to create contact now?';
        Text125: Label 'Do You want to link this vehice to contact No. %1?';
        Text131: Label 'There is no vehicle with Registration No. %1';
        VehicleConfirm: Label 'There is a vehicle linked to this contact.\%1 %2\%3 %4\%5 %6\Do you want to apply this vehicle?';
        ContactConfirm: Label 'There is a customer linked to this vehicle.\%1 %2\Do you want to apply this customer?';
        ProcessCancelled: Label 'The vehicle with registration number %1,  VIN %2 already exists service order no %3.';
        InvalidHour: Label 'The new hour is less than the previous one.';
        Text061: Label '%1 is set up to process from %2 %3 only.';
        Text062: Label 'Vehicle has not been linked to any Contacts. Please inform authorised person to link Vehicle with Contacts.';
        CompHeader: Record "33019847";
        UserSetup: Record "91";

    [Scope('Internal')]
    procedure AssistEdit(OldComplainHeader: Record "33019847"): Boolean
    var
        ComplainHeader2: Record "33019847";
    begin
        WITH  CompHeader DO BEGIN
          COPY(Rec);
          ServiceSetup.GET;
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode1,OldComplainHeader."No. Series","No. Series") THEN BEGIN
            //ServiceSetup.GET;
            NoSeriesMgt.SetSeries("No.");
            Rec := CompHeader;
            EXIT(TRUE);
          END;
        END;
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
    end;

    [Scope('Internal')]
    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    [Scope('Internal')]
    procedure CheckCustomerCreated(Prompt: Boolean): Boolean
    var
        Cont: Record "5050";
    begin
        /*
        IF (RecreateDmsServLines <> '') AND ("Sell-to Customer No." <> '') THEN
          EXIT(TRUE);
        
        
        IF Prompt THEN
          IF NOT CONFIRM(Text035,TRUE) THEN
            EXIT(FALSE);
        
        IF "Sell-to Customer No." = '' THEN BEGIN
          TESTFIELD("Sell-to Contact No.");
        
          TESTFIELD("Sell-to Customer Template Code");
          Cont.GET("Sell-to Contact No.");
          Cont.CreateCustomer("Sell-to Customer Template Code");
          COMMIT;
          GET(AssistEdit::"0","No.");
        END;
        
        IF RecreateDmsServLines = '' THEN BEGIN
          TESTFIELD("Bill-to Contact No.");
          TESTFIELD("Bill-to Customer Template Code");
          Cont.GET("Bill-to Contact No.");
          Cont.CreateCustomer("Bill-to Customer Template Code");
          COMMIT;
          GET(AssistEdit::"0","No.");
        END;
        
        EXIT((RecreateDmsServLines <> '') AND ("Sell-to Customer No." <> ''));
        */

    end;

    [Scope('Internal')]
    procedure UpdateSellToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "5054";
        Cont: Record "5050";
        Cust: Record "18";
        recVehicle: Record "25006005";
    begin
        IF Cust.GET(CustomerNo) THEN BEGIN
          IF Cust."Primary Contact No." <> '' THEN
            "Contact No." := Cust."Primary Contact No."
          ELSE BEGIN
            ContBusRel.RESET;
            ContBusRel.SETCURRENTKEY("Link to Table","No.");
            ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
            ContBusRel.SETRANGE("No.","Customer No.");
            IF ContBusRel.FIND('-') THEN BEGIN
              "Contact No." := ContBusRel."Contact No.";

              IF (Rec."Vehicle Registration No." = xRec."Vehicle Registration No.")
                AND ("Vehicle Serial No." = xRec."Vehicle Serial No.") AND NOT FindCustomer THEN
                 FindContVehicle;

            END;
          END;
          Contact := Cust.Contact;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateSellToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "5054";
        Cust: Record "18";
        Cont: Record "5050";
        CustTemplate: Record "5105";
        ContComp: Record "5050";
        recVehicle: Record "25006005";
    begin
        
        IF Cont.GET(ContactNo) THEN BEGIN
          "Contact No." := Cont."No.";
        
          IF Cont.Type = Cont.Type::Company THEN
            Contact := Cont.Name
          ELSE
            IF Cust.GET("Customer No.") THEN
              Contact := Cust.Contact
            ELSE
              Contact := '';
        END ELSE BEGIN
            Contact := '';
            EXIT;
          END;
        
        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
        IF ContBusinessRelation.FIND('-') THEN BEGIN
          IF ("Customer No." <> '') AND
             ("Customer No." <> ContBusinessRelation."No.")
          THEN
            ERROR(Text037,Cont."No.",Cont.Name,"Customer No.")
          ELSE IF "Customer No." = '' THEN BEGIN
            SkipSellToContact := TRUE;
            VALIDATE("Customer No.",ContBusinessRelation."No.");
            SkipSellToContact := FALSE;
          END;
        END ELSE BEGIN
          //IF AssistEdit = AssistEdit::"0" THEN BEGIN
            Cont.TESTFIELD("Company No.");
            ContComp.GET(Cont."Company No.");
            "Customer Name" := ContComp."Company Name";
            "Customer Name 2" := ContComp."Name 2";
            Address := ContComp.Address;
            "Address 2" := ContComp."Address 2";
            City := ContComp.City;
            "Post Code" := ContComp."Post Code";
            Country := ContComp.County;
            "Country/Region Code" := ContComp."Country/Region Code";
            //SetHideValidationDialog := ContComp."Name 2";
            //UpdateDMSServLines := ContComp.Address;
            //CreateDim := ContComp."Address 2";
            /*
            IF ("Sell-to Customer Template Code" = '') AND (NOT CustTemplate.ISEMPTY) THEN
              VALIDATE("Sell-to Customer Template Code",Cont.FindCustomerTemplate);
          END ELSE
            ERROR(Text039,Cont."No.",Cont.Name);
           */
        END;

    end;

    [Scope('Internal')]
    procedure FindContVehicle(): Code[20]
    var
        Vehicle: Record "25006005";
        VehCount: Integer;
        Cont: Record "5050";
        VehicleContact: Record "25006013";
    begin
        IF "Contact No." = '' THEN
         EXIT;

        IF NOT Cont.GET("Contact No.") THEN
         EXIT;

        FindVehicle := TRUE;

        Vehicle.RESET;

        MarkContVehicles(Vehicle,Cont."No.");
        IF (Cont.Type = Cont.Type::Company)
         AND (Cont."Company No." <> '')  THEN BEGIN
          IF Cont.GET(Cont."Company No.") THEN
            MarkContVehicles(Vehicle,Cont."No.");
        END;
        Vehicle.MARKEDONLY(TRUE);
        VehCount := Vehicle.COUNT;

        CASE VehCount OF
         0:
          BEGIN
           Vehicle.MARKEDONLY(FALSE);
          END;
         1:
          BEGIN
           Vehicle.FINDFIRST;
           IF CONFIRM(VehicleConfirm,TRUE,Vehicle."Make Code",Vehicle."Model Code",
             Vehicle.FIELDCAPTION("Registration No."),Vehicle."Registration No.",
             Vehicle.FIELDCAPTION(VIN),Vehicle.VIN) THEN
           VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
          END;
         ELSE
          BEGIN
           COMMIT;
           //IF cuLookUpMgt.LookUpVehicleAMT(Vehicle,'') THEN
           //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
           IF PAGE.RUNMODAL(PAGE::"Vehicle List",Vehicle) = ACTION::LookupOK THEN //!!
             VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
          END;
        END;
    end;

    [Scope('Internal')]
    procedure FindVehicleCont(): Code[20]
    var
        Vehicle: Record "25006005";
        CustomerCount: Integer;
        Contact: Record "5050";
        VehicleContact: Record "25006013";
        ContBusRelation: Record "5054";
        Customer: Record "18";
    begin
        IF "Vehicle Serial No." = '' THEN
          EXIT;

        FindCustomer := TRUE;

        Contact.RESET;
        Customer.RESET;

        MarkVehicleContacts(Contact,"Vehicle Serial No.");
        Contact.MARKEDONLY(TRUE);
        IF Contact.FINDFIRST THEN
          REPEAT
            ContBusRelation.SETRANGE("Contact No.", Contact."No.");
            IF ContBusRelation.FINDFIRST THEN
              REPEAT
                IF Customer.GET(ContBusRelation."No.") THEN
                  Customer.MARK(TRUE);
              UNTIL ContBusRelation.NEXT = 0;
          UNTIL Contact.NEXT = 0;
        Customer.MARKEDONLY(TRUE);

        CustomerCount := Customer.COUNT;
        IF CustomerCount=0 THEN
          ERROR(Text062);
        CASE CustomerCount OF
         0:
          BEGIN
           Customer.MARKEDONLY(FALSE);
          END;
         1:
          BEGIN
           Customer.FINDFIRST;
           IF CONFIRM(ContactConfirm,TRUE,Customer."No.", Customer.Name) THEN
             VALIDATE("Customer No.",Customer."No.");
          END;
         ELSE
          BEGIN
            COMMIT;
            IF PAGE.RUNMODAL(PAGE::"Customer List", Customer) = ACTION::LookupOK THEN
              VALIDATE("Customer No.",Customer."No.");
          END;
        END;
    end;

    [Scope('Internal')]
    procedure UpdVehicleInfo(VehSerialNo: Code[20];recVehicle: Record "25006005")
    var
        recServHeader: Record "25006145";
        recSalesLine: Record "37";
        SkipBAL: Code[10];
    begin
        /*//11.07.2007. EDMS P2 >>
        //Sipradi-YS * Modified to not allow multiple service orders for same vehicle, except Balkumari
        IF ("Responsibility Centers" <> 'BAL-SCV') AND ("Responsibility Centers" <> 'BAL-SPC') THEN BEGIN
          IF VIN <> '' THEN
           BEGIN
            recServHeader.SETRANGE("Document Type",AssistEdit);
            recServHeader.SETFILTER("No.",'<>%1',"No.");
            recServHeader.SETRANGE("Vehicle Serial No.",VehSerialNo);
            recServHeader.SETFILTER("Responsibility Centers",'<>%1&<>%2','BAL-SPC','BAL-SCV');
            IF recServHeader.FINDFIRST THEN
                DuplicateServiceOrderNo := recServHeader."No.";
            CASE recServHeader.COUNT OF
              0:
                EXIT;
              1:
                //IF NOT
                //CONFIRM(tcSER001,FALSE,recVehicle."Make Code",recVehicle."Model Code",recVehicle."Registration No.",recVehicle.VIN) THEN
                ERROR(ProcessCancelled,recVehicle."Registration No.",recVehicle.VIN,DuplicateServiceOrderNo);
        
              ELSE
                //IF NOT
                //CONFIRM(Text121,FALSE,recVehicle."Make Code",recVehicle."Model Code",recVehicle."Registration No.",recVehicle.VIN,
                //        recServHeader.COUNT) THEN
                // ERROR(ProcessCancelled);
                ERROR(ProcessCancelled,recVehicle."Registration No.",recVehicle.VIN,DuplicateServiceOrderNo);
        
            END;
           END;
        END;
        //11.07.2007. EDMS P2 <<
        */

    end;

    [Scope('Internal')]
    procedure GetUserSetup()
    var
        UserSetup: Record "91";
        SingleInstanceMgt: Codeunit "25006001";
        UserProfileMgt: Codeunit "25006002";
        UserProfile: Record "25006067";
        ServSetup: Record "25006120";
        ServLocation: Code[20];
    begin
        /*ServSetup.GET;
        IF UserSetup.GET(USERID) THEN
         BEGIN
          IF UserSetup."Salespers./Purch. Code" <> '' THEN
           VALIDATE("Service Person",UserSetup."Salespers./Purch. Code");
         END;
        
        IF UserProfileMgt.CurrProfileID <> '' THEN
         BEGIN
          IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
           BEGIN
            IF UserProfile."Spec. Service Setup" THEN
             BEGIN //For Vehicle Salespersons
              VALIDATE("Initiator Code",UserSetup."Salespers./Purch. Code");
              VALIDATE("Service Person",UserProfile."Spec. Order Receiver");
              UserProfile.TESTFIELD("Spec. Service User Profile");
              IF UserProfile.GET(UserProfile."Spec. Service User Profile") THEN
               BEGIN
                ServLocation := UserProfile."Def. Service Location Code";
                IF ServLocation = '' THEN
                  ServLocation := ServSetup."Def. Service Location Code";
                IF ServLocation <> '' THEN
                 VALIDATE("Location Code",ServLocation);
                IF UserProfile."Default Deal Type Code" <> '' THEN
                  VALIDATE("Deal Type",UserProfile."Default Deal Type Code");
               END;
             END
            ELSE
             BEGIN //For Service Employees
              ServLocation := UserProfile."Def. Service Location Code";
              IF ServLocation = '' THEN
               ServLocation := ServSetup."Def. Service Location Code";
              IF ServLocation <> '' THEN
               VALIDATE("Location Code",ServLocation);
              IF UserProfile."Default Deal Type Code" <> '' THEN
                VALIDATE("Deal Type",UserProfile."Default Deal Type Code");
             END;
           END;
         END;
        */

    end;

    [Scope('Internal')]
    procedure TestKilometrage()
    var
        ServOrdInfoPaneMgt: Codeunit "25006104";
    begin
    end;

    [Scope('Internal')]
    procedure CheckVehicleCreated(Prompt: Boolean): Boolean
    var
        Vehicle: Record "25006005";
    begin
        /*
        IF ("Vehicle Serial No." <> '') THEN
          EXIT(TRUE);
        
        IF Prompt THEN
          IF NOT CONFIRM(Text122,TRUE) THEN
            EXIT(FALSE);
        
        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        TESTFIELD(VIN);
        
        Vehicle.RESET;
        Vehicle."Serial No." := '';
        Vehicle.INSERT(TRUE);
        Vehicle.VALIDATE(VIN, VIN);
        Vehicle.VALIDATE("Make Code", "Make Code");
        Vehicle.VALIDATE("Model Code", "Model Code");
        IF "Model Version No." <> '' THEN
          Vehicle.VALIDATE("Model Version No.", "Model Version No.");
        IF "Vehicle Registration No." <> '' THEN
          Vehicle.VALIDATE("Registration No.", "Vehicle Registration No.");
        IF "Vehicle Status Code" <> '' THEN
          Vehicle.VALIDATE("Status Code", "Vehicle Status Code");
        Vehicle.MODIFY(TRUE);
        
        "Vehicle Serial No." := Vehicle."Serial No.";
        
        EXIT("Vehicle Serial No." <> '');
         */

    end;

    [Scope('Internal')]
    procedure CheckContactCreated(Prompt: Boolean): Boolean
    var
        Contact: Record "25006005";
    begin
        /*
        IF ("Sell-to Contact No." <> '') THEN
          EXIT(TRUE);
        IF ("Sell-to Customer No." <> '') THEN
          EXIT(TRUE);
        
        IF Prompt THEN
          IF NOT CONFIRM(Text123,TRUE) THEN
            EXIT(FALSE);
        
        EXIT(CreateContactFromServHeader);
        */

    end;

    [Scope('Internal')]
    procedure MarkContVehicles(var Vehicle: Record "25006005";ContNo: Code[20])
    var
        VehicleContact: Record "25006013";
    begin
        VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Contact No.");
        VehicleContact.SETRANGE("Contact No.",ContNo);
        IF VehicleContact.FINDFIRST THEN
         REPEAT
          IF Vehicle.GET(VehicleContact."Vehicle Serial No.") THEN
            Vehicle.MARK := TRUE;
         UNTIL VehicleContact.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure MarkVehicleContacts(var Contact: Record "5050";VehSerialNo: Code[20])
    var
        VehicleContact: Record "25006013";
    begin
        VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Vehicle Serial No.");
        VehicleContact.SETRANGE("Vehicle Serial No.",VehSerialNo);
        IF VehicleContact.FINDFIRST THEN
         REPEAT
          IF Contact.GET(VehicleContact."Contact No.") THEN
            Contact.MARK := TRUE;
         UNTIL VehicleContact.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateVehicleContact()
    var
        VehicleContact: Record "25006013";
    begin
        ServiceSetup.GET;
        IF NOT ServiceSetup."Offer Link Vehicle and Contact" THEN
          EXIT;

        IF "Contact No." = '' THEN
          EXIT;

        VehicleContact.RESET;
        VehicleContact.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        IF VehicleContact.COUNT > 0 THEN
          EXIT;

        IF NOT CONFIRM(STRSUBSTNO(Text125, "Contact No.")) THEN
          EXIT;

        VehicleContact.INIT;
        VehicleContact.VALIDATE("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleContact.VALIDATE("Relationship Code", ServiceSetup."Link Relationship Code");
        VehicleContact.VALIDATE("Contact No.", "Contact No.");
        VehicleContact.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure SetNotFindVehicle()
    begin
        FindCustomer := TRUE;
        FindVehicle := TRUE;
    end;

    [Scope('Internal')]
    procedure GetNoSeriesCode1(): Code[20]
    begin
        EXIT(StplSysMgt.getCustCompNo);
    end;
}

