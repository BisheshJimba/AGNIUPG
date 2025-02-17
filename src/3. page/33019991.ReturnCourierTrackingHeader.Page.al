page 33019991 "Return Courier Tracking Header"
{
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Posting,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019987;
    SourceTableView = ORDER(Ascending)
                      WHERE(Document Type=CONST(Return));

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
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Applies To Entry"; "Applies To Entry")
                {
                }
                field("Transfer From Code"; "Transfer From Code")
                {
                }
                field("Transfer To Code"; "Transfer To Code")
                {
                }
                field("Transfer From Department"; "Transfer From Department")
                {
                }
                field("Transfer To Department"; "Transfer To Department")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Returned Date"; "Returned Date")
                {
                }
                field(Status; Status)
                {
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                }
            }
            part(Lines; 33019992)
            {
                Caption = 'Lines';
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(No.);
            }
            group("Transfer From")
            {
                field("Transfer From Name";"Transfer From Name")
                {
                }
                field("Transfer From Address";"Transfer From Address")
                {
                }
                field("Transfer From Address 2";"Transfer From Address 2")
                {
                }
                field("Transfer From Post Code";"Transfer From Post Code")
                {
                }
                field("Transfer From City";"Transfer From City")
                {
                }
                field("Transfer From Contact";"Transfer From Contact")
                {
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                }
                field("Shipment Date";"Shipment Date")
                {
                }
                field("Shipping Time";"Shipping Time")
                {
                }
            }
            group("Transfer To")
            {
                field("Transfer To Name";"Transfer To Name")
                {
                }
                field("Transfer To Address";"Transfer To Address")
                {
                }
                field("Transfer To Address 2";"Transfer To Address 2")
                {
                }
                field("Transfer To Post Code";"Transfer To Post Code")
                {
                }
                field("Transfer To City";"Transfer To City")
                {
                }
                field("Transfer To Contact";"Transfer To Contact")
                {
                }
                field("Receipt Date";"Receipt Date")
                {
                }
            }
            group(Shipping)
            {
                field("Transaction Type";"Transaction Type")
                {
                }
                field("Transport Method";"Transport Method")
                {
                }
                field("CT No.";"CT No.")
                {
                }
                field(Insurance;Insurance)
                {
                }
            }
        }
        area(factboxes)
        {
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
                action(Post_Return)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        ConfirmPost: Boolean;
                        Text33019961: Label 'Do you want to post?';
                        Text33019962: Label 'Aborted by User - %1!';
                    begin
                        //Calling codeunit 33019965 to post Courier Tracking without printing.
                        ConfirmPost := DIALOG.CONFIRM(Text33019961,TRUE);
                        IF ConfirmPost THEN
                          CODEUNIT.RUN(CODEUNIT::"Courier Tracking - Post",Rec)
                        ELSE
                          MESSAGE(Text33019962,USERID);
                    end;
                }
                action(Post_Print_Return)
                {
                    Caption = 'Post and Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        ConfirmPost: Boolean;
                        Text33019963: Label 'Do you want to post?';
                        Text33019964: Label 'Aborted by User - %1!';
                    begin
                        //Calling codeunit 33019969 to post Courier Tracking without printing.
                        ConfirmPost := DIALOG.CONFIRM(Text33019963,TRUE);
                        IF ConfirmPost THEN
                          CODEUNIT.RUN(CODEUNIT::"Courier Track. - Post + Print",Rec)
                        ELSE
                          MESSAGE(Text33019964,USERID);
                    end;
                }
            }
        }
        area(reporting)
        {
            group(Documents)
            {
                Caption = 'Documents';
                action(Print_Document)
                {
                    Caption = 'Print Document';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        LocalCourTrackHdr: Record "33019987";
                    begin
                        //Setting filter and viewing report.
                        LocalCourTrackHdr.RESET;
                        LocalCourTrackHdr.SETRANGE("Document Type","Document Type");
                        LocalCourTrackHdr.SETRANGE("No.","No.");
                        REPORT.RUN(33019976,TRUE,TRUE,LocalCourTrackHdr);
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
}

