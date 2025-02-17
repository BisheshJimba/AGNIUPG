page 33020534 "Travel Voucher Page"
{
    PageType = Card;
    SourceTable = Table33020426;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Travel Order Form No."; "Travel Order Form No.")
                {
                }
                field("Travelr's ID No."; "Travelr's ID No.")
                {
                }
                field("Traveler's Name"; "Traveler's Name")
                {
                }
                field(Designation; Designation)
                {
                    Visible = false;
                }
                field(Department; Department)
                {
                }
                field("Depature Date (AD)"; "Depature Date (AD)")
                {
                    Enabled = DatesEditable;
                }
                field("Arrival Date (AD)"; "Arrival Date (AD)")
                {
                    Enabled = DatesEditable;
                }
                field("Mode Of Transportation"; "Mode Of Transportation")
                {
                    Editable = false;
                }
                field("Travel Destination I"; "Travel Destination I")
                {
                }
                field("Travel Destination II"; "Travel Destination II")
                {
                }
                field("Travel Destination III"; "Travel Destination III")
                {
                }
                field("Days (Destination I)"; "Days (Destination I)")
                {
                    Editable = false;
                }
                field("Days (Destination II)"; "Days (Destination II)")
                {
                    Visible = false;
                }
                field("Days (Destination III)"; "Days (Destination III)")
                {
                    Visible = false;
                }
                field("TADA/Hotel Bill (I) (Nrs.)"; "TADA/Hotel Bill (I) (Nrs.)")
                {
                }
                field("TADA/Hotel Bill (II) (Nrs.)"; "TADA/Hotel Bill (II) (Nrs.)")
                {
                    Visible = false;
                }
                field("TADA/Hotel Bill (III) (Nrs.)"; "TADA/Hotel Bill (III) (Nrs.)")
                {
                    Visible = false;
                }
                field("Airport Tax (Nrs.)"; "Airport Tax (Nrs.)")
                {
                }
                field("Bus Transportation"; "Bus Transportation")
                {
                    Editable = true;
                    Enabled = BusEditable;
                }
                field("Fuel Expenses (Nrs.)"; "Fuel Expenses (Nrs.)")
                {
                }
                field("TADA Return"; "TADA Return")
                {
                }
                field("TADA II (40%) (Nrs.)"; "TADA II (40%) (Nrs.)")
                {
                    Visible = false;
                }
                field("TADA III (40%) (Nrs.)"; "TADA III (40%) (Nrs.)")
                {
                    Visible = false;
                }
                field("Bus Ticket (Nrs.)"; "Bus Ticket (Nrs.)")
                {
                }
                field("Road Tax (Nrs.)"; "Road Tax (Nrs.)")
                {
                }
                field("Train Ticket (Nrs.)"; "Train Ticket (Nrs.)")
                {
                }
                field("Air Ticket (Nrs.)"; "Air Ticket (Nrs.)")
                {
                }
                field("Guest Expenses (Nrs.)"; "Guest Expenses (Nrs.)")
                {
                }
                field("Training Expenses (Nrs.)"; "Training Expenses (Nrs.)")
                {
                }
                field("Others (Nrs.)"; "Others (Nrs.)")
                {
                }
                field("Advance Taken"; "Advance Taken")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                    Editable = false;
                }
                field("Service Provided"; "Service Provided")
                {
                }
                field("Travel Purpose"; "Travel Purpose")
                {
                    Editable = false;
                }
                field("Creation Date"; "Creation Date")
                {
                    Editable = false;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Journal Template Name"; "Journal Template Name")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("G/L Account No."; "G/L Account No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Ellipsis = true;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TESTFIELD("Journal Template Name");
                    TESTFIELD("Journal Batch Name");
                    TESTFIELD("G/L Account No.");

                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name", "Journal Template Name");
                    GenJournalLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                    IF GenJournalLine.FINDFIRST THEN BEGIN
                        ConfirmLine := DIALOG.CONFIRM('Do you want to delete the existing Line?', TRUE);
                        IF ConfirmLine THEN BEGIN
                            GenJournalLine.DELETEALL;
                        END ELSE
                            EXIT;
                    END;
                    GenJournalLine1.INIT;
                    GenJournalLine1.VALIDATE("Journal Template Name", "Journal Template Name");
                    GenJournalLine1.VALIDATE("Journal Batch Name", "Journal Batch Name");
                    GenJournalLine1."Line No." := 10000;
                    GenJournalLine1.VALIDATE("Account Type", GenJournalLine1."Account Type"::"G/L Account");
                    GenJournalLine1.VALIDATE(Amount, "Total Amount");
                    GenJournalLine1.INSERT;
                    MESSAGE('Journal Lines created');
                end;
            }
            action(Print)
            {
                Caption = 'P&rint';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TravelVoucher.RESET;
                    TravelVoucher.SETRANGE("Travel Order Form No.", "Travel Order Form No.");
                    IF TravelVoucher.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020506, TRUE, FALSE, TravelVoucher);
                    END;
                end;
            }
            action("Edit Date")
            {
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    HRSetup.GET(USERID);
                    DatesEditable := FALSE;

                    IF HRSetup."HR Admin" THEN BEGIN
                        DatesEditable := TRUE;
                    END ELSE
                        ERROR('You do not have HR Admin Permission. Please contact your system administrator.')
                end;
            }
            action("Edit Bus")
            {
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    HRSetup.GET(USERID);
                    BusEditable := FALSE;

                    IF HRSetup."HR Admin" THEN BEGIN
                        BusEditable := TRUE;
                    END ELSE
                        ERROR('You do not have HR Admin Permission. Please contact your system administrator.');
                end;
            }
        }
    }

    var
        GenJournalLine: Record "81";
        ConfirmLine: Boolean;
        GenJournalLine1: Record "81";
        TravelVoucher: Record "33020426";
        TravelVoucherReport: Report "33020506";
        [InDataSet]
        DatesEditable: Boolean;
        HRSetup: Record "33020304";
        BusEditable: Boolean;
}

