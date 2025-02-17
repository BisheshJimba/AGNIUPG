page 33020555 "Attendance Journal"
{
    AutoSplitKey = true;
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Attendance';
    SaveValues = true;
    SourceTable = Table33020555;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SAVERECORD;
                    AttJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate()
                begin
                    AttJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater()
            {
                field("Document No."; "Document No.")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field(Description; Description)
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field("Employee No."; "Employee No.")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field("Employee Name"; "Employee Name")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field("Attendance From"; "Attendance From")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field("Attendance To"; "Attendance To")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field("Present Days"; "Present Days")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field("Absent Days"; "Absent Days")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field(Holidays; Holidays)
                {
                }
                field("Paid Days"; "Paid Days")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field("Conflict Exists"; "Conflict Exists")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field("Posting Date"; "Posting Date")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                }
                field("Source Code"; "Source Code")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                    Visible = false;
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                    Style = Unfavorable;
                    StyleExpr = ConflictionExist;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&ttendance")
            {
                Caption = 'A&ttendance';
                action("<Action1000000004>")
                {
                    Caption = 'Journal D&etail';
                    Image = SelectEntries;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 33020557;
                    RunPageLink = Journal Template Name=FIELD(Journal Template Name),
                                  Journal Batch Name=FIELD(Journal Batch Name),
                                  Document No.=FIELD(Document No.),
                                  Journal Line No.=FIELD(Line No.),
                                  Employee No.=FIELD(Employee No.);

                    trigger OnAction()
                    begin
                        CALCFIELDS("Conflict Exists");
                        IF "Conflict Exists" THEN
                          ConflictionExist := TRUE
                        ELSE
                          ConflictionExist := FALSE;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("<Action1000000024>")
                {
                    Caption = 'L&og';
                    Image = BulletList;

                    trigger OnAction()
                    begin
                        AttLog.RESET;
                        AttLog.SETRANGE("Employee ID","Employee No.");
                        AttLog.SETRANGE(Date,"Attendance From","Attendance To");
                        AttLogPage.SETTABLEVIEW(AttLog);
                        AttLogPage.RUN;
                    end;
                }
                action("<Action1000000025>")
                {
                    Caption = 'A&ctivities';
                    Image = ItemWorksheet;

                    trigger OnAction()
                    begin
                        ActLog.RESET;
                        ActLog.SETRANGE("Employee No.","Employee No.");
                        ActLog.SETRANGE("Start Date","Attendance From","Attendance To");
                        ActLogPage.SETTABLEVIEW(ActLog);
                        ActLogPage.RUN;
                    end;
                }
            }
        }
        area(processing)
        {
            group("<Action1000000026>")
            {
                Caption = 'P&osting';
                action(Post)
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Attendance-Post (Yes/No)",Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Process Activities")
                {
                    Caption = 'Process &Activities';
                    Image = SelectItemSubstitution;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        AttJnlManagement.ProcessActivities(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
        CALCFIELDS("Conflict Exists");
        IF "Conflict Exists" THEN
          ConflictionExist := TRUE
        ELSE
          ConflictionExist := FALSE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CALCFIELDS("Conflict Exists");
        IF "Conflict Exists" THEN
          ConflictionExist := TRUE
        ELSE
          ConflictionExist := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Journal Template Name" = '');
        IF OpenedFromBatch THEN BEGIN
          CurrentJnlBatchName := "Journal Batch Name";
          AttJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          EXIT;
        END;
        AttJnlManagement.TemplateSelection(PAGE::"Attendance Journal",0,Rec,JnlSelected);
        IF NOT JnlSelected THEN
          ERROR('');
        AttJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        CurrentJnlBatchName: Code[20];
        OpenedFromBatch: Boolean;
        AttJnlManagement: Codeunit "33020504";
        EmpName: Code[20];
        [InDataSet]
        ConflictionExist: Boolean;
        AttLogPage: Page "33020558";
                        AttLog: Record "33020550";
                        ActLogPage: Page "33020559";
                        ActLog: Record "33020551";

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SAVERECORD;
        AttJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        //xRec := Rec;
    end;
}

