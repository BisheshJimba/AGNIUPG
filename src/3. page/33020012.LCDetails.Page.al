page 33020012 "LC Details"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Details';
    SourceTable = Table33020012;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("LC\DO No."; "LC\DO No.")
                {
                    Caption = 'LC\DO\TDR No.';
                    Importance = Promoted;
                }
                field(Description; Description)
                {
                }
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Issued To/Received From"; "Issued To/Received From")
                {
                    Importance = Promoted;
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
                field("Type of LC"; "Type of LC")
                {

                    trigger OnValidate()
                    begin
                        IF "Type of LC" = "Type of LC"::Inland THEN
                            NotEditCurrExch := FALSE
                        ELSE
                            NotEditCurrExch := TRUE;
                    end;
                }
                field("Currency Code"; "Currency Code")
                {
                    Editable = NotEditCurrExch;
                }
                field("Exchange Rate"; "Exchange Rate")
                {
                    Editable = NotEditCurrExch;
                }
                field("Has Amendment"; "Has Amendment")
                {
                    Editable = false;
                }
                field("BG Type"; "BG Type")
                {
                }
                field(Units; Units)
                {
                }
                field(Location; Location)
                {
                    Caption = 'Dispatch/Receiving Location';
                }
                field("Insured By"; "Insured By")
                {
                }
                field(Incoterms; Incoterms)
                {
                    OptionCaption = '  ,C&F,CIF,CIP,EX-WORKS,FOB,CFR,C&I,CNI,CPT';
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Dealer Tenant ID"; "Dealer Tenant ID")
                {
                    Importance = Additional;
                }
                field(Type; Type)
                {
                }
            }
            group(Invoicing)
            {
                field("LC\BG Value"; "LC\BG Value")
                {
                }
                field("LC Value (LCY)"; "LC Value (LCY)")
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
                field("Purchase LC Utilised"; "Purchase LC Utilised")
                {
                    Description = '<Vendors used (V0009|V01088|V01112|V01201|V01247|V0210|V0211|V0235|V0344|V0347|V0411|V0481|V0482|V0497|V0507|V0509|V0927|LCV-00001|)>';
                }
                field("Sales LC/BG Utilised"; "Sales LC/BG Utilised")
                {
                }
                field("Sales BG Utilised"; "Sales BG Utilised")
                {
                }
                field("Remaining BG Value"; "Remaining BG Value")
                {
                }
                field("Amended Value"; "Amended Value")
                {
                }
            }
            group("Remarks ")
            {
                Caption = 'Remarks';
                field(Remarks; Remarks)
                {
                }
                field(Notes; Notes)
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
            group("LC Details")
            {
                Caption = 'LC Details';
                action("<Action1000000000>")
                {
                    Caption = '&LC Allotment';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33020026;
                    RunPageLink = LC Code=FIELD(No.);
                }
                action(Page_LCRegister)
                {
                    Caption = '&Register';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 116;
                                    RunPageMode = View;
                }
                action(Page_LCTerm)
                {
                    Caption = '&Terms';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                }
                action(Page_Amend)
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
                action(Page_VehTrack)
                {
                    Caption = 'Veh&icle Tracking';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33020018;
                                    RunPageLink = No.=FIELD(No.);
                }
                action(Page_LCOrder)
                {
                    Caption = '&Order';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 50;
                                    RunPageLink = Sys. LC No.=FIELD(No.);
                    RunPageMode = View;
                }
                action(Page_LCPOrder)
                {
                    Caption = '&Posted Order';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 136;
                                    RunPageLink = Sys. LC No.=FIELD(No.);
                    RunPageMode = View;
                }
                action("&Value Entries")
                {
                    Caption = '&Value Entries';
                    Image = ValueLedger;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33020027;
                                    RunPageLink = LC Code=FIELD(No.);
                }
                action("<Action41>")
                {
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 20;
                                    RunPageLink = System LC No.=FIELD(No.);
                    RunPageView = SORTING(System LC No.)
                                  ORDER(Ascending);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group(Function)
            {
                Caption = 'Function';
                action(Fun_LCRelease)
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //Calling function in Codeunit 33020011::"Letter of Credit Management" to release the current record.
                        TESTFIELD("Issuing Bank");
                        TESTFIELD("LC\BG Value");
                        CU_LetterOfCredit.ReleaseLC(Rec);
                    end;
                }
                action(Fun_LCAmendment)
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
                action(Fun_LCClose)
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
                action(Reopen)
                {

                    trigger OnAction()
                    begin
                        //Calling function in Codeunit 33020011::"Letter of Credit Management" to reopen the current record.
                        CU_LetterOfCredit.ReopenLC(Rec);
                    end;
                }
                separator()
                {
                }
                action(Fun_OpenLCJrnl)
                {
                    Caption = 'Open &Journal';
                    Image = OpenJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        PAGE.RUN(33020021);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("<Action1102159023>")
            {
                Caption = 'Pending';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    LCDetails: Record "33020012";
                begin
                    //Run report with filter.
                    LCDetails.RESET;
                    LCDetails.SETRANGE("No.","No.");
                    REPORT.RUN(33020011,TRUE,TRUE,LCDetails);
                end;
            }
            action("<Action1102159022>")
            {
                Caption = 'Amendments Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    LCDetails: Record "33020012";
                begin
                    //Run report with filter.
                    LCDetails.RESET;
                    LCDetails.SETRANGE("No.","No.");
                    REPORT.RUN(33020012,TRUE,TRUE,LCDetails);
                end;
            }
            action("<Action1000000004>")
            {
                Caption = 'Marine Cargo Insurance Memo';

                trigger OnAction()
                begin
                    //Run report with filter.
                    LCDetails.RESET;
                    LCDetails.SETRANGE("No.","No.");
                    REPORT.RUN(33020019,TRUE,TRUE,LCDetails);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Calculating Utilized and Remaining value for the LC.
        CALCFIELDS("Sales BG Utilised");
        LCDetailVehTrack.RESET;
        LCDetailVehTrack.SETRANGE("No.","No.");
        IF LCDetailVehTrack.FIND('-') THEN BEGIN
          //LCDetailVehTrack.CALCFIELDS("No. of Vehicle Received");
          IF (LCDetailVehTrack."No. of Vehicle Received" <> 0) THEN
            "Utilized Value" := (LCDetailVehTrack."Unit Price"/LCDetailVehTrack."No. of Vehicle Received") - "Sales BG Utilised";
          "Remaining Value" := "LC\BG Value" - "Utilized Value";
        END;

        IF "Type of LC" = "Type of LC"::Inland THEN
          NotEditCurrExch := FALSE
        ELSE
          NotEditCurrExch := TRUE;

        CALCFIELDS("Purchase LC Utilised");
        "Remaining BG Value" := "LC\BG Value" - "Sales BG Utilised"; //ratan 10/18/2020
    end;

    var
        CU_LetterOfCredit: Codeunit "33020011";
        LCDetails: Record "33020012";
        LCDetailVehTrack: Record "33020016";
        [InDataSet]
        NotEditCurrExch: Boolean;
}

