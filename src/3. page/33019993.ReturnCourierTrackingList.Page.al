page 33019993 "Return Courier Tracking List"
{
    CardPageID = "Return Courier Tracking Header";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Posting,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019987;
    SourceTableView = ORDER(Ascending)
                      WHERE(Document Type=CONST(Return));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Transfer From Code"; "Transfer From Code")
                {
                }
                field("Transfer To Department"; "Transfer To Department")
                {
                }
                field(Status; Status)
                {
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                }
                field("Transfer To City"; "Transfer To City")
                {
                }
                field("Transfer To Contact"; "Transfer To Contact")
                {
                }
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Transport Method"; "Transport Method")
                {
                }
                field("CT No."; "CT No.")
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
        area(processing)
        {
            action(Import_ShipDetails)
            {
                Caption = 'Import Shipment Details';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report 33019975;
            }
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
                        ConfirmPost := DIALOG.CONFIRM(Text33019961, TRUE);
                        IF ConfirmPost THEN
                            CODEUNIT.RUN(CODEUNIT::"Courier Tracking - Post", Rec)
                        ELSE
                            MESSAGE(Text33019962, USERID);
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
                        ConfirmPost := DIALOG.CONFIRM(Text33019963, TRUE);
                        IF ConfirmPost THEN
                            CODEUNIT.RUN(CODEUNIT::"Courier Track. - Post + Print", Rec)
                        ELSE
                            MESSAGE(Text33019964, USERID);
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
                        LocalCourTrackHdr.SETRANGE("Document Type", "Document Type");
                        LocalCourTrackHdr.SETRANGE("No.", "No.");
                        REPORT.RUN(33019976, TRUE, TRUE, LocalCourTrackHdr);
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
                SETFILTER("Responsibility Center", UserSetup."Default Responsibility Center");
                FILTERGROUP(2);
            END;
        END;
    end;

    var
        UserSetup: Record "91";
}

