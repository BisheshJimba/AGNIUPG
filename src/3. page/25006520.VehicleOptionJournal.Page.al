page 25006520 "Vehicle Option Journal"
{
    // 19.06.2004 EDMS P1
    //    * Created

    AutoSplitKey = true;
    Caption = 'Vehicle Option Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = Table25006387;

    layout
    {
        area(content)
        {
            field(codCurrentJnlBatchName; codCurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SAVERECORD;
                    cuVehOptJnlMgt.fLookupName(codCurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate()
                begin
                    cuVehOptJnlMgt.fCheckName(codCurrentJnlBatchName, Rec);
                    codCurrentJnlBatchNameOnAfterV;
                end;
            }
            repeater()
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("External Document No."; "External Document No.")
                {
                    Visible = false;
                }
                field(VIN; VIN)
                {
                    DrillDown = false;
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
                field("Option Type"; "Option Type")
                {
                }
                field("Option Subtype"; "Option Subtype")
                {
                    Visible = false;
                }
                field("Option Code"; "Option Code")
                {
                }
                field("External Code"; "External Code")
                {
                    Visible = false;
                }
                field(Standard; Standard)
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Cost Amount (LCY)"; "Cost Amount (LCY)")
                {
                    Visible = false;
                }
                field(Correction; Correction)
                {
                    Visible = false;
                }
                field("Applies-to Entry"; "Applies-to Entry")
                {
                }
            }
            group()
            {
                field(txtItemDescription; txtItemDescription)
                {
                    Caption = 'Vehicle Serial No.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                action(Card)
                {
                    Caption = 'Card';
                    Image = Edit;
                    RunObject = Page 25006032;
                    RunPageLink = Serial No.=FIELD(Vehicle Serial No.);
                    ShortCutKey = 'Shift+F5';
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
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Vehicle Opt. Jnl.-Post",Rec);
                        codCurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Vehicle Opt. Jnl.-Post+Print",Rec);
                        codCurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
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
        fSetUpNewLine(xRec);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        cuVehOptJnlMgt.fTemplateSelection(Rec);
        cuVehOptJnlMgt.fOpenJnl(codCurrentJnlBatchName,Rec);
    end;

    var
        cuVehOptJnlMgt: Codeunit "25006305";
        codCurrentJnlBatchName: Code[10];
        txtItemDescription: Text[50];
        txtNewItemDescription: Text[50];

    local procedure codCurrentJnlBatchNameOnAfterV()
    begin
        CurrPage.SAVERECORD;
        cuVehOptJnlMgt.fSetName(codCurrentJnlBatchName,Rec);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        txtItemDescription := "Vehicle Serial No.";
    end;
}

