pageextension 50024 pageextension50024 extends "User Setup"
{
    // 02.05.2017 EB.P7 Sign
    //   Added field:
    //     "Signed Document Path"
    // 
    // 15.03.2016 EB.P7 Branches
    //   Added field: Branch Code
    // 
    // 08.06.2015 EB.P7 #Schedule3.0
    //   Added field: "Resource No."
    // 
    // 16.04.2013 EDMS P8
    //   * Removed use of 'User Setup'.'Allow Posting Credit Memo'
    // 
    // 19.12.2011 EDMS P8
    //   * Add button/function: Card
    Editable = IsEditable;
    Caption = 'Service Warranty Approver';

    //Unsupported feature: Property Insertion (CardPageID) on ""User Setup"(Page 119)".

    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 4".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 6".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 8".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 15".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 17".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 21".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 3".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 4".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 4".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 6".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 6".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 8".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 8".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 15".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 17".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 21".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 3".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 3".

        addafter("Control 2")
        {
            field("Can See Cost"; Rec."Can See Cost")
            {
            }
            field("Allow View all Veh. Invoice"; Rec."Allow View all Veh. Invoice")
            {
            }
            field("Allow Direct Vehicle Sales"; Rec."Allow Direct Vehicle Sales")
            {
            }
            field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
            {
            }
            field("Allow SP change in Contact"; Rec."Allow SP change in Contact")
            {
            }
            field("Register Time"; Rec."Register Time")
            {
            }
            field("Sales Resp. Ctr. Filter"; Rec."Sales Resp. Ctr. Filter")
            {
                Visible = false;
            }
            field("Purchase Resp. Ctr. Filter"; Rec."Purchase Resp. Ctr. Filter")
            {
                Visible = false;
            }
            field("Service Resp. Ctr. Filter"; Rec."Service Resp. Ctr. Filter")
            {
                Visible = false;
            }
            field("Service Resp. Ctr. Filter EDMS"; Rec."Service Resp. Ctr. Filter EDMS")
            {
                Visible = false;
            }
            field("Default Responsibility Center"; Rec."Default Responsibility Center")
            {
                Visible = false;
            }
            field("Default Accountability Center"; Rec."Default Accountability Center")
            {
            }
            field("Default Location"; Rec."Default Location")
            {
            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
            }
            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
            }
            field("GL Account Department"; Rec."GL Account Department")
            {
            }
            field("Default User Profile Code"; Rec."Default User Profile Code")
            {
            }
            field("Allow Use Service Schedule"; Rec."Allow Use Service Schedule")
            {
            }
            field("Allow Creating Spare PO"; Rec."Allow Creating Spare PO")
            {
            }
        }
        addafter("Control 21")
        {
            field("Profile Change Authority"; Rec."Profile Change Authority")
            {
            }
            field("Allow Post.Multiple Commission"; Rec."Allow Post.Multiple Commission")
            {
            }
            field("User Profile Filter"; Rec."User Profile Filter")
            {
            }
        }
        addafter("Control 17")
        {
            field("Allow Correcting Serv-Inv"; Rec."Allow Correcting Serv-Inv")
            {
            }
        }
        addafter("Control 15")
        {
            field("Vehicle Modify Authority"; Rec."Vehicle Modify Authority")
            {
            }
            field("Vehicle Accessory Approver"; Rec."Vehicle Accessory Approver")
            {
            }
            field("Can Transfer Vehicle Loan"; Rec."Can Transfer Vehicle Loan")
            {
            }
            field("Can See Vehicle Commission"; Rec."Can See Vehicle Commission")
            {
            }
            field("Allow Posting From"; Rec."Allow Posting From")
            {
            }
            field("Signatory Group"; Rec."Signatory Group")
            {
            }
        }
        addafter("Control 8")
        {
            field("Payment and General Jnl Post"; Rec."Payment and General Jnl Post")
            {
            }
        }
        addafter("Control 4")
        {
            field("Allow Cancel Service Reserv."; Rec."Allow Cancel Service Reserv.")
            {
            }
        }
        addafter("Control 3")
        {
            field("Full Name"; Rec."Full Name")
            {
            }
            field("Can Edit Customer Card"; Rec."Can Edit Customer Card")
            {
            }
            field("Can Edit Vendor Card"; Rec."Can Edit Vendor Card")
            {
            }
            field("Can Edit Bank Card"; Rec."Can Edit Bank Card")
            {
            }
            field("Can Edit Item Card"; Rec."Can Edit Item Card")
            {
            }
            field("Can Edit Fixed Assets Card"; Rec."Can Edit Fixed Assets Card")
            {
            }
            field("Can Edit Employee Card"; Rec."Can Edit Employee Card")
            {
            }
            field("Can Reverse Journel"; Rec."Can Reverse Journel")
            {
            }
            field("Mobile App Admin"; Rec."Mobile App Admin")
            {
            }
            field("Can Wave VF Penalty"; Rec."Can Wave VF Penalty")
            {
            }
            field("Loan Cash Rec. Posting Batch"; Rec."Loan Cash Rec. Posting Batch")
            {
            }
            field("Can Reschedule Loan"; Rec."Can Reschedule Loan")
            {
            }
            field("Can Approve Veh. Ins. HP"; Rec."Can Approve Veh. Ins. HP")
            {
            }
            field("Can Post Veh. Ins. HP"; Rec."Can Post Veh. Ins. HP")
            {
            }
            field("Can Approve Vehicle Loan"; Rec."Can Approve Vehicle Loan")
            {
            }
            field("Cancel Only Own Reservation"; Rec."Cancel Only Own Reservation")
            {
            }
            field("VF Posting Batch"; Rec."VF Posting Batch")
            {
            }
            field("Print HP - Delivery Order"; Rec."Print HP - Delivery Order")
            {
            }
            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
            }
            field("Can Approve NCHL-NPI User"; Rec."Can Approve NCHL-NPI User")
            {
            }
            field("Allow NCHL Response Message"; Rec."Allow NCHL Response Message")
            {
            }
            field("Can Edit Interest"; Rec."Can Edit Interest")
            {
            }
            field("Can Verify Loan"; Rec."Can Verify Loan")
            {
            }
            field("Can  Show HP Bank Details"; Rec."Can  Show HP Bank Details")
            {
            }
            field("Allow Block Customer"; Rec."Allow Block Customer")
            {
            }
            field("Can Edit Margin Interest Rate"; Rec."Can Edit Margin Interest Rate")
            {
            }
            field("Allow All Templates"; Rec."Allow All Templates")
            {
            }
            field("Can Edit Item Description"; Rec."Can Edit Item Description")
            {
            }
        }
        moveafter("Control 2"; "Control 21")
        moveafter("Control 21"; "Control 17")
        moveafter("Control 17"; "Control 15")
        moveafter("Control 15"; "Control 8")
        moveafter("Control 8"; "Control 6")
    }

    var
        [InDataSet]
        IsEditable: Boolean;
        UserSetup: Record "91";


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    HideExternalUsers;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    HideExternalUsers;

    UserSetup.GET(USERID);
    IF UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::Admin THEN
      IsEditable := TRUE
    ELSE BEGIN
      //SetFilterOnRecord;
      IsEditable := FALSE;
    END
    */
    //end;
}

