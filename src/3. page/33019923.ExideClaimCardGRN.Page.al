page 33019923 "Exide Claim Card GRN"
{
    PageType = Card;
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
                    Caption = 'Scrap Amount';
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
                }
                field("Issued MFG"; "Issued MFG")
                {
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
                Caption = 'Process';
                action("<Action1102159041>")
                {
                    Caption = 'Make Issue';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        text33019886: Label 'Aborted By User - %1 !';
                        text33019885: Label 'Are you sure to Issue ?';
                        ConfirmPost: Boolean;
                    begin
                        //MEssage('err');
                        // to insert new issue no.

                        IF "Issue Part No." <> '' THEN BEGIN

                            IF "Issue No." = '' THEN BEGIN
                                SerMgtSetup.GET;
                                SerMgtSetup.TESTFIELD(SerMgtSetup."Issue No.");
                                NoSeriesMgmt.InitSeries(SerMgtSetup."Issue No.", xRec."No. Series1", 0D, "Issue No.", "No. Series1");
                            END;

                            NoSeriesLine.SETRANGE("Series Code", SerMgtSetup."Issue No.");
                            IF NoSeriesLine.FIND('-') THEN BEGIN
                                ExideClaim.COPY(Rec);
                                ExideClaim.SETRANGE("Job Card No.", "Job Card No.");
                                IF ExideClaim.FINDFIRST THEN BEGIN
                                    ExideClaim."Issue No." := NoSeriesLine."Last No. Used";
                                    ExideClaim.MODIFY
                                END;
                            END;
                            ConfirmPost := DIALOG.CONFIRM(text33019885, TRUE);
                            IF ConfirmPost THEN
                                CODEUNIT.RUN(CODEUNIT::CodeIssue, Rec)
                            ELSE
                                MESSAGE(text33019886, USERID);

                        END ELSE
                            MESSAGE(text0001);
                    end;
                }
                action("Make GRN")
                {
                    Caption = 'Make GRN';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                        ExideClaim.SETRANGE("Job Card No.", "Job Card No.");
                        IF ExideClaim.FINDFIRST THEN BEGIN
                            IF ExideClaim.GRN = TRUE THEN BEGIN
                                MESSAGE(text0003, "Job Card No.");
                                EXIT;
                            END
                            ELSE BEGIN

                                ExideClaim.COPY(Rec);
                                ScrapAmount := ExideClaim."Scrap Amount";
                                ScrapNo := ExideClaim."Scrap No.";
                                Dimension1 := ExideClaim."Dimension 1";
                                Dimension2 := ExideClaim."Dimension 2";


                                ExideClaim.SETRANGE("Job Card No.", "Job Card No.");
                                IF ExideClaim.FINDFIRST THEN BEGIN
                                    ExideClaim.GRN := TRUE;
                                    ExideClaim.MODIFY;
                                END;


                                BatSrvSetup.GET;
                                GRNPost();
                                /*
                                ItemJournal.RESET;
                                ItemJournalBatch.GET(BatSrvSetup."Journal Template Name",BatSrvSetup."Journal Batch Name");

                                // to insert in item journal line
                                ItemJournal.INIT;
                                ItemJournal."Posting Date" := WORKDATE;
                                ItemJournal.SETRANGE("Journal Template Name",BatSrvSetup."Journal Template Name");
                                ItemJournal.SETRANGE("Journal Batch Name",BatSrvSetup."Journal Batch Name");
                                IF ItemJournal.FIND('+') THEN BEGIN
                                  ItemJournal."Document No." := ItemJournal."Document No.";
                                  ItemJournal."Line No." := ItemJournal."Line No."+ 10000;

                                END ELSE BEGIN
                                  IF ItemJournalBatch."No. Series" <> '' THEN BEGIN
                                        //MESSAGE(ItemJournalBatch."No. Series");
                                    CLEAR(NoSeriesMgmt);
                                    ItemJournal."Document No." := NoSeriesMgmt.GetNextNo(ItemJournalBatch."No. Series",TODAY,FALSE);
                                  END;
                                 ItemJournal."Line No." := 10000;
                                END;




                                 UserSetUp.GET(USERID);
                                 ItemJournal."Journal Template Name" := BatSrvSetup."Journal Template Name";

                                 ItemJournal."Journal Batch Name" := BatSrvSetup."Journal Batch Name";


                                 //GblItemJournal."Item No." := GblExideClaim."Battery Part No.";
                                 ItemJournal.VALIDATE("Item No.", ScrapNo);
                                 ItemJournal.VALIDATE("Location Code" , UserSetUp."Default Location");
                                 ItemJournal.Description := ExideClaim."Battery Description";
                                 ItemJournal.VALIDATE("Inventory Posting Group" , BatSrvSetup."Inventory Posting Group");
                                 ItemJournal."Entry Type" := BatSrvSetup."Entry Type";
                                 ItemJournal.VALIDATE(Quantity, ExideClaim."Qty.");
                                 //GblItemJournal."Invoiced Quantity" := GblExideClaim."Qty.";
                                 ItemJournal.VALIDATE("Source Code" , BatSrvSetup."Source Code");
                                 ItemJournal.VALIDATE("Gen. Prod. Posting Group" , BatSrvSetup."Gen. Prod. Posting Group");
                                 ItemJournal."Flushing Method" := BatSrvSetup."Flushing Method";
                                 ItemJournal."Document Date" := WORKDATE;
                                 ItemJournal.VALIDATE("Unit Amount",ScrapAmount);
                                 ItemJournal.VALIDATE("Shortcut Dimension 1 Code",Dimension1);
                                 ItemJournal.VALIDATE("Shortcut Dimension 2 Code",Dimension2);
                                 ItemJournal.INSERT;


                                  "Posted Job Header".SETRANGE("Job Card No.","Job Card No.");
                                   IF "Posted Job Header".FINDFIRST THEN BEGIN
                                     "Posted Job Header".GRN := ItemJournal."Document No.";
                                     "Posted Job Header".MODIFY;
                                   END;




                                MESSAGE(text0002);
                                EXIT;
                                */
                            END;
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

    var
        [InDataSet]
        MakeIssue: Boolean;
        SerMgtSetup: Record "5911";
        NoSeriesMgmt: Codeunit "396";
        ExideClaim: Record "33019886";
        NoSeriesLine: Record "309";
        text0001: Label 'Issue Part No. Should Not Be Empty.';
        BatSrvSetup: Record "33019889";
        ItemJournal: Record "83";
        ItemJournalBatch: Record "233";
        UserSetUp: Record "91";
        ScrapAmount: Decimal;
        ScrapNo: Code[20];
        Dimension1: Code[20];
        Dimension2: Code[20];
        text0002: Label 'GRN made successfully!';
        "Posted Job Header": Record "33019894";
        ReqLine: Record "246";
        ReqBatch: Record "245";
        text0003: Label 'GRN of %1 is already created.';
        UserProfileCode: Code[30];
        UserProfileSetup: Record "25006067";
        ReqBatchCode: Code[20];

    [Scope('Internal')]
    procedure GRNPost()
    begin
        ReqLine.RESET;
        UserSetUp.GET(USERID);
        UserProfileCode := UserSetUp."Default User Profile Code";
        //MESSAGE('%1',UserProfileCode);
        UserProfileSetup.SETRANGE("Profile ID", UserProfileCode);
        IF UserProfileSetup.FIND('-') THEN BEGIN
            ReqBatchCode := UserProfileSetup."Requisition Worksheet Batch";
            // MESSAGE('%1',ReqBatchCode);
        END;
        //ReqBatch.GET(BatSrvSetup."Journal Template Name",BatSrvSetup."Journal Batch Name");
        ReqBatch.GET(BatSrvSetup."Journal Template Name", ReqBatchCode);

        // to insert in Req line
        ReqLine.INIT;
        ReqLine."Order Date" := TODAY;
        ReqLine.SETRANGE("Worksheet Template Name", BatSrvSetup."Journal Template Name");
        //ReqLine.SETRANGE("Journal Batch Name",BatSrvSetup."Journal Batch Name");
        ReqLine.SETRANGE("Journal Batch Name", ReqBatchCode);
        IF ReqLine.FIND('+') THEN BEGIN

            ReqLine."Line No." := ReqLine."Line No." + 10000;

        END ELSE BEGIN
            ReqLine."Line No." := 10000;
        END;




        UserSetUp.GET(USERID);
        ReqLine."Worksheet Template Name" := BatSrvSetup."Journal Template Name";

        // ReqLine."Journal Batch Name" := BatSrvSetup."Journal Batch Name";
        ReqLine."Journal Batch Name" := ReqBatchCode;


        //GblReqline."Item No." := GblExideClaim."Battery Part No.";
        ReqLine.VALIDATE(Type, ReqLine.Type::Item);
        ReqLine.VALIDATE("No.", ScrapNo);
        ReqLine.VALIDATE("Replenishment System", ReqLine."Replenishment System"::Purchase);

        ReqLine.VALIDATE("Location Code", UserSetUp."Default Location");
        ReqLine.Description := ExideClaim."Battery Description";
        ReqLine.VALIDATE(Quantity, ExideClaim."Qty.");

        //GblReqline."Invoiced Quantity" := GblExideClaim."Qty.";
        ReqLine."Document Profile" := ReqLine."Document Profile"::"Spare Parts Trade";
        ReqLine.VALIDATE("Direct Unit Cost", 0);
        ReqLine.VALIDATE("Shortcut Dimension 1 Code", Dimension1);
        ReqLine.VALIDATE("Shortcut Dimension 2 Code", Dimension2);
        ReqLine."Battery Job No." := "Job Card No.";
        ReqLine.INSERT;

        /*
         "Posted Job Header".SETRANGE("Job Card No.","Job Card No.");
          IF "Posted Job Header".FINDFIRST THEN BEGIN
            "Posted Job Header".GRN := Reqline."Document No.";
            "Posted Job Header".MODIFY;
          END;
         */



        MESSAGE(text0002);
        EXIT;

    end;
}

