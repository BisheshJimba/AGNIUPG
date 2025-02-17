page 33020179 "Ins. Memo Card - PCD"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Document';
    SourceTable = Table33020165;
    SourceTableView = WHERE(Vehicle Division=CONST(CVD),
                            Posted=CONST(No));

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
                            CurrPage.UPDATE;
                    end;
                }
                field("Ins. Company Code"; "Ins. Company Code")
                {
                }
                field("Ins. Company Name"; "Ins. Company Name")
                {
                }
                field("Memo Date"; "Memo Date")
                {
                }
                field("Memo Date (BS)"; "Memo Date (BS)")
                {
                }
                field(Type; Type)
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
            part(; 33020174)
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
        area(creation)
        {
            group(Documents)
            {
                Caption = 'Document(s)';
                action(PrintIncDoc)
                {
                    Caption = '&Print';
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

                    trigger OnAction()
                    var
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        //Call function to send approval request.
                        GblDocAppMngt.sendAppReqVehInsurance(DATABASE::"Ins. Memo Header", GblDocType::"Vehicle Insurance", "Reference No.",
                        GblEntryType::PCD);
                    end;
                }
                action(Cancel_AppReq)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

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
        GblDocAppMngt: Codeunit "33019915";
        GblDocAppPostCheck: Codeunit "33019916";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;
        GblEntryType: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary;
}

