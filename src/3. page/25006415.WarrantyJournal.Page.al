page 25006415 "Warranty Journal"
{
    AutoSplitKey = true;
    Caption = 'Warranty Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategories = 'a,b,c,Posting';
    SaveValues = true;
    SourceTable = Table25006206;

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
                    WarrantyJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate()
                begin
                    WarrantyJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater()
            {
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Warranty Document No."; "Warranty Document No.")
                {
                }
                field("Warranty Document Line No."; "Warranty Document Line No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Debit Code"; "Debit Code")
                {
                }
                field("Debit Description"; "Debit Description")
                {
                }
                field("Reject Code"; "Reject Code")
                {
                }
                field("Reject Description"; "Reject Description")
                {
                }
                field(Status; Status)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
                {
                }
            }
            group()
            {
                Visible = false;
                field(VehName; VehName)
                {
                    Caption = 'Vehicle Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
            }
            group("&Service")
            {
                Caption = '&Service';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page 25006405;
                    RunPageLink = No.=FIELD(Document No.);
                    ShortCutKey = 'Shift+F5';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    RunObject = Page 25006409;
                                    RunPageLink = Warranty Document No.=FIELD(Document No.);
                    ShortCutKey = 'Ctrl+F5';
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Warranty Jnl.-Post",Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("<Action1101901008>")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Warranty Jnl.-Post+Print",Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ShowShortcutDimCode(ShortcutDimCode);// 29.10.2012 EDMS
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        CLEAR(ShortcutDimCode);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        WarrantyJnlManagement.TemplateSelection(PAGE::"Warranty Journal",FALSE,Rec,JnlSelected);
        IF NOT JnlSelected THEN
          ERROR('');
        WarrantyJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        WarrantyJnlManagement: Codeunit "25006210";
        ReportPrint: Codeunit "228";
        CurrentJnlBatchName: Code[10];
        VehName: Text[30];
        ShortcutDimCode: array [8] of Code[20];

    local procedure SerialNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SAVERECORD;
        WarrantyJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        WarrantyJnlManagement.GetVeh("Debit Description",VehName);
    end;
}

