page 25006751 "SIE Ledger Entries"
{
    Caption = 'SIE Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = Table25006703;
    SourceTableView = SORTING(Date 1, Time 1);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SIE No."; "SIE No.")
                {
                }
                field("Date 1"; "Date 1")
                {
                    Visible = IsVisibleDate1;
                }
                field("Time 1"; "Time 1")
                {
                    Visible = IsVisibleTime1;
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Qty. to Assign"; "Qty. to Assign")
                {
                }
                field("Qty. Assigned"; "Qty. Assigned")
                {
                }
                field(Open; Open)
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field(Correction; Correction)
                {
                }
                field("Automatic Entry"; "Automatic Entry")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("Code10 1"; "Code10 1")
                {
                    Visible = IsVisibleCode10_1;
                }
                field("Code10 2"; "Code10 2")
                {
                    Visible = IsVisibleCode10_2;
                }
                field("Code10 3"; "Code10 3")
                {
                    Visible = IsVisibleCode10_3;
                }
                field("Code10 4"; "Code10 4")
                {
                    Visible = IsVisibleCode10_4;
                }
                field("Code10 5"; "Code10 5")
                {
                    Visible = IsVisibleCode10_5;
                }
                field("Code10 6"; "Code10 6")
                {
                    Visible = IsVisibleCode10_6;
                }
                field("Code20 1"; "Code20 1")
                {
                    Visible = IsVisibleCode20_1;
                }
                field("Code20 2"; "Code20 2")
                {
                    Visible = IsVisibleCode20_2;
                }
                field("Code20 3"; "Code20 3")
                {
                    Visible = IsVisibleCode20_3;
                }
                field("Code20 4"; "Code20 4")
                {
                    Visible = IsVisibleCode20_4;
                }
                field("Code20 5"; "Code20 5")
                {
                    Visible = IsVisibleCode20_5;
                }
                field("Code20 6"; "Code20 6")
                {
                    Visible = IsVisibleCode20_6;
                }
                field("Int 1"; "Int 1")
                {
                    Visible = IsVisibleInt1;
                }
                field("Int 2"; "Int 2")
                {
                    Visible = IsVisibleInt2;
                }
                field("Int 3"; "Int 3")
                {
                    Visible = IsVisibleInt3;
                }
                field("Int 4"; "Int 4")
                {
                    Visible = IsVisibleInt4;
                }
                field("Int 5"; "Int 5")
                {
                    Visible = IsVisibleInt5;
                }
                field("Int 6"; "Int 6")
                {
                    Visible = IsVisibleInt6;
                }
                field("Decimal 1"; "Decimal 1")
                {
                    Visible = IsVisibleDec1;
                }
                field("Decimal 2"; "Decimal 2")
                {
                    Visible = IsVisibleDec2;
                }
                field("Decimal 3"; "Decimal 3")
                {
                    Visible = IsVisibleDec3;
                }
                field("Decimal 4"; "Decimal 4")
                {
                    Visible = IsVisibleDec4;
                }
                field("Decimal 5"; "Decimal 5")
                {
                    Visible = IsVisibleDec5;
                }
                field("Decimal 6"; "Decimal 6")
                {
                    Visible = IsVisibleDec6;
                }
                field("Date 2"; "Date 2")
                {
                    Visible = IsVisibleDate2;
                }
                field("Time 2"; "Time 2")
                {
                    Visible = IsVisibleTime2;
                }
                field("Text50 1"; "Text50 1")
                {
                    Visible = IsVisibleText50_1;
                }
                field("Text50 2"; "Text50 2")
                {
                    Visible = IsVisibleText50_2;
                }
                field("Text100 1"; "Text100 1")
                {
                    Visible = IsVisibleText100_1;
                }
                field("Text10 1"; "Text10 1")
                {
                    Visible = IsVisibleText10_1;
                }
                field("Text10 2"; "Text10 2")
                {
                    Visible = IsVisibleText10_2;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SetVariableFields;
    end;

    var
        IsVisibleDate1: Boolean;
        IsVisibleTime1: Boolean;
        IsVisibleCode10_1: Boolean;
        IsVisibleCode10_2: Boolean;
        IsVisibleCode10_3: Boolean;
        IsVisibleCode10_4: Boolean;
        IsVisibleCode10_5: Boolean;
        IsVisibleCode10_6: Boolean;
        IsVisibleCode20_1: Boolean;
        IsVisibleCode20_2: Boolean;
        IsVisibleCode20_3: Boolean;
        IsVisibleCode20_4: Boolean;
        IsVisibleCode20_5: Boolean;
        IsVisibleCode20_6: Boolean;
        IsVisibleInt1: Boolean;
        IsVisibleInt2: Boolean;
        IsVisibleInt3: Boolean;
        IsVisibleInt4: Boolean;
        IsVisibleInt5: Boolean;
        IsVisibleInt6: Boolean;
        IsVisibleDec1: Boolean;
        IsVisibleDec2: Boolean;
        IsVisibleDec3: Boolean;
        IsVisibleDec4: Boolean;
        IsVisibleDec5: Boolean;
        IsVisibleDec6: Boolean;
        IsVisibleDate2: Boolean;
        IsVisibleTime2: Boolean;
        IsVisibleText50_1: Boolean;
        IsVisibleText50_2: Boolean;
        IsVisibleText100_1: Boolean;
        IsVisibleText10_1: Boolean;
        IsVisibleText10_2: Boolean;

    [Scope('Internal')]
    procedure SetVariableFields()
    begin
        IsVisibleDate1 := IsVFActive(FIELDNO("Date 1"));
        IsVisibleTime1 := IsVFActive(FIELDNO("Time 1"));
        IsVisibleDate2 := IsVFActive(FIELDNO("Date 2"));
        IsVisibleTime2 := IsVFActive(FIELDNO("Time 2"));
        IsVisibleCode10_1 := IsVFActive(FIELDNO("Code10 1"));
        IsVisibleCode10_2 := IsVFActive(FIELDNO("Code10 2"));
        IsVisibleCode10_3 := IsVFActive(FIELDNO("Code10 3"));
        IsVisibleCode10_4 := IsVFActive(FIELDNO("Code10 4"));
        IsVisibleCode10_5 := IsVFActive(FIELDNO("Code10 5"));
        IsVisibleCode10_6 := IsVFActive(FIELDNO("Code10 6"));
        IsVisibleCode20_1 := IsVFActive(FIELDNO("Code20 1"));
        IsVisibleCode20_2 := IsVFActive(FIELDNO("Code20 2"));
        IsVisibleCode20_3 := IsVFActive(FIELDNO("Code20 3"));
        IsVisibleCode20_4 := IsVFActive(FIELDNO("Code20 4"));
        IsVisibleCode20_5 := IsVFActive(FIELDNO("Code20 5"));
        IsVisibleCode20_6 := IsVFActive(FIELDNO("Code20 6"));
        IsVisibleInt1 := IsVFActive(FIELDNO("Int 1"));
        IsVisibleInt2 := IsVFActive(FIELDNO("Int 2"));
        IsVisibleInt3 := IsVFActive(FIELDNO("Int 3"));
        IsVisibleInt4 := IsVFActive(FIELDNO("Int 4"));
        IsVisibleInt5 := IsVFActive(FIELDNO("Int 5"));
        IsVisibleInt6 := IsVFActive(FIELDNO("Int 6"));
        IsVisibleDec1 := IsVFActive(FIELDNO("Decimal 1"));
        IsVisibleDec2 := IsVFActive(FIELDNO("Decimal 2"));
        IsVisibleDec3 := IsVFActive(FIELDNO("Decimal 3"));
        IsVisibleDec4 := IsVFActive(FIELDNO("Decimal 4"));
        IsVisibleDec5 := IsVFActive(FIELDNO("Decimal 5"));
        IsVisibleDec6 := IsVFActive(FIELDNO("Decimal 6"));
        IsVisibleText50_1 := IsVFActive(FIELDNO("Text50 1"));
        IsVisibleText50_2 := IsVFActive(FIELDNO("Text50 2"));
        IsVisibleText100_1 := IsVFActive(FIELDNO("Text100 1"));
        IsVisibleText10_1 := IsVFActive(FIELDNO("Text50 1"));
        IsVisibleText10_2 := IsVFActive(FIELDNO("Text50 2"));
    end;
}

