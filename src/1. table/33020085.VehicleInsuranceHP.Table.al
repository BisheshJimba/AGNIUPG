table 33020085 "Vehicle Insurance HP"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF VehicleFinanceHeader.GET("Loan No.") THEN BEGIN

                    VehicleFinanceHeader.TESTFIELD("Customer No.");
                    VehicleFinanceHeader.TESTFIELD("Vehicle No.");
                    VehicleFinanceHeader.TESTFIELD(Closed, FALSE);

                    Vehicle.GET(VehicleFinanceHeader."Vehicle No.");

                    "Vehicle Serial No." := Vehicle."Serial No.";
                    "VIN No." := Vehicle.VIN;
                    "Engine No." := Vehicle."Engine No.";
                    "Vehicle Reg. No." := Vehicle."Registration No.";

                    "Customer No." := VehicleFinanceHeader."Customer No.";
                    "Customer Name" := VehicleFinanceHeader."Customer Name";

                    Customer.GET(VehicleFinanceHeader."Customer No.");
                    "Customer Phone No." := Customer."Phone No." + ', ' + Customer."Mobile No.";
                    "Cust. Mobile Phone No." := Customer."Mobile No.";
                    "Credit Officer" := VehicleFinanceHeader."Responsible Person Code";
                    VehicleFinanceHeader.CALCFIELDS("Responsible Person Name");
                    "Credit Officer Name" := VehicleFinanceHeader."Responsible Person Name";

                END ELSE BEGIN

                    "Vehicle Serial No." := '';
                    "VIN No." := '';
                    "Engine No." := '';
                    "Vehicle Reg. No." := '';
                    "Customer No." := '';
                    "Customer Name" := '';
                    "Customer Phone No." := '';
                    "Cust. Mobile Phone No." := '';
                    "Credit Officer" := '';
                    "Credit Officer Name" := '';
                END;
            end;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Insurance Type"; Option)
        {
            OptionCaption = ' ,Third Party,AHPPL';
            OptionMembers = " ","Third Party",AHPPL;
        }
        field(4; "Creation DateTime"; DateTime)
        {
        }
        field(5; "Created By"; Code[50])
        {
        }
        field(10; "Policy No."; Text[100])
        {
        }
        field(11; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                VALIDATE("End Date", CALCDATE('1Y-1D', "Start Date"));
            end;
        }
        field(12; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Start Date");

                IF "End Date" < "Start Date" THEN
                    ERROR('End Date must not be before Start Date.');
            end;
        }
        field(20; "Insurance Company Code"; Code[20])
        {
            TableRelation = Vendor.No.;

            trigger OnValidate()
            var
                Vendor: Record "23";
            begin
                IF Vendor.GET("Insurance Company Code") THEN
                    "Insurance Company Name" := Vendor.Name
                ELSE
                    "Insurance Company Name" := '';
            end;
        }
        field(21; "Insurance Company Name"; Text[50])
        {
        }
        field(30; "Vehicle Serial No."; Code[20])
        {
            TableRelation = Vehicle."Serial No.";
        }
        field(31; "VIN No."; Code[20])
        {
        }
        field(32; "Engine No."; Code[30])
        {
        }
        field(33; "Vehicle Reg. No."; Code[20])
        {
        }
        field(40; "Customer No."; Code[20])
        {
            TableRelation = Customer.No.;

            trigger OnValidate()
            var
                Customer: Record "18";
            begin
                IF Customer.GET("Customer No.") THEN
                    "Customer Name" := Customer.Name
                ELSE
                    "Customer Name" := '';
            end;
        }
        field(41; "Customer Name"; Text[50])
        {
        }
        field(42; "Customer Phone No."; Text[100])
        {
        }
        field(50; Status; Option)
        {
            OptionCaption = ' ,Open,Pending Approval,Approved,Posted';
            OptionMembers = " ",Open,"Pending Approval",Approved,Posted;
        }
        field(51; Approved; Boolean)
        {
        }
        field(52; "Approved By"; Code[50])
        {
        }
        field(53; "Approved Date"; Date)
        {
        }
        field(54; "Approved Time"; Time)
        {
        }
        field(55; "Send For Approval DateTime"; DateTime)
        {
        }
        field(56; "Send for Approval By"; Code[50])
        {
        }
        field(60; Posted; Boolean)
        {
        }
        field(61; "Posted By"; Code[50])
        {
        }
        field(62; "Posted Date"; Date)
        {
        }
        field(63; "Posted Time"; Time)
        {
        }
        field(70; Cancel; Boolean)
        {
        }
        field(71; "Cancelled By"; Code[50])
        {
        }
        field(72; "Cancelled Date"; Date)
        {
        }
        field(73; "Cancelled Time"; Time)
        {
        }
        field(74; "Request for Cancellation"; Boolean)
        {
        }
        field(75; "Cancellation Request Sent By"; Code[50])
        {
        }
        field(76; "Cancellation Request Sent DT"; DateTime)
        {
        }
        field(100; "Insured Value"; Decimal)
        {
            FieldClass = Normal;
        }
        field(104; "Ins. Prem Value (with VAT)"; Decimal)
        {
        }
        field(105; Expired; Boolean)
        {
        }
        field(106; "Jnl. Document No."; Code[20])
        {
        }
        field(107; "Cancellation Jnl. Doc. No."; Code[20])
        {
        }
        field(500; "Bill No."; Code[35])
        {
        }
        field(501; "Credit Officer"; Code[20])
        {
        }
        field(502; "Credit Officer Name"; Text[80])
        {
        }
        field(503; Remarks; Text[150])
        {
        }
        field(504; "Cust. Mobile Phone No."; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Loan No.", Status, "End Date", Cancel)
        {
        }
        key(Key3; "Loan No.", "End Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Creation DateTime" := CURRENTDATETIME;
        "Created By" := USERID;
    end;

    trigger OnModify()
    begin
        IF Status = Status::Approved THEN
            ERROR(ErrorText001)
        ELSE IF Status = Status::"Pending Approval" THEN
            ERROR(ErrorText002);
    end;

    var
        VehicleFinanceHeader: Record "33020062";
        Vehicle: Record "25006005";
        VehicleInsurance: Record "33020085";
        ErrorText001: Label 'You cannot modify approved Document.';
        ErrorText002: Label 'You cannot modify the Document while has been send for Approval. Please Re-open or Reject the Docuemnt.';
        Customer: Record "18";

    [Scope('Internal')]
    procedure SetStyle(): Text
    begin
        IF Cancel THEN
            EXIT('Unfavorable');
        IF "Request for Cancellation" THEN
            EXIT('Attention');
        EXIT('');
    end;
}

