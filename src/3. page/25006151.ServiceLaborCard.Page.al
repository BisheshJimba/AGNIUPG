page 25006151 "Service Labor Card"
{
    // 19.01.2010 EDMS P2
    //   * Added menu item Labor -> Texts
    // 
    // 09.10.2007. EDMS P2
    //   * Made unvisible "Functions -> Restore VOLVO model and serie list"

    Caption = 'Service Labor Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table25006121;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    var
                        SER001: Label 'Make Code must be filled in. Please enter a value.';
                    begin
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                    LookupPageID = "Model Version List";
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Group Code"; "Group Code")
                {
                }
                field("Subgroup Code"; "Subgroup Code")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Date Created"; "Date Created")
                {
                    Editable = false;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    Editable = false;
                }
                field("Variable Field 25006800"; "Variable Field 25006800")
                {
                    Visible = DMSVariableField25006800Visibl;
                }
                field("Variable Field 25006801"; "Variable Field 25006801")
                {
                    Visible = DMSVariableField25006801Visibl;
                }
                field("Variable Field 25006802"; "Variable Field 25006802")
                {
                    Visible = DMSVariableField25006802Visibl;
                }
                field("Washing/Greasing/Polishing"; "Washing/Greasing/Polishing")
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Free of Charge"; "Free of Charge")
                {
                }
                field("Price Includes VAT"; "Price Includes VAT")
                {
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Price/Profit Calculation"; "Price/Profit Calculation")
                {
                }
                field("Profit %"; "Profit %")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                }
                field("Price Group Code"; "Price Group Code")
                {
                }
                field("Labor Discount Group"; "Labor Discount Group")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Labor")
            {
                Caption = '&Labor';
                action("Service Ledger Entries")
                {
                    Caption = 'Service Ledger Entries';
                    Image = ServiceLedger;
                    RunObject = Page 25006211;
                    RunPageLink = No.=FIELD(No.),
                                  Type=CONST(Labor);
                    RunPageView = SORTING(Entry Type,Type,Payment Method Code,No.,Posting Date)
                                  ORDER(Ascending);
                    ShortCutKey = 'Ctrl+F5';
                }
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(Labor),
                                  No.=FIELD(No.);
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                                    RunPageLink = Table ID=CONST(25006121),
                                  No.=FIELD(No.);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Translations)
                {
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page 25006203;
                                    RunPageLink = No.=FIELD(No.);
                }
                action(Texts)
                {
                    Caption = 'Texts';
                    Image = Text;
                    RunObject = Page 25006250;
                                    RunPageLink = Service Labor No.=FIELD(No.);
                }
                action("&Standard Times")
                {
                    Caption = '&Standard Times';
                    Image = Timeline;
                    RunObject = Page 25006153;
                                    RunPageLink = Labor No.=FIELD(No.);
                    ShortCutKey = 'Ctrl+S';
                }
                action("<Action1190012>")
                {
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    RunObject = Page 25006154;
                                    RunPageLink = Code=FIELD(No.),
                                  Type=CONST(Labor);
                }
                action(Skills)
                {
                    Caption = 'Skills';
                    Image = Skills;
                    RunObject = Page 25006179;
                                    RunPageLink = Labor Code=FIELD(No.);
                    RunPageView = SORTING(Labor Code,Skill Code);
                }
                action("Sales Line Discounts")
                {
                    Caption = 'Sales Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page 25006077;
                                    RunPageLink = Type=CONST(Labor),
                                  Code=FIELD(No.);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetVariableFields;
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        DMSVariableField25006802Visibl := TRUE;
        DMSVariableField25006801Visibl := TRUE;
        DMSVariableField25006800Visibl := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetVariableFields;
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        SetVariableFields
    end;

    var
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006801Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006802Visibl: Boolean;

    [Scope('Internal')]
    procedure SetVariableFields()
    begin
        //Variable Fields
         DMSVariableField25006800Visibl := IsVFActive(FIELDNO("Variable Field 25006800"));
         DMSVariableField25006801Visibl := IsVFActive(FIELDNO("Variable Field 25006801"));
         DMSVariableField25006802Visibl := IsVFActive(FIELDNO("Variable Field 25006802"));
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        SETRANGE("Make Code");
        SETRANGE("No.");
    end;
}

