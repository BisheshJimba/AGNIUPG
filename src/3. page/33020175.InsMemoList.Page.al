page 33020175 "Ins. Memo List -"
{
    CardPageID = "Ins. Memo Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Document';
    RefreshOnActivate = true;
    SourceTable = Table33020165;
    SourceTableView = WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vehicle Division"; "Vehicle Division")
                {
                    Visible = false;
                }
                field("Memo Date (BS)"; "Memo Date (BS)")
                {
                }
                field("Reference No."; "Reference No.")
                {
                }
                field("Memo Date"; "Memo Date")
                {
                }
                field("Ins. Company Code"; "Ins. Company Code")
                {
                }
                field("Ins. Company Name"; "Ins. Company Name")
                {
                }
                field(Type; Type)
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
        area(creation)
        {
            group(Documents)
            {
                Caption = 'Document(s)';
                action(PrintIncDoc)
                {
                    Caption = '&Comprehensive Ins. Memo';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        LclInsMemo: Record "33020165";
                    begin
                        //Setting filter and previewing report.
                        LclInsMemo.RESET;
                        LclInsMemo.SETRANGE("Reference No.", "Reference No.");
                        REPORT.RUN(33020164, TRUE, TRUE, LclInsMemo);
                    end;
                }
            }
            action("   &Marine Cargo Insurance Memo")
            {
                Caption = '   &Marine Cargo Insurance Memo';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Report 33020018;

                trigger OnAction()
                begin
                    REPORT.RUN(33020018);
                end;
            }
        }
        area(processing)
        {
            group("Function")
            {
                Caption = 'Function(s)';
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
                        LclVehTranPostDoc: Codeunit "33020164";
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        //Call function to check for approval. Without approval donot let post.
                        GblDocAppPostCheck.checkDocApproval(DATABASE::"Ins. Memo Header", LclDocType::"Vehicle Insurance", "Reference No.", 'Insurance');

                        //Calling function Codeunit::"Vehicle Transfer Post Doc" - PostInsMemo.
                        LclVehTranPostDoc.postInsMemo(Rec);
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
                        //Call function to send approval request.
                        GblDocAppMngt.sendAppReqVehInsurance(DATABASE::"Ins. Memo Header", GblDocType::"Vehicle Insurance", "Reference No.",
                        GblEntryType::CVD);
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
                        //Call function to cancel approval request.
                        GblDocAppMngt.cancelAppReqVehIns(DATABASE::"Ins. Memo Header", GblDocType::"Vehicle Insurance", "Reference No.");
                    end;
                }
            }
        }
    }

    var
        GblDocAppPostCheck: Codeunit "33019916";
        GblDocAppMngt: Codeunit "33019915";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;
        GblEntryType: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary;
}

