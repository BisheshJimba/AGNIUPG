table 33019963 "Fuel Issue Entry"
{
    Caption = 'Fuel Issue Entry';
    DataCaptionFields = "No.", "Petrol Pump Name";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Description = 'To separate fuel issue for like Coupan, Stock, Cash issue.';
            OptionCaption = 'Coupon,Stock,Cash';
            OptionMembers = Coupon,Stock,Cash;
        }
        field(2; "No."; Code[20])
        {
            Description = 'System Generated No. series';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    AdminSetup.GET;
                    NoSeriesMngt.TestManual(GetNoSeries);
                    "No. Series" := '';
                END;
            end;
        }
        field(4; "VIN (Chasis No.)"; Code[20])
        {

            trigger OnValidate()
            begin
                //Populating Vehicle Details.
                Vehicle.RESET;
                Vehicle.SETRANGE(VIN, "VIN (Chasis No.)");
                IF Vehicle.FIND('-') THEN BEGIN
                    "Registration No." := Vehicle."Registration No.";
                    MODIFY;
                END;
            end;
        }
        field(6; Mileage; Decimal)
        {
        }
        field(7; "Issue Type"; Option)
        {
            OptionCaption = ' ,Department,Staff,Sales,Others';
            OptionMembers = " ",Department,Staff,Sales,Others;

            trigger OnValidate()
            begin
                IF ("Issue Type" IN ["Issue Type"::Staff, "Issue Type"::Sales, "Issue Type"::Others, "Issue Type"::"5"]) THEN
                    Department := '';
            end;
        }
        field(8; "Movement Type"; Option)
        {
            OptionCaption = ' ,Delivery,Transfer,Demo,Repair,Office Use,Tour,Regular,Others';
            OptionMembers = " ",Delivery,Transfer,Demo,Repair,"Office Use",Tour,Regular,Others;

            trigger OnValidate()
            begin
                //Not to show Kilometerage field if movement type is delivery or transfer
            end;
        }
        field(9; "Fuel Type"; Option)
        {
            OptionCaption = ' ,Diesel,Petrol,Kerosene,Mobile,Engine Oil,Others';
            OptionMembers = " ",Diesel,Petrol,Kerosene,Mobile,"Engine Oil",Others;

            trigger OnValidate()
            begin
                //Update fuel rate.
                FuelRate.RESET;
                FuelRate.SETRANGE(Type, "Fuel Type");
                FuelRate.SETRANGE(Location, Location);
                FuelRate.SETFILTER(Date, '%1..%2', 0D, "Issue Date");
                IF FuelRate.FIND('+') THEN
                    //VALIDATE("Rate (Rs.)",FuelRate.Rate)
                    "Rate (Rs.)" := FuelRate.Rate
                ELSE
                    "Rate (Rs.)" := 0.0;

                //"Amount (Rs.)" := "Rate (Rs.)" * "Issued Fuel (Litre)";
                VALIDATE("Amount (Rs.)", "Rate (Rs.)" * "Total Fuel Issued");
            end;
        }
        field(10; "From City Code"; Code[10])
        {
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("From City Name");

                IF ("To City Code" <> '') THEN BEGIN
                    //Populate Distance, Issued litre and unit of measure.
                    DistanceMst.RESET;
                    DistanceMst.SETRANGE("From City Code", "From City Code");
                    DistanceMst.SETRANGE("To City Code", "To City Code");
                    IF DistanceMst.FIND('-') THEN BEGIN
                        Distance := DistanceMst."Total Km";
                        IF (Mileage <> 0) THEN
                            IssuedLtr := ROUND((Distance / Mileage), 1, '>');
                        VALIDATE("Issued Fuel (Litre)", IssuedLtr);
                        "Unit of Measure" := 'LTR';
                    END;
                END;
            end;
        }
        field(11; "From City Name"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(From City Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "To City Code"; Code[10])
        {
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("To City Name");

                //Populate Distance, Issued litre and unit of measure.
                DistanceMst.RESET;
                DistanceMst.SETRANGE("From City Code", "From City Code");
                DistanceMst.SETRANGE("To City Code", "To City Code");
                IF DistanceMst.FIND('-') THEN BEGIN
                    Distance := DistanceMst."Total Km";
                    IF (Mileage <> 0) THEN
                        IssuedLtr := ROUND((Distance / Mileage), 1, '>');
                    VALIDATE("Issued Fuel (Litre)", IssuedLtr);
                    "Unit of Measure" := 'LTR';
                END;
            end;
        }
        field(13; "To City Name"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(To City Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; Distance; Decimal)
        {
        }
        field(15; "Purpose of Travel"; Text[120])
        {
        }
        field(16; "Petrol Pump Code"; Code[20])
        {
            TableRelation = Vendor.No. WHERE(Blocked = FILTER(<> All));

            trigger OnValidate()
            var
                Text33019962: Label 'Coupon No. has exceeded the specified range for this petrol pump. Please open another coupon in coupon master or contact your system administrator.';
                Text33019961: Label 'Coupon No. not found for this petrol pump. Please check coupon master or contact your system administrator.';
            begin
                CALCFIELDS("Petrol Pump Name");

                //Generating Issued Coupon No. on the basis of Location and Petrol Pump.
                CouponMst.RESET;
                CouponMst.SETRANGE(Location, Location);
                CouponMst.SETRANGE("Petrol Pump Code", "Petrol Pump Code");
                //CouponMst.SETFILTER("Starting Date",'%1..%2',0D,"Issue Date");
                CouponMst.SETRANGE(Open, TRUE);
                IF CouponMst.FIND('+') THEN BEGIN
                    IF CouponMst."Last Issued No." <> '' THEN BEGIN
                        IF (CouponMst."Last Issued No." <> CouponMst."Range To") THEN BEGIN
                            "Issued Coupon No." := INCSTR(CouponMst."Last Issued No.");
                            MODIFY;
                        END ELSE
                            ERROR(Text33019962);
                    END ELSE BEGIN
                        "Issued Coupon No." := CouponMst."Range From";
                        MODIFY;
                    END;
                    CouponMst."Last Issued No." := "Issued Coupon No.";
                    CouponMst."Last Issued Date" := TODAY;
                    CouponMst.MODIFY;
                END ELSE
                    ERROR(Text33019961);
            end;
        }
        field(17; "Petrol Pump Name"; Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE(No.=FIELD(Petrol Pump Code)));
                Editable = false;
                FieldClass = FlowField;
        }
        field(18; "Issued Coupon No."; Code[10])
        {
            Editable = false;
        }
        field(19; "Issued Fuel (Litre)"; Decimal)
        {

            trigger OnValidate()
            begin
                //Populating Total Fuel Issued.
                //VALIDATE("Total Fuel Issued",("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)"));
                "Total Fuel Issued" := "Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)";
            end;
        }
        field(20; "Issued Fuel Add. (Litre)"; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                //Checking Add. Fuel Limit.
                AdminSetup.GET;
                IF ("Issued Fuel (Litre)" <> 0) THEN
                  "%AddFuel" := (("Issued Fuel (Litre)" * AdminSetup."Add. Fuel Limit %") / 100);
                
                
                IF ("Issued Fuel Add. (Litre)" > "%AddFuel") THEN BEGIN
                  IF ("Issued Fuel Add. (Litre)" > AdminSetup."Add. Fuel Limit") THEN BEGIN
                    ERROR(Text33019961,AdminSetup."Add. Fuel Limit %",AdminSetup."Add. Fuel Limit");
                  END;
                END;
                */

                //Populating Total Fuel Issued.
                //VALIDATE("Total Fuel Issued",("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)"));
                "Total Fuel Issued" := "Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)";

            end;
        }
        field(21; "Issue Date"; Date)
        {

            trigger OnValidate()
            begin
                "Issue Date (BS)" := SysMngt.getNepaliDate("Issue Date")
            end;
        }
        field(22; Location; Code[10])
        {
            TableRelation = Location.Code WHERE(Admin/Procurement=CONST(Yes));
        }
        field(23; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2),
                                                          Code=FILTER(7000..7999));

            trigger OnValidate()
            begin

                //Inserting Informations.
                DeptEmpVehInfo.RESET;
                DeptEmpVehInfo.SETFILTER("Entry Type",'Department');
                DeptEmpVehInfo.SETRANGE(Location,Location);
                DeptEmpVehInfo.SETRANGE(Code,Department);
                IF DeptEmpVehInfo.FIND('-') THEN BEGIN
                   "Issued For" := DeptEmpVehInfo.Type;
                  "VIN (Chasis No.)" := DeptEmpVehInfo.VIN;
                  Mileage := DeptEmpVehInfo.Mileage;
                  "Registration No." := DeptEmpVehInfo."Vehicle No./Reg. No.";
                  "Movement Type" := "Movement Type"::"Office Use";
                  //VALIDATE("Fuel Type",DeptEmpVehInfo."Fuel Type");
                  MODIFY;
                END;
                 DeptName.RESET;
                 DeptName.SETRANGE(Code,Department);
                IF DeptName.FIND('-') THEN BEGIN
                  "Department Name" := DeptName.Name;
                  MODIFY;
                END;
            end;
        }
        field(24;"Staff No.";Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            var
                FuelCnsmThisMth: Decimal;
                FuelIssueLedgEnty: Record "33019965";
            begin
                CALCFIELDS("Staff Name");

                //Inserting Vehicle and Other information.
                DeptEmpVehInfo.RESET;
                DeptEmpVehInfo.SETFILTER("Entry Type",'Employee');
                DeptEmpVehInfo.SETRANGE(Code,"Staff No.");
                IF DeptEmpVehInfo.FIND('-') THEN BEGIN
                  "Issued For" := DeptEmpVehInfo.Type;
                  "VIN (Chasis No.)" := DeptEmpVehInfo.VIN;
                  Mileage := DeptEmpVehInfo.Mileage;
                  "Registration No." := DeptEmpVehInfo."Vehicle No./Reg. No.";
                  "Movement Type" := "Movement Type"::Tour;
                  //VALIDATE("Fuel Type",DeptEmpVehInfo."Fuel Type");
                  MODIFY;
                END;
            end;
        }
        field(25;"Staff Name";Text[50])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE (No.=FIELD(Staff No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26;"Amount (Rs.)";Decimal)
        {
            Editable = false;
        }
        field(28;"Add. From City Code";Code[10])
        {
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Add. From City Name");
            end;
        }
        field(29;"Add. From City Name";Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE (Code=FIELD(Add. From City Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(31;"Add. To City Name";Text[30])
        {
        }
        field(32;"Add Additional City";Boolean)
        {
        }
        field(33;"Add. Distance";Decimal)
        {

            trigger OnValidate()
            begin
                //Populating Additional Fuel Issued.
                IF (Mileage <> 0) THEN
                  VALIDATE("Add. Litre",("Add. Distance"/Mileage));
            end;
        }
        field(34;"Add. Litre";Decimal)
        {

            trigger OnValidate()
            begin
                //Populating Additional fuel issued.
                "Add. Total Fuel Issued" := ("Add. Litre" + "Add. Litre (Add.)");
                "Amount (Rs.)" := ROUND(("Rate (Rs.)" * ("Total Fuel Issued" + "Add. Total Fuel Issued")),GLSetup."Amount Rounding Precision",'=')
                ;
            end;
        }
        field(35;"Add. Litre (Add.)";Decimal)
        {

            trigger OnValidate()
            begin
                //Populating Additional fuel issued.
                "Add. Total Fuel Issued" := ("Add. Litre" + "Add. Litre (Add.)");
                "Amount (Rs.)" := ROUND(("Rate (Rs.)" * ("Total Fuel Issued" + "Add. Total Fuel Issued")),GLSetup."Amount Rounding Precision",'=')
                ;
            end;
        }
        field(36;"Issued By";Code[50])
        {
            Editable = false;
        }
        field(38;"Issued For";Option)
        {
            OptionCaption = ' ,Vehicle,Motorcycle,Generator,Service,Others';
            OptionMembers = " ",Vehicle,Motorcycle,Generator,Service,Others;
        }
        field(39;"Registration No.";Code[20])
        {
            Caption = 'Registration No.';
            TableRelation = IF (Issued For=CONST(Motorcycle)) "Dept/Emp. Vehicle"."Vehicle No./Reg. No." WHERE (Type=CONST(Motorcycle))
                            ELSE IF (Issued For=CONST(Generator)) "Dept/Emp. Vehicle"."Vehicle No./Reg. No." WHERE (Type=CONST(Generator));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(40;Manufacturer;Option)
        {
            OptionCaption = 'TATA,Others';
            OptionMembers = TATA,Others;
        }
        field(41;"Rate (Rs.)";Decimal)
        {

            trigger OnValidate()
            begin
                //Populating Amount.
                GLSetup.GET;
                "Amount (Rs.)" := ROUND(("Rate (Rs.)" * "Total Fuel Issued"),GLSetup."Amount Rounding Precision",'=');
            end;
        }
        field(42;"Unit of Measure";Code[10])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(43;"Total Fuel Issued";Decimal)
        {

            trigger OnValidate()
            begin
                /*
                //Calling function to check staffs' monthly fuel limit.
                IF "Issue Type" = "Issue Type"::Staff THEN
                  FuelIssueMngt.calcStaffFuelUsage("Staff No.","Issue Date","Issued For","Total Fuel Issued");
                */

            end;
        }
        field(44;"Add. Total Fuel Issued";Decimal)
        {
        }
        field(45;"Document Date";Date)
        {
            Editable = false;
        }
        field(46;"User ID";Code[50])
        {
            Editable = false;
        }
        field(47;"No. Series";Code[20])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(49;"Source Code";Code[10])
        {
            TableRelation = "Source Code";
        }
        field(51;"Responsibility Center";Code[10])
        {
            Editable = false;
        }
        field(52;"Issued To";Text[50])
        {
        }
        field(53;"Kilometerage (KM)";Decimal)
        {
        }
        field(54;"Issue Date (BS)";Code[10])
        {

            trigger OnValidate()
            begin
                "Issue Date" := SysMngt.getEngDate("Issue Date (BS)");
                MODIFY;
            end;
        }
        field(55;"Department Name";Text[30])
        {
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1;"Document Type","No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        AdminSetup.GET;
        GblUserSetup.GET(USERID);

        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMngt.InitSeries(GetNoSeries,xRec."No. Series",0D,"No.","No. Series");
        END;

        //Inserting source code to track the entry on Ledgers and Registers.
        SourceCodeSetup.GET;
        "Source Code" := SourceCodeSetup."Fuel Issue Entry";

        //Inserting responsibility center.
        "Responsibility Center" := GblUserSetup."Default Responsibility Center";
        "Accountability Center" := GblUserSetup."Default Accountability Center";
        Location := GblUserSetup."Default Location";

        "Document Date" := TODAY;
        "User ID" := USERID;
        "Issued By" := USERID;
        "Issue Date" := TODAY;
    end;

    var
        AdminSetup: Record "33019964";
        NoSeriesMngt: Codeunit "396";
        SourceCodeSetup: Record "242";
        CouponMst: Record "33019962";
        GLSetup: Record "98";
        Vehicle: Record "25006005";
        DistanceMst: Record "33019961";
        GblUserSetup: Record "91";
        ItemLedgEntry: Record "32";
        FuelIssueMngt: Codeunit "33019973";
        "%AddFuel": Decimal;
        Text33019961: Label 'Must not be greater then %1 % of Issued Fuel or %2 litre.';
        FuelRate: Record "33019984";
        SysMngt: Codeunit "50000";
        IssuedLtr: Decimal;
        DeptEmpVehInfo: Record "33019983";
        DeptName: Record "349";

    [Scope('Internal')]
    procedure AssistEdit(xFuelEntry: Record "33019963"): Boolean
    begin
        AdminSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries,xFuelEntry."No. Series","No. Series") THEN BEGIN
          AdminSetup.GET;
          TestNoSeries;
          NoSeriesMngt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        CASE "Document Type" OF
          "Document Type"::Coupon:
            AdminSetup.TESTFIELD("Coupon No.");
          "Document Type"::Stock:
            AdminSetup.TESTFIELD("Stock No.");
          "Document Type"::Cash:
            AdminSetup.TESTFIELD("Cash No.");
        END;
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        CASE "Document Type" OF
          "Document Type"::Coupon:
            EXIT(AdminSetup."Coupon No.");
          "Document Type"::Stock:
            EXIT(AdminSetup."Stock No.");
          "Document Type"::Cash:
            EXIT(AdminSetup."Cash No.");
        END;
    end;
}

