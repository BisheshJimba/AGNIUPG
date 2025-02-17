page 33019899 "Issued Exide Claim Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Print';
    RefreshOnActivate = true;
    SourceTable = Table33019886;

    layout
    {
        area(content)
        {
            group("Job Info.")
            {
                field("Job Card No."; "Job Card No.")
                {
                }
                field("Claim No."; "Claim No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Claim Date"; "Claim Date")
                {
                }
                field("Job Date"; "Job Date")
                {
                }
                field("No. of Months"; "No. of Months")
                {
                    Editable = false;
                }
                field("Issue No."; "Issue No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit1() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Sales Order No."; "Sales Order No.")
                {
                    Editable = false;
                }
            }
            group("Battery Info.")
            {
                field("Battery Part No."; "Battery Part No.")
                {
                    Editable = false;
                }
                field("Battery Description"; "Battery Description")
                {
                    Editable = false;
                }
                field("Vehicle Type"; "Vehicle Type")
                {
                    Editable = false;
                }
                field("Qty."; "Qty.")
                {
                }
                field("Scrap No."; "Scrap No.")
                {
                }
                field("Scrap Amount"; "Scrap Amount")
                {
                }
                field("NDP Rate"; "NDP Rate")
                {
                    Editable = false;
                }
                field("Claim Amount"; "Claim Amount")
                {
                    Editable = false;
                }
                field("Additional Amount"; "Additional Amount")
                {
                    Editable = false;
                }
                field("Total Claim Amount"; "Total Claim Amount")
                {
                    Editable = false;
                }
            }
            group("Issued Info.")
            {
                field("Issue Part No."; "Issue Part No.")
                {

                    trigger OnValidate()
                    begin
                        /*
                        IF "Issue Part No." = '' THEN
                          MakeIssue := FALSE
                        ELSE
                          MakeIssue := TRUE;
                        */

                    end;
                }
                field("Issue Part Description"; "Issue Part Description")
                {
                    Editable = false;
                }
                field("Issued Serial No."; "Issued Serial No.")
                {
                    Caption = 'Replace Battery Serial No.';
                }
                field("Issued MFG"; "Issued MFG")
                {
                    Caption = 'Replace Battey MFG';
                }
                field("Issue Qty."; "Issue Qty.")
                {
                }
                field("Sales Rate"; "Sales Rate")
                {
                    Editable = false;
                }
                field(Total; Total)
                {
                    Editable = false;
                }
                field("Pro-Rata %"; "Pro-Rata %")
                {
                }
            }
            group("Claimed Acceptance")
            {
                field("Claim Status"; "Claim Status")
                {
                    Caption = 'Claim';
                }
                field("Exide Claim Date"; "Exide Claim Date")
                {
                }
                field("Exide Credit Date"; "Exide Credit Date")
                {
                }
            }
            group(Others)
            {
                field("Credit Amount"; "Credit Amount")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102159040>")
            {
                Caption = 'Print';
                action("<Action1102159041>")
                {
                    Caption = 'Exide Claim Card';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'F10';

                    trigger OnAction()
                    var
                        text33019886: Label 'Aborted By User - %1 !';
                        text33019885: Label 'Are you sure to Issue ?';
                        ConfirmPost: Boolean;
                    begin
                        //MEssage('err');
                        // to print Exide claim card
                        ExideClaim.SETRANGE("Job Card No.", "Job Card No.");
                        IF ExideClaim.FINDFIRST THEN
                            REPORT.RUNMODAL(33019890, TRUE, FALSE, ExideClaim);
                    end;
                }
            }
        }
        area(processing)
        {
            group("<Action1000000003>")
            {
                Caption = 'Posting';
                action("<Action1000000004>")
                {
                    Caption = 'Post';
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = New;

                    trigger OnAction()
                    begin
                        //msg('123');
                        PostedBatteryHeader.SETRANGE("Job Card No.", "Job Card No.");
                        IF PostedBatteryHeader.FIND('-') THEN BEGIN
                            PostedBatteryHeader."Rep. Batt. Serial" := "Issued Serial No.";
                            PostedBatteryHeader."Rep. Batt. MFG" := "Issued MFG";
                            PostedBatteryHeader.MODIFY;
                            IF PostedBatteryHeader.MODIFY THEN
                                MESSAGE(text0003)
                            ELSE
                                MESSAGE(text0004);

                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
        IF "Issue Part No." = '' THEN
            MakeIssue := FALSE
        ELSE
            MakeIssue := TRUE;
        */

    end;

    trigger OnModifyRecord(): Boolean
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Battery-Can Edit Pages" THEN
            ERROR(text0002);
    end;

    var
        [InDataSet]
        MakeIssue: Boolean;
        SerMgtSetup: Record "5911";
        NoSeriesMgmt: Codeunit "396";
        ExideClaim: Record "33019886";
        NoSeriesLine: Record "309";
        text0001: Label 'Issue Part No. Should Not Be Empty.';
        UserSetup: Record "91";
        text0002: Label 'You do not have permission to edit this page.';
        PostedBatteryHeader: Record "33019894";
        text0003: Label 'Changes made successfully!';
        text0004: Label 'Nothing is done!';
}

