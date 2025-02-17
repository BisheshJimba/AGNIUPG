page 33020163 "CC Memo Card"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Document';
    SourceTable = Table33020163;
    SourceTableView = ORDER(Ascending)
                      WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Reference No."; "Reference No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field("From Dept. Code"; "From Dept. Code")
                {
                }
                field("From Dept. Name"; "From Dept. Name")
                {
                }
                field("To Dept. Code"; "To Dept. Code")
                {
                }
                field("To Dept. Name"; "To Dept. Name")
                {
                }
                field("Memo Date"; "Memo Date")
                {
                }
                field("Memo Date (BS)"; "Memo Date (BS)")
                {
                }
            }
            part(; 33020164)
            {
                SubPageLink = Reference No.=FIELD(Reference No.);
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
            group("<Action1102159022>")
            {
                Caption = 'Document';
                action(Print_CCMemo)
                {
                    Caption = '&Print Memo';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        LclCCMemo: Record "33020163";
                        LclVTMngt: Codeunit "33020163";
                        LclHasValue: Boolean;
                        Text33020163: Label 'Sorry, you cannot print this document without entering Insurance Memo No. on lines. \ Or contact your system administrator for further assistance.';
                    begin
                        //Checking insurance memo no. on lines and printing document. If system donot find insurance memo no. on CC Memo Line for supplied
                        //CC Memo No. then it returns false. Then user cannot print the document.
                        LclHasValue := LclVTMngt.checkInsMemoNoCC("Reference No.");

                        //Not Required Insurance.
                        //IF LclHasValue THEN BEGIN
                        //Setting filter and printing CC Memo.
                        LclCCMemo.RESET;
                        LclCCMemo.SETRANGE("Reference No.", "Reference No.");
                        REPORT.RUN(33020163, TRUE, TRUE, LclCCMemo);
                        //END ELSE
                        //ERROR(Text33020163);
                    end;
                }
                action(Print_Memo_InsDept)
                {
                    Caption = 'Print Memo - Ins. Dept.';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        LclCCMemo: Record "33020163";
                    begin
                        //Setting filter and printing CC Memo.
                        LclCCMemo.RESET;
                        LclCCMemo.SETRANGE("Reference No.", "Reference No.");
                        REPORT.RUN(33020169, TRUE, TRUE, LclCCMemo);
                    end;
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Function';
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        //Call function to check for approval. Without approval donot let post.
                        GblDocAppPostCheck.checkDocApproval(DATABASE::"CC Memo Header", LclDocType::"Vehicle Custom Clearance", "Reference No.",
                        'Custom Clearance');

                        //Calling function in codeunit to post CC Memo.
                        GblVehTranPostDoc.postCCMemo(Rec);
                    end;
                }
                separator()
                {
                }
                action(Send_AppReq)
                {
                    Caption = 'Send Approval Request';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        //Calling function to send approval request of Custom Clearance Memo.
                        GblDocAppMngt.sendAppReqVehCC(DATABASE::"CC Memo Header", GblDocType::"Vehicle Custom Clearance", "Reference No.", GblEntryType::CVD)
                        ;
                    end;
                }
                action(Cancel_AppReq)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        //Calling function to cancel approval request.
                        GblDocAppMngt.cancelAppReqVehCC(DATABASE::"CC Memo Header", GblDocType::"Vehicle Custom Clearance", "Reference No.");
                    end;
                }
                separator()
                {
                }
                action(Send_InsReq)
                {
                    Caption = 'Send Insurance Request';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        MESSAGE('Send Insurance request!');
                    end;
                }
            }
        }
    }

    var
        GblVehTranPostDoc: Codeunit "33020164";
        GblDocAppMngt: Codeunit "33019915";
        GblDocAppPostCheck: Codeunit "33019916";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;
        GblEntryType: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary;
}

