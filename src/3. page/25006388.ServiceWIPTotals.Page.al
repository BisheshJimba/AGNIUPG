page 25006388 "Service WIP Totals"
{
    PageType = List;
    SourceTable = Table25006196;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Service Order No."; "Service Order No.")
                {
                }
                field("Posted Cost Adjustment"; "Posted Cost Adjustment")
                {
                }
                field("Posted Sales Adjustment"; "Posted Sales Adjustment")
                {
                }
                field(Reversed; Reversed)
                {
                }
                field("Reverse Posting Date"; "Reverse Posting Date")
                {
                }
                field(Consolidated; Consolidated)
                {
                }
                field("Item C. Amt. (Posted)"; "Item C. Amt. (Posted)")
                {
                }
                field("Item S. Amt. (Posted)"; "Item S. Amt. (Posted)")
                {
                }
                field("Labor C. Amt. (Posted)"; "Labor C. Amt. (Posted)")
                {
                }
                field("Labor S. Amt. (Posted)"; "Labor S. Amt. (Posted)")
                {
                }
                field("Ext.S. C. Amt. (Posted)"; "Ext.S. C. Amt. (Posted)")
                {
                }
                field("Ext.S. S. Amt. (Posted)"; "Ext.S. S. Amt. (Posted)")
                {
                }
                field("Cost Amt. (Posted)"; "Cost Amt. (Posted)")
                {
                }
                field("Sales Amt. (Posted)"; "Sales Amt. (Posted)")
                {
                }
                field("WIP Totals"; "WIP Totals")
                {
                }
                field("Reverse Document No."; "Reverse Document No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group()
            {
                action("Reverse WIP G/L Entries")
                {
                    Caption = 'Reverse WIP G/L Entries';

                    trigger OnAction()
                    var
                        PostReversWIP: Report "25006319";
                        ServiceWIPTotals: Record "25006196";
                    begin
                        ServiceWIPTotals.RESET;
                        IF Rec.GETFILTERS <> '' THEN
                            ServiceWIPTotals.COPYFILTERS(Rec)
                        ELSE
                            ServiceWIPTotals.SETRANGE("Document No.", Rec."Document No.");
                        PostReversWIP.SETTABLEVIEW(ServiceWIPTotals);
                        PostReversWIP.RUNMODAL;
                    end;
                }
            }
        }
        area(navigation)
        {
            group()
            {
                action("Show G/L Entries")
                {
                    Caption = 'Show G/L Entries';

                    trigger OnAction()
                    var
                        GLEntries: Record "17";
                        GLEntriesPage: Page "20";
                        SourceCodeSetup: Record "242";
                    begin
                        SourceCodeSetup.GET;
                        GLEntries.RESET;
                        GLEntries.SETFILTER("Document No.", '%1|%2', Rec."Document No.", Rec."Reverse Document No.");
                        GLEntries.SETRANGE("Source Code", SourceCodeSetup."Service G/L WIP EDMS");
                        GLEntriesPage.SETTABLEVIEW(GLEntries);
                        GLEntriesPage.RUNMODAL;
                    end;
                }
                action("Show WIP Entries")
                {
                    Caption = 'Show WIP Entries';
                    RunObject = Page 25006385;
                    RunPageLink = Document No.=FIELD(Document No.);

                    trigger OnAction()
                    var
                        WIPEntries: Page "25006385";
                    begin
                    end;
                }
                action("Show Posted WIP Service Lines")
                {
                    Caption = 'Show Posted WIP Service Lines';
                    RunObject = Page 25006294;
                                    RunPageLink = Shipment Date=FIELD(Document No.);
                }
            }
        }
    }
}

