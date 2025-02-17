page 25006225 "Ext. Service Journal"
{
    AutoSplitKey = true;
    Caption = 'External Service Journal';
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = Table25006143;

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
                    ExtServiceJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate()
                begin
                    ExtServiceJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater()
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Ext. Service No."; "Ext. Service No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field(Amount; Amount)
                {
                }
            }
            group()
            {
                field(ExtServiceName; ExtServiceName)
                {
                    Caption = 'External Service Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&External Service")
            {
                Caption = '&External Service';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SAVERECORD;
                    end;
                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page 25006173;
                    RunPageLink = No.=FIELD(Ext. Service No.);
                    ShortCutKey = 'Shift+F5';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    RunObject = Page 25006223;
                                    RunPageLink = External Serv. No.=FIELD(Ext. Service No.);
                    RunPageView = SORTING(External Serv. No.,Posting Date);
                    ShortCutKey = 'Ctrl+F5';
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintExtServJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    ShortCutKey = 'F11';

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Ext. Service Jnl.-Post",Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Ext. Service Jnl.-Post+Print",Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
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
        ExtServiceJnlManagement.TemplateSelection(Rec,JnlSelected);
        IF NOT JnlSelected THEN
          ERROR('');
        ExtServiceJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        ExtServiceJnlManagement: Codeunit "25006118";
        CurrentJnlBatchName: Code[10];
        ExtServiceName: Text[50];
        ReportPrint: Codeunit "228";

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SAVERECORD;
        ExtServiceJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ExtServiceJnlManagement.GetExtService("Ext. Service No.",ExtServiceName);
    end;
}

