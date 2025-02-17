table 33019967 "Posted Fuel Issue Entry"
{
    Caption = 'Posted Fuel Issue Entry';
    LookupPageID = 33020003;

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
        }
        field(4; "VIN (Chasis No.)"; Code[20])
        {
            Description = 'Derived VIN when validate Vehicle No.';
        }
        field(6; Mileage; Decimal)
        {
            Description = 'Derived VIN when validate Vehicle No.';
        }
        field(7; "Issue Type"; Option)
        {
            OptionCaption = ' ,Department,Staff,Sales,Others';
            OptionMembers = " ",Department,Staff,Sales,Others;
        }
        field(8; "Movement Type"; Option)
        {
            OptionCaption = ' ,Delivery,Transfer,Demo,Repair,Office Use,Others';
            OptionMembers = " ",Delivery,Transfer,Demo,Repair,"Office Use",Others;
        }
        field(9; "Fuel Type"; Option)
        {
            OptionCaption = ' ,Diesel,Petrol,Kerosene,Mobile,Engine Oil,Others';
            OptionMembers = " ",Diesel,Petrol,Kerosene,Mobile,"Engine Oil",Others;
        }
        field(10; "From City Code"; Code[10])
        {
            Description = 'Linked to Post Code';
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("From City Name");
            end;
        }
        field(11; "From City Name"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(From City Code)));
            Description = 'Linked to Post Code as FlowField';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "To City Code"; Code[10])
        {
            Description = 'Linked to Post Code';
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("To City Name");
            end;
        }
        field(13; "To City Name"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(To City Code)));
            Description = 'Linked to Post Code as FlowField';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; Distance; Decimal)
        {
            Description = 'Calculation on the basis of Mileage and Distance Master table.';
        }
        field(15; "Purpose of Travel"; Text[120])
        {
        }
        field(16; "Petrol Pump Code"; Code[20])
        {
            Description = 'Linked to Vendor Table';
            TableRelation = Vendor.No. WHERE(Blocked = FILTER(<> All));

            trigger OnValidate()
            begin
                CALCFIELDS("Petrol Pump Name");
            end;
        }
        field(17; "Petrol Pump Name"; Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE(No.=FIELD(Petrol Pump Code)));
                Description = 'Linked to Vendor Table as FlowField';
                Editable = false;
                FieldClass = FlowField;
        }
        field(18; "Issued Coupon No."; Code[10])
        {
            Description = 'Brough from Coupon master, last no. used + increment by 1';
        }
        field(19; "Issued Fuel (Litre)"; Decimal)
        {
        }
        field(20; "Issued Fuel Add. (Litre)"; Decimal)
        {
        }
        field(21; "Issue Date"; Date)
        {
        }
        field(22; Location; Code[10])
        {
            Description = 'Linked to Location master.';
            TableRelation = Location.Code WHERE(Admin/Procurement=CONST(Yes));
        }
        field(23; Department; Code[20])
        {
            Description = 'Linked to Dimension Value master';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2),
                                                          Code=FILTER(7000..7999));
        }
        field(24;"Staff No.";Code[20])
        {
            Description = 'Linked to Employee Master filtered with Active staffs only';
            TableRelation = Employee.No. WHERE (Status=CONST(" "));

            trigger OnValidate()
            begin
                CALCFIELDS("Staff Name");
            end;
        }
        field(25;"Staff Name";Text[50])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE (No.=FIELD(Staff No.)));
            Description = 'Linked to Employee Master as FlowField';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26;"Amount (Rs.)";Decimal)
        {
            Description = 'Only for Cash based';
        }
        field(28;"Add. From City Code";Code[10])
        {
            Description = 'Linked to Post Code master.';
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Add. From City Name");
            end;
        }
        field(29;"Add. From City Name";Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE (Code=FIELD(Add. From City Code)));
            Description = 'Linked to Post Code master as flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31;"Add. To City Name";Text[30])
        {
            Description = 'Linked to Post Code master as flowfield';
        }
        field(32;"Add Additional City";Boolean)
        {
            Description = 'To show/hide Additional city.';
        }
        field(33;"Add. Distance";Decimal)
        {
        }
        field(34;"Add. Litre";Decimal)
        {
        }
        field(35;"Add. Litre (Add.)";Decimal)
        {
        }
        field(36;"Issued By";Code[50])
        {
        }
        field(38;"Issued For";Option)
        {
            OptionCaption = ' ,Vehicle,Motorcycle,Generator,Service,Others';
            OptionMembers = " ",Vehicle,Motorcycle,Generator,Service,Others;
        }
        field(39;"Registration No.";Code[20])
        {
            Caption = 'Registration No.';
        }
        field(40;Manufacturer;Option)
        {
            OptionCaption = 'TATA,Others';
            OptionMembers = TATA,Others;
        }
        field(41;"Rate (Rs.)";Decimal)
        {
        }
        field(42;"Unit of Measure";Code[10])
        {
            Description = 'Linked to unit of measure master';
            TableRelation = "Unit of Measure".Code;
        }
        field(43;"Total Fuel Issued";Decimal)
        {
        }
        field(44;"Add. Total Fuel Issued";Decimal)
        {
        }
        field(45;"Document Date";Date)
        {
        }
        field(46;"User ID";Code[50])
        {
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
        field(55;"Department Name";Text[30])
        {
        }
        field(56;Void;Boolean)
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
}

