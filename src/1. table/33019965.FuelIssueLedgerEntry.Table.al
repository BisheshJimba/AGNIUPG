table 33019965 "Fuel Issue Ledger Entry"
{
    Caption = 'Fuel Issue Ledger Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = 'Coupon,Stock,Cash';
            OptionMembers = Coupon,Stock,Cash;
        }
        field(3; "Document No."; Code[20])
        {
        }
        field(4; VIN; Code[20])
        {
        }
        field(5; "From City"; Code[10])
        {
        }
        field(6; "To City"; Code[10])
        {
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
        field(9; Description; Text[120])
        {
            Description = 'Purpose of Travel';
        }
        field(10; "Fuel Type"; Option)
        {
            OptionCaption = ' ,Diesel,Petrol,Kerosene,Mobile,Engine Oil,Others';
            OptionMembers = " ",Diesel,Petrol,Kerosene,Mobile,"Engine Oil",Others;
        }
        field(11; "Petrol Pump"; Code[20])
        {
        }
        field(12; "Issued Coupon No."; Code[10])
        {
        }
        field(13; "Issued Date"; Date)
        {
        }
        field(14; "Posting Type"; Option)
        {
            Description = 'For stock adjustment';
            OptionCaption = ' ,Positive Adjmt.,Negative Adjmt.';
            OptionMembers = " ","Positive Adjmt.","Negative Adjmt.";
        }
        field(15; "Issued For"; Option)
        {
            OptionCaption = ' ,Vehicle,Motorcycle,Generator,Service,Others';
            OptionMembers = " ",Vehicle,Motorcycle,Generator,Service,Others;
        }
        field(16; Location; Code[10])
        {
            TableRelation = "Location - Admin";
        }
        field(17; Department; Code[20])
        {
        }
        field(18; "Staff No."; Code[20])
        {
        }
        field(19; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Registration No.';
        }
        field(20; Manufacturer; Option)
        {
            OptionCaption = 'TATA,Others';
            OptionMembers = TATA,Others;
        }
        field(21; Amount; Decimal)
        {
        }
        field(22; Remarks; Text[120])
        {
        }
        field(23; "Add. From City"; Code[10])
        {
        }
        field(24; "Add. To City"; Text[30])
        {
        }
        field(25; "Issued By"; Code[50])
        {
        }
        field(27; "Unit of Measure"; Code[10])
        {
        }
        field(28; Rate; Decimal)
        {
        }
        field(29; Quantity; Decimal)
        {
        }
        field(30; "Posting Date"; Date)
        {
        }
        field(31; "Document Date"; Date)
        {
        }
        field(32; "User ID"; Code[50])
        {
        }
        field(33; "Journal Template Name"; Code[10])
        {
        }
        field(34; "Journal Batch Name"; Code[10])
        {
        }
        field(35; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(36; "Item No."; Code[20])
        {
        }
        field(37; Reconciled; Boolean)
        {
        }
        field(38; "Responsibility Center"; Code[10])
        {
        }
        field(39; "Vehicle Last Visit KM"; Decimal)
        {
        }
        field(40; "Issued To"; Text[50])
        {
        }
        field(41; Void; Boolean)
        {
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Petrol Pump")
        {
            SumIndexFields = Quantity, Amount;
        }
        key(Key3; Location)
        {
            SumIndexFields = Amount, Quantity;
        }
        key(Key4; Location, "Petrol Pump", "Posting Type", Reconciled, Void, "Posting Date")
        {
            SumIndexFields = Quantity, Amount;
        }
        key(Key5; VIN, "Posting Date")
        {
            SumIndexFields = Quantity, Amount;
        }
        key(Key6; "Staff No.", "Posting Date")
        {
            SumIndexFields = Quantity, Amount;
        }
        key(Key7; Department, "Posting Date")
        {
            SumIndexFields = Quantity, Amount;
        }
    }

    fieldgroups
    {
    }

    var
        LastEntryNo: Integer;
}

