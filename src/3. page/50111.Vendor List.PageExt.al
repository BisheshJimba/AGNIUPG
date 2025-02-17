pageextension 50111 pageextension50111 extends "Vendor List"
{
    Editable = StandardAccent;
    Editable = true;
    Editable = StrongAccent;
    Editable = true;
    Editable = false;
    Editable = false;
    Editable = false;
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 14".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 15".


        //Unsupported feature: Property Modification (SubPageLink) on "VendorDetailsFactBox(Control 1901138007)".


        //Unsupported feature: Property Modification (SubPageLink) on "VendorStatisticsFactBox(Control 1904651607)".


        //Unsupported feature: Property Modification (SubPageLink) on "VendorHistBuyFromFactBox(Control 1903435607)".


        //Unsupported feature: Property Modification (SubPageLink) on "VendorHistPayToFactBox(Control 1906949207)".

        modify("Location Code2")
        {
            Visible = false;
        }
        modify("Control 1102601008")
        {
            Visible = false;
        }
        modify("Control 1102601010")
        {
            Visible = false;
        }
        modify("Control 1102601012")
        {
            Visible = false;
        }
        addafter("Control 4")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                Style = Attention;
                StyleExpr = TRUE;
            }
        }
        addafter("Control 59")
        {
            field("Vendor Category"; "Vendor Category")
            {
                Visible = false;
            }
            field("Vendor Level (SOR)"; "Vendor Level (SOR)")
            {
                Visible = false;
            }
        }
        addafter("Control 32")
        {
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
            }
        }
        addafter("Control 47")
        {
            field(Address; Rec.Address)
            {
            }
        }
        addafter("Control 1102601004")
        {
            field("Location Code2"; Rec."Location Code")
            {
                ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                Visible = false;
            }
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies how the vendor must ship items to you.';
                Visible = false;
            }
            field("Lead Time Calculation"; Rec."Lead Time Calculation")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies a date formula for the amount of time that it takes to replenish the item.';
                Visible = false;
            }
            field("Interest Rate"; "Interest Rate")
            {
            }
            field("Maturity Date"; "Maturity Date")
            {
            }
            field("Base Calendar Code"; Rec."Base Calendar Code")
            {
                ToolTip = 'Specifies the code for the vendor''s customizable calendar.';
                Visible = false;
            }
            field(Saved; Saved)
            {
            }
        }
        moveafter("Control 68"; "Control 32")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "DimensionsSingle(Action 84)".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 20".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 62".


        //Unsupported feature: Property Modification (RunPageView) on "Action 22".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 18".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 21".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 19".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 57".

    }


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ResyncVisible := ReadSoftOCRMasterDataSync.IsSyncEnabled;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ResyncVisible := ReadSoftOCRMasterDataSync.IsSyncEnabled;

    //FILTERGROUP(3);
    //SETRANGE("Vendor Type","Vendor Type"::" ");
    */
    //end;
}

