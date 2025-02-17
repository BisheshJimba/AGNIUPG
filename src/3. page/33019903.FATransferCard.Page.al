page 33019903 "FA Transfer Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Posting';
    SourceTable = Table33019890;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("FA No."; "FA No.")
                {
                    Editable = false;
                }
                field("FA Description"; "FA Description")
                {
                    Editable = false;
                }
                field("FA Description2"; "FA Description2")
                {
                    Editable = false;
                }
                field(Date; Date)
                {
                }
                field("From Branch Codes"; FixedAssests."Global Dimension 1 Code")
                {
                    Caption = 'From Branch Codes';
                    Visible = false;
                }
                field("From FA Location"; "From Location Code")
                {
                    Editable = false;
                    TableRelation = "FA Location".Code;
                }
                field("To FA Location"; "To Location Code")
                {
                    MultiLine = true;
                    TableRelation = "FA Location".Code;
                }
                field("To Branch Code"; "To Branch Code")
                {
                }
                field("From Branch Code"; "From Branch Code")
                {
                }
                field("From Emp"; "From Resposible Emp")
                {
                    Caption = 'From Resposible Employee';
                    Editable = false;
                    TableRelation = Employee.No.;
                }
                field("To Emp"; "To Resposible Emp")
                {
                    Caption = 'To Resposible Employee';
                    TableRelation = Employee.No.;
                }
                field("From Location"; "From Location")
                {
                }
                field("To Location"; "To Location")
                {
                }
                field(Reason; Reason)
                {
                    MultiLine = true;
                }
                field(Remarks; Remarks)
                {
                    MultiLine = true;
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
            group("<Action1102159019>")
            {
                Caption = 'Post Action';
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Message('123');
                        ConfirmPost := DIALOG.CONFIRM(text001, TRUE);
                        IF ConfirmPost THEN BEGIN
                            // TESTFIELD("From Branch Code");
                            TESTFIELD("To Branch Code");
                            FATransfer_Post;
                            MESSAGE(text003);
                        END
                        ELSE
                            MESSAGE(text002, UserID);
                    end;
                }
                action("<Action1102159021>")
                {
                    Caption = 'Post and Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Message('123');

                        ConfirmPost := DIALOG.CONFIRM(text001, TRUE);
                        IF ConfirmPost THEN BEGIN
                            FATransfer_Post;
                            // to print
                            FATransfer.RESET;
                            FATransfer.SETRANGE(FATransfer."FA No.", "FA No.");
                            FATransfer.SETRANGE(FATransfer."From Location Code", "From Location Code");
                            REPORT.RUN(33019885, FALSE, TRUE, FATransfer);
                            COMMIT;
                            MESSAGE(text003)
                        END
                        ELSE
                            MESSAGE(text002, UserID);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

        /*
         FixedAssests.GET("FA No.");
        MESSAGE('%1',FixedAssests."No.");
       MESSAGE('%1',FixedAssests."FA Location Code");
        FALocation := FixedAssests."FA Location Code";
        MESSAGE('%1',FALocation);
        "From Location Code" := FALocation;
         */

    end;

    var
        FixedAssests: Record "5600";
        FALocation: Code[10];
        FromLocation: Code[10];
        ToLocation: Code[10];
        "FANo.": Code[20];
        Date: Date;
        FromEmp: Code[20];
        ToEmp: Code[20];
        Reason: Text[30];
        Remarks: Text[30];
        FATransfer: Record "33019891";
        FAT: Record "33019890";
        FixAsset: Record "5600";
        ConfirmPost: Boolean;
        text001: Label 'Do you want to post - FA Transfer?';
        text002: Label 'Aborted by user - %1!';
        text003: Label 'FA Transfer is done successfully!';

    [Scope('Internal')]
    procedure FATransfer_Post()
    begin
        // code to insert in FA Transfer Register table
        FATransfer.INIT;
        FATransfer."FA No." := "FA No.";
        FATransfer.Date := Date;
        FATransfer."From Location Code" := "From Location Code";
        FATransfer."To Location Code" := "To Location Code";
        FATransfer.Reason := Reason;
        FATransfer.Remarks := Remarks;
        FATransfer."From Responsible Emp" := "From Resposible Emp";
        FATransfer."To Responsible Emp" := "To Resposible Emp";
        FATransfer."FA Description" := "FA Description";
        FATransfer."FA Description2" := "FA Description2";
        //Bishesh Jimba 12/31/2024
        FATransfer."To Location" := "To Location";

        Rec.CALCFIELDS("From Branch Code");
        FATransfer."From Branch" := Rec."From Branch Code";
        FATransfer."To Branch" := Rec."To Branch Code";

        FATransfer.TESTFIELD(FATransfer."To Location Code");
        FATransfer.TESTFIELD(FATransfer."To Responsible Emp");
        FATransfer.INSERT(TRUE);

        //To delete from FA Transfer
        FAT.DELETEALL;

        // To Update in Fixed Asset
        FixAsset.SETRANGE(FixAsset."No.", "FA No.");
        IF FixAsset.FINDFIRST THEN BEGIN
            FixAsset."FA Location Code" := "To Location Code";
            FixAsset."Responsible Employee" := "To Resposible Emp";
            //Bishesh Jimba 12/30/24
            FixAsset."Location Code" := "To Location";
            FixAsset.VALIDATE("Global Dimension 1 Code", "To Branch Code");
            FixAsset.MODIFY;
        END;

        COMMIT;
    end;
}

