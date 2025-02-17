table 25006120 "Service Mgt. Setup EDMS"
{
    // 10.10.2016 EB.P7 #WSH16
    //   Removed field"On Task Start" (moved to resource)
    // 
    // 04.04.2014 Elva Baltic P15 # MMG7.00
    //   * added field - "Def. Translation Language Code"
    // 
    // 2012.07.31 EDMS P8
    //   * Added fields: "Notify Before (VF Run 1)", Notify Before (VF Run 2), Notify Before (VF Run 3)
    // 
    // 19.01.2009. EDMS P2
    //   * Added field "Check Vehicle Sales Date"
    // 
    // 30.05.2008. EDMS P2
    //   * Added field "Transfer Qty. in Service"
    // 
    // 26.05.2008. EDMS P2
    //   * Added field "Control Alloc. Status on Post"
    // 
    // 07.01.2008. EDMS P2
    //   * Added field "Linked Entries Tracking"
    // 
    // 03.01.2008. EDMS P2
    //   * Added field "Split Allocation Tracking"
    // 
    // 27.12.2007. EDMS P2
    //   * Added field "Base Calendar Code"
    // 
    // 26.11.2007. EDMS P2
    //   * Added field "Control Lines In Serv. Order"
    // 
    // 29.08.2007. EDMS P2
    //   * Added new field "Quantity Equal Standard Time"
    // 
    // 24.08.2007. EDMS P2
    //   * Added field "Control Kilometrage"
    // 
    // 15.08.2007. EDMS P2
    //   * Added field "Autom. Apply Credit Memo"

    Caption = 'Service Mgt. Setup EDMS';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Quote Nos."; Code[10])
        {
            Caption = 'Quote Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Order Nos."; Code[10])
        {
            Caption = 'Order Nos.';
            TableRelation = "No. Series";
        }
        field(33; "Posted Order Nos."; Code[10])
        {
            Caption = 'Posted Order Nos.';
            TableRelation = "No. Series";
        }
        field(35; "Return Order Nos."; Code[10])
        {
            Caption = 'Return Order Nos.';
            TableRelation = "No. Series";
        }
        field(38; "Posted Return Order Nos."; Code[10])
        {
            Caption = 'Posted Return Order Nos.';
            TableRelation = "No. Series";
        }
        field(60; "Labor Nos."; Code[10])
        {
            Caption = 'Labor Nos.';
            TableRelation = "No. Series";
        }
        field(90; "Service Package Nos."; Code[10])
        {
            Caption = 'Service Package Nos.';
            TableRelation = "No. Series";
        }
        field(94; "Service Plan Nos."; Code[10])
        {
            Caption = 'Service Plan Nos.';
            TableRelation = "No. Series";
        }
        field(96; "Recall Campaign Nos."; Code[10])
        {
            Caption = 'Recall Campaign Nos.';
            TableRelation = "No. Series";
        }
        field(98; "Warranty Nos."; Code[10])
        {
            Caption = 'Warranty Nos.';
            TableRelation = "No. Series";
        }
        field(100; "Invoice Nos."; Code[10])
        {
            Caption = 'Invoice Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF Rec."Invoice Nos." <> '' THEN
                    MESSAGE(Txt301);
            end;
        }
        field(110; "External Service Nos."; Code[10])
        {
            Caption = 'External Service Nos.';
            TableRelation = "No. Series";
        }
        field(140; "Credit Warnings"; Option)
        {
            Caption = 'Credit Warnings';
            OptionCaption = 'Both Warnings,Credit Limit,Overdue Balance,No Warning';
            OptionMembers = "Both Warnings","Credit Limit","Overdue Balance","No Warning";
        }
        field(200; "Credit Memo Nos."; Code[10])
        {
            Caption = 'Credit Memo Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF Rec."Credit Memo Nos." <> '' THEN
                    MESSAGE(Txt302);
            end;
        }
        field(210; "Posted Credit Memo Nos."; Code[10])
        {
            Caption = 'Posted Credit Memo Nos.';
            TableRelation = "No. Series";
        }
        field(220; "Order Nos. from Quote"; Code[10])
        {
            Caption = 'Order Nos. from Quote';
            TableRelation = "No. Series";
        }
        field(230; "Posted Invoice Nos."; Code[10])
        {
            Caption = 'Posted Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(310; "Ext. Doc. No. Mandatory"; Boolean)
        {
            Caption = 'Ext. Doc. No. Mandatory';
        }
        field(320; "Cust. Price Group Mandatory"; Boolean)
        {
            Caption = 'Cust. Price Group Mandatory';
        }
        field(340; "Split Invc.Balance G/L Account"; Code[20])
        {
            Caption = 'Balance Account Number';
            TableRelation = "G/L Account";
        }
        field(350; "Prices Including VAT In Inv."; Boolean)
        {
            Caption = 'Prices Including VAT In Inv.';
        }
        field(360; "Use Order No. as Posting No."; Boolean)
        {
            Caption = 'Use Order No. as Posting No.';
        }
        field(370; "Use Order No. for Inv.&Cr.Memo"; Boolean)
        {
            Caption = 'Use Order No. for Inv.&Cr.Memo';
        }
        field(380; "Posted Prepmt. Inv. Nos."; Code[10])
        {
            Caption = 'Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(390; "Posted Prepmt. Cr. Memo Nos."; Code[10])
        {
            Caption = 'Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(395; "Service Booking Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(400; "Check Prepmt. when Posting"; Boolean)
        {
            Caption = 'Check Prepmt. when Posting';
        }
        field(410; "Service Schedule Active"; Boolean)
        {
            Caption = 'Service Schedule Active';
            Description = 'means is used calendar or not';
        }
        field(1000; "Show Line Grouping"; Boolean)
        {
            Caption = 'Show Line Grouping';
        }
        field(5000; "Control Package Consistency"; Boolean)
        {
            Caption = 'Control Package Consistency';
        }
        field(10500; "Deal Type Mandatory"; Boolean)
        {
            Caption = 'Deal Type Mandatory';
        }
        field(10600; "Archive Quotes and Orders"; Boolean)
        {
            Caption = 'Archive Quotes and Orders';
        }
        field(20100; "Inbound Transfer Line Filling"; Option)
        {
            Caption = 'Inbound Transfer Line Filling';
            Description = 'Service Transfer';
            OptionCaption = 'Manual,Prompt,Automatic';
            OptionMembers = Manual,Prompt,Automatic;
        }
        field(20120; "Outbound Transfer Line Filling"; Option)
        {
            Caption = 'Outbound Transfer Line Filling';
            Description = 'Service Transfer';
            OptionCaption = 'Manual,Prompt,Automatic';
            OptionMembers = Manual,Prompt,Automatic;
        }
        field(20200; "Def. Service Location Code"; Code[20])
        {
            Caption = 'Def. Service Location Code';
            Description = 'Service Transfer';
            TableRelation = Location;
        }
        field(20220; "Def. Spare Part Location Code"; Code[20])
        {
            Caption = 'Def. Spare Part Location Code';
            Description = 'Service Transfer';
            TableRelation = Location;
        }
        field(20250; "Transfer On Return"; Option)
        {
            Caption = 'Transfer On Return';
            Description = 'Service Transfer';
            OptionCaption = 'Manual,Create Transfer Order,Create&Post Transfer Order';
            OptionMembers = Manual,"Create Transfer Order","Create&Post Transfer Order";
        }
        field(20300; "Fully Transfered Mandatory"; Boolean)
        {
            Caption = 'Fully Transfered Mandatory';
        }
        field(20340; "Inbound Transf. Auto-Reserve"; Boolean)
        {
            Caption = 'Inbound Transf. Auto-Reserve';
        }
        field(30000; "Item No. Replacement Warnings"; Boolean)
        {
            Caption = 'Item No. Replacement Warnings';
        }
        field(30200; "Recall Campaign Warnings"; Boolean)
        {
            Caption = 'Recall Campaign Warnings';
        }
        field(30210; "Log Service Plan Mgt. Process"; Boolean)
        {
            Caption = 'Log Service Plan Mgt. Process';
        }
        field(30310; "Check Transfered Qty.On Delete"; Option)
        {
            Caption = 'Check Transfered Qty.On Delete';
            OptionCaption = 'No,Confirm,Restrict';
            OptionMembers = No,Confirm,Restrict;
        }
        field(30320; "Def. Translation Language Code"; Code[10])
        {
            Caption = 'Default Translation Language Code';
            TableRelation = Language;
        }
        field(50001; "Revisit Repair Period"; Integer)
        {
            Description = 'PSF';
        }
        field(50002; "Revisit Repair KM"; Integer)
        {
            Description = 'PSF';
        }
        field(50003; "Attachment Storage"; Text[250])
        {
        }
        field(25006001; "Def. Ordering Price Type Code"; Code[10])
        {
            Caption = 'Def. Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006010; "Offer Link Vehicle and Contact"; Boolean)
        {
            Caption = 'Offer Link Vehicle and Contact';
        }
        field(25006015; "Payment Method Mandatory"; Boolean)
        {
            Caption = 'Payment Method Mandatory';
        }
        field(25006020; "Link Relationship Code"; Code[10])
        {
            Caption = 'Link Relationship Code';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006300; "AutoApply Credit Memo"; Boolean)
        {
            Caption = 'AutoApply Credit Memo';
        }
        field(25006310; "Check Kilometrage on Release"; Boolean)
        {
            CaptionClass = '7,25006120,25006310';
        }
        field(25006311; "Check VF Run 2 on Release"; Boolean)
        {
            CaptionClass = '7,25006120,25006311';
        }
        field(25006312; "Check VF Run 3 on Release"; Boolean)
        {
            CaptionClass = '7,25006120,25006312';
        }
        field(25006320; "Quantity Equals Standard Time"; Boolean)
        {
            Caption = 'Quantity Equals Standard Time';
        }
        field(25006330; "Make and Model Mandatory"; Boolean)
        {
            Caption = 'Make and Model Mandatory';
        }
        field(25006340; "Check Vehicle Sales Date"; Boolean)
        {
            Caption = 'Check Vehicle Sales Date';
        }
        field(25006350; "Copy Comments Serv. Plan"; Boolean)
        {
            Caption = 'Copy Comments Serv. Plan';
        }
        field(25006360; "Create To-do After Posting"; Boolean)
        {
            Caption = 'Create To-do After Posting';
        }
        field(25006370; "To-do Date Formula"; DateFormula)
        {
            Caption = 'To-do Date Formula';
        }
        field(25006375; "To-do Interaction Template"; Code[20])
        {
            Caption = 'To-do Interaction Template';
            TableRelation = "Interaction Template";
        }
        field(25006380; "Notify Before (Date Formula)"; DateFormula)
        {
            Caption = 'Notify Before (Date Formula)';
            Description = 'Serv. Plan';
        }
        field(25006390; "Notify Before (Kilometrage)"; Integer)
        {
            CaptionClass = '7,25006120,25006390';
            Description = 'Serv. Plan';
        }
        field(25006391; "Notify Before (VF Run 2)"; Decimal)
        {
            CaptionClass = '7,25006120,25006391';
            Description = 'Serv. Plan';
        }
        field(25006392; "Notify Before (VF Run 3)"; Decimal)
        {
            CaptionClass = '7,25006120,25006392';
            Description = 'Serv. Plan';
        }
        field(25006400; "Service Plan Notification"; Boolean)
        {
            Caption = 'Service Plan Notification';
            Description = 'Serv. Plan';
        }
        field(25006410; "Serv. Plan Cont. Relationship"; Code[20])
        {
            Caption = 'Serv. Plan Cont. Relationship';
            Description = 'Serv. Plan - used for auto generation of serv. doc';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006411; "PDI Cont. Relationship"; Code[20])
        {
            Caption = 'PDI Cont. Relationship';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006412; "Notify About Components"; Boolean)
        {
            Caption = 'Notify About Components';
        }
        field(25006413; "Service Comment Line Type"; Code[20])
        {
            Caption = 'Service Comment Line Type';
            TableRelation = "Service Comment Line Type";
        }
        field(25006414; "Control Veh. Reg. No. Dubl."; Option)
        {
            Caption = 'Control Vehicle Registration No. Dublicates';
            OptionMembers = Warning,No,Yes;
        }
        field(25006415; "Default Location Code"; Code[20])
        {
        }
        field(25006417; "Default Idle Event"; Code[20])
        {
            TableRelation = "Serv. Standard Event";
        }
        field(25006418; "Resource No. Mandatory"; Boolean)
        {
        }
        field(25006419; "Auto Apply Replacements"; Boolean)
        {
            Caption = 'Automatically Apply Replacements';
        }
        field(33020235; "Warranty Job Type Code"; Code[20])
        {
            Description = 'Warranty Job Type Code related to Job type master';
            TableRelation = "Job Type Master".No.;
        }
        field(33020236; "Free Job Type Code"; Code[20])
        {
            Description = 'Free Job type Code related to Job type master';
            TableRelation = "Job Type Master".No.;
        }
        field(33020237; "Apply Rules of Checking Steps"; Boolean)
        {
        }
        field(33020238; "Sanjivani Rem. B/C Account No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(33020239; "Sanjivani Gen. Bus. Posting Gr"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
        }
        field(33020240; "Sanjivani Gen. Pro. Posting Gr"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(33020241; "Warranty Register Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020242; "Allow Local Parts For Warranty"; Boolean)
        {
        }
        field(33020243; "Inbound/Outbound Consistency"; Boolean)
        {
            Description = 'Checks Inbound/Outbound Consistency';
        }
        field(33020244; "Dealer Service Followup Nos."; Code[10])
        {
            Description = 'number series will be used when dealer service order followup is synchronized from all dealers';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Txt301: Label 'Don''t forget to relate this Num. serie with Posted Sales Invoice Num. serie';
        Txt302: Label 'Don''t forget to relate this Num. serie with Posted Sales Credit Memo Num. serie';
        VFMgt: Codeunit "25006004";

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Service Mgt. Setup EDMS", intFieldNo));
    end;
}

