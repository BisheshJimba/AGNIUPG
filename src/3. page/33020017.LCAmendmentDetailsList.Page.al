page 33020017 "LC Amendment Details List"
{
    CardPageID = "LC Amendment Details";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Details';
    SourceTable = Table33020013;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Version No."; "Version No.")
                {
                }
                field("No."; "No.")
                {
                }
                field("LC No."; "LC No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Date of Issue"; "Date of Issue")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Expiry Date"; "Expiry Date")
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
        area(processing)
        {
            group("<Action1102159040>")
            {
                Caption = 'F&unction';
                action("<Action1102159041>")
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //Calling function in Codeunit 33020011::"Letter of Credit Management" to release the current record.
                        CU_LetterOfCredit.AmendedLCRelease(Rec);
                    end;
                }
            }
        }
        area(navigation)
        {
            group("<Action1102159023>")
            {
                Caption = 'Details';
                action("<Action1102159024>")
                {
                    Caption = '&Register';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 116;
                    RunPageMode = View;
                }
                action("<Action1102159025>")
                {
                    Caption = 'Veh&icle Tracking';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33020019;
                    RunPageLink = Version No.=FIELD(Version No.),
                                  No.=FIELD(No.);
                }
                action("&Order")
                {
                    Caption = '&Order';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 50;
                                    RunPageLink = Sys. LC No.=FIELD(No.),
                                  LC Amend No.=FIELD(Version No.);
                    RunPageMode = View;
                }
                action("&Posted Order")
                {
                    Caption = '&Posted Order';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 136;
                                    RunPageLink = Sys. LC No.=FIELD(No.),
                                  LC Amend No.=FIELD(Version No.);
                    RunPageMode = View;
                }
            }
        }
    }

    var
        CU_LetterOfCredit: Codeunit "33020011";
}

