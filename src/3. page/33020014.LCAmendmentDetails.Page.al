page 33020014 "LC Amendment Details"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Details';
    SourceTable = Table33020013;

    layout
    {
        area(content)
        {
            group(General)
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
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Issued To/Received From"; "Issued To/Received From")
                {
                }
                field("Issued To/Received From Name"; "Issued To/Received From Name")
                {
                }
                field("Issuing Bank"; "Issuing Bank")
                {
                }
                field("Issue Bank Name1"; "Issue Bank Name1")
                {
                }
                field("Issue Bank Name2"; "Issue Bank Name2")
                {
                }
                field("Receiving Bank"; "Receiving Bank")
                {
                }
                field("Receiving Bank Name"; "Receiving Bank Name")
                {
                }
                field("Tolerance Percentage"; "Tolerance Percentage")
                {
                }
                field("Vehicle Division"; "Vehicle Division")
                {
                }
                field("Vehicle Category"; "Vehicle Category")
                {
                }
                field(Released; Released)
                {
                }
                field(Closed; Closed)
                {
                }
                field("Date of Issue"; "Date of Issue")
                {
                }
                field("Expiry Date"; "Expiry Date")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("<Bank Amend No.>"; "Bank Amended No.")
                {
                    Caption = 'Bank Amend No.';
                }
                field("Bank Amended Refresh No."; "Bank Amended Refresh No.")
                {
                }
                field("Type of LC"; "Type of LC")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Exchange Rate"; "Exchange Rate")
                {
                }
            }
            group(Invoicing)
            {
                field("LC Value"; "LC Value")
                {
                }
                field("LC Value (LCY)"; "LC Value (LCY)")
                {
                }
                field("Amended Value"; "Amended Value")
                {
                }
                field("Previous LC Value"; "Previous LC Value")
                {
                }
                field("Utilized Value"; "Utilized Value")
                {
                    Visible = false;
                }
                field("Remaining Value"; "Remaining Value")
                {
                    Visible = false;
                }
            }
            part(Clause; 33020022)
            {
                SubPageLink = LC No.=FIELD(No.),
                              Amend No.=FIELD(Version No.);
            }
            group("Remarks ")
            {
                Caption = 'Remarks';
                field(Remarks;Remarks)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(;Notes)
            {
            }
            systempart(;MyNotes)
            {
            }
            systempart(;Links)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102159048>")
            {
                Caption = 'Details';
                action("<Action1102159049>")
                {
                    Caption = 'Veh&icle Tracking';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33020019;
                                    RunPageLink = Version No.=FIELD(Version No.),
                                  No.=FIELD(No.);
                }
                action("<Action1102159050>")
                {
                    Caption = '&Register';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 116;
                                    RunPageMode = View;
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
                action("<Action1102159052>")
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
        area(processing)
        {
            group("F&unction")
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
                action("<Action1102159047>")
                {
                    Caption = '&Close';
                }
                separator()
                {
                }
                action("<Action1102159043>")
                {
                    Caption = 'Open &Journal';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Process;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Calculating Utilized and Remaining value for the LC.
        LCAmendlVehTrack.RESET;
        LCAmendlVehTrack.SETRANGE("Version No.","Version No.");
        LCAmendlVehTrack.SETRANGE("No.","No.");
        IF LCAmendlVehTrack.FIND('-') THEN BEGIN
          LCAmendlVehTrack.CALCFIELDS("No. of Vehicle Received");
          IF (LCAmendlVehTrack."No. of Vehicle Received" <> 0) THEN
            "Utilized Value" := (LCAmendlVehTrack."Unit Price"/LCAmendlVehTrack."No. of Vehicle Received");
          "Remaining Value" := "LC Value" - "Utilized Value";
        END;
    end;

    var
        CU_LetterOfCredit: Codeunit "33020011";
        LCAmendlVehTrack: Record "33020017";
}

