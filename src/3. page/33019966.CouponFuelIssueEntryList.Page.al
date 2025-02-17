page 33019966 "Coupon-Fuel Issue Entry List"
{
    CardPageID = "Coupon-Fuel Issue Entry Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Posting';
    RefreshOnActivate = true;
    SourceTable = Table33019963;
    SourceTableView = WHERE(Document Type=FILTER(Coupon));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("VIN (Chasis No.)";"VIN (Chasis No.)")
                {
                    Caption = 'Chasis No.';
                }
                field("Issue Type";"Issue Type")
                {
                }
                field("Movement Type";"Movement Type")
                {
                }
                field("Fuel Type";"Fuel Type")
                {
                }
                field("From City Name";"From City Name")
                {
                }
                field("To City Name";"To City Name")
                {
                }
                field("Purpose of Travel";"Purpose of Travel")
                {
                }
                field("Petrol Pump Name";"Petrol Pump Name")
                {
                }
                field("Issue Date";"Issue Date")
                {
                }
                field(Location;Location)
                {
                }
                field(Department;Department)
                {
                }
            }
        }
        area(factboxes)
        {
            part(;33019998)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
            }
            part(;33019999)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
            }
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(PostingActionGroup)
            {
                Caption = 'Posting';
                action(Post_Coupon)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        ConfirmPost: Boolean;
                        Text33019961: Label 'Do you want to post - Fuel Issue Coupon?';
                        Text33019962: Label 'Aborted by user - %1!';
                    begin
                        //Calling codeunit 33019961 to post Fuel Issue Entry without printing.
                        ConfirmPost := DIALOG.CONFIRM(Text33019961,TRUE);
                        IF ConfirmPost THEN
                          CODEUNIT.RUN(CODEUNIT::"Fuel Issue - Post",Rec)
                        ELSE
                          MESSAGE(Text33019962,USERID);
                    end;
                }
                action(Post_Print_Coupon)
                {
                    Caption = 'Post and Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        ConfirmPost: Boolean;
                        Text33019963: Label 'Do you want to post - Fuel Issue Coupon?';
                        Text33019964: Label 'Aborted by user - %1!';
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        /*
                        //Call function to check for approval. Without approval donot let post.
                        GblDocAppPostCheck.checkDocApproval(DATABASE::"Fuel Issue Entry",LclDocType::"Fuel Issue","No.",'Fuel Issue');
                        */
                        
                        //Calling codeunit 33019964 to post Fuel Issue Entry with printing.
                        ConfirmPost := DIALOG.CONFIRM(Text33019963,TRUE);
                        IF ConfirmPost THEN
                          CODEUNIT.RUN(CODEUNIT::"Fuel Issue - Post + Print",Rec)
                        ELSE
                          MESSAGE(Text33019964,USERID);

                    end;
                }
            }
            group("Function")
            {
                Caption = 'Function';
                action(SendAppReq)
                {
                    Caption = 'Send Approval Request';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Calling function to send approval request.
                        GblDocAppMngt.sendAppReqFuelIssue(DATABASE::"Fuel Issue Entry",GblDocType::"Fuel Issue","No.",GblEntryType::Coupon);
                    end;
                }
                action(CancelAppReq)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Calling function to cancel approval request.
                        GblDocAppMngt.cancelAppReqFuelIssue(DATABASE::"Fuel Issue Entry",GblDocType::"Fuel Issue","No.",GblEntryType::Coupon);
                    end;
                }
            }
        }
        area(reporting)
        {
            group("<Action1102159061>")
            {
                Caption = 'Documents';
                action(Fuel_Coupon)
                {
                    Caption = 'Coupon';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        FuelIssueEntry: Record "33019963";
                    begin
                        //Viewing report with filter of selected document.
                        FuelIssueEntry.RESET;
                        FuelIssueEntry.SETRANGE("Document Type","Document Type");
                        FuelIssueEntry.SETRANGE("No.","No.");
                        REPORT.RUN(33019961,TRUE,TRUE,FuelIssueEntry);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Setting responsibility center user wise.
        UserSetup.GET(USERID);
        IF UserSetup."Apply Rules" THEN BEGIN
          IF (UserSetup."Default Responsibility Center" <> '') THEN BEGIN
            FILTERGROUP(0);
            SETFILTER("Responsibility Center",UserSetup."Default Responsibility Center");
            FILTERGROUP(2);
          END;
        END;
    end;

    var
        UserSetup: Record "91";
        [InDataSet]
        ApprovalShowHide: Boolean;
        GblDocAppMngt: Codeunit "33019915";
        GblDocAppPostCheck: Codeunit "33019916";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;
        GblEntryType: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary;
}

