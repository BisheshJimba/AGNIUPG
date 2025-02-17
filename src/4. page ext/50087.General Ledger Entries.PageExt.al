pageextension 50087 pageextension50087 extends "General Ledger Entries"
{
    // 17.12.2014 EDMS P12
    //   * Changed property Visible for field Amount from AmountVisible to TRUE (default)
    //     (was remained from old localization)
    // 
    // 30.04.2014 Elva Baltic P8 #F058 MMG7.00
    //   * ADDED PERMISSIONS
    // 
    // 03.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Added field "VAT Bus. Posting Group"
    //   *Added field "VAT Prod. Posting Group"
    // 17.03.2014 Elva Baltic P7 #S0033 MMG7.00
    //   * Field Added "Source Description"
    // 
    // 25.02.2014 Elva Baltic P7 #F058 MMG7.00
    //   * Vehicle Cycle number cheange functionality added
    // 
    // 12.08.2013 EDMS P8
    //   * Added fields: VIN, etc.

    //Unsupported feature: Property Modification (SourceTableView) on ""General Ledger Entries"(Page 20)".


    //Unsupported feature: Property Insertion (Permissions) on ""General Ledger Entries"(Page 20)".

    layout
    {

        //Unsupported feature: Property Deletion (Visible) on "Control 40".

        modify("Control 46")
        {
            Visible = false;
        }
        modify("Control 20")
        {
            Visible = false;
        }
        addafter("Control 10")
        {
            field(Narration; Narration)
            {
            }
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
            }
            field("User ID"; Rec."User ID")
            {
            }
            field("Created by"; "Created by")
            {
            }
        }
        addafter("Control 30")
        {
            field("Employee Code"; "Employee Code")
            {
            }
            field("Employee Name"; "Employee Name")
            {
            }
        }
        addafter("Control 14")
        {
            field("Inventory Posting Group"; "Inventory Posting Group")
            {
            }
        }
        addafter("Control 5")
        {
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
            }
        }
        addafter("Control 38")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Visible = false;
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field("Vehicle Registration No."; "Vehicle Registration No.")
            {
                Visible = false;
            }
            field("Source Type"; Rec."Source Type")
            {
            }
            field("Source No."; Rec."Source No.")
            {
            }
            field("VIN(Item Charge Assigned)"; "VIN(Item Charge Assigned)")
            {
                Caption = 'VIN (Item Charge Assigned)';
            }
            field(VIN; VIN)
            {
                Visible = false;
            }
            field("VIN - COGS"; "VIN - COGS")
            {
            }
            field("External Document No."; Rec."External Document No.")
            {
            }
            field("Entry No."; Rec."Entry No.")
            {
            }
            field("System-Created Entry"; Rec."System-Created Entry")
            {
                Visible = false;
            }
            field("Pre Assigned No."; "Pre Assigned No.")
            {
            }
            field("System LC No."; "System LC No.")
            {
                Visible = false;
            }
            field("Bank LC No."; "Bank LC No.")
            {
                Visible = false;
            }
            field("LC Amend No."; "LC Amend No.")
            {
                Visible = false;
            }
            field("Invertor Serial No."; "Invertor Serial No.")
            {
                Visible = false;
            }
            field("TDS Group"; "TDS Group")
            {
            }
            field("TDS%"; "TDS%")
            {
            }
            field("TDS Type"; "TDS Type")
            {
            }
            field("TDS Amount"; "TDS Amount")
            {
            }
            field("TDS Base Amount"; "TDS Base Amount")
            {
            }
            field("Import Invoice No."; "Import Invoice No.")
            {
                Visible = false;
            }
            field("Exempt Purchase No."; "Exempt Purchase No.")
            {
                Visible = false;
            }
            field("Value Entry Doc 1"; "Value Entry Doc 1")
            {
            }
            field("Cost Type"; "Cost Type")
            {
            }
            field("Value Entry Doc 2"; "Value Entry Doc 2")
            {
            }
            field("Value Entry Doc 3"; "Value Entry Doc 3")
            {
            }
            field("Value Entry Doc 4"; "Value Entry Doc 4")
            {
            }
        }
    }
    actions
    {


        //Unsupported feature: Code Modification on "ReverseTransaction(Action 63).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CLEAR(ReversalEntry);
        IF Reversed THEN
          ReversalEntry.AlreadyReversedEntry(TABLECAPTION,"Entry No.");
        IF "Journal Batch Name" = '' THEN
          ReversalEntry.TestFieldError;
        TESTFIELD("Transaction No.");
        ReversalEntry.ReverseTransaction("Transaction No.")
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        UserSetUp.GET(USERID);
        IF NOT UserSetUp."Can Reverse Journel" THEN
          ERROR('You do not have Permission to Reverse');
        #1..5

        IF "Source Code" = '' THEN     //**SM 04 10 2013 to control the reversal of TDS posted from purchase order
          ReversalEntry.TestFieldError;

        TESTFIELD("Transaction No.");
        ReversalEntry.ReverseTransaction("Transaction No.")
        */
        //end;
        addafter("Action 65")
        {
            action("Print Voucher")
            {
                Caption = 'Print Voucher';
                Image = ValueLedger;
                Promoted = true;

                trigger OnAction()
                begin
                    GLEntry.SETRANGE("Document No.", Rec."Document No.");
                    IF GLEntry.FINDFIRST THEN
                        REPORT.RUN(50029, TRUE, FALSE, GLEntry);
                end;
            }
            action("Print Cash Receipt")
            {
                Image = Receipt;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", Rec."Document No.");
                    IF GLEntry.FINDFIRST THEN
                        REPORT.RUNMODAL(33020362, TRUE, FALSE, GLEntry);
                end;
            }
            action("<Action1000000013>")
            {
                Caption = 'Debit/Credit Note';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    GLRec.SETRANGE("Posting Date", Rec."Posting Date");
                    GLRec.SETRANGE("Document No.", Rec."Document No.");
                    //GLRec.SETRANGE("Source Type","Source Type");
                    GLRec.SETRANGE("Source No.", Rec."Source No.");
                    IF GLRec.FINDFIRST THEN
                        REPORT.RUNMODAL(33020029, TRUE, FALSE, GLRec);
                end;
            }
        }
        addafter(DocsWithoutIC)
        {
            action(RUN)
            {

                trigger OnAction()
                begin
                    REPORT.RUN(25006309);
                end;
            }
            action("Update GL account no")
            {
                Visible = false;

                trigger OnAction()
                begin
                    TempCodeunit.RUN;
                end;
            }
        }
    }

    var
        Navigate: Page "344";
        [InDataSet]
        AmountVisible: Boolean;
        [InDataSet]
        "Debit AmountVisible": Boolean;
        [InDataSet]
        "Credit AmountVisible": Boolean;
        GLEntry: Record "17";
        "VIN(Item Charge Assigned)": Code[20];
        GLRec: Record "17";
        UserSetUp: Record "91";
        TempCodeunit: Codeunit "25006202";
        ItemLedgerEntries: Record "32";
        WarehouseEntryVar: Record "7312";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*

    "VIN(Item Charge Assigned)" := GetVINItemCharge(Rec);
    */
    //end;
}

