pageextension 50183 pageextension50183 extends "Sales Invoice Subform"
{
    Editable = IsEditable;
    Editable = false;
    Editable = IsVisible;
    Editable = false;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".


        //Unsupported feature: Code Modification on "Control 8.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ValidateAutoReserve;
        RedistributeTotalsOnAfterValidate;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //Sipradi-YS BEGIN
        IF ("Document Profile" = "Document Profile"::Service) THEN
          ChangeQtyPrice;
        //SIpradi-YS END
        ValidateAutoReserve;
        RedistributeTotalsOnAfterValidate;
        */
        //end;


        //Unsupported feature: Code Modification on "Control 12.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        RedistributeTotalsOnAfterValidate;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        RedistributeTotalsOnAfterValidate;

        //Sipradi-YS BEGin
        {IF ("Document Profile" = "Document Profile"::Service) THEN
          ChangeQtyPrice; }
        //Sipradi-YS END
        */
        //end;
        addafter("Control 4")
        {
            field("HS Code"; "HS Code")
            {
                Editable = false;
            }
        }
        addafter("Control 14")
        {
            field("External Serv. Tracking No."; "External Serv. Tracking No.")
            {
                Visible = false;
            }
        }
        addafter("Control 6")
        {
            field("Job Type"; "Job Type")
            {
            }
        }
        addafter("Control 84")
        {
            field("Qty. to Invoice"; Rec."Qty. to Invoice")
            {
                Visible = false;
            }
        }
        addafter("Control 72")
        {
            field(ABC; ABC)
            {
            }
        }
        addafter("Control 48")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                Visible = false;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                Visible = false;
            }
        }
        addafter("Control 106")
        {
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
            }
            field("Package No."; "Package No.")
            {
            }
            field("Package Version No."; "Package Version No.")
            {
            }
            field("Package Version Spec. Line No."; "Package Version Spec. Line No.")
            {
            }
            field("Customer Price Group"; Rec."Customer Price Group")
            {
            }
            field(VIN; VIN)
            {
                Visible = false;
            }
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Visible = false;
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field("VIN-COGS"; "VIN-COGS")
            {
            }
        }
    }

    var
        [InDataSet]
        ISVisible: Boolean;
        UserSetup: Record "91";
        NoDelete: Label 'You cannot delete %1 Invoices.';
        IsEditable: Boolean;


    //Unsupported feature: Code Modification on "OnDeleteRecord".

    //trigger OnDeleteRecord(): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
      COMMIT;
      IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
        EXIT(FALSE);
      ReserveSalesLine.DeleteLine(Rec);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    //Sipradi-YS BEGIN
    IF ("Document Profile" = "Document Profile"::Service) OR ("Document Profile" = "Document Profile"::"Spare Parts Trade") THEN
      ERROR(NoDelete,"Document Profile");
    //Sipradi-YS END

    #1..6
    */
    //end;


    //Unsupported feature: Code Modification on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesSetup.GET;
    Currency.InitRoundingPrecision;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SalesSetup.GET;
    Currency.InitRoundingPrecision;

    UserSetup.GET(USERID);
    IF UserSetup."Can See Cost" THEN
      ISVisible :=TRUE
    ELSE
      ISVisible := FALSE;
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Location.READPERMISSION THEN
      LocationCodeVisible := NOT Location.ISEMPTY;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF Location.READPERMISSION THEN
      LocationCodeVisible := NOT Location.ISEMPTY;

    CALCFIELDS(Inventory);

    UserSetup.GET(USERID);
    IF UserSetup."Can Edit Item Description" THEN
      IsEditable := TRUE
    ELSE
      IsEditable := FALSE;
    */
    //end;
}

