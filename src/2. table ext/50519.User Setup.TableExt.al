tableextension 50519 tableextension50519 extends "User Setup"
{
    // 02.05.2017 EB.P7 Sign
    //   Added field:
    //     "Signed Document Path"
    // 
    // 14.04.2016 EB.P30
    //   Added field: Register Statistics
    // 
    // 15.03.2016 EB.P7 Branches
    //   Added field: Branch Code
    // 
    // 08.06.2015 EB.P7 #Schedule3.0
    //   Added field: Resource No.
    // 
    // 16.02.2015 EB.P7 #SingleInst.
    //   Disabled Profile ID field trigger.
    // 
    // 07.05.2014 Elva Baltic P8 #xxx MMG7.00
    //   * Change field name 'Default User Profile Code' into 'Profile ID' and relate with Profile table instead of T25006067.
    // 
    // 30.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Set default profile should go to system vars
    // 
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Allow Cancel Service Reserv."
    //     "Allow Block Customer"
    // 
    // 16.04.2013 EDMS P8
    //   * removed unused fields 'Allow Posting Transfer' and 'Allow Posting Credit Memo'
    // 
    // 05.12.2011 EDMS P8
    //   * Added fields:
    //       Veh. Sales Amount Appr. Limit
    //       Spare Parts Sales Appr. Limit
    //       Veh. Service Approval Limit
    //       Unlimited Veh. Sales Approval
    //       Unlimited Spare Parts Sales
    //       Unlimited Veh. Service Appr.
    // 
    // 15.06.2007. EDMS P2
    //   * Added new key Salesperson/Purch.Code
    //   * Profile Change Authority
    //     - Blank,Limited,Standar,Admin
    //     - Blank -> If set 'blank' User will not have authority to change own profile.
    //     - Limited -> If set 'Limited', User can modify own Profile and 'Profile filters' must have a value.
    //     - Standard -> If set 'Standard', User can modify other Profiles and 'Profile filters' must have a value.
    //     - Admin -> Every Profiles and Users will be listed and has permission to modify any of them.
    fields
    {
        field(10000; "Can Approve NCHL-NPI User"; Boolean)
        {
            Description = 'NCHL-NPI_1.00';
        }
        field(50000; "Administrator Authority"; Boolean)
        {
        }
        field(50001; "User Department"; Option)
        {
            OptionCaption = ' ,Admin,Corporate,Vehicle,Spares,Service,IT,Finance,GPD,MED,BU,HR';
            OptionMembers = " ",Admin,Corporate,Vehicle,Spares,Service,IT,Finance,GPD,MED,BU,HR;
        }
        field(50002; "Profile Change Authority"; Option)
        {
            OptionCaption = ' ,Limited,Standard,Admin';
            OptionMembers = " ",Limited,Standard,Admin;
        }
        field(50003; "User Profile Filter"; Code[250])
        {
        }
        field(50004; "Can See Cost"; Boolean)
        {
        }
        field(50005; "Battery-Can Edit Pages"; Boolean)
        {
        }
        field(50006; "Allow View all Veh. Invoice"; Boolean)
        {
        }
        field(50007; "VF Posting Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name;
        }
        field(50099; "Allow Post.Multiple Commission"; Boolean)
        {
        }
        field(50100; "Signatory Group"; Option)
        {
            Description = 'CNY1.0';
            OptionCaption = ' ,A,B';
            OptionMembers = " ",A,B;
        }
        field(50103; "Allow SP change in Contact"; Boolean)
        {
            Description = 'CNY.CRM';
        }
        field(50104; "GL Account Department"; Option)
        {
            OptionMembers = " ",Admin,"Service and Spareparts",HR,Marketing;
        }
        field(59001; "Allow TDS A/C Direct Posting"; Boolean)
        {
        }
        field(59002; "Vehicle Allotment Modify"; Boolean)
        {
        }
        field(59009; "Allow to block service item"; Boolean)
        {
        }
        field(80002; "Can Reschedule Loan"; Boolean)
        {
        }
        field(80116; "Can Approve Veh. Ins. HP"; Boolean)
        {
            Description = 'SRT';
        }
        field(80117; "Can Post Veh. Ins. HP"; Boolean)
        {
            Description = 'SRT';
        }
        field(80118; "Loan Disbursal Posting Batch"; Code[10])
        {
            Description = 'is being used for loan disburse from loan card (loan disburse action)';
            TableRelation = "Gen. Journal Batch".Name WHERE(Template Type=CONST(General),
                                                             Journal Template Name=CONST(GENERAL));
        }
        field(80119; "Can Print Tax Invoice"; Boolean)
        {
        }
        field(25006000; "Default User Profile Code"; Code[30])
        {
            Caption = 'Company Profile ID';
            TableRelation = Profile;
        }
        field(25006010; "SP Sales Disc. Group Code"; Code[10])
        {
            Caption = 'SP Sales Disc. Group Code';
            TableRelation = "Spare Part Sales Disc. Group";
        }
        field(25006020; "Service Resp. Ctr. Filter EDMS"; Code[10])
        {
            Caption = 'Service Resp. Ctr. Filter EDMS';
            TableRelation = "Responsibility Center";
        }
        field(25006060; "Allow Posting Only Today"; Boolean)
        {
            Caption = 'Allow Posting Only Today';
        }
        field(25006090; "Starting Form ID"; Integer)
        {
            Caption = 'Starting Form ID';
        }
        field(25006100; "Schedule Add-In Log Path"; Text[250])
        {
            Caption = 'Schedule Add-In Log Path';
        }
        field(25006110; "Schedule Add-In Log Active"; Boolean)
        {
            Caption = 'Schedule Add-In Log Active';
        }
        field(25006580; "Item Markup Restriction Group"; Code[20])
        {
            Caption = 'Item Markup Restriction Group';
            TableRelation = "Item Markup Restriction Group";
        }
        field(25006585; "Veh. Acc. Cycle Change Funct."; Boolean)
        {
            Caption = 'Veh. Acc. Cycle Change Funct.';
        }
        field(25006595; "Allow Use Service Schedule"; Option)
        {
            Caption = 'Allow Use Service Schedule';
            OptionCaption = ' ,View Only,Time Registration,Planning,All ';
            OptionMembers = " ","View Only","Time Registration",Planning,"All ";
        }
        field(25006605; "Allow Posting Transfer"; Boolean)
        {
            Caption = 'Allow Posting Transfer';
        }
        field(25006615; "Allow Posting Credit Memo"; Boolean)
        {
            Caption = 'Allow Posting Credit Memo';
        }
        field(25006625; "Cancel Only Own Reservation"; Boolean)
        {
            Caption = 'Cancel Only Own Reservation';
        }
        field(25006635; "SIE management"; Boolean)
        {
            Caption = 'SIE management';
        }
        field(25006645; "Show Time Reg. Pane"; Boolean)
        {
            Caption = 'Show Time Reg. Pane';
        }
        field(25006700; "Cust. Credit Control"; Boolean)
        {
            Caption = 'Cust. Credit Control';
        }
        field(25006712; "Veh. Service Approval Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Veh. Service Approval Limit';

            trigger OnValidate()
            begin
                IF "Unlimited Veh. Service Appr." AND ("Veh. Service Approval Limit" <> 0) THEN
                    ERROR(Text003, FIELDCAPTION("Veh. Service Approval Limit"), FIELDCAPTION("Unlimited Veh. Service Appr."));
                IF "Veh. Service Approval Limit" < 0 THEN
                    ERROR(Text005);
            end;
        }
        field(25006713; "Unlimited Veh. Sales Approval"; Boolean)
        {
            Caption = 'Unlimited Veh. Sales Approval';

            trigger OnValidate()
            begin
                IF "Unlimited Veh. Sales Approval" THEN
                    "Veh. Sales Amount Appr. Limit" := 0;
            end;
        }
        field(25006714; "Unlimited Spare Parts Sales"; Boolean)
        {
            Caption = 'Unlimited Spare Parts Sales';

            trigger OnValidate()
            begin
                IF "Unlimited Spare Parts Sales" THEN
                    "Spare Parts Sales Appr. Limit" := 0;
            end;
        }
        field(25006715; "Unlimited Veh. Service Appr."; Boolean)
        {
            Caption = 'Unlimited Veh. Service Appr.';

            trigger OnValidate()
            begin
                IF "Unlimited Veh. Service Appr." THEN
                    "Veh. Service Approval Limit" := 0;
            end;
        }
        field(25006716; "Veh. Purch. Amount Appr. Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Veh. Purch. Amount Appr. Limit';

            trigger OnValidate()
            begin
                IF "Unlimited Veh. Purch. Approval" AND ("Veh. Purch. Amount Appr. Limit" <> 0) THEN
                    ERROR(Text003, FIELDCAPTION("Veh. Purch. Amount Appr. Limit"), FIELDCAPTION("Unlimited Veh. Purch. Approval"));
                IF "Veh. Purch. Amount Appr. Limit" < 0 THEN
                    ERROR(Text005);
            end;
        }
        field(25006717; "Spare Parts Purch. Appr. Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Spare Parts Purch. Appr. Limit';

            trigger OnValidate()
            begin
                IF "Unlimited Spare Parts Purch." AND ("Spare Parts Purch. Appr. Limit" <> 0) THEN
                    ERROR(Text003, FIELDCAPTION("Spare Parts Purch. Appr. Limit"), FIELDCAPTION("Unlimited Spare Parts Purch."));
                IF "Spare Parts Purch. Appr. Limit" < 0 THEN
                    ERROR(Text005);
            end;
        }
        field(25006718; "Unlimited Veh. Purch. Approval"; Boolean)
        {
            Caption = 'Unlimited Veh. Purch. Approval';

            trigger OnValidate()
            begin
                IF "Unlimited Veh. Purch. Approval" THEN
                    "Veh. Purch. Amount Appr. Limit" := 0;
            end;
        }
        field(25006719; "Unlimited Spare Parts Purch."; Boolean)
        {
            Caption = 'Unlimited Spare Parts Purch.';

            trigger OnValidate()
            begin
                IF "Unlimited Spare Parts Purch." THEN
                    "Spare Parts Purch. Appr. Limit" := 0;
            end;
        }
        field(25006720; "Veh. Sales Amount Appr. Limit"; Integer)
        {
            Caption = 'Veh. Sales Amount Appr. Limit';

            trigger OnValidate()
            begin
                IF "Unlimited Veh. Sales Approval" AND ("Veh. Sales Amount Appr. Limit" <> 0) THEN
                    ERROR(Text003, FIELDCAPTION("Veh. Sales Amount Appr. Limit"), FIELDCAPTION("Unlimited Veh. Sales Approval"));
                IF "Veh. Sales Amount Appr. Limit" < 0 THEN
                    ERROR(Text005);
            end;
        }
        field(25006721; "Spare Parts Sales Appr. Limit"; Integer)
        {
            Caption = 'Spare Parts Sales Appr. Limit';

            trigger OnValidate()
            begin
                IF "Unlimited Spare Parts Sales" AND ("Spare Parts Sales Appr. Limit" <> 0) THEN
                    ERROR(Text003, FIELDCAPTION("Spare Parts Sales Appr. Limit"), FIELDCAPTION("Unlimited Spare Parts Sales"));
                IF "Spare Parts Sales Appr. Limit" < 0 THEN
                    ERROR(Text005);
            end;
        }
        field(25006730; "Allow Block Customer"; Boolean)
        {
            Caption = 'Allow Block Customer';
        }
        field(25006740; "Allow Cancel Service Reserv."; Boolean)
        {
            Caption = 'Allow Cancel Service Reserv.';
        }
        field(25006750; "Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(25006760; "Branch Code"; Code[20])
        {
            TableRelation = Branch;
        }
        field(25006770; "Register Statistics"; Boolean)
        {
            Caption = 'Register Statistics';
        }
        field(25006780; "Signed Document Path"; Text[250])
        {
            Caption = 'Signed Document Path';
        }
        field(33019831; "Allow Creating Spare PO"; Boolean)
        {
            Description = 'Carry Out Action Message Credential';
        }
        field(33019832; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(33019833; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(33019834; "Warranty Approver"; Boolean)
        {
        }
        field(33019961; "Default Location"; Code[10])
        {
            TableRelation = Location.Code;
        }
        field(33019962; "Fuel Issue Limit"; Decimal)
        {
        }
        field(33019963; "Fuel Approval"; Boolean)
        {
        }
        field(33019964; "Fuel Document Print Authority"; Boolean)
        {
        }
        field(33019965; "Apply Rules"; Boolean)
        {
        }
        field(33020011; "LC Approval Authority"; Boolean)
        {
        }
        field(33020012; "Default Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(33020013; "Approval/Disapproval Authority"; Boolean)
        {
        }
        field(33020014; "Application Proces. Authority"; Boolean)
        {
        }
        field(33020015; "Vehilce Division"; Option)
        {
            OptionCaption = ' ,CVD,PCD';
            OptionMembers = " ",CVD,PCD;
        }
        field(33020016; "Allow Emp. Req. Posting"; Boolean)
        {
        }
        field(33020017; "Journal Template Filter"; Code[250])
        {
        }
        field(33020062; "Can Approve Vehicle Loan"; Boolean)
        {
        }
        field(33020063; "Batt-Lube User"; Boolean)
        {
        }
        field(33020064; "Allow Direct Vehicle Sales"; Boolean)
        {
        }
        field(33020065; "Allow Correcting Serv-Inv"; Boolean)
        {
        }
        field(33020066; "Vehicle Modify Authority"; Option)
        {
            OptionCaption = ' ,All,Limited';
            OptionMembers = " ",All,Limited;
        }
        field(33020067; "Allow Changing Dim after Ship"; Boolean)
        {
        }
        field(33020068; "Vehicle Accessory Approver"; Boolean)
        {
        }
        field(33020069; "Can Transfer Vehicle Loan"; Boolean)
        {
        }
        field(33020070; "Can See Vehicle Commission"; Boolean)
        {
        }
        field(33020071; "Default Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center".Code;
        }
        field(33020072; "Max. Vehicle Sales Disc. Amt"; Decimal)
        {
        }
        field(33020073; "Payment and General Jnl Post"; Boolean)
        {
            Description = 'Exclusively on demand of M/s. Agni Corporation// for those who can post invoice & cash receipt journal but not payment and general journal';
        }
        field(33020074; "Full Name"; Text[100])
        {
        }
        field(33020075; "Can Run Veh. Allotment"; Boolean)
        {
        }
        field(33020076; "Can Update Posting Groups"; Boolean)
        {
        }
        field(33020077; "Can Edit Customer Card"; Boolean)
        {
        }
        field(33020078; "Can Edit Vendor Card"; Boolean)
        {
        }
        field(33020079; "Can Edit Bank Card"; Boolean)
        {
        }
        field(33020080; "Can Edit Item Card"; Boolean)
        {
        }
        field(33020081; "Can Edit Fixed Assets Card"; Boolean)
        {
        }
        field(33020082; "Can Edit Employee Card"; Boolean)
        {
        }
        field(33020083; "Can Reverse Journel"; Boolean)
        {
            Description = 'RL 7/3/19';
        }
        field(33020084; "Mobile App Admin"; Boolean)
        {
        }
        field(33020085; "Can Wave VF Penalty"; Boolean)
        {
        }
        field(33020086; "Loan Cash Rec. Posting Batch"; Code[10])
        {
            Description = 'is being used for cash receipt journal';
            TableRelation = "Gen. Journal Batch".Name WHERE(Template Type=CONST(Cash Receipts));
        }
        field(33020087; "Can modify Installment Dates"; Boolean)
        {
        }
        field(33020088; "Print HP - Delivery Order"; Boolean)
        {
        }
        field(33020089; "Can modify Accidental Vehicle"; Boolean)
        {
        }
        field(33020090; "Can modify Accidental Ins."; Boolean)
        {
        }
        field(33020091; "Customer Posting Group"; Code[100])
        {
        }
        field(33020092; "Can Edit Interest"; Boolean)
        {
        }
        field(33020093; "Can Verify Loan"; Boolean)
        {
        }
        field(33020094; "Can  Show HP Bank Details"; Boolean)
        {
        }
        field(33020095; "Can Edit Margin Interest Rate"; Boolean)
        {
            Description = 'for Agni Astha Company';
        }
        field(33020096; "Allow NCHL Response Message"; Boolean)
        {
        }
        field(33020097; "Allow All Templates"; Boolean)
        {
        }
        field(33020098; "Multisession Login"; Boolean)
        {
            Description = 'This will restrict user to run multiple ssession when set TRUE';
        }
        field(33020099; "Can Edit Item Description"; Boolean)
        {
        }
    }


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
    /*
    IF ("Profile Change Authority" = "Profile Change Authority"::Limited) OR
      ("Profile Change Authority" = "Profile Change Authority"::Standard) THEN
      TESTFIELD("User Profile Filter")
    ELSE IF ("Profile Change Authority" = "Profile Change Authority"::" ") OR
            ("Profile Change Authority" = "Profile Change Authority"::Admin) THEN
      "User Profile Filter" := '';
    */
    //end;

    procedure SetFilterOnRecord()
    begin
        UserSetup.GET(USERID);
        IF (UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::" ") OR
           (UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::Limited) THEN BEGIN
            FILTERGROUP(2);
            SETFILTER("User ID", USERID);
            FILTERGROUP(0);
        END
        ELSE
            IF (UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::Standard) THEN BEGIN
                FILTERGROUP(2);
                SETFILTER("User Profile Filter", '%1', UserSetup."User Profile Filter");
                FILTERGROUP(0);
            END;
    end;

    var
        Text100: Label 'Another user already has same PutIn/TakeOut Batch Name';
        UserSetup: Record "91";
        SingleInstanceMgt: Codeunit "25006001";
}

