page 33019889 "Exide Claim Card"
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
                    Editable = false;
                }
                field("Scrap No."; "Scrap No.")
                {
                    Editable = false;
                }
                field("Scrap Amount"; "Scrap Amount")
                {
                    Caption = 'Scrap Amount';
                    Editable = false;
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
                    Caption = 'Replace Battery MFG';
                }
                field("Issue Qty."; "Issue Qty.")
                {
                    Editable = false;
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
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        text33019886: Label 'Aborted By User - %1 !';
                        text33019885: Label 'Are you sure to Issue ?';
                        ConfirmPost: Boolean;
                    begin
                        //MEssage('err');
                        // to check it job already exists

                        ExideClaim.SETRANGE("Job Card No.", "Job Card No.");
                        IF ExideClaim.FINDFIRST THEN BEGIN
                            IF ExideClaim.Issued = TRUE THEN BEGIN
                                MESSAGE(text0003, "Job Card No.");
                                EXIT;
                            END
                            ELSE BEGIN


                                // to insert new issue no

                                IF "Issue Part No." <> '' THEN BEGIN
                                    Item.GET("Issue Part No.");
                                    IF UserSetup.GET(USERID) THEN BEGIN
                                        IF Location.GET(UserSetup."Default Location") THEN BEGIN
                                            IF Location."Use As Service Location" THEN BEGIN
                                                IF UserProfileSetup.GET(UserSetup."Default User Profile Code") THEN BEGIN
                                                    Item.SETFILTER("Location Filter", '%1', UserProfileSetup."Def. Spare Part Location Code");
                                                    Item.CALCFIELDS(Inventory);
                                                END;
                                            END
                                            ELSE BEGIN
                                                Item.SETFILTER("Location Filter", '%1', UserSetup."Default Location");
                                                Item.CALCFIELDS(Inventory);
                                            END;
                                        END;
                                    END;

                                    IF Item.Inventory <= 0 THEN BEGIN
                                        MESSAGE(text0002);
                                        EXIT;
                                        // MESSAGE('%1',Item.Inventory);
                                    END;

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

                                EXIT;
                            END;

                        END
                    end;
                }
            }
            group("<Action1000000000>")
            {
                Caption = 'Print';
                action("Exide Claim Card")
                {
                    Caption = 'Exide Claim Card';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //msg('123');
                        ExideClaim.SETRANGE("Job Card No.", "Job Card No.");
                        IF ExideClaim.FINDFIRST THEN
                            REPORT.RUNMODAL(33019893, TRUE, FALSE, ExideClaim);
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
        Item: Record "27";
        text0002: Label 'No more item in stock.';
        UserSetup: Record "91";
        Location: Record "14";
        UserProfileSetup: Record "25006067";
        text0003: Label 'Record with Job Card No. %1 already exists.';

    [Scope('Internal')]
    procedure GetSelectionFilter(): Code[80]
    var
        Item: Record "27";
        FirstItem: Code[30];
        LastItem: Code[30];
        SelectionFilter: Code[250];
        ItemCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Item);
        ItemCount := Item.COUNT;
        IF ItemCount > 0 THEN BEGIN
            Item.FIND('-');
            WHILE ItemCount > 0 DO BEGIN
                ItemCount := ItemCount - 1;
                Item.MARKEDONLY(FALSE);
                FirstItem := Item."No.";
                LastItem := FirstItem;
                More := (ItemCount > 0);
                WHILE More DO
                    IF Item.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT Item.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastItem := Item."No.";
                            ItemCount := ItemCount - 1;
                            IF ItemCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstItem = LastItem THEN
                    SelectionFilter := SelectionFilter + FirstItem
                ELSE
                    SelectionFilter := SelectionFilter + FirstItem + '..' + LastItem;
                IF ItemCount > 0 THEN BEGIN
                    Item.MARKEDONLY(TRUE);
                    Item.NEXT;
                END;
            END;
        END;
        //MESSAGE(SelectionFilter);
        EXIT(SelectionFilter);
    end;
}

