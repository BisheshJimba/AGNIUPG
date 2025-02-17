page 25006150 "Service Mgt. Setup EDMS"
{
    // 10.10.2016 EB.P7 #WSH16
    //   Removed field"On Task Start" (moved to resource)
    // 
    // 04.04.2014 Elva Baltic P15 # MMG7.00
    //   * added field - "Def. Translation Language Code"
    // 
    // 22.01.2014 MMG7.1.00 P8 F029
    //   * Added fields: "Adv. Prepayment Account"
    // 
    // 28.01.2010 EDMS P2
    //   * Opened fields "Create To-do After Posting"
    //                  "To-do Date Formula"
    //                  "Serv. Plan Notify Date Formula"
    //                  "Serv. Plan Notify Kilometrage"
    //                  "Offer Link Vehicle and Contact"
    //                  "Link Relationship Code"
    // 
    // 19.01.2009. EDMS P2
    //   * Opened field "Check Vehicle Sales Date"

    Caption = 'Service Setup';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006120;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Check Kilometrage on Release"; "Check Kilometrage on Release")
                {
                }
                field("Check VF Run 2 on Release"; "Check VF Run 2 on Release")
                {
                    Visible = IsVFRun2Visible;
                }
                field("Check VF Run 3 on Release"; "Check VF Run 3 on Release")
                {
                    Visible = IsVFRun3Visible;
                }
                field("Check Prepmt. when Posting"; "Check Prepmt. when Posting")
                {
                }
                field("Quantity Equals Standard Time"; "Quantity Equals Standard Time")
                {
                }
                field("Control Package Consistency"; "Control Package Consistency")
                {
                }
                field("Def. Ordering Price Type Code"; "Def. Ordering Price Type Code")
                {
                }
                field("AutoApply Credit Memo"; "AutoApply Credit Memo")
                {
                }
                field("Prices Including VAT In Inv."; "Prices Including VAT In Inv.")
                {
                }
                field("Archive Quotes and Orders"; "Archive Quotes and Orders")
                {
                }
                field("Ext. Doc. No. Mandatory"; "Ext. Doc. No. Mandatory")
                {
                }
                field("Cust. Price Group Mandatory"; "Cust. Price Group Mandatory")
                {
                }
                field("Deal Type Mandatory"; "Deal Type Mandatory")
                {
                }
                field("Payment Method Mandatory"; "Payment Method Mandatory")
                {
                }
                field("Make and Model Mandatory"; "Make and Model Mandatory")
                {
                }
                field("Item No. Replacement Warnings"; "Item No. Replacement Warnings")
                {
                }
                field("Auto Apply Replacements"; "Auto Apply Replacements")
                {
                }
                field("Recall Campaign Warnings"; "Recall Campaign Warnings")
                {
                }
                field("Check Vehicle Sales Date"; "Check Vehicle Sales Date")
                {
                }
                field("Offer Link Vehicle and Contact"; "Offer Link Vehicle and Contact")
                {
                }
                field("Link Relationship Code"; "Link Relationship Code")
                {
                }
                field("Copy Comments Serv. Plan"; "Copy Comments Serv. Plan")
                {
                }
                field("Service Schedule Active"; "Service Schedule Active")
                {
                }
                field("Serv. Plan Cont. Relationship"; "Serv. Plan Cont. Relationship")
                {
                }
                field("PDI Cont. Relationship"; "PDI Cont. Relationship")
                {
                }
                field("Def. Translation Language Code"; "Def. Translation Language Code")
                {
                }
                field("Control Veh. Reg. No. Dubl."; "Control Veh. Reg. No. Dubl.")
                {
                }
                field("Default Idle Event"; "Default Idle Event")
                {
                }
                field("Resource No. Mandatory"; "Resource No. Mandatory")
                {
                }
                field("Apply Rules of Checking Steps"; "Apply Rules of Checking Steps")
                {
                }
                field("Revisit Repair Period"; "Revisit Repair Period")
                {
                }
                field("Revisit Repair KM"; "Revisit Repair KM")
                {
                }
                field("Attachment Storage"; "Attachment Storage")
                {
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                field("Inbound Transfer Line Filling"; "Inbound Transfer Line Filling")
                {
                }
                field("Outbound Transfer Line Filling"; "Outbound Transfer Line Filling")
                {
                }
                field("Def. Service Location Code"; "Def. Service Location Code")
                {
                }
                field("Def. Spare Part Location Code"; "Def. Spare Part Location Code")
                {
                }
                field("Transfer On Return"; "Transfer On Return")
                {
                }
                field("Fully Transfered Mandatory"; "Fully Transfered Mandatory")
                {
                }
                field("Check Transfered Qty.On Delete"; "Check Transfered Qty.On Delete")
                {
                }
                field("Inbound Transf. Auto-Reserve"; "Inbound Transf. Auto-Reserve")
                {
                }
                field("Inbound/Outbound Consistency"; "Inbound/Outbound Consistency")
                {
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Labor Nos."; "Labor Nos.")
                {
                }
                field("Service Package Nos."; "Service Package Nos.")
                {
                }
                field("External Service Nos."; "External Service Nos.")
                {
                }
                field("Warranty Nos."; "Warranty Nos.")
                {
                }
                field("Service Plan Nos."; "Service Plan Nos.")
                {
                }
                field("Quote Nos."; "Quote Nos.")
                {
                }
                field("Order Nos."; "Order Nos.")
                {
                }
                field("Posted Order Nos."; "Posted Order Nos.")
                {
                    Enabled = PostedOrderNosEnable;
                }
                field("Return Order Nos."; "Return Order Nos.")
                {
                }
                field("Posted Return Order Nos."; "Posted Return Order Nos.")
                {
                    Enabled = PostedReturnOrderNosEnable;
                }
                field("Recall Campaign Nos."; "Recall Campaign Nos.")
                {
                }
                field("Invoice Nos."; "Invoice Nos.")
                {
                    Enabled = InvoiceNosEnable;
                }
                field("Posted Invoice Nos."; "Posted Invoice Nos.")
                {
                }
                field("Credit Memo Nos."; "Credit Memo Nos.")
                {
                    Enabled = CreditMemoNosEnable;
                }
                field("Posted Credit Memo Nos."; "Posted Credit Memo Nos.")
                {
                }
                field("Order Nos. from Quote"; "Order Nos. from Quote")
                {
                }
                field("Posted Prepmt. Inv. Nos."; "Posted Prepmt. Inv. Nos.")
                {
                }
                field("Posted Prepmt. Cr. Memo Nos."; "Posted Prepmt. Cr. Memo Nos.")
                {
                }
                field("Use Order No. as Posting No."; "Use Order No. as Posting No.")
                {

                    trigger OnValidate()
                    begin
                        PostedOrderNosEnable := NOT "Use Order No. as Posting No.";
                        PostedReturnOrderNosEnable := NOT "Use Order No. as Posting No.";
                    end;
                }
                field("Use Order No. for Inv.&Cr.Memo"; "Use Order No. for Inv.&Cr.Memo")
                {

                    trigger OnValidate()
                    begin
                        InvoiceNosEnable := NOT "Use Order No. for Inv.&Cr.Memo";
                        CreditMemoNosEnable := NOT "Use Order No. for Inv.&Cr.Memo";
                    end;
                }
                field("Service Booking Nos."; "Service Booking Nos.")
                {
                }
                field("Warranty Register Nos."; "Warranty Register Nos.")
                {
                }
            }
            group("Service Plan")
            {
                Caption = 'Service Plan';
                field("Service Plan Notification"; "Service Plan Notification")
                {
                }
                field("Notify Before (Date Formula)"; "Notify Before (Date Formula)")
                {
                }
                field("Notify Before (Kilometrage)"; "Notify Before (Kilometrage)")
                {
                    Visible = IsVFRun1Visible;
                }
                field("Notify Before (VF Run 2)"; "Notify Before (VF Run 2)")
                {
                    Visible = IsVFRun2Visible;
                }
                field("Notify Before (VF Run 3)"; "Notify Before (VF Run 3)")
                {
                    Visible = IsVFRun3Visible;
                }
                field("Notify About Components"; "Notify About Components")
                {
                }
                field("Log Service Plan Mgt. Process"; "Log Service Plan Mgt. Process")
                {
                }
            }
            group("To-do")
            {
                Caption = 'To-do';
                field("Create To-do After Posting"; "Create To-do After Posting")
                {
                }
                field("To-do Date Formula"; "To-do Date Formula")
                {
                }
                field("To-do Interaction Template"; "To-do Interaction Template")
                {
                }
            }
            group(Warranty)
            {
                Caption = 'Warranty';
                field("Warranty Job Type Code"; "Warranty Job Type Code")
                {
                }
                field("Free Job Type Code"; "Free Job Type Code")
                {
                }
                field("Allow Local Parts For Warranty"; "Allow Local Parts For Warranty")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CreditMemoNosEnable := TRUE;
        InvoiceNosEnable := TRUE;
        PostedReturnOrderNosEnable := TRUE;
        PostedOrderNosEnable := TRUE;

        IsVFRun1Visible := IsVFActive(FIELDNO("Notify Before (Kilometrage)"));
        IsVFRun2Visible := IsVFActive(FIELDNO("Notify Before (VF Run 2)"));
        IsVFRun3Visible := IsVFActive(FIELDNO("Notify Before (VF Run 3)"));
    end;

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
        OnActivateForm;

        SetVariableFields;
    end;

    var
        [InDataSet]
        PostedOrderNosEnable: Boolean;
        [InDataSet]
        PostedReturnOrderNosEnable: Boolean;
        [InDataSet]
        InvoiceNosEnable: Boolean;
        [InDataSet]
        CreditMemoNosEnable: Boolean;
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;

    local procedure OnActivateForm()
    begin
        PostedOrderNosEnable := NOT "Use Order No. as Posting No.";
        PostedReturnOrderNosEnable := NOT "Use Order No. as Posting No.";
        InvoiceNosEnable := NOT "Use Order No. for Inv.&Cr.Memo";
        CreditMemoNosEnable := NOT "Use Order No. for Inv.&Cr.Memo";
    end;

    [Scope('Internal')]
    procedure SetVariableFields()
    begin
        //Variable Fields
        IsVFRun1Visible := IsVFActive(FIELDNO("Notify Before (Kilometrage)"));
        IsVFRun2Visible := IsVFActive(FIELDNO("Notify Before (VF Run 2)"));
        IsVFRun3Visible := IsVFActive(FIELDNO("Notify Before (VF Run 3)"));
    end;
}

