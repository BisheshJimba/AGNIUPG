page 33020013 "LC Details List"
{
    CardPageID = "LC Details";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Details';
    SourceTable = Table33020012;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("LC\DO No."; "LC\DO No.")
                {
                    Caption = 'LC\DO\TDR No.';
                }
                field("Issued To/Received From"; "Issued To/Received From")
                {
                }
                field("Issued To/Received From Name"; "Issued To/Received From Name")
                {
                }
                field(Units; Units)
                {
                }
                field("LC\BG Value"; "LC\BG Value")
                {
                }
                field("Date of Issue"; "Date of Issue")
                {
                }
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Type of LC"; "Type of LC")
                {
                }
                field("Expiry Date"; "Expiry Date")
                {
                }
                field(Closed; Closed)
                {
                }
                field(Released; Released)
                {
                }
                field("Sales LC/BG Utilised"; "Sales LC/BG Utilised")
                {
                }
                field("Purchase LC Utilised"; "Purchase LC Utilised")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; MyNotes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102159035>")
            {
                Caption = 'Details';
                action("&LC Allotment")
                {
                    Caption = '&LC Allotment';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33020026;
                    RunPageLink = LC Code=FIELD(No.);

                    trigger OnAction()
                    begin
                        //
                    end;
                }
                action("<Action1000000003>")
                {
                    Caption = '&Value Entries';
                    Image = ValueLedger;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33020027;
                                    RunPageLink = LC Code=FIELD(No.);
                }
                action("<Action1102159036>")
                {
                    Caption = '&Register';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 116;
                                    RunPageMode = View;
                }
                action("<Action1102159037>")
                {
                    Caption = '&Terms';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                }
                action("<Action1102159038>")
                {
                    Caption = 'A&mendments';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        LCAmendDetail: Record "33020013";
                    begin
                        //Opening the LC page.
                        LCAmendDetail.RESET;
                        LCAmendDetail.SETRANGE("No.","No.");
                        PAGE.RUN(33020017,LCAmendDetail);
                    end;
                }
                action("<Action1102159036 >")
                {
                    Caption = 'Veh&icle Tracking';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33020018;
                                    RunPageLink = No.=FIELD(No.);
                    RunPageMode = View;
                    Visible = false;
                }
                action("<Action1102159039>")
                {
                    Caption = '&Order';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 50;
                                    RunPageLink = Sys. LC No.=FIELD(No.);
                    RunPageMode = View;
                }
                action("<Action1102159040>")
                {
                    Caption = '&Posted Order';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 136;
                                    RunPageLink = Sys. LC No.=FIELD(No.);
                    RunPageMode = View;
                }
            }
        }
        area(processing)
        {
            group("<Action1102159042>")
            {
                Caption = 'Function';
                action("<Action1102159043>")
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //Calling function in Codeunit 33020011::"Letter of Credit Management" to release the current record.
                        CU_LetterOfCredit.ReleaseLC(Rec);
                    end;
                }
                action("<Action1102159044>")
                {
                    Caption = '&Amendemts';
                    Image = AdjustEntries;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //Calling function in Codeunit 33020011::"Letter of Credit Management" to amend the current record.
                        CU_LetterOfCredit.AmendLC(Rec);
                    end;
                }
                action("<Action1102159045>")
                {
                    Caption = '&Close';
                    Image = ClosePeriod;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //Calling function in Codeunit 33020011::"Letter of Credit Management" to close the current record.
                        CU_LetterOfCredit.CloseLC(Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("<Action1102159035 >")
            {
                Caption = 'Pending';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    LCDetail: Record "33020012";
                begin
                    //Run report with filter.
                    LCDetail.RESET;
                    LCDetail.SETRANGE("No.","No.");
                    REPORT.RUN(33020011,TRUE,TRUE,LCDetail);
                end;
            }
            action("Amendment Details")
            {
                Caption = 'Amendment Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    LCDetail: Record "33020012";
                begin
                    //Run report with filter.
                    LCDetail.RESET;
                    LCDetail.SETRANGE("No.","No.");
                    REPORT.RUN(33020012,TRUE,TRUE,LCDetail);
                end;
            }
        }
    }

    var
        CU_LetterOfCredit: Codeunit "33020011";
}

