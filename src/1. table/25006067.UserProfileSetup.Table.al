table 25006067 "User Profile Setup"
{
    // 17.10.2007. EDMS P2
    //   * Added field "Don't Show Accounting Groups"

    Caption = 'User Profile Setup';

    fields
    {
        field(10; "Profile ID"; Code[30])
        {
            Caption = 'Profile ID';
        }
        field(20; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(30; "Default Deal Type Code"; Code[10])
        {
            Caption = 'Default Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(40; "Default Make Code"; Code[20])
        {
            Caption = 'Default Make Code';
            TableRelation = Make;
        }
        field(50; "Default Location Code"; Code[10])
        {
            Caption = 'Default Location Code';
            TableRelation = Location;
        }
        field(100; "Def. Service Location Code"; Code[20])
        {
            Caption = 'Def. Service Location Code';
            TableRelation = Location;
        }
        field(120; "Def. Spare Part Location Code"; Code[20])
        {
            Caption = 'Def. Spare Part Location Code';
            TableRelation = Location;
        }
        field(160; "Default Location Filter"; Code[20])
        {
            Caption = 'Default Location Filter';
            TableRelation = Location;
        }
        field(170; "Default Vendor No."; Code[20])
        {
            Caption = 'Default Vendor No.';
            TableRelation = Vendor;
        }
        field(180; "Default Vehicle Status"; Code[20])
        {
            Caption = 'Default Vehicle Status';
            TableRelation = "Vehicle Status".Code;
        }
        field(200; "Don't Use Vehicle Assembly"; Boolean)
        {
            Caption = 'Don''t Use Vehicle Assembly ';
        }
        field(250; "Show Vehicle Count"; Boolean)
        {
            Caption = 'Show Vehicle Count';
        }
        field(260; "Make Code Filter"; Text[50])
        {
            Caption = 'Make Code Filter';
        }
        field(270; "Default Payment Method"; Code[10])
        {
            Caption = 'Default Payment Method';
            TableRelation = "Payment Method";
        }
        field(280; "Default Shipping Agent Code"; Code[10])
        {
            Caption = 'Default Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(300; "Sales Line Markup Check"; Option)
        {
            Caption = 'Sales Line Markup Check';
            Description = 'Need to delete';
            OptionCaption = 'None,Message,Warning';
            OptionMembers = "None",Message,Warning;
        }
        field(310; "Sales Line Min Markup %"; Decimal)
        {
            Caption = 'Sales Line Min Markup %';
            Description = 'Need to delete';
        }
        field(400; "Spec. Service Setup"; Boolean)
        {
            Caption = 'Spec. Service Setup';
            Description = 'Service for Veh. Trade';
        }
        field(410; "Spec. Service User Profile"; Code[30])
        {
            Caption = 'Spec. Service User Profile';
            Description = 'Service for Veh. Trade';
            TableRelation = "User Profile Setup";
        }
        field(420; "Spec. Order Receiver"; Code[20])
        {
            Caption = 'Spec. Order Receiver';
            Description = 'Service for Veh. Trade';
            TableRelation = Salesperson/Purchaser;
        }
        field(510;"Vehicle Sales Disc. Check";Boolean)
        {
            Caption = 'Vehicle Sales Disc. Check';
        }
        field(520;"Vehicle Max Sales Disc.%";Decimal)
        {
            Caption = 'Vehicle Max Sales Disc.%';
        }
        field(530;"Service Schedule View Code";Code[10])
        {
            Caption = 'Service Schedule View Code';
            TableRelation = "Schedule View";
        }
        field(50000;"Requisition Worksheet Batch";Code[10])
        {
        }
        field(33020235;"Default Workplace";Code[10])
        {
            TableRelation = "Serv. Workplace".Code;
        }
        field(33020236;"Default Bin for Local Parts";Code[20])
        {
            TableRelation = Bin.Code WHERE (Location Code=FIELD(Default Location Code));
        }
        field(33020237;"Default Responsibility Center";Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(33020238;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(33020239;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(33020240;"Default Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center".Code;
        }
    }

    keys
    {
        key(Key1;"Profile ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        cuSingleInstanceMgt: Codeunit "25006001";

    [Scope('Internal')]
    procedure fIsCurrentWorkplace(recWorkplace: Record "25006067"): Boolean
    begin
        IF cuSingleInstanceMgt.GetUserProfile = recWorkplace."Profile ID" THEN
         EXIT(TRUE)
        ELSE
         EXIT(FALSE);
    end;
}

