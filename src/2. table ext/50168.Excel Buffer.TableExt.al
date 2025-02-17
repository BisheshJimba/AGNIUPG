tableextension 50168 tableextension50168 extends "Excel Buffer"
{
    procedure AddColumn2(Value: Variant; IsFormula: Boolean; CommentText: Text[1000]; IsBold: Boolean; IsItalics: Boolean; IsUnderline: Boolean; NumFormat: Text[30]; CellType: Option)
    begin
        IF CurrentRow < 1 THEN
            NewRow;

        CurrentCol := CurrentCol + 1;
        INIT;
        VALIDATE("Row No.", CurrentRow);
        VALIDATE("Column No.", CurrentCol);
        IF IsFormula THEN
            SetFormula(FORMAT(Value))
        ELSE
            "Cell Value as Text" := FORMAT(Value);
        Comment := CommentText;
        Bold := IsBold;
        Italic := IsItalics;
        Underline := IsUnderline;
        NumberFormat := NumFormat;
        "Cell Type" := CellType;
        INSERT;
    end;

    procedure AddInfoColumn2(Value: Variant; IsFormula: Boolean; CommentText: Text[1000]; IsBold: Boolean; IsItalics: Boolean; IsUnderline: Boolean; NumFormat: Text[30]; CellType: Option)
    begin
        IF CurrentRow < 1 THEN
            NewRow;

        CurrentCol := CurrentCol + 1;
        INIT;
        InfoExcelBuf.VALIDATE("Row No.", CurrentRow);
        InfoExcelBuf.VALIDATE("Column No.", CurrentCol);
        IF IsFormula THEN
            InfoExcelBuf.SetFormula(FORMAT(Value))
        ELSE
            InfoExcelBuf."Cell Value as Text" := FORMAT(Value);
        InfoExcelBuf.Bold := IsBold;
        InfoExcelBuf.Italic := IsItalics;
        InfoExcelBuf.Underline := IsUnderline;
        InfoExcelBuf.NumberFormat := NumFormat;
        InfoExcelBuf."Cell Type" := CellType;
        InfoExcelBuf.INSERT;
    end;

    var
        InfoExcelBuf: Record "370" temporary;
}

