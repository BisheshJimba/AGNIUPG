table 33019864 "Membership Details"
{

    fields
    {
        field(1; "Membership Card No."; Code[20])
        {
        }
        field(3; "Customer No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
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
                    "Phone No." := Cust."Phone No.";
                END;

                //UpdateSellToCont("Customer No.");
            end;
        }
        field(4; "Customer Name"; Text[80])
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(5; VIN; Code[20])
        {
            TableRelation = Vehicle;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                /*IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                 VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                */

            end;

            trigger OnValidate()
            begin
                /*
                IF VIN = '' THEN
                  VALIDATE("Vehicle Serial No.",'')
                ELSE BEGIN
                  recVehicle.RESET;
                  recVehicle.SETCURRENTKEY(VIN);
                  recVehicle.SETRANGE(VIN,VIN);
                  IF recVehicle.FINDFIRST THEN
                    VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                END;
                */

            end;
        }
        field(6; "Joined Date"; Date)
        {
        }
        field(7; "Expiry Date"; Date)
        {
        }
        field(8; "Engine No."; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Engine No." WHERE(VIN = FIELD(VIN)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Scheme Code"; Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(10; Status; Option)
        {
            Description = 'active and inactive depends upon the expiry date and blocked is forceful cancellation of membership.';
            OptionCaption = ' ,Active,Inactive,Blocked';
            OptionMembers = " ",Active,Inactive,Blocked;
        }
        field(14; "No. series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(16; "Assigned User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                IF NOT UserMgt.CheckRespCenter2(0, "Accountability Center", "Assigned User ID") THEN
                    ERROR(
                      Text061, "Assigned User ID",
                      RespCenter.TABLECAPTION, UserMgt.GetSalesFilter2("Assigned User ID"));
            end;
        }
        field(20; "Customer Name 2"; Text[50])
        {
        }
        field(21; Address; Text[50])
        {
        }
        field(22; "Address 2"; Text[50])
        {
        }
        field(23; "Phone No."; Text[30])
        {
        }
        field(24; "Vehicle Registration No."; Code[20])
        {

            trigger OnLookup()
            var
                vehicle: Record "25006005";
            begin
                /*
                IF "Vehicle Registration No." <> '' THEN BEGIN
                  vehicle.RESET;
                  vehicle.SETCURRENTKEY("Registration No.");
                  vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
                  IF vehicle.FINDFIRST THEN;
                  vehicle.SETRANGE("Registration No.");
                END;
                
                IF LookUpMgt.LookUpVehicleAMT(vehicle,"Vehicle Serial No.") THEN
                 VALIDATE("Vehicle Serial No.",vehicle."Serial No.");
                */

            end;
        }
        field(25; "Contact No."; Code[20])
        {
        }
        field(26; "Insurance Amount"; Decimal)
        {
        }
        field(27; "Free Recharge Coupon"; Boolean)
        {
        }
        field(28; "Recharge Amount"; Decimal)
        {
        }
        field(29; "Driver Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Membership Card No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Assigned User ID" := USERID;
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", "Assigned User ID");
        IF UserSetup.FINDFIRST THEN BEGIN
            "Accountability Center" := UserSetup."Default Accountability Center";
        END;
    end;

    var
        Customer: Record "18";
        StplSysMgt: Codeunit "50000";
        NoSeriesMgt: Codeunit "396";
        UserSetup: Record "91";
        ServiceSetup: Record "25006120";
        Cust: Record "18";
        recVehicle: Record "25006005";
        LookUpMgt: Codeunit "25006003";
        UserMgt: Codeunit "5700";
        Text061: Label '%1 is set up to process from %2 %3 only.';
        RespCenter: Record "33019846";
        FindCustomer: Boolean;
        FindVehicle: Boolean;
        VehicleConfirm: Label 'There is a vehicle linked to this contact.\%1 %2\%3 %4\%5 %6\Do you want to apply this vehicle?';
        Text062: Label 'Vehicle has not been linked to any Contacts. Please inform authorised person to link Vehicle with Contacts.';
        ContactConfirm: Label 'There is a customer linked to this vehicle.\%1 %2\Do you want to apply this customer?';
        ItemRec: Record "27";

    [Scope('Internal')]
    procedure GetNoSeriesCode1(): Code[20]
    begin
        EXIT(StplSysMgt.GetMembershipNo);
    end;

    [Scope('Internal')]
    procedure AssistEdit(OldMembershipDetail: Record "33019864"): Boolean
    var
        MembershipDetails: Record "33019864";
        AccoutabilityCenter: Record "33019846";
    begin
    end;

    [Scope('Internal')]
    procedure UpdateSellToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "5054";
        Cont: Record "5050";
        Cust: Record "18";
        recVehicle: Record "25006005";
    begin
        /*
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
        END;
        */

    end;

    [Scope('Internal')]
    procedure FindContVehicle(): Code[20]
    var
        Vehicle: Record "25006005";
        VehCount: Integer;
        Cont: Record "5050";
        VehicleContact: Record "25006013";
    begin
        /*
        IF "Contact No." = '' THEN
         EXIT;
        
        IF NOT Cont.GET("Contact No.") THEN
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
           VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
          END;
         ELSE
          BEGIN
           COMMIT;
           //IF cuLookUpMgt.LookUpVehicleAMT(Vehicle,'') THEN
           //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
           IF FORM.RUNMODAL(FORM::"Vehicle List",Vehicle) = ACTION::LookupOK THEN //!!
             VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
          END;
        END;
        */

    end;

    [Scope('Internal')]
    procedure MarkContVehicles(var Vehicle: Record "25006005"; ContNo: Code[20])
    var
        VehicleContact: Record "25006013";
    begin
        /*VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Contact No.");
        VehicleContact.SETRANGE("Contact No.",ContNo);
        IF VehicleContact.FINDFIRST THEN
         REPEAT
          IF Vehicle.GET(VehicleContact."Vehicle Serial No.") THEN
            Vehicle.MARK := TRUE;
         UNTIL VehicleContact.NEXT = 0;
        */

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
        /*
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
            IF FORM.RUNMODAL(FORM::"Customer List", Customer) = ACTION::LookupOK THEN
              VALIDATE("Customer No.",Customer."No.");
          END;
        END;
        */

    end;

    [Scope('Internal')]
    procedure MarkVehicleContacts(var Contact: Record "5050"; VehSerialNo: Code[20])
    var
        VehicleContact: Record "25006013";
    begin
        /*
        VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Vehicle Serial No.");
        VehicleContact.SETRANGE("Vehicle Serial No.",VehSerialNo);
        IF VehicleContact.FINDFIRST THEN
         REPEAT
          IF Contact.GET(VehicleContact."Contact No.") THEN
            Contact.MARK := TRUE;
         UNTIL VehicleContact.NEXT = 0;
        */

    end;
}

