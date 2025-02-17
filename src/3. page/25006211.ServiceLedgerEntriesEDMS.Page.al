page 25006211 "Service Ledger Entries EDMS"
{
    // 11.06.2015 EB.P30 #T041
    //   Added fields:
    //     "Resource Cost Amount"
    //     "Quantity (Hours)"
    //     "Resources"
    // 
    // 12.02.2015 EB.P7 #T020
    //   Removed field "Date Filter" because of Clipboard Crash
    // 
    // 29.05.2013 Elva Baltic P15
    //   * Added ShowDocument function
    // 
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 28.01.2010 EDMSB P2
    //   * Opened field "Standard Time", "Campaign No.", "Labor Group Code", "Labor Subgroup Code"
    // 
    // 20.10.2008. EDMS P2
    //   * Opened field "Deal Type code"
    // 
    // 29.05.2008. EDMS P2
    //   * Opened field VIN

    Caption = 'Service Ledger Entries EDMS';
    DataCaptionFields = "Vehicle Serial No.";
    Editable = false;
    PageType = List;
    SourceTable = Table25006167;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Entry Type"; "Entry Type")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PostedServOrder: Record "25006149";
                        PostedRetOrder: Record "25006154";
                        SalesInvoiceHdr: Record "112";
                    begin
                        //29.05.2013 Elva Baltic P15 >>
                        ShowDocument;
                        //29.05.2013 Elva Baltic P15 <<
                    end;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                }
                field("Total Cost"; "Total Cost")
                {
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Charged Qty."; "Charged Qty.")
                {
                }
                field(Chargeable; Chargeable)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Discount %"; "Discount %")
                {
                }
                field(Description; Description)
                {
                }
                field("Deal Type Code"; "Deal Type Code")
                {
                }
                field("Service Order Type"; "Service Order Type")
                {
                }
                field("Service Order No."; "Service Order No.")
                {
                }
                field("Job No."; "Job No.")
                {
                }
                field("Labor Group Code"; "Labor Group Code")
                {
                }
                field("Labor Subgroup Code"; "Labor Subgroup Code")
                {
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field(Open; Open)
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field("Pre-Assigned No."; "Pre-Assigned No.")
                {
                }
                field("Service Receiver"; "Service Receiver")
                {
                }
                field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
                {
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                }
                field("Cust. Ledger Entry No."; "Cust. Ledger Entry No.")
                {
                }
                field("Serv. Order Remaining Amt"; "Serv. Order Remaining Amt")
                {
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                }
                field("Warranty Claim No."; "Warranty Claim No.")
                {
                    Visible = false;
                }
                field("Variable Field 25006800"; "Variable Field 25006800")
                {
                    Visible = DMSVariableField25006800Visibl;
                }
                field("Variable Field 25006801"; "Variable Field 25006801")
                {
                    Visible = DMSVariableField25006801Visibl;
                }
                field("Variable Field 25006802"; "Variable Field 25006802")
                {
                    Visible = DMSVariableField25006802Visibl;
                }
                field("Document Line No."; "Document Line No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //29.05.2013 Elva Baltic P15 >>
                        ShowDocument;
                        //29.05.2013 Elva Baltic P15 <<
                    end;
                }
                field("Entry No."; "Entry No.")
                {
                }
                field("Package No."; "Package No.")
                {
                    Visible = false;
                }
                field("Package Version No."; "Package Version No.")
                {
                    Visible = false;
                }
                field("Package Version Spec. Line No."; "Package Version Spec. Line No.")
                {
                    Visible = false;
                }
                field("Standard Time"; "Standard Time")
                {
                }
                field("Campaign No."; "Campaign No.")
                {
                }
                field(Kilometrage; Kilometrage)
                {
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = false;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = false;
                }
                field("Parent Vehicle Serial No."; "Parent Vehicle Serial No.")
                {
                }
                field("Minutes Per UoM"; "Minutes Per UoM")
                {
                    Visible = false;
                }
                field("Finished Hours"; "Finished Hours")
                {
                    Visible = true;
                }
                field("Resource Cost Amount"; "Resource Cost Amount")
                {
                }
                field(GetResourceTextFieldValue(); GetResourceTextFieldValue())
                {
                    Caption = 'Resources';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowDetLedgEntries;
                    end;
                }
                field("Service Address Code"; "Service Address Code")
                {
                    Visible = false;
                }
                field("Service Address"; "Service Address")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("Tire Entries")
                {
                    Caption = 'Tire Entries';
                    Image = ItemLedger;
                    RunObject = Page 25006269;
                    RunPageLink = Service Ledger Entry No.=FIELD(Entry No.);
                }
                action("Detailed Service Ledger Entries")
                {
                    Caption = 'Detailed Service Ledger Entries';
                    Image = ItemLedger;
                    RunObject = Page 25006261;
                                    RunPageLink = Service Ledger Entry No.=FIELD(Entry No.);
                    ShortCutKey = 'Ctrl+F5';
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.RUN;
                end;
            }
            action(Comments)
            {
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ServiceCommentLine: Record "25006148";
                    SalesCommentLine: Record "44";
                begin
                    CASE "Entry Type" OF
                      "Entry Type"::Usage:
                        BEGIN
                          ServiceCommentLine.RESET;
                          ServiceCommentLine.SETRANGE(Type,ServiceCommentLine.Type::"Service Order");
                          ServiceCommentLine.SETRANGE("No.","Document No.");
                          PAGE.RUN(PAGE::"Service Comment Sheet EDMS",ServiceCommentLine);
                        END;
                      "Entry Type"::Sale:
                        BEGIN
                          SalesCommentLine.RESET;
                          SalesCommentLine.SETRANGE("Document Type",SalesCommentLine."Document Type"::"Posted Invoice");
                          SalesCommentLine.SETRANGE("No.","Document No.");
                          PAGE.RUN(PAGE::"Sales Comment Sheet",SalesCommentLine);
                        END;
                    END
                end;
            }
        }
    }

    var
        Navigate: Page "344";
    [InDataSet]

    DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006801Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006802Visibl: Boolean;
        ResourcesNo: Text;

    [Scope('Internal')]
    procedure fSetVariableFields()
    begin
        //Variable Fields
         DMSVariableField25006800Visibl := IsVFActive(FIELDNO("Variable Field 25006800"));
         DMSVariableField25006801Visibl := IsVFActive(FIELDNO("Variable Field 25006801"));
         DMSVariableField25006802Visibl := IsVFActive(FIELDNO("Variable Field 25006802"));
    end;

    [Scope('Internal')]
    procedure fHideVariableFields()
    begin
        //Variable Fields
         DMSVariableField25006800Visibl := FALSE;
         DMSVariableField25006801Visibl := FALSE;
         DMSVariableField25006802Visibl := FALSE;
    end;

    [Scope('Internal')]
    procedure ShowDocument()
    var
        PostedServOrder: Record "25006149";
        PostedRetOrder: Record "25006154";
        SalesInvoiceHdr: Record "112";
    begin
        //29.05.2013 Elva Baltic P15
        IF "Entry Type" = "Entry Type"::Usage THEN BEGIN
          PostedServOrder.RESET;
          PostedServOrder.SETRANGE("No.","Document No.");
          IF PostedServOrder.FINDFIRST THEN
            PAGE.RUN(PAGE::"Posted Service Order EDMS",PostedServOrder)
          ELSE BEGIN
            PostedRetOrder.RESET;
            PostedRetOrder.SETRANGE("No.","Document No.");
            IF PostedRetOrder.FINDFIRST THEN
              PAGE.RUN(PAGE::"Posted Service Ret.Order EDMS",PostedRetOrder)
          END;
        END ELSE IF "Entry Type" = "Entry Type"::Sale THEN BEGIN
          SalesInvoiceHdr.RESET;
          SalesInvoiceHdr.SETRANGE("No.","Document No.");
          IF SalesInvoiceHdr.FINDFIRST THEN
            PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHdr)

        END ELSE      //Info
        ;
    end;
}

