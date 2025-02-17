page 33019980 "Cheque Entries"
{
    // Name        Version         Date        Description
    // ***********************************************************
    //             CTS6.1.2        24-09-12    Page Courier Tracking Lines
    // Ravi        CNY1.0          24-09-12    Previous Page "Courier Tracking Lines" has been changed to "Check Entries"

    Editable = false;
    PageType = List;
    SourceTable = Table33019971;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Cheque No."; "Cheque No.")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field("Bank No."; "Bank No.")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Created Date"; "Created Date")
                {
                }
                field("Payee Name"; "Payee Name")
                {
                }
                field("Cheque Type"; "Cheque Type")
                {
                }
                field("Cheque Amount"; "Cheque Amount")
                {
                }
                field("Signatory (Group A)"; "Signatory (Group A)")
                {
                }
                field("Signatory (Group B)"; "Signatory (Group B)")
                {
                }
                field(Assigned; Assigned)
                {
                }
                field(Posted; Posted)
                {
                }
                field(Void; Void)
                {
                }
                field("Void Description"; "Void Description")
                {
                }
                field("Bundle No."; "Bundle No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("<Action1000000004>")
            {
                Caption = 'Update Signatory Group';

                trigger OnAction()
                begin
                    UpdateSignatoryGroup.GetEntryNo("Entry No.");
                    UpdateSignatoryGroup.RUN;
                end;
            }
            action("Void Cheque")
            {
                Ellipsis = true;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    OK: Boolean;
                begin
                    OK := CONFIRM('Are you sure you want to void this cheque?');

                    IF OK THEN BEGIN
                        Rec.Void := TRUE;
                        Rec.MODIFY;
                    END;
                end;
            }
        }
    }

    var
        UserSetup_G: Record "91";
        SignataryA: Text[30];
        SignataryB: Text[30];
        UpdateSignatoryGroup: Report "50052";
}

