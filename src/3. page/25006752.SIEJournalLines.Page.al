page 25006752 "SIE Journal Lines"
{
    Caption = 'SIE Journal Lines';
    Editable = false;
    PageType = List;
    SourceTable = Table25006702;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                }
                field("SIE No."; "SIE No.")
                {
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
                field("Int 7"; "Int 7")
                {
                    Visible = IsVisibleInt7;
                }
                field("Int 8"; "Int 8")
                {
                    Visible = IsVisibleInt8;
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
                field("Decimal 7"; "Decimal 7")
                {
                    Visible = IsVisibleDec7;
                }
                field("Decimal 8"; "Decimal 8")
                {
                    Visible = IsVisibleDec8;
                }
                field("Date 1"; "Date 1")
                {
                    Visible = IsVisibleDate1;
                }
                field("Date 2"; "Date 2")
                {
                    Visible = IsVisibleDate2;
                }
                field("Date 3"; "Date 3")
                {
                    Visible = IsVisibleDate3;
                }
                field("Date 4"; "Date 4")
                {
                    Visible = IsVisibleDate4;
                }
                field("Time 1"; "Time 1")
                {
                    Visible = IsVisibleTime1;
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
                field("Text10 1"; "Text10 1")
                {
                    Visible = IsVisibleText10_1;
                }
                field("Text10 2"; "Text10 2")
                {
                    Visible = IsVisibleText10_2;
                }
                field(Posted; Posted)
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
        IsVisibleDate2: Boolean;
        IsVisibleDate3: Boolean;
        IsVisibleDate4: Boolean;
        IsVisibleTime1: Boolean;
        IsVisibleTime2: Boolean;
        IsVisibleCode10_1: Boolean;
        IsVisibleCode10_2: Boolean;
        IsVisibleCode10_3: Boolean;
        IsVisibleCode20_1: Boolean;
        IsVisibleCode20_2: Boolean;
        IsVisibleCode20_3: Boolean;
        IsVisibleInt1: Boolean;
        IsVisibleInt2: Boolean;
        IsVisibleInt3: Boolean;
        IsVisibleInt4: Boolean;
        IsVisibleInt5: Boolean;
        IsVisibleInt6: Boolean;
        IsVisibleInt7: Boolean;
        IsVisibleInt8: Boolean;
        IsVisibleDec1: Boolean;
        IsVisibleDec2: Boolean;
        IsVisibleDec3: Boolean;
        IsVisibleDec4: Boolean;
        IsVisibleDec5: Boolean;
        IsVisibleDec6: Boolean;
        IsVisibleDec7: Boolean;
        IsVisibleDec8: Boolean;
        IsVisibleText50_1: Boolean;
        IsVisibleText50_2: Boolean;
        IsVisibleText100_1: Boolean;
        IsVisibleText10_1: Boolean;
        IsVisibleText10_2: Boolean;

    [Scope('Internal')]
    procedure SetVariableFields()
    begin
        IsVisibleDate1 := IsVFActive(FIELDNO("Date 1"));
        IsVisibleDate2 := IsVFActive(FIELDNO("Date 2"));
        IsVisibleDate3 := IsVFActive(FIELDNO("Date 3"));
        IsVisibleDate4 := IsVFActive(FIELDNO("Date 4"));
        IsVisibleTime1 := IsVFActive(FIELDNO("Time 1"));
        IsVisibleTime2 := IsVFActive(FIELDNO("Time 2"));
        IsVisibleCode10_1 := IsVFActive(FIELDNO("Code10 1"));
        IsVisibleCode10_2 := IsVFActive(FIELDNO("Code10 2"));
        IsVisibleCode10_3 := IsVFActive(FIELDNO("Code10 3"));
        IsVisibleCode20_1 := IsVFActive(FIELDNO("Code20 1"));
        IsVisibleCode20_2 := IsVFActive(FIELDNO("Code20 2"));
        IsVisibleCode20_3 := IsVFActive(FIELDNO("Code20 3"));
        IsVisibleInt1 := IsVFActive(FIELDNO("Int 1"));
        IsVisibleInt2 := IsVFActive(FIELDNO("Int 2"));
        IsVisibleInt3 := IsVFActive(FIELDNO("Int 3"));
        IsVisibleInt4 := IsVFActive(FIELDNO("Int 4"));
        IsVisibleInt5 := IsVFActive(FIELDNO("Int 5"));
        IsVisibleInt6 := IsVFActive(FIELDNO("Int 6"));
        IsVisibleInt7 := IsVFActive(FIELDNO("Int 7"));
        IsVisibleInt8 := IsVFActive(FIELDNO("Int 8"));
        IsVisibleDec1 := IsVFActive(FIELDNO("Decimal 1"));
        IsVisibleDec2 := IsVFActive(FIELDNO("Decimal 2"));
        IsVisibleDec3 := IsVFActive(FIELDNO("Decimal 3"));
        IsVisibleDec4 := IsVFActive(FIELDNO("Decimal 4"));
        IsVisibleDec5 := IsVFActive(FIELDNO("Decimal 5"));
        IsVisibleDec6 := IsVFActive(FIELDNO("Decimal 6"));
        IsVisibleDec7 := IsVFActive(FIELDNO("Decimal 7"));
        IsVisibleDec8 := IsVFActive(FIELDNO("Decimal 8"));
        IsVisibleText50_1 := IsVFActive(FIELDNO("Text50 1"));
        IsVisibleText50_2 := IsVFActive(FIELDNO("Text50 2"));
        IsVisibleText100_1 := IsVFActive(FIELDNO("Text100 1"));
        IsVisibleText10_1 := IsVFActive(FIELDNO("Text50 1"));
        IsVisibleText10_2 := IsVFActive(FIELDNO("Text50 2"));
    end;
}

