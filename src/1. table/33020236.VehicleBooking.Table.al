table 33020236 "Vehicle Booking"
{

    fields
    {
        field(1; Date; Date)
        {
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = false;
            Editable = false;
        }
        field(3; "Customer No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF Customer.GET("Customer No.") THEN
                    "Customer Name" := Customer.Name;
                Contact := Customer.Contact;

                IF ("Customer No." <> '') AND (Contact <> '') THEN BEGIN
                    Cont.GET(Contact);
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                    ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SETRANGE("No.", "Customer No.");
                    IF ContBusinessRelation.FIND('-') THEN
                        IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                            ERROR(Text038, Cont."No.", Cont.Name, "Customer No.");
                END;

                //UpdateSellToCust("Sell-to Contact No.");


                IF (Rec."Vehicle Reg. No." = xRec."Vehicle Reg. No.")
                 AND ("Vehicle Serial No." = xRec."Vehicle Serial No.") AND NOT FindCustomer THEN
                    FindContVehicle;
            end;
        }
        field(4; "Customer Name"; Text[50])
        {
        }
        field(5; Contact; Text[50])
        {
        }
        field(6; "Vehicle Reg. No."; Code[20])
        {

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Reg. No." <> '' THEN BEGIN
                    Vehicle.RESET;
                    Vehicle.SETCURRENTKEY("Registration No.");
                    Vehicle.SETRANGE("Registration No.", "Vehicle Reg. No.");
                    IF Vehicle.FINDFIRST THEN;
                    Vehicle.SETRANGE("Registration No.");
                END;

                IF LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") THEN BEGIN
                    VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");
                    "Vehicle Reg. No." := Vehicle."Registration No.";
                END
            end;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Reg. No." = '' THEN BEGIN
                    VALIDATE("Vehicle Serial No.", '');
                    EXIT;
                END;

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY("Registration No.");
                Vehicle.SETRANGE("Registration No.", "Vehicle Reg. No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                    IF "Vehicle Serial No." <> Vehicle."Serial No." THEN BEGIN
                        "Vehicle Reg. No." := Vehicle."Registration No.";
                        VALIDATE("Vehicle Serial No.", Vehicle."Serial No.")
                    END
                END ELSE
                    MESSAGE(STRSUBSTNO(Text131, "Vehicle Reg. No."));
            end;
        }
        field(7; "Vehicle Serial No."; Code[20])
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
                Vehi: Record "33019823";
            begin
                IF "Vehicle Serial No." = '' THEN BEGIN
                    "Vehicle Reg. No." := '';
                    Make := '';
                    "Model Code" := '';
                    VIN := '';
                    "Vehicle Accounting Cycle No." := '';
                    "Model Commercial Name" := '';

                    EXIT;
                END;

                Vehicle.GET("Vehicle Serial No.");

                IF Vehi.GET("Vehicle Serial No.") THEN;
                Vehi.CALCFIELDS("Default Vehicle Acc. Cycle No.");


                VIN := Vehicle.VIN;
                VALIDATE("Vehicle Accounting Cycle No.", Vehi."Default Vehicle Acc. Cycle No.");
                "Vehicle Reg. No." := Vehicle."Registration No.";
                Make := Vehicle."Make Code";
                "Model Code" := Vehicle."Model Code";


                IF Model.GET(Make, "Model Code") THEN
                    "Model Commercial Name" := Model."Commercial Name"
                ELSE
                    "Model Commercial Name" := Vehicle."Model Commercial Name";




                //UpdateVehicleContact;

                DocumentMgt.ShowVehicleComments("Vehicle Serial No.");

                //CheckRecallCampaigns("Vehicle Serial No.");
            end;
        }
        field(8; "Model Code"; Code[20])
        {
            TableRelation = Model.Code;
        }
        field(9; "Time Slot Booked"; Time)
        {
        }
        field(10; "Job Description"; Text[150])
        {
        }
        field(11; "Booked on Date"; Date)
        {
        }
        field(12; "Booked By"; Code[50])
        {
            TableRelation = Employee.No.;
        }
        field(13; Remarks; Text[150])
        {
        }
        field(14; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(15; "Responsibility Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center".Code;
        }
        field(16; "Job Created"; Boolean)
        {
            Editable = false;
        }
        field(17; "Job Creation Date"; Date)
        {
        }
        field(18; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(19; Make; Code[10])
        {
        }
        field(20; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                IF LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") THEN
                    VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
                bFillCustomer: Boolean;
            begin
                TESTFIELD(Status, Status::Open);

                IF VIN = '' THEN
                    VALIDATE("Vehicle Serial No.", '')
                ELSE BEGIN
                    recVehicle.RESET;
                    recVehicle.SETCURRENTKEY(VIN);
                    recVehicle.SETRANGE(VIN, VIN);
                    IF recVehicle.FINDFIRST THEN
                        VALIDATE("Vehicle Serial No.", recVehicle."Serial No.");
                END;
            end;
        }
        field(21; Kilometrage; Decimal)
        {
            BlankZero = true;
            Caption = 'Kilometrage';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                /*TestKilometrage;
                CheckServicePlan
                */

            end;
        }
        field(22; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(23; "Model Commercial Name"; Text[50])
        {
            CalcFormula = Lookup(Model."Commercial Name" WHERE(Make Code=FIELD(Make),
                                                                Code=FIELD(Model Code)));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24;"Service Order No.";Code[10])
        {
            TableRelation = "Service Header EDMS".No.;
        }
        field(25;Location;Code[10])
        {
            TableRelation = Location.Code;
        }
        field(26;"Accountability Center";Code[10])
        {
        }
    }

    keys
    {
        key(Key1;Date,"Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Posting Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Date := WORKDATE;
        "Posting Date" := WORKDATE;
        GetResponsibilityCenter;
    end;

    var
        Customer: Record "18";
        LookUpMgt: Codeunit "25006003";
        Text131: Label 'There is no vehicle with Registration No. %1';
        Text038: Label 'Contact %1 %2 is related to a different company than customer %3.';
        FindVehicle: Boolean;
        VehicleConfirm: Label 'There is a vehicle linked to this contact.\%1 %2\%3 %4\%5 %6\Do you want to apply this vehicle?';
        FindCustomer: Boolean;
        UserMgt: Codeunit "5700";

    [Scope('Internal')]
    procedure FindContVehicle()
    var
        Vehicle: Record "25006005";
        VehCount: Integer;
        Cont: Record "5050";
        VehicleContact: Record "25006013";
    begin
        IF Contact = '' THEN
         EXIT;

        IF NOT Cont.GET(Contact) THEN
         EXIT;

        FindVehicle := TRUE;

        Vehicle.RESET;

        MarkContVehicles(Vehicle,Cont."No.");
        IF (Cont.Type = Cont.Type::Person)
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
             BEGIN
           VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
           VALIDATE("Vehicle Reg. No.",Vehicle."Registration No.");
           VALIDATE("Model Code",Vehicle."Model Code");
           END
          END;
         ELSE
          BEGIN
           COMMIT;
           //IF cuLookUpMgt.LookUpVehicleAMT(Vehicle,'') THEN
           //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
           IF PAGE.RUNMODAL(PAGE::"Vehicle List",Vehicle) = ACTION::LookupOK THEN //!!
           BEGIN
             VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
             VALIDATE("Vehicle Reg. No.",Vehicle."Registration No.");
             VALIDATE("Model Code",Vehicle."Model Code");
           END
          END;
        END;
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
    procedure CreateJobCard()
    var
        ServHeaderEDMS: Record "25006145";
        Cust: Record "18";
        JobAlreadyCreated: Label 'Job Card Already Created For Vehicle %1.';
    begin

        IF NOT "Job Created" THEN
        BEGIN
           TESTFIELD("Customer No.");
           TESTFIELD("Vehicle Reg. No.");
           TESTFIELD("Booked on Date");
           TESTFIELD("Time Slot Booked");

           ServHeaderEDMS.RESET;
           ServHeaderEDMS.INIT;

           ServHeaderEDMS."Document Type" := ServHeaderEDMS."Document Type"::Order;
           ServHeaderEDMS.VALIDATE("No.");
           ServHeaderEDMS."Sell-to Customer Template Code" := '';
           ServHeaderEDMS."Sell-to Customer No.":="Customer No.";
           ServHeaderEDMS."Sell-to Contact No.":=Contact;

           Cust.GET("Customer No.");

           ServHeaderEDMS."Sell-to Customer Name" := "Customer Name";
           ServHeaderEDMS."Sell-to Address" := Cust.Address;
           ServHeaderEDMS."Sell-to Address 2" := Cust."Address 2";
           ServHeaderEDMS."Sell-to City" := Cust.City;
           ServHeaderEDMS."Sell-to Post Code" := Cust."Post Code";
           ServHeaderEDMS."Sell-to County" := Cust.County;
           ServHeaderEDMS."Sell-to Country/Region Code" := Cust."Country/Region Code";
           ServHeaderEDMS."Bill-to Customer No." := Cust."Bill-to Customer No.";
           //IF NOT SkipSellToContact THEN
            //"Sell-to Contact" := Cust.Contact;
           ServHeaderEDMS."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
           ServHeaderEDMS."VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
           ServHeaderEDMS."VAT Registration No." := Cust."VAT Registration No.";
           ServHeaderEDMS."Responsibility Center" := "Responsibility Center";
           ServHeaderEDMS."Accountability Center" := "Accountability Center";
           ServHeaderEDMS."Location Code" := Location;
           //GetShippingTime(FIELDNO("Sell-to Customer No."));

           //VALIDATE("Vehicle Item Charge No.",Cust."Default Service Item Charge");


           ServHeaderEDMS."Vehicle Registration No.":="Vehicle Reg. No.";
           ServHeaderEDMS."Vehicle Serial No.":="Vehicle Serial No.";
           ServHeaderEDMS."Vehicle Accounting Cycle No." := "Vehicle Accounting Cycle No.";
           ServHeaderEDMS."Make Code" := Make;
           ServHeaderEDMS."Model Code" := "Model Code";
           ServHeaderEDMS.VIN := VIN;
           ServHeaderEDMS.Kilometrage := Kilometrage;
           ServHeaderEDMS.Status := Status;
           ServHeaderEDMS."Model Commercial Name" := "Model Commercial Name";
           ServHeaderEDMS.INSERT(TRUE);

           "Job Created" := TRUE;
           "Job Creation Date" := WORKDATE;
           "Service Order No." := ServHeaderEDMS."No.";

           MODIFY;
           MESSAGE('Job Card Created For Vehicle %1. Job Card No.=%2',"Vehicle Reg. No.",ServHeaderEDMS."No.");
        END
        ELSE
         MESSAGE(JobAlreadyCreated,"Vehicle Reg. No.");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[10]
    var
        ServiceSetup: Record "25006120";
        NoSeriesMgt: Codeunit "396";
    begin
          ServiceSetup.GET;
          NoSeriesMgt.TestManual(ServiceSetup."Order Nos.");
          //"No. Series" := '';
        /*
        IF ServiceSetup."Use Order No. as Posting No." THEN
              "Posting No." := "No.";
          END
         */

    end;

    [Scope('Internal')]
    procedure GetResponsibilityCenter(): Code[10]
    var
        UserSetup: Record "91";
    begin
        IF UserMgt.DefaultResponsibility THEN BEGIN
          IF UserSetup.GET(USERID) THEN BEGIN
            "Responsibility Center" := UserSetup."Default Responsibility Center";
            Location := UserSetup."Default Location";
          END
        END ELSE BEGIN
          IF UserSetup.GET(USERID) THEN BEGIN
            "Accountability Center" := UserSetup."Default Accountability Center";
            Location := UserSetup."Default Location";
          END;
        END;
    end;
}

