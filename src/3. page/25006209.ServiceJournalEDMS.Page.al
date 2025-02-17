page 25006209 "Service Journal EDMS"
{
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 20.10.2008. EDMS P2
    //   * Opened field "Deal Type code"

    AutoSplitKey = true;
    Caption = 'Service Journal EDMS';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = Table25006165;

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
                    ServJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate()
                begin
                    ServJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater()
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("External Document No."; "External Document No.")
                {
                    Visible = false;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {

                    trigger OnValidate()
                    begin
                        SerialNoOnAfterValidate;
                    end;
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        //ShowShortcutDimCode(ShortcutDimCode);//29.10.2012 EDMS
                    end;
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field(ShortcutDimCode[3];ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(3,ShortcutDimCode[3]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(3,ShortcutDimCode[3]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode[4];ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(4,ShortcutDimCode[4]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(4,ShortcutDimCode[4]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode[5];ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(5,ShortcutDimCode[5]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(5,ShortcutDimCode[5]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode[6];ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(6,ShortcutDimCode[6]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(6,ShortcutDimCode[6]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode[7];ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(7,ShortcutDimCode[7]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(7,ShortcutDimCode[7]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode[8];ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(8,ShortcutDimCode[8]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(8,ShortcutDimCode[8]);//29.10.2012 EDMS
                    end;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                }
                field("Unit Cost";"Unit Cost")
                {
                }
                field("Total Cost";"Total Cost")
                {
                }
                field("Unit Price";"Unit Price")
                {
                }
                field(Amount;Amount)
                {
                }
                field("Deal Type Code";"Deal Type Code")
                {
                }
                field(Chargeable;Chargeable)
                {
                }
                field("Reason Code";"Reason Code")
                {
                    Visible = false;
                }
                field("Tire Operation Type";"Tire Operation Type")
                {
                }
                field("Vehicle Axle Code";"Vehicle Axle Code")
                {
                }
                field("Tire Position Code";"Tire Position Code")
                {
                    DrillDown = true;
                    DrillDownPageID = "Vehicle Tire Positions";
                    Lookup = true;
                    LookupPageID = "Vehicle Tire Positions";
                }
                field("Tire Code";"Tire Code")
                {
                }
                field("New Vehicle Axle Code";"New Vehicle Axle Code")
                {
                    Visible = false;
                }
                field("New Tire Position Code";"New Tire Position Code")
                {
                    Visible = false;
                }
                field(Kilometrage;Kilometrage)
                {
                    Visible = false;
                }
                field("Variable Field Run 2";"Variable Field Run 2")
                {
                    Visible = false;
                }
                field("Variable Field Run 3";"Variable Field Run 3")
                {
                    Visible = false;
                }
                field("Plan No.";"Plan No.")
                {
                    Visible = false;
                }
                field("Plan Stage Recurrence";"Plan Stage Recurrence")
                {
                }
                field("Plan Stage Code";"Plan Stage Code")
                {
                    Visible = false;
                }
                field("Minutes Per UoM";"Minutes Per UoM")
                {
                    Visible = false;
                }
                field("Quantity (Hours)";"Quantity (Hours)")
                {
                    Visible = false;
                }
            }
            group()
            {
                field(VehName;VehName)
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
                action("D&etails")
                {
                    Caption = 'D&etails';
                    Ellipsis = true;
                    Image = ViewDetails;
                    RunObject = Page 25006193;
                                    RunPageLink = Journal Template Name=FIELD(Journal Template Name),
                                  Journal Batch Name=FIELD(Journal Batch Name),
                                  Journal Line No.=FIELD(Line No.);
                }
            }
            group("&Service")
            {
                Caption = '&Service';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page 25006032;
                                    RunPageLink = Serial No.=FIELD(Vehicle Serial No.);
                    ShortCutKey = 'Shift+F5';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    RunObject = Page 25006211;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.);
                    RunPageView = SORTING(Vehicle Serial No.);
                    ShortCutKey = 'Ctrl+F5';
                }
                action("&Tire Entries")
                {
                    Caption = '&Tire Entries';
                    Image = ItemLedger;
                    RunObject = Page 25006269;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.);
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintServJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Serv. Jnl.-Post",Rec);
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
                        CODEUNIT.RUN(CODEUNIT::"Service Jnl.-Post+Print",Rec);
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
        ServJnlManagement.TemplateSelection(PAGE::"Service Journal EDMS",FALSE,Rec,JnlSelected);
        IF NOT JnlSelected THEN
          ERROR('');
        ServJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        ServJnlManagement: Codeunit "25006105";
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
        ServJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ServJnlManagement.GetVeh("Vehicle Serial No.",VehName);
    end;
}

